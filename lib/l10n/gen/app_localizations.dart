import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_my.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('my'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'J\'Donuts'**
  String get appTitle;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Round food for every mood'**
  String get onboardingTitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get started'**
  String get getStarted;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveAccount;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @continueWith.
  ///
  /// In en, this message translates to:
  /// **'Continue with {provider}'**
  String continueWith(String provider);

  /// No description provided for @comingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'{feature} is coming soon'**
  String comingSoonTitle(String feature);

  /// No description provided for @socialUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Signing in with {provider} isn\'t part of this demo. Use your phone number instead.'**
  String socialUnavailable(String provider);

  /// No description provided for @legalPrefix.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you acknowledge that you have read and agree to our '**
  String get legalPrefix;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// No description provided for @legalAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get legalAnd;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @legalUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The full {document} will open here in the live app.'**
  String legalUnavailable(String document);

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @phoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get phoneTitle;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'09 xxx xxx xxx'**
  String get phoneHint;

  /// No description provided for @phoneErrorEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number.'**
  String get phoneErrorEmpty;

  /// No description provided for @phoneErrorInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a Myanmar mobile number, like 09 254 135 592.'**
  String get phoneErrorInvalid;

  /// No description provided for @phoneNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'This number isn\'t registered yet.'**
  String get phoneNotRegistered;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAccount;

  /// No description provided for @phoneAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This number already has an account.'**
  String get phoneAlreadyRegistered;

  /// No description provided for @logInInstead.
  ///
  /// In en, this message translates to:
  /// **'Log in instead'**
  String get logInInstead;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @stepProgress.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String stepProgress(int step, int total);

  /// No description provided for @stepsComplete.
  ///
  /// In en, this message translates to:
  /// **'All steps complete'**
  String get stepsComplete;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your number'**
  String get otpTitle;

  /// No description provided for @otpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent 6 digit OTP to {phone}'**
  String otpSubtitle(String phone);

  /// No description provided for @otpWrong.
  ///
  /// In en, this message translates to:
  /// **'That code isn\'t right. {attemptsLeft, plural, =1{1 try left.} other{{attemptsLeft} tries left.}}'**
  String otpWrong(int attemptsLeft);

  /// No description provided for @otpLocked.
  ///
  /// In en, this message translates to:
  /// **'Too many wrong codes. Request a new code to try again.'**
  String get otpLocked;

  /// No description provided for @otpNoCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get otpNoCode;

  /// No description provided for @otpResendIn.
  ///
  /// In en, this message translates to:
  /// **'resend in '**
  String get otpResendIn;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **' min'**
  String get minutesShort;

  /// No description provided for @otpResend.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get otpResend;

  /// No description provided for @otpResent.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a new code.'**
  String get otpResent;

  /// No description provided for @otpFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get otpFieldLabel;

  /// No description provided for @nameTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your name?'**
  String get nameTitle;

  /// No description provided for @firstNameHint.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstNameHint;

  /// No description provided for @lastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastNameHint;

  /// No description provided for @nameErrorRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your first name.'**
  String get nameErrorRequired;

  /// No description provided for @nameErrorTooLong.
  ///
  /// In en, this message translates to:
  /// **'Use 50 characters or fewer.'**
  String get nameErrorTooLong;

  /// No description provided for @nameErrorCharacters.
  ///
  /// In en, this message translates to:
  /// **'Use letters and spaces only.'**
  String get nameErrorCharacters;

  /// No description provided for @dobTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your date of birth?'**
  String get dobTitle;

  /// No description provided for @monthHint.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get monthHint;

  /// No description provided for @dayHint.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get dayHint;

  /// No description provided for @yearHint.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get yearHint;

  /// No description provided for @dobErrorInvalid.
  ///
  /// In en, this message translates to:
  /// **'That date doesn\'t exist. Check the day and month.'**
  String get dobErrorInvalid;

  /// No description provided for @dobErrorFuture.
  ///
  /// In en, this message translates to:
  /// **'Your date of birth can\'t be in the future.'**
  String get dobErrorFuture;

  /// No description provided for @dobErrorTooYoung.
  ///
  /// In en, this message translates to:
  /// **'You need to be at least {age} years old to join.'**
  String dobErrorTooYoung(int age);

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the world of J\'donuts'**
  String get welcomeTitle;

  /// No description provided for @letsExplore.
  ///
  /// In en, this message translates to:
  /// **'Let\'s explore'**
  String get letsExplore;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericError;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Check your connection and try again.'**
  String get networkError;

  /// No description provided for @memberTier.
  ///
  /// In en, this message translates to:
  /// **'{tier} member'**
  String memberTier(String tier);

  /// No description provided for @pointsToNextTier.
  ///
  /// In en, this message translates to:
  /// **'{points} points left to become {tier} Member'**
  String pointsToNextTier(String points, String tier);

  /// No description provided for @topTier.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached the top tier'**
  String get topTier;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications, {count} unread'**
  String notifications(int count);

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Showing saved data.'**
  String get offlineBanner;

  /// No description provided for @refreshFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t refresh. Showing saved data.'**
  String get refreshFailed;

  /// No description provided for @refreshed.
  ///
  /// In en, this message translates to:
  /// **'Up to date.'**
  String get refreshed;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all {section}'**
  String seeAll(String section);

  /// No description provided for @sectionEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet. Check back soon.'**
  String get sectionEmpty;

  /// No description provided for @sectionError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this section.'**
  String get sectionError;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @discountOff.
  ///
  /// In en, this message translates to:
  /// **'{percent}% off'**
  String discountOff(int percent);

  /// No description provided for @newBadge.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newBadge;

  /// No description provided for @shopsTitle.
  ///
  /// In en, this message translates to:
  /// **'There are {count} J\'Donut shops near you.'**
  String shopsTitle(int count);

  /// No description provided for @exploreNow.
  ///
  /// In en, this message translates to:
  /// **'Explore now'**
  String get exploreNow;

  /// No description provided for @orderOnline.
  ///
  /// In en, this message translates to:
  /// **'Order Online'**
  String get orderOnline;

  /// No description provided for @priceMmk.
  ///
  /// In en, this message translates to:
  /// **'{price} MMK'**
  String priceMmk(String price);

  /// No description provided for @whatsThis.
  ///
  /// In en, this message translates to:
  /// **'What\'s this?'**
  String get whatsThis;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get addToCart;

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added {quantity} × {name} to your cart.'**
  String addedToCart(int quantity, String name);

  /// No description provided for @increaseQuantity.
  ///
  /// In en, this message translates to:
  /// **'Increase quantity'**
  String get increaseQuantity;

  /// No description provided for @decreaseQuantity.
  ///
  /// In en, this message translates to:
  /// **'Decrease quantity'**
  String get decreaseQuantity;

  /// No description provided for @quantityValue.
  ///
  /// In en, this message translates to:
  /// **'Quantity {quantity}'**
  String quantityValue(int quantity);

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'This product isn\'t available any more.'**
  String get productNotFound;

  /// No description provided for @rewardsTitle.
  ///
  /// In en, this message translates to:
  /// **'J\' Donuts Rewards'**
  String get rewardsTitle;

  /// No description provided for @rewardsPill.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewardsPill;

  /// No description provided for @totalPoints.
  ///
  /// In en, this message translates to:
  /// **'Total points'**
  String get totalPoints;

  /// No description provided for @tierHereNow.
  ///
  /// In en, this message translates to:
  /// **'You\'re here now'**
  String get tierHereNow;

  /// No description provided for @tierRemaining.
  ///
  /// In en, this message translates to:
  /// **'{points} pts Remaining to become {tier}'**
  String tierRemaining(String points, String tier);

  /// No description provided for @tierSoon.
  ///
  /// In en, this message translates to:
  /// **'You\'ll be here soon'**
  String get tierSoon;

  /// No description provided for @tierReached.
  ///
  /// In en, this message translates to:
  /// **'Reached'**
  String get tierReached;

  /// No description provided for @tabEarn.
  ///
  /// In en, this message translates to:
  /// **'Eat more earn more'**
  String get tabEarn;

  /// No description provided for @tabGift.
  ///
  /// In en, this message translates to:
  /// **'Gift'**
  String get tabGift;

  /// No description provided for @earn.
  ///
  /// In en, this message translates to:
  /// **'Earn'**
  String get earn;

  /// No description provided for @redeem.
  ///
  /// In en, this message translates to:
  /// **'Redeem'**
  String get redeem;

  /// No description provided for @pointsShort.
  ///
  /// In en, this message translates to:
  /// **'{points} pts'**
  String pointsShort(String points);

  /// No description provided for @challengeProgress.
  ///
  /// In en, this message translates to:
  /// **'{progress}/{goal}'**
  String challengeProgress(int progress, int goal);

  /// No description provided for @earnTapped.
  ///
  /// In en, this message translates to:
  /// **'Points are added at the counter in the live app.'**
  String get earnTapped;

  /// No description provided for @redeemTapped.
  ///
  /// In en, this message translates to:
  /// **'Gifts are redeemed at the counter in the live app.'**
  String get redeemTapped;

  /// No description provided for @rewardsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No challenges right now. Check back soon.'**
  String get rewardsEmpty;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navReward.
  ///
  /// In en, this message translates to:
  /// **'Reward'**
  String get navReward;

  /// No description provided for @navOrder.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get navOrder;

  /// No description provided for @navWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get navWallet;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @comingSoonBody.
  ///
  /// In en, this message translates to:
  /// **'This tab isn\'t part of the code test.'**
  String get comingSoonBody;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @logOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logOutConfirmTitle;

  /// No description provided for @logOutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need your phone number and a code to log in again.'**
  String get logOutConfirmBody;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageName.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageName;

  /// No description provided for @signedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {phone}'**
  String signedInAs(String phone);

  /// No description provided for @cartCount.
  ///
  /// In en, this message translates to:
  /// **'Cart, {count} items'**
  String cartCount(int count);

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @dobSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dobSheetTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'my'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'my':
      return AppLocalizationsMy();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
