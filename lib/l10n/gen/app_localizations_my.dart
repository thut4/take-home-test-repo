// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Burmese (`my`).
class AppLocalizationsMy extends AppLocalizations {
  AppLocalizationsMy([String locale = 'my']) : super(locale);

  @override
  String get appTitle => 'J\'Donuts';

  @override
  String get onboardingTitle => 'စိတ်ကြိုက် ဒိုးနတ်များ';

  @override
  String get getStarted => 'စတင်မည်';

  @override
  String get haveAccount => 'အကောင့်ရှိပြီးသားလား?';

  @override
  String get logIn => 'ဝင်ရောက်မည်';

  @override
  String continueWith(String provider) {
    return '$provider ဖြင့် ဆက်လုပ်မည်';
  }

  @override
  String comingSoonTitle(String feature) {
    return '$feature မကြာမီ ရောက်ရှိမည်';
  }

  @override
  String socialUnavailable(String provider) {
    return '$provider ဖြင့် ဝင်ရောက်ခြင်းကို ဤဗားရှင်းတွင် မရနိုင်သေးပါ။ ဖုန်းနံပါတ်ဖြင့် ဝင်ရောက်ပါ။';
  }

  @override
  String get legalPrefix => 'ဆက်လုပ်ခြင်းဖြင့် ကျွန်ုပ်တို့၏ ';

  @override
  String get termsOfUse => 'အသုံးပြုမှုစည်းမျဉ်း';

  @override
  String get legalAnd => ' နှင့် ';

  @override
  String get privacyPolicy => 'ကိုယ်ရေးအချက်အလက်မူဝါဒ';

  @override
  String legalUnavailable(String document) {
    return '$document အပြည့်အစုံကို အက်ပ်အစစ်တွင် ဖွင့်ပါမည်။';
  }

  @override
  String get close => 'ပိတ်မည်';

  @override
  String get phoneTitle => 'ဖုန်းနံပါတ် ထည့်ပါ';

  @override
  String get phoneHint => '09 xxx xxx xxx';

  @override
  String get phoneErrorEmpty => 'ဖုန်းနံပါတ် ထည့်ပါ။';

  @override
  String get phoneErrorInvalid =>
      '09 254 135 592 ကဲ့သို့ မြန်မာ ဖုန်းနံပါတ် ထည့်ပါ။';

  @override
  String get phoneNotRegistered => 'ဤနံပါတ်ဖြင့် စာရင်းမသွင်းရသေးပါ။';

  @override
  String get createAccount => 'အကောင့်ဖွင့်မည်';

  @override
  String get phoneAlreadyRegistered => 'ဤနံပါတ်တွင် အကောင့်ရှိပြီးဖြစ်သည်။';

  @override
  String get logInInstead => 'ဝင်ရောက်မည်';

  @override
  String get continueLabel => 'ဆက်လုပ်မည်';

  @override
  String get back => 'နောက်သို့';

  @override
  String stepProgress(int step, int total) {
    return 'အဆင့် $step / $total';
  }

  @override
  String get stepsComplete => 'အဆင့်အားလုံး ပြီးပါပြီ';

  @override
  String get otpTitle => 'နံပါတ်ကို အတည်ပြုပါ';

  @override
  String otpSubtitle(String phone) {
    return '$phone သို့ ဂဏန်း ၆ လုံး OTP ပို့ထားပါသည်';
  }

  @override
  String otpWrong(int attemptsLeft) {
    String _temp0 = intl.Intl.pluralLogic(
      attemptsLeft,
      locale: localeName,
      other: 'နောက်ထပ် $attemptsLeft ကြိမ် ကြိုးစားနိုင်သည်။',
    );
    return 'ကုဒ် မှားနေပါသည်။ $_temp0';
  }

  @override
  String get otpLocked => 'ကုဒ် အကြိမ်ကြိမ် မှားသွားပါသည်။ ကုဒ်အသစ် တောင်းပါ။';

  @override
  String get otpNoCode => 'ကုဒ် မရရှိဘူးလား?';

  @override
  String get otpResendIn => 'ပြန်ပို့ရန် ';

  @override
  String get minutesShort => ' မိနစ်';

  @override
  String get otpResend => 'ကုဒ် ပြန်ပို့မည်';

  @override
  String get otpResent => 'ကုဒ်အသစ် ပို့ပြီးပါပြီ။';

  @override
  String get otpFieldLabel => 'ဂဏန်း ၆ လုံး ကုဒ်';

  @override
  String get nameTitle => 'သင့်အမည်ကို ပြောပြပါ';

  @override
  String get firstNameHint => 'အမည်';

  @override
  String get lastNameHint => 'မျိုးနွယ်အမည်';

  @override
  String get nameErrorRequired => 'အမည် ထည့်ပါ။';

  @override
  String get nameErrorTooLong => 'စာလုံး ၅၀ ထက် မပိုရပါ။';

  @override
  String get nameErrorCharacters => 'စာလုံးနှင့် နေရာလွတ်သာ သုံးပါ။';

  @override
  String get dobTitle => 'မွေးနေ့ ထည့်ပါ';

  @override
  String get monthHint => 'လ';

  @override
  String get dayHint => 'ရက်';

  @override
  String get yearHint => 'နှစ်';

  @override
  String get dobErrorInvalid => 'ထိုရက်စွဲ မရှိပါ။ ရက်နှင့် လကို စစ်ပါ။';

  @override
  String get dobErrorFuture => 'မွေးနေ့သည် အနာဂတ်တွင် မဖြစ်နိုင်ပါ။';

  @override
  String dobErrorTooYoung(int age) {
    return 'အသက် $age နှစ် အနည်းဆုံး ရှိရပါမည်။';
  }

  @override
  String get welcomeTitle => 'J\'donuts ကမ္ဘာသို့ ကြိုဆိုပါသည်';

  @override
  String get letsExplore => 'စူးစမ်းကြမယ်';

  @override
  String get genericError => 'တစ်ခုခု မှားသွားပါသည်။ ထပ်ကြိုးစားပါ။';

  @override
  String get networkError =>
      'အင်တာနက် မရှိပါ။ ချိတ်ဆက်မှုကို စစ်ပြီး ထပ်ကြိုးစားပါ။';

  @override
  String memberTier(String tier) {
    return '$tier အဖွဲ့ဝင်';
  }

  @override
  String pointsToNextTier(String points, String tier) {
    return '$tier အဖွဲ့ဝင် ဖြစ်ရန် $points မှတ် လိုသေးသည်';
  }

  @override
  String get topTier => 'အမြင့်ဆုံးအဆင့် ရောက်ပါပြီ';

  @override
  String notifications(int count) {
    return 'အသိပေးချက် $count ခု';
  }

  @override
  String get offlineBanner =>
      'အင်တာနက် မရှိပါ။ သိမ်းထားသော အချက်အလက်ကို ပြသနေသည်။';

  @override
  String get refreshFailed =>
      'အသစ် မရယူနိုင်ပါ။ သိမ်းထားသော အချက်အလက်ကို ပြသနေသည်။';

  @override
  String get refreshed => 'နောက်ဆုံးအခြေအနေ ဖြစ်ပါပြီ။';

  @override
  String seeAll(String section) {
    return '$section အားလုံး ကြည့်မည်';
  }

  @override
  String get sectionEmpty => 'ယခု မရှိသေးပါ။ နောက်မှ ပြန်ကြည့်ပါ။';

  @override
  String get sectionError => 'ဤအပိုင်းကို ဖွင့်မရပါ။';

  @override
  String get retry => 'ထပ်ကြိုးစားမည်';

  @override
  String discountOff(int percent) {
    return '$percent% လျှော့';
  }

  @override
  String get newBadge => 'အသစ်';

  @override
  String shopsTitle(int count) {
    return 'သင့်အနီးတွင် J\'Donut ဆိုင် $count ဆိုင် ရှိသည်။';
  }

  @override
  String get exploreNow => 'ကြည့်ရှုမည်';

  @override
  String get orderOnline => 'အွန်လိုင်း မှာယူမည်';

  @override
  String priceMmk(String price) {
    return '$price ကျပ်';
  }

  @override
  String get whatsThis => 'ဒါဘာလဲ?';

  @override
  String get addToCart => 'ခြင်းထဲထည့်မည်';

  @override
  String addedToCart(int quantity, String name) {
    return '$name $quantity ခု ခြင်းထဲ ထည့်ပြီးပါပြီ။';
  }

  @override
  String get increaseQuantity => 'အရေအတွက် တိုးမည်';

  @override
  String get decreaseQuantity => 'အရေအတွက် လျှော့မည်';

  @override
  String quantityValue(int quantity) {
    return 'အရေအတွက် $quantity';
  }

  @override
  String get productNotFound => 'ဤပစ္စည်း မရှိတော့ပါ။';

  @override
  String get rewardsTitle => 'J\' Donuts ဆုလာဘ်';

  @override
  String get rewardsPill => 'ဆုလာဘ်';

  @override
  String get totalPoints => 'စုစုပေါင်း အမှတ်';

  @override
  String get tierHereNow => 'လက်ရှိ အဆင့်';

  @override
  String tierRemaining(String points, String tier) {
    return '$tier ဖြစ်ရန် $points မှတ် လိုသည်';
  }

  @override
  String get tierSoon => 'မကြာမီ ရောက်မည်';

  @override
  String get tierReached => 'ရောက်ပြီး';

  @override
  String get tabEarn => 'စားလေ ရလေ';

  @override
  String get tabGift => 'လက်ဆောင်';

  @override
  String get earn => 'ရယူမည်';

  @override
  String get redeem => 'လဲလှယ်မည်';

  @override
  String pointsShort(String points) {
    return '$points မှတ်';
  }

  @override
  String challengeProgress(int progress, int goal) {
    return '$progress/$goal';
  }

  @override
  String get earnTapped => 'အမှတ်များကို ဆိုင်တွင် ထည့်ပေးပါမည်။';

  @override
  String get redeemTapped => 'လက်ဆောင်များကို ဆိုင်တွင် လဲလှယ်နိုင်ပါသည်။';

  @override
  String get rewardsEmpty => 'ယခု စိန်ခေါ်မှု မရှိသေးပါ။';

  @override
  String get navHome => 'ပင်မ';

  @override
  String get navReward => 'ဆုလာဘ်';

  @override
  String get navOrder => 'မှာယူ';

  @override
  String get navWallet => 'ပိုက်ဆံအိတ်';

  @override
  String get navSettings => 'ဆက်တင်';

  @override
  String get comingSoonBody => 'ဤ tab သည် code test ၏ အစိတ်အပိုင်း မဟုတ်ပါ။';

  @override
  String get settingsTitle => 'ဆက်တင်';

  @override
  String get logOut => 'ထွက်မည်';

  @override
  String get logOutConfirmTitle => 'ထွက်မလား?';

  @override
  String get logOutConfirmBody =>
      'ပြန်ဝင်ရန် ဖုန်းနံပါတ်နှင့် ကုဒ် လိုအပ်ပါမည်။';

  @override
  String get cancel => 'မလုပ်တော့ပါ';

  @override
  String get language => 'ဘာသာစကား';

  @override
  String get languageName => 'မြန်မာ';

  @override
  String signedInAs(String phone) {
    return '$phone ဖြင့် ဝင်ထားသည်';
  }

  @override
  String cartCount(int count) {
    return 'ခြင်း၊ $count ခု';
  }

  @override
  String get done => 'ပြီးပြီ';

  @override
  String get dobSheetTitle => 'မွေးနေ့';
}
