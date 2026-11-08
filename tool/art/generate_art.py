"""Generates every bitmap the app ships, so the repo holds no third-party or
client artwork.

    python3 -m venv .venv && .venv/bin/pip install pillow numpy
    .venv/bin/python tool/art/generate_art.py

Writes seed images to assets/images/ and the server-only images to
server/public/images/.
"""

from __future__ import annotations

import math
import random
from dataclasses import dataclass, field
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageFilter

ROOT = Path(__file__).resolve().parents[2]
ASSETS = ROOT / "assets" / "images"
SERVER = ROOT / "server" / "public" / "images"

SUPERSAMPLE = 2
LIGHT = np.array([-0.45, -0.55, 0.70])
LIGHT = LIGHT / np.linalg.norm(LIGHT)
HALF = LIGHT + np.array([0.0, 0.0, 1.0])
HALF = HALF / np.linalg.norm(HALF)

SPRINKLE_COLOURS = [
    (255, 255, 255), (255, 214, 64), (92, 200, 236), (122, 196, 90),
    (240, 86, 154), (255, 128, 40), (150, 110, 230),
]
CHOC_SPRINKLES = [(70, 38, 22), (40, 22, 14)]

DOUGH = np.array([226, 162, 92], dtype=float)
CHOCOLATE = (92, 52, 32)
PINK = (244, 124, 168)
DEEP_PINK = (236, 92, 150)
PURPLE = (150, 112, 232)
WHITE_ICING = (250, 246, 240)
MATCHA = (152, 196, 110)
CARAMEL = (222, 150, 70)


@dataclass
class DonutStyle:
    icing: tuple[int, int, int] | None
    drizzle: tuple[int, int, int] | None = None
    sprinkles: list[tuple[int, int, int]] = field(default_factory=list)
    sprinkle_count: int = 0
    seed: int = 1


# ---------------------------------------------------------------- helpers


def grid(size: int):
    ys, xs = np.mgrid[0:size, 0:size].astype(float)
    return xs - size / 2, ys - size / 2


def to_image(rgb: np.ndarray, alpha: np.ndarray) -> Image.Image:
    rgba = np.dstack([np.clip(rgb, 0, 255), np.clip(alpha, 0, 1) * 255])
    return Image.fromarray(rgba.astype(np.uint8), "RGBA")


def downsample(img: Image.Image, size: int) -> Image.Image:
    return img.resize((size, size), Image.LANCZOS)


def shadow(size: int, cx: float, cy: float, rx: float, ry: float,
           strength: float = 0.28) -> Image.Image:
    layer = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer)
    alpha = int(255 * strength)
    draw.ellipse([cx - rx, cy - ry, cx + rx, cy + ry], fill=(60, 30, 40, alpha))
    return layer.filter(ImageFilter.GaussianBlur(size * 0.03))


# ------------------------------------------------------------------ donut


def torus_fields(size: int):
    dx, dy = grid(size)
    r = np.hypot(dx, dy) + 1e-6
    r_out, r_in = size * 0.42, size * 0.135
    major, minor = (r_out + r_in) / 2, (r_out - r_in) / 2
    t = (r - major) / minor
    inside = np.abs(t) <= 1
    h = np.sqrt(np.clip(1 - t**2, 0, 1))
    normal = np.dstack([t * dx / r, t * dy / r, h])
    diffuse = np.clip(normal @ LIGHT, 0, 1)
    spec = np.clip(normal @ HALF, 0, 1)
    theta = np.arctan2(dy, dx)
    return dx, dy, t, inside, diffuse, spec, theta


def icing_mask(t: np.ndarray, theta: np.ndarray, seed: int) -> np.ndarray:
    rng = np.random.default_rng(seed)
    p = rng.uniform(0, 6.28, 4)
    outer = (0.66 + 0.07 * np.sin(5 * theta + p[0])
             + 0.04 * np.sin(9 * theta + p[1]) + 0.02 * np.sin(17 * theta))
    inner = (-0.58 - 0.05 * np.sin(4 * theta + p[2])
             - 0.03 * np.sin(11 * theta + p[3]))
    return (t < outer) & (t > inner), np.minimum(t - inner, outer - t)


def drizzle_mask(dx, dy, size: int, seed: int) -> np.ndarray:
    rng = random.Random(seed)
    angle = rng.uniform(-0.5, 0.5)
    u = dx * math.cos(angle) + dy * math.sin(angle)
    v = -dx * math.sin(angle) + dy * math.cos(angle)
    spacing, width = size * 0.085, size * 0.017
    wave = size * 0.03 * np.sin(u / (size * 0.05) + rng.uniform(0, 6))
    offset = np.mod(v + wave, spacing)
    return np.minimum(offset, spacing - offset) < width


def shade(colour, diffuse, spec, gloss: float) -> np.ndarray:
    base = np.array(colour, dtype=float)
    light = 0.5 + 0.62 * diffuse
    rgb = base[None, None, :] * light[..., None]
    return rgb + (spec**38 * 255 * gloss)[..., None]


def sprinkle_layer(size: int, mask: np.ndarray, style: DonutStyle):
    layer = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer)
    rng = random.Random(style.seed)
    ys, xs = np.nonzero(mask)
    if len(xs) == 0:
        return layer
    length, width = size * 0.03, max(2, int(size * 0.011))
    for _ in range(style.sprinkle_count):
        i = rng.randrange(len(xs))
        x, y = xs[i], ys[i]
        a = rng.uniform(0, math.pi)
        x2, y2 = x + length * math.cos(a), y + length * math.sin(a)
        colour = rng.choice(style.sprinkles)
        draw.line([(x + 2, y + 3), (x2 + 2, y2 + 3)], fill=(0, 0, 0, 50),
                  width=width)
        draw.line([(x, y), (x2, y2)], fill=colour + (255,), width=width)
        for px, py in ((x, y), (x2, y2)):
            draw.ellipse([px - width / 2, py - width / 2, px + width / 2,
                          py + width / 2], fill=colour + (255,))
    clip = Image.fromarray((mask * 255).astype(np.uint8), "L")
    layer.putalpha(Image.composite(layer.getchannel("A"),
                                   Image.new("L", layer.size, 0), clip))
    return layer


def render_donut(style: DonutStyle, out_size: int = 512) -> Image.Image:
    size = out_size * SUPERSAMPLE
    dx, dy, t, inside, diffuse, spec, theta = torus_fields(size)
    noise = np.random.default_rng(style.seed).normal(0, 5, (size, size))
    rgb = DOUGH[None, None, :] * (0.48 + 0.6 * diffuse)[..., None]
    rgb += noise[..., None]
    # Pale ring where the dough rose around the icing.
    rgb += (np.exp(-((t - 0.8) ** 2) / 0.01) * 22)[..., None]
    top = np.zeros_like(inside)
    if style.icing is not None:
        top, edge = icing_mask(t, theta, style.seed)
        top &= inside
        icing_rgb = shade(style.icing, diffuse, spec, 0.55)
        icing_rgb *= (0.82 + 0.18 * np.clip(edge / 0.06, 0, 1))[..., None]
        rgb = np.where(top[..., None], icing_rgb, rgb)
        if style.drizzle is not None:
            drizzle = drizzle_mask(dx, dy, size, style.seed) & top
            rgb = np.where(drizzle[..., None],
                           shade(style.drizzle, diffuse, spec, 0.7), rgb)
    img = to_image(rgb, inside.astype(float))
    if style.sprinkle_count:
        img = Image.alpha_composite(img, sprinkle_layer(size, top, style))
    canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    canvas = Image.alpha_composite(
        canvas, shadow(size, size * 0.53, size * 0.56, size * 0.4, size * 0.4))
    canvas = Image.alpha_composite(canvas, img)
    return downsample(canvas, out_size)


# ------------------------------------------------------------------ glass


@dataclass
class GlassStyle:
    layers: list[tuple[float, tuple[int, int, int]]]
    foam: tuple[int, int, int] | None = None
    ice: bool = True
    marble: bool = True
    seed: int = 3


def glass_shape(size: int):
    xs, ys = np.mgrid[0:size, 0:size][::-1].astype(float)
    top, bottom = size * 0.08, size * 0.93
    frac = np.clip((ys - top) / (bottom - top), 0, 1)
    half = size * (0.215 - 0.045 * frac)
    cx = size / 2
    inside = (ys >= top) & (ys <= bottom) & (np.abs(xs - cx) <= half)
    corner = size * 0.05
    near_bottom = ys > bottom - corner
    edge_dist = half - np.abs(xs - cx)
    rounded = ((corner - edge_dist) ** 2
               + (ys - (bottom - corner)) ** 2) <= corner ** 2
    inside &= ~near_bottom | (edge_dist >= corner) | rounded
    return xs, ys, frac, inside, (xs - cx) / half


def liquid_colour(style: GlassStyle, frac, xs, ys, size):
    stops = style.layers
    rgb = np.zeros(frac.shape + (3,))
    positions = np.array([p for p, _ in stops])
    colours = np.array([c for _, c in stops], dtype=float)
    for ch in range(3):
        rgb[..., ch] = np.interp(frac, positions, colours[:, ch])
    if style.marble:
        swirl = np.sin(xs / size * 18 + 4 * np.sin(ys / size * 9 + style.seed))
        rgb *= (1 + 0.06 * swirl)[..., None]
    return rgb


def render_glass(style: GlassStyle, out_size: int = 512) -> Image.Image:
    size = out_size * SUPERSAMPLE
    xs, ys, frac, inside, across = glass_shape(size)
    rgb = liquid_colour(style, frac, xs, ys, size)
    if style.foam is not None:
        foam = frac < 0.24
        bubbles = np.random.default_rng(style.seed).normal(0, 9, frac.shape)
        rgb = np.where(foam[..., None],
                       np.array(style.foam)[None, None, :] + bubbles[..., None],
                       rgb)
    rgb *= (1 - 0.18 * np.abs(across) ** 3)[..., None]
    highlight = np.exp(-((across + 0.55) ** 2) / 0.004) * 120
    rgb += highlight[..., None]
    img = to_image(rgb, inside.astype(float))
    if style.ice:
        img = Image.alpha_composite(img, ice_layer(size, style.seed))
        img.putalpha(Image.fromarray((inside * 255).astype(np.uint8), "L"))
    canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    canvas = Image.alpha_composite(
        canvas, shadow(size, size * 0.52, size * 0.93, size * 0.2, size * 0.04))
    canvas = Image.alpha_composite(canvas, img)
    return downsample(canvas, out_size)


def ice_layer(size: int, seed: int) -> Image.Image:
    layer = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer)
    rng = random.Random(seed)
    for _ in range(4):
        x = size / 2 + rng.uniform(-0.13, 0.08) * size
        y = size * rng.uniform(0.1, 0.35)
        s = size * rng.uniform(0.08, 0.12)
        draw.rounded_rectangle([x, y, x + s, y + s], radius=s * 0.2,
                               fill=(255, 255, 255, 70),
                               outline=(255, 255, 255, 120), width=4)
    return layer.filter(ImageFilter.GaussianBlur(2))


# ------------------------------------------------------- scenes (opaque)


def scene_with_donuts(bg, donuts, positions, out=(640, 480)) -> Image.Image:
    canvas = Image.new("RGBA", out, bg + (255,))
    for style, (x, y, s) in zip(donuts, positions):
        d = render_donut(style, int(s))
        canvas.alpha_composite(d, (int(x - s / 2), int(y - s / 2)))
    return canvas.convert("RGB")


def box_scene(bg, tray, donuts, out=(640, 480)) -> Image.Image:
    canvas = Image.new("RGBA", out, bg + (255,))
    draw = ImageDraw.Draw(canvas)
    w, h = out
    draw.rounded_rectangle([w * 0.08, h * 0.1, w * 0.92, h * 0.9], 28,
                           fill=tray + (255,))
    cols, rows, size = 3, 2, h * 0.36
    for i, style in enumerate(donuts[: cols * rows]):
        cx = w * (0.24 + 0.26 * (i % cols))
        cy = h * (0.31 + 0.38 * (i // cols))
        canvas.alpha_composite(render_donut(style, int(size)),
                               (int(cx - size / 2), int(cy - size / 2)))
    return canvas.convert("RGB")


def bakery_display(seed: int, out=(640, 400)) -> Image.Image:
    rng = random.Random(seed)
    w, h = out
    img = Image.new("RGB", out, (58, 34, 22))
    draw = ImageDraw.Draw(img)
    for row in range(3):
        y = h * (0.3 + row * 0.3)
        draw.rectangle([0, y, w, y + 10], fill=(214, 190, 160))
        for i in range(9):
            cx = w * (0.06 + i * 0.11) + rng.uniform(-6, 6)
            r = rng.uniform(22, 30)
            tone = rng.choice([(222, 160, 80), (196, 124, 58), (236, 186, 110)])
            draw.ellipse([cx - r, y - r * 1.2, cx + r, y - 2], fill=tone)
            draw.ellipse([cx - r * 0.5, y - r * 1.05, cx + r * 0.1, y - r * 0.7],
                         fill=(250, 220, 170))
    glare = Image.new("L", out, 0)
    gd = ImageDraw.Draw(glare)
    gd.polygon([(w * 0.5, 0), (w * 0.62, 0), (w * 0.35, h), (w * 0.23, h)],
               fill=60)
    img = Image.composite(Image.new("RGB", out, (255, 255, 255)), img,
                          glare.filter(ImageFilter.GaussianBlur(14)))
    return img.filter(ImageFilter.GaussianBlur(0.6))


def cookies_plate(out=(640, 480)) -> Image.Image:
    img = Image.new("RGB", out, (246, 226, 214))
    draw = ImageDraw.Draw(img)
    w, h = out
    draw.ellipse([w * 0.12, h * 0.06, w * 0.88, h * 0.94], fill=(255, 255, 255))
    rng = random.Random(7)
    for cx, cy in [(0.36, 0.38), (0.62, 0.36), (0.5, 0.64), (0.3, 0.66),
                   (0.7, 0.64)]:
        r = h * 0.15
        x, y = w * cx, h * cy
        draw.ellipse([x - r, y - r, x + r, y + r], fill=(206, 146, 82))
        for _ in range(7):
            a, d = rng.uniform(0, 6.28), rng.uniform(0, r * 0.75)
            px, py = x + d * math.cos(a), y + d * math.sin(a)
            draw.ellipse([px - 6, py - 5, px + 6, py + 5], fill=(78, 44, 26))
    return img


def avatar(out: int = 256) -> Image.Image:
    img = Image.new("RGB", (out, out), (253, 214, 186))
    draw = ImageDraw.Draw(img)
    s = out
    draw.ellipse([s * 0.18, s * 0.72, s * 0.82, s * 1.3], fill=(84, 140, 214))
    draw.ellipse([s * 0.24, s * 0.12, s * 0.76, s * 0.7], fill=(58, 36, 30))
    draw.ellipse([s * 0.3, s * 0.2, s * 0.7, s * 0.66], fill=(242, 196, 160))
    draw.rectangle([s * 0.43, s * 0.6, s * 0.57, s * 0.76], fill=(242, 196, 160))
    draw.chord([s * 0.26, s * 0.1, s * 0.74, s * 0.48], 180, 360,
               fill=(58, 36, 30))
    for ex in (0.42, 0.58):
        draw.ellipse([s * (ex - 0.07), s * 0.37, s * (ex + 0.07), s * 0.47],
                     outline=(40, 30, 30), width=3)
        draw.ellipse([s * (ex - 0.015), s * 0.41, s * (ex + 0.015), s * 0.44],
                     fill=(40, 30, 30))
    draw.arc([s * 0.44, s * 0.5, s * 0.56, s * 0.58], 20, 160,
             fill=(190, 90, 90), width=3)
    return img


# ------------------------------------------------------------------- main

DONUTS = {
    "coconut": DonutStyle(CHOCOLATE, drizzle=DEEP_PINK, seed=11),
    "strawberry_choc": DonutStyle(PINK, drizzle=CHOCOLATE, seed=12),
    "pink_sprinkle": DonutStyle(PINK, sprinkles=SPRINKLE_COLOURS,
                                sprinkle_count=160, seed=13),
    "blueberry": DonutStyle(PURPLE, sprinkles=[(255, 255, 255)],
                            sprinkle_count=40, seed=14),
    "classic_glazed": DonutStyle(WHITE_ICING, seed=15),
    "choc_sprinkle": DonutStyle(CHOCOLATE, sprinkles=SPRINKLE_COLOURS,
                                sprinkle_count=120, seed=16),
    "caramel": DonutStyle(CARAMEL, drizzle=WHITE_ICING, seed=17),
}
SERVER_DONUTS = {"matcha": DonutStyle(MATCHA, drizzle=WHITE_ICING, seed=18)}
GLASSES = {
    "dalgona": GlassStyle([(0, (236, 220, 196)), (1, (214, 182, 146))],
                          foam=(196, 132, 70), ice=False, seed=21),
    "iced_latte": GlassStyle([(0, (244, 236, 224)), (0.45, (206, 168, 128)),
                              (1, (96, 56, 34))], seed=22),
    "iced_americano": GlassStyle([(0, (120, 72, 40)), (1, (48, 26, 16))],
                                 marble=False, seed=23),
}


def save(img: Image.Image, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    img.save(path, optimize=True)
    print(f"wrote {path.relative_to(ROOT)} ({path.stat().st_size // 1024} KB)")


def main() -> None:
    for name, style in DONUTS.items():
        save(render_donut(style), ASSETS / "products" / f"{name}.png")
    for name, style in GLASSES.items():
        save(render_glass(style), ASSETS / "products" / f"{name}.png")
    for name, style in SERVER_DONUTS.items():
        save(render_donut(style), SERVER / "products" / f"{name}.png")
    assorted = [DONUTS[k] for k in ("pink_sprinkle", "classic_glazed",
                                    "choc_sprinkle", "strawberry_choc",
                                    "blueberry", "caramel", "coconut")]
    pile = [(120, 120, 300), (330, 90, 280), (540, 140, 300), (200, 330, 300),
            (440, 350, 300), (640, 380, 260), (0, 400, 260)]
    save(scene_with_donuts((250, 236, 238), assorted, pile),
         ASSETS / "products" / "mistletoe_box.jpg")
    save(box_scene((234, 242, 246), (120, 196, 226), assorted),
         ASSETS / "products" / "christmas_box.jpg")
    save(cookies_plate(), ASSETS / "products" / "santa_cookies.jpg")
    for i in range(1, 5):
        save(bakery_display(i), ASSETS / "shops" / f"shop_{i}.jpg")
    save(bakery_display(9, out=(640, 360)),
         ASSETS / "banners" / "central_boulevard.jpg")
    save(scene_with_donuts((92, 200, 236), assorted[:3],
                           [(140, 180, 300), (360, 160, 280), (560, 220, 300)],
                           out=(640, 360)),
         ASSETS / "banners" / "hot_deal.jpg")
    save(avatar(), ASSETS / "brand" / "member_avatar.png")


if __name__ == "__main__":
    main()
