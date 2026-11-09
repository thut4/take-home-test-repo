// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'J\'Donuts';

  @override
  String get onboardingTitle => 'Round food for every mood';

  @override
  String get getStarted => 'Let\'s get started';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get logIn => 'Log in';

  @override
  String continueWith(String provider) {
    return 'Continue with $provider';
  }

  @override
  String comingSoonTitle(String feature) {
    return '$feature is coming soon';
  }

  @override
  String socialUnavailable(String provider) {
    return 'Signing in with $provider isn\'t part of this demo. Use your phone number instead.';
  }

  @override
  String get legalPrefix =>
      'By continuing, you acknowledge that you have read and agree to our ';

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get legalAnd => ' and ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String legalUnavailable(String document) {
    return 'The full $document will open here in the live app.';
  }

  @override
  String get close => 'Close';

  @override
  String get phoneTitle => 'Enter your phone number';

  @override
  String get phoneHint => '09 xxx xxx xxx';

  @override
  String get phoneErrorEmpty => 'Enter your phone number.';

  @override
  String get phoneErrorInvalid =>
      'Enter a Myanmar mobile number, like 09 254 135 592.';

  @override
  String get phoneNotRegistered => 'This number isn\'t registered yet.';

  @override
  String get createAccount => 'Create an account';

  @override
  String get phoneAlreadyRegistered => 'This number already has an account.';

  @override
  String get logInInstead => 'Log in instead';

  @override
  String get continueLabel => 'Continue';

  @override
  String get back => 'Back';

  @override
  String stepProgress(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get stepsComplete => 'All steps complete';

  @override
  String get otpTitle => 'Verify your number';

  @override
  String otpSubtitle(String phone) {
    return 'We\'ve sent 6 digit OTP to $phone';
  }

  @override
  String otpWrong(int attemptsLeft) {
    String _temp0 = intl.Intl.pluralLogic(
      attemptsLeft,
      locale: localeName,
      other: '$attemptsLeft tries left.',
      one: '1 try left.',
    );
    return 'That code isn\'t right. $_temp0';
  }

  @override
  String get otpLocked =>
      'Too many wrong codes. Request a new code to try again.';

  @override
  String get otpNoCode => 'Didn\'t receive the code?';

  @override
  String get otpResendIn => 'resend in ';

  @override
  String get minutesShort => ' min';

  @override
  String get otpResend => 'Resend code';

  @override
  String get otpResent => 'We\'ve sent a new code.';

  @override
  String get otpFieldLabel => '6-digit code';

  @override
  String get nameTitle => 'What\'s your name?';

  @override
  String get firstNameHint => 'First Name';

  @override
  String get lastNameHint => 'Last Name';

  @override
  String get nameErrorRequired => 'Enter your first name.';

  @override
  String get nameErrorTooLong => 'Use 50 characters or fewer.';

  @override
  String get nameErrorCharacters => 'Use letters and spaces only.';

  @override
  String get dobTitle => 'What\'s your date of birth?';

  @override
  String get monthHint => 'Month';

  @override
  String get dayHint => 'Day';

  @override
  String get yearHint => 'Year';

  @override
  String get dobErrorInvalid =>
      'That date doesn\'t exist. Check the day and month.';

  @override
  String get dobErrorFuture => 'Your date of birth can\'t be in the future.';

  @override
  String dobErrorTooYoung(int age) {
    return 'You need to be at least $age years old to join.';
  }

  @override
  String get welcomeTitle => 'Welcome to the world of J\'donuts';

  @override
  String get letsExplore => 'Let\'s explore';

  @override
  String get genericError => 'Something went wrong. Please try again.';

  @override
  String get networkError =>
      'You\'re offline. Check your connection and try again.';

  @override
  String memberTier(String tier) {
    return '$tier member';
  }

  @override
  String pointsToNextTier(String points, String tier) {
    return '$points points left to become $tier Member';
  }

  @override
  String get topTier => 'You\'ve reached the top tier';

  @override
  String notifications(int count) {
    return 'Notifications, $count unread';
  }

  @override
  String get offlineBanner => 'You\'re offline. Showing saved data.';

  @override
  String get refreshFailed => 'Couldn\'t refresh. Showing saved data.';

  @override
  String get refreshed => 'Up to date.';

  @override
  String seeAll(String section) {
    return 'See all $section';
  }

  @override
  String get sectionEmpty => 'Nothing here yet. Check back soon.';

  @override
  String get sectionError => 'Couldn\'t load this section.';

  @override
  String get sectionNotFound => 'This section isn\'t available any more.';

  @override
  String get retry => 'Try again';

  @override
  String discountOff(int percent) {
    return '$percent% off';
  }

  @override
  String get newBadge => 'New';

  @override
  String shopsTitle(int count) {
    return 'There are $count J\'Donut shops near you.';
  }

  @override
  String get exploreNow => 'Explore now';

  @override
  String get orderOnline => 'Order Online';

  @override
  String priceMmk(String price) {
    return '$price MMK';
  }

  @override
  String get whatsThis => 'What\'s this?';

  @override
  String get addToCart => 'Add to cart';

  @override
  String addedToCart(int quantity, String name) {
    return 'Added $quantity × $name to your cart.';
  }

  @override
  String get increaseQuantity => 'Increase quantity';

  @override
  String get decreaseQuantity => 'Decrease quantity';

  @override
  String quantityValue(int quantity) {
    return 'Quantity $quantity';
  }

  @override
  String get productNotFound => 'This product isn\'t available any more.';

  @override
  String get rewardsTitle => 'J\' Donuts Rewards';

  @override
  String get rewardsPill => 'Rewards';

  @override
  String get totalPoints => 'Total points';

  @override
  String get tierHereNow => 'You\'re here now';

  @override
  String tierRemaining(String points, String tier) {
    return '$points pts Remaining to become $tier';
  }

  @override
  String get tierSoon => 'You\'ll be here soon';

  @override
  String get tierReached => 'Reached';

  @override
  String get tabEarn => 'Eat more earn more';

  @override
  String get tabGift => 'Gift';

  @override
  String get earn => 'Earn';

  @override
  String get redeem => 'Redeem';

  @override
  String pointsShort(String points) {
    return '$points pts';
  }

  @override
  String challengeProgress(int progress, int goal) {
    return '$progress/$goal';
  }

  @override
  String get earnTapped => 'Points are added.';

  @override
  String get redeemTapped => 'Gifts are redeemed.';

  @override
  String get rewardsEmpty => 'No challenges right now. Check back soon.';

  @override
  String get navHome => 'Home';

  @override
  String get navReward => 'Reward';

  @override
  String get navOrder => 'Order';

  @override
  String get navWallet => 'Wallet';

  @override
  String get navSettings => 'Settings';

  @override
  String get comingSoonBody => 'This tab isn\'t part of the code test.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get logOut => 'Log out';

  @override
  String get logOutConfirmTitle => 'Log out?';

  @override
  String get logOutConfirmBody =>
      'You\'ll need your phone number and a code to log in again.';

  @override
  String get cancel => 'Cancel';

  @override
  String get language => 'Language';

  @override
  String get languageName => 'English';

  @override
  String signedInAs(String phone) {
    return 'Signed in as $phone';
  }

  @override
  String cartCount(int count) {
    return 'Cart, $count items';
  }

  @override
  String get done => 'Done';

  @override
  String get dobSheetTitle => 'Date of birth';
}
