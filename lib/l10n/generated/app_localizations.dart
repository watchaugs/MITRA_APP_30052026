import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_as.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_or.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('as'),
    Locale('bn'),
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('mr'),
    Locale('or'),
    Locale('pa'),
    Locale('ta'),
    Locale('te')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'MITRA'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'AR Learning Platform'**
  String get tagline;

  /// No description provided for @ministry.
  ///
  /// In en, this message translates to:
  /// **'Ministry of Education, Govt. of India'**
  String get ministry;

  /// No description provided for @splashLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading your world...'**
  String get splashLoading;

  /// No description provided for @onboardTitle1.
  ///
  /// In en, this message translates to:
  /// **'See Your Textbook Come Alive'**
  String get onboardTitle1;

  /// No description provided for @onboardBody1.
  ///
  /// In en, this message translates to:
  /// **'Point your camera at any NCERT textbook page and watch 3D models, animations, and interactive AR experiences appear right in your classroom.'**
  String get onboardBody1;

  /// No description provided for @onboardTitle2.
  ///
  /// In en, this message translates to:
  /// **'Learn, Play, Earn XP'**
  String get onboardTitle2;

  /// No description provided for @onboardBody2.
  ///
  /// In en, this message translates to:
  /// **'Complete topics, ace quizzes, and unlock badges. Climb the leaderboard and prove you\'re the best in your class!'**
  String get onboardBody2;

  /// No description provided for @onboardTitle3.
  ///
  /// In en, this message translates to:
  /// **'Available in Your Language'**
  String get onboardTitle3;

  /// No description provided for @onboardBody3.
  ///
  /// In en, this message translates to:
  /// **'MITRA speaks your language — Hindi, Tamil, Telugu, Kannada, Bengali, Gujarati, Marathi and more. Learning has never felt this close to home.'**
  String get onboardBody3;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started →'**
  String get getStarted;

  /// No description provided for @skipIntro.
  ///
  /// In en, this message translates to:
  /// **'Skip intro'**
  String get skipIntro;

  /// No description provided for @namaste.
  ///
  /// In en, this message translates to:
  /// **'Namaste! 🙏'**
  String get namaste;

  /// No description provided for @signInContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue learning'**
  String get signInContinue;

  /// No description provided for @iAmA.
  ///
  /// In en, this message translates to:
  /// **'I am a'**
  String get iAmA;

  /// No description provided for @student.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get student;

  /// No description provided for @teacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get teacher;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtp;

  /// No description provided for @otpSentWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'OTP sent via WhatsApp to'**
  String get otpSentWhatsApp;

  /// No description provided for @verifyLogin.
  ///
  /// In en, this message translates to:
  /// **'Verify & Login →'**
  String get verifyLogin;

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in'**
  String get resendIn;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'s'**
  String get seconds;

  /// No description provided for @chooseAvatar.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Avatar'**
  String get chooseAvatar;

  /// No description provided for @avatarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This will show on your profile & leaderboard'**
  String get avatarSubtitle;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// No description provided for @yourClass.
  ///
  /// In en, this message translates to:
  /// **'Your Class'**
  String get yourClass;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue →'**
  String get continueBtn;

  /// No description provided for @selectState.
  ///
  /// In en, this message translates to:
  /// **'Select Your State'**
  String get selectState;

  /// No description provided for @stateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll show content specific to your state curriculum'**
  String get stateSubtitle;

  /// No description provided for @detectAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto-detect my location'**
  String get detectAuto;

  /// No description provided for @selectManually.
  ///
  /// In en, this message translates to:
  /// **'Select manually'**
  String get selectManually;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning,'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon,'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening,'**
  String get goodEvening;

  /// No description provided for @dayStreak.
  ///
  /// In en, this message translates to:
  /// **'day streak'**
  String get dayStreak;

  /// No description provided for @xpPoints.
  ///
  /// In en, this message translates to:
  /// **'XP'**
  String get xpPoints;

  /// No description provided for @inClass.
  ///
  /// In en, this message translates to:
  /// **'in class'**
  String get inClass;

  /// No description provided for @continueLearning.
  ///
  /// In en, this message translates to:
  /// **'Continue Learning'**
  String get continueLearning;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @subjects.
  ///
  /// In en, this message translates to:
  /// **'Subjects'**
  String get subjects;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @openAR.
  ///
  /// In en, this message translates to:
  /// **'Open AR'**
  String get openAR;

  /// No description provided for @takeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Take Quiz'**
  String get takeQuiz;

  /// No description provided for @leaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboard;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @classRank.
  ///
  /// In en, this message translates to:
  /// **'Class Rank'**
  String get classRank;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navLearn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get navLearn;

  /// No description provided for @navAR.
  ///
  /// In en, this message translates to:
  /// **'AR'**
  String get navAR;

  /// No description provided for @navRanks.
  ///
  /// In en, this message translates to:
  /// **'Ranks'**
  String get navRanks;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @searchTopics.
  ///
  /// In en, this message translates to:
  /// **'Search topics, chapters...'**
  String get searchTopics;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @arReady.
  ///
  /// In en, this message translates to:
  /// **'AR Ready'**
  String get arReady;

  /// No description provided for @incomplete.
  ///
  /// In en, this message translates to:
  /// **'Incomplete'**
  String get incomplete;

  /// No description provided for @arScanning.
  ///
  /// In en, this message translates to:
  /// **'AR SCANNING'**
  String get arScanning;

  /// No description provided for @rotate.
  ///
  /// In en, this message translates to:
  /// **'Rotate'**
  String get rotate;

  /// No description provided for @zoom.
  ///
  /// In en, this message translates to:
  /// **'Zoom'**
  String get zoom;

  /// No description provided for @labels.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get labels;

  /// No description provided for @snap.
  ///
  /// In en, this message translates to:
  /// **'Snap'**
  String get snap;

  /// No description provided for @takeQuizOnTopic.
  ///
  /// In en, this message translates to:
  /// **'📝 Take Quiz on This Topic'**
  String get takeQuizOnTopic;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'QUESTION'**
  String get question;

  /// No description provided for @questionOf.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get questionOf;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correct;

  /// No description provided for @wrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong'**
  String get wrong;

  /// No description provided for @nextQuestion.
  ///
  /// In en, this message translates to:
  /// **'Next Question →'**
  String get nextQuestion;

  /// No description provided for @submitQuiz.
  ///
  /// In en, this message translates to:
  /// **'Submit Quiz'**
  String get submitQuiz;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent!'**
  String get excellent;

  /// No description provided for @youScored.
  ///
  /// In en, this message translates to:
  /// **'You scored'**
  String get youScored;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'on'**
  String get on;

  /// No description provided for @xpEarned.
  ///
  /// In en, this message translates to:
  /// **'XP Earned'**
  String get xpEarned;

  /// No description provided for @timeTaken.
  ///
  /// In en, this message translates to:
  /// **'Time Taken'**
  String get timeTaken;

  /// No description provided for @badgeUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Badge Unlocked!'**
  String get badgeUnlocked;

  /// No description provided for @continueLearningBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue Learning →'**
  String get continueLearningBtn;

  /// No description provided for @reviewAnswers.
  ///
  /// In en, this message translates to:
  /// **'Review Answers'**
  String get reviewAnswers;

  /// No description provided for @myBadges.
  ///
  /// In en, this message translates to:
  /// **'My Badges'**
  String get myBadges;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @offlineMode.
  ///
  /// In en, this message translates to:
  /// **'Offline Mode'**
  String get offlineMode;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkTheme;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @textSize.
  ///
  /// In en, this message translates to:
  /// **'Text Size'**
  String get textSize;

  /// No description provided for @arContent.
  ///
  /// In en, this message translates to:
  /// **'AR & Content'**
  String get arContent;

  /// No description provided for @autoDownloadOffline.
  ///
  /// In en, this message translates to:
  /// **'Auto-download Offline'**
  String get autoDownloadOffline;

  /// No description provided for @wifiOnlyDownload.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi Only Download'**
  String get wifiOnlyDownload;

  /// No description provided for @arSoundEffects.
  ///
  /// In en, this message translates to:
  /// **'AR Sound Effects'**
  String get arSoundEffects;

  /// No description provided for @dailyReminders.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminders'**
  String get dailyReminders;

  /// No description provided for @leaderboardUpdates.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard Updates'**
  String get leaderboardUpdates;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @childSafety.
  ///
  /// In en, this message translates to:
  /// **'Child Safety Policy'**
  String get childSafety;

  /// No description provided for @dataConsent.
  ///
  /// In en, this message translates to:
  /// **'Data & Consent'**
  String get dataConsent;

  /// No description provided for @watchToEarnXP.
  ///
  /// In en, this message translates to:
  /// **'Watch to earn +50 XP'**
  String get watchToEarnXP;

  /// No description provided for @skipAd.
  ///
  /// In en, this message translates to:
  /// **'Skip Ad »'**
  String get skipAd;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learnMore;

  /// No description provided for @earnByWatching.
  ///
  /// In en, this message translates to:
  /// **'Earn 50 XP by watching the full ad'**
  String get earnByWatching;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Showing downloaded content.'**
  String get offlineBanner;

  /// No description provided for @syncingContent.
  ///
  /// In en, this message translates to:
  /// **'Syncing latest content...'**
  String get syncingContent;

  /// No description provided for @downloadComplete.
  ///
  /// In en, this message translates to:
  /// **'Download complete. Available offline.'**
  String get downloadComplete;

  /// No description provided for @consentTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Privacy Matters'**
  String get consentTitle;

  /// No description provided for @consentBody.
  ///
  /// In en, this message translates to:
  /// **'MITRA collects your name, class, school and learning progress to personalise your experience. We never sell your data. As a student under 18, a parent or guardian must consent. By continuing, you confirm you have parental consent.'**
  String get consentBody;

  /// No description provided for @consentAgree.
  ///
  /// In en, this message translates to:
  /// **'I Agree & Continue'**
  String get consentAgree;

  /// No description provided for @consentDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get consentDecline;

  /// No description provided for @parentalConsent.
  ///
  /// In en, this message translates to:
  /// **'Parental Consent'**
  String get parentalConsent;

  /// No description provided for @parentPhone.
  ///
  /// In en, this message translates to:
  /// **'Parent\'s Mobile Number'**
  String get parentPhone;

  /// No description provided for @sendConsentOtp.
  ///
  /// In en, this message translates to:
  /// **'Send Consent OTP →'**
  String get sendConsentOtp;

  /// No description provided for @teacherMode.
  ///
  /// In en, this message translates to:
  /// **'TEACHER MODE'**
  String get teacherMode;

  /// No description provided for @students.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get students;

  /// No description provided for @avgProgress.
  ///
  /// In en, this message translates to:
  /// **'Avg Progress'**
  String get avgProgress;

  /// No description provided for @activeToday.
  ///
  /// In en, this message translates to:
  /// **'Active Today'**
  String get activeToday;

  /// No description provided for @classes.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get classes;

  /// No description provided for @viewStudentAnalytics.
  ///
  /// In en, this message translates to:
  /// **'📊 View Student Analytics'**
  String get viewStudentAnalytics;

  /// No description provided for @assignQuiz.
  ///
  /// In en, this message translates to:
  /// **'📝 Assign Quiz'**
  String get assignQuiz;

  /// No description provided for @pushContent.
  ///
  /// In en, this message translates to:
  /// **'📚 Push Content'**
  String get pushContent;

  /// No description provided for @myClasses.
  ///
  /// In en, this message translates to:
  /// **'My Classes'**
  String get myClasses;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'as',
        'bn',
        'en',
        'gu',
        'hi',
        'kn',
        'mr',
        'or',
        'pa',
        'ta',
        'te'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'as':
      return AppLocalizationsAs();
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'mr':
      return AppLocalizationsMr();
    case 'or':
      return AppLocalizationsOr();
    case 'pa':
      return AppLocalizationsPa();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
