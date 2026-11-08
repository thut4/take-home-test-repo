/// The design system's public API. Screens import only this file (plus
/// `package:flutter/widgets.dart`), never `material_ui` or `cupertino_ui`.
library;

export 'components/adaptive_app.dart';
export 'components/adaptive_button.dart';
export 'components/adaptive_dialog.dart';
export 'components/adaptive_list_tile.dart';
export 'components/adaptive_loading_indicator.dart';
export 'components/adaptive_page.dart';
export 'components/adaptive_scaffold.dart';
export 'components/adaptive_switch.dart';
export 'components/adaptive_text_field.dart';
export 'components/app_code_input.dart';
export 'components/app_cta_button.dart';
export 'components/app_feedback.dart';
export 'components/app_icons.dart';
export 'components/app_motion.dart';
export 'components/app_network_image.dart';
export 'components/app_page_transitions.dart';
export 'components/app_pressable.dart';
export 'components/app_skeleton.dart';
export 'components/app_state_views.dart';
export 'components/app_svg_icon.dart';
export 'components/app_text_input.dart';
export 'components/app_wheel_picker.dart';
// useCupertino is deliberately not exported: screens never branch on the
// renderer.
export 'components/target.dart'
    show
        RendererPolicy,
        debugOverrideTargetPlatform,
        debugResetRendererOverrides,
        rendererPolicy;
export 'theme/app_theme_scope.dart'
    show AppThemeContext, AppThemeData, AppThemeMode;
export 'tokens/color_tokens.dart';
export 'tokens/motion_tokens.dart';
export 'tokens/spacing_tokens.dart';
export 'tokens/typography_tokens.dart';
