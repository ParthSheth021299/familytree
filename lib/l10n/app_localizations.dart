import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('gu'),
    Locale('hi')
  ];

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Family Tree'**
  String get title;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get searchHint;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @children.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get children;

  /// No description provided for @bloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Blood Group'**
  String get bloodGroup;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @tip.
  ///
  /// In en, this message translates to:
  /// **'Tap on the tree icon to explore family structure.\nFilter by branch or search names easily!'**
  String get tip;

  /// No description provided for @madeWithLoveForDahibanagar.
  ///
  /// In en, this message translates to:
  /// **'Made with ❤️ for Dahibanagar'**
  String get madeWithLoveForDahibanagar;

  /// No description provided for @addFamily.
  ///
  /// In en, this message translates to:
  /// **'Add Family'**
  String get addFamily;

  /// No description provided for @birthdaysToday.
  ///
  /// In en, this message translates to:
  /// **'Birthdays Today'**
  String get birthdaysToday;

  /// No description provided for @familyStats.
  ///
  /// In en, this message translates to:
  /// **'Family Stats'**
  String get familyStats;

  /// No description provided for @addFamilyMember.
  ///
  /// In en, this message translates to:
  /// **'Add Family Member'**
  String get addFamilyMember;

  /// No description provided for @selectParent.
  ///
  /// In en, this message translates to:
  /// **'Select Parent (Father or Mother)'**
  String get selectParent;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @totalMembers.
  ///
  /// In en, this message translates to:
  /// **'Total Members:'**
  String get totalMembers;

  /// No description provided for @males.
  ///
  /// In en, this message translates to:
  /// **'Males'**
  String get males;

  /// No description provided for @females.
  ///
  /// In en, this message translates to:
  /// **'Females'**
  String get females;

  /// No description provided for @married.
  ///
  /// In en, this message translates to:
  /// **'Married'**
  String get married;

  /// No description provided for @dobAdded.
  ///
  /// In en, this message translates to:
  /// **'DOB Added'**
  String get dobAdded;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @dob.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dob;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @areYouMarried.
  ///
  /// In en, this message translates to:
  /// **'Are you married?'**
  String get areYouMarried;

  /// No description provided for @spouseDetails.
  ///
  /// In en, this message translates to:
  /// **'Spouse Details'**
  String get spouseDetails;

  /// No description provided for @spouseName.
  ///
  /// In en, this message translates to:
  /// **'Spouse Name'**
  String get spouseName;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @noMembersFound.
  ///
  /// In en, this message translates to:
  /// **'No members found'**
  String get noMembersFound;

  /// No description provided for @memberSummary.
  ///
  /// In en, this message translates to:
  /// **'Member Summary'**
  String get memberSummary;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @no_birthdays_today.
  ///
  /// In en, this message translates to:
  /// **'No birthdays today'**
  String get no_birthdays_today;

  /// No description provided for @upcoming_birthdays.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Birthdays'**
  String get upcoming_birthdays;

  /// No description provided for @no_upcoming_birthdays.
  ///
  /// In en, this message translates to:
  /// **'No upcoming birthdays'**
  String get no_upcoming_birthdays;

  /// No description provided for @guest_user.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guest_user;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// No description provided for @treeView.
  ///
  /// In en, this message translates to:
  /// **'Tree View'**
  String get treeView;

  /// No description provided for @memories.
  ///
  /// In en, this message translates to:
  /// **'Memories'**
  String get memories;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @familyMemberAdded.
  ///
  /// In en, this message translates to:
  /// **'Family member added'**
  String get familyMemberAdded;

  /// No description provided for @selectMainRoot.
  ///
  /// In en, this message translates to:
  /// **'Select Main Root:'**
  String get selectMainRoot;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @markAsInternalRoot.
  ///
  /// In en, this message translates to:
  /// **'Mark as Internal Root'**
  String get markAsInternalRoot;

  /// No description provided for @selectFamilyRootPerson.
  ///
  /// In en, this message translates to:
  /// **'Select Family Root Person'**
  String get selectFamilyRootPerson;

  /// No description provided for @saveMember.
  ///
  /// In en, this message translates to:
  /// **'Save Member'**
  String get saveMember;

  /// No description provided for @memberUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Member updated successfully'**
  String get memberUpdatedSuccessfully;

  /// No description provided for @spouseWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Spouse Whatsapp'**
  String get spouseWhatsapp;

  /// No description provided for @spouseBloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Spouse Blood Group'**
  String get spouseBloodGroup;

  /// No description provided for @spouseEmail.
  ///
  /// In en, this message translates to:
  /// **'Spouse Email'**
  String get spouseEmail;

  /// No description provided for @spouseLocation.
  ///
  /// In en, this message translates to:
  /// **'Spouse Location'**
  String get spouseLocation;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @hasChildren.
  ///
  /// In en, this message translates to:
  /// **'Has Children'**
  String get hasChildren;

  /// No description provided for @isInternalRoot.
  ///
  /// In en, this message translates to:
  /// **'Is Internal Root'**
  String get isInternalRoot;

  /// No description provided for @isMarried.
  ///
  /// In en, this message translates to:
  /// **'Is Married'**
  String get isMarried;

  /// No description provided for @mainRoot.
  ///
  /// In en, this message translates to:
  /// **'Main Root'**
  String get mainRoot;

  /// No description provided for @familyMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get familyMembers;

  /// No description provided for @noGroupedMemberFound.
  ///
  /// In en, this message translates to:
  /// **'No grouped members found.'**
  String get noGroupedMemberFound;

  /// No description provided for @editMember.
  ///
  /// In en, this message translates to:
  /// **'Edit Member'**
  String get editMember;

  /// No description provided for @confrimDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Deletion'**
  String get confrimDelete;

  /// No description provided for @confirmText.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this member?\n'**
  String get confirmText;

  /// No description provided for @unDone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get unDone;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @memberDelete.
  ///
  /// In en, this message translates to:
  /// **'Member deleted successfully'**
  String get memberDelete;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @searchByName.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get searchByName;

  /// No description provided for @hideSpouse.
  ///
  /// In en, this message translates to:
  /// **'Hide Spouse'**
  String get hideSpouse;

  /// No description provided for @showSpouse.
  ///
  /// In en, this message translates to:
  /// **'Show Spouse'**
  String get showSpouse;

  /// No description provided for @spouse.
  ///
  /// In en, this message translates to:
  /// **'Spouse'**
  String get spouse;

  /// No description provided for @familyMoments.
  ///
  /// In en, this message translates to:
  /// **'Family Moments'**
  String get familyMoments;

  /// No description provided for @addMoment.
  ///
  /// In en, this message translates to:
  /// **'Add Moment'**
  String get addMoment;

  /// No description provided for @enterTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter title'**
  String get enterTitle;

  /// No description provided for @enterCaption.
  ///
  /// In en, this message translates to:
  /// **'Enter caption'**
  String get enterCaption;

  /// No description provided for @uploadImages.
  ///
  /// In en, this message translates to:
  /// **'Upload Images'**
  String get uploadImages;

  /// No description provided for @saveMoment.
  ///
  /// In en, this message translates to:
  /// **'Save Moment'**
  String get saveMoment;

  /// No description provided for @titleIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get titleIsRequired;

  /// No description provided for @momentSaved.
  ///
  /// In en, this message translates to:
  /// **'Moment Saved'**
  String get momentSaved;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @languages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languages;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get selectLanguage;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginText.
  ///
  /// In en, this message translates to:
  /// **'Login as Admin or Temp User'**
  String get loginText;

  /// No description provided for @userLogs.
  ///
  /// In en, this message translates to:
  /// **'User Logs'**
  String get userLogs;

  /// No description provided for @noUserFound.
  ///
  /// In en, this message translates to:
  /// **'No users found.'**
  String get noUserFound;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Status: Active'**
  String get statusActive;

  /// No description provided for @statusInActive.
  ///
  /// In en, this message translates to:
  /// **'Status: Inactive'**
  String get statusInActive;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @viewLogs.
  ///
  /// In en, this message translates to:
  /// **'View Logs'**
  String get viewLogs;

  /// No description provided for @createTemporaryID.
  ///
  /// In en, this message translates to:
  /// **'Create Temporary ID'**
  String get createTemporaryID;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @temporaryAccess.
  ///
  /// In en, this message translates to:
  /// **'Temporary Access'**
  String get temporaryAccess;

  /// No description provided for @enterEmailAndPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter email and password to create a temporary user.'**
  String get enterEmailAndPassword;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get enterEmail;

  /// No description provided for @emailValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter an email'**
  String get emailValidation;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get enterPassword;

  /// No description provided for @passwordValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter Password'**
  String get passwordValidation;

  /// No description provided for @temporaryUser.
  ///
  /// In en, this message translates to:
  /// **'Create Temporary User'**
  String get temporaryUser;

  /// No description provided for @adminPanel.
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get adminPanel;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @houseRoot.
  ///
  /// In en, this message translates to:
  /// **'House Root'**
  String get houseRoot;

  /// No description provided for @applyFilter.
  ///
  /// In en, this message translates to:
  /// **'Apply Filter'**
  String get applyFilter;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @upcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Events'**
  String get upcomingEvents;

  /// No description provided for @noUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'No Upcoming Events'**
  String get noUpcomingEvents;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get invalidEmail;

  /// No description provided for @createEvent.
  ///
  /// In en, this message translates to:
  /// **'Create Event'**
  String get createEvent;

  /// No description provided for @eventDescription.
  ///
  /// In en, this message translates to:
  /// **'Event Description'**
  String get eventDescription;

  /// No description provided for @noEventDate.
  ///
  /// In en, this message translates to:
  /// **'No Date Selected'**
  String get noEventDate;

  /// No description provided for @eventTitle.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get eventTitle;

  /// No description provided for @chooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose Date'**
  String get chooseDate;

  /// No description provided for @pickImages.
  ///
  /// In en, this message translates to:
  /// **'Pick Images'**
  String get pickImages;

  /// No description provided for @uploadSelected.
  ///
  /// In en, this message translates to:
  /// **'Upload Selected'**
  String get uploadSelected;

  /// No description provided for @uploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get uploaded;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'image(s)'**
  String get image;

  /// No description provided for @viewAllMoments.
  ///
  /// In en, this message translates to:
  /// **'View all Moments'**
  String get viewAllMoments;

  /// No description provided for @createNewMoment.
  ///
  /// In en, this message translates to:
  /// **'Create a New Moment'**
  String get createNewMoment;

  /// No description provided for @createNewMomentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Capture and share a special memory with your family.'**
  String get createNewMomentSubtitle;

  /// No description provided for @spouseGender.
  ///
  /// In en, this message translates to:
  /// **'Spouse Gender'**
  String get spouseGender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @spouseDob.
  ///
  /// In en, this message translates to:
  /// **'Spouse Date of Birth'**
  String get spouseDob;

  /// No description provided for @spousePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Spouse Phone Number'**
  String get spousePhoneNumber;

  /// No description provided for @selectRootPerson.
  ///
  /// In en, this message translates to:
  /// **'Select root person'**
  String get selectRootPerson;

  /// No description provided for @eventCalendar.
  ///
  /// In en, this message translates to:
  /// **'Event Calendar'**
  String get eventCalendar;

  /// No description provided for @noteTitle.
  ///
  /// In en, this message translates to:
  /// **'NOTE:'**
  String get noteTitle;

  /// No description provided for @noteMessage.
  ///
  /// In en, this message translates to:
  /// **'Before adding any other family member, first add the root/main member and select it as the internal root member.'**
  String get noteMessage;

  /// No description provided for @loadingDashboard.
  ///
  /// In en, this message translates to:
  /// **'Loading Dashboard...'**
  String get loadingDashboard;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @welcomeDashboard.
  ///
  /// In en, this message translates to:
  /// **'Welcome to your family dashboard'**
  String get welcomeDashboard;

  /// No description provided for @familyOverview.
  ///
  /// In en, this message translates to:
  /// **'Family Overview'**
  String get familyOverview;

  /// No description provided for @demographics.
  ///
  /// In en, this message translates to:
  /// **'Demographics'**
  String get demographics;

  /// No description provided for @genderDistribution.
  ///
  /// In en, this message translates to:
  /// **'Gender Distribution'**
  String get genderDistribution;

  /// No description provided for @generatingPdf.
  ///
  /// In en, this message translates to:
  /// **'Generating PDF...'**
  String get generatingPdf;

  /// No description provided for @errorCapturingTree.
  ///
  /// In en, this message translates to:
  /// **'Error capturing tree:'**
  String get errorCapturingTree;

  /// No description provided for @downloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get downloadPdf;

  /// No description provided for @memberDetails.
  ///
  /// In en, this message translates to:
  /// **'Member Details'**
  String get memberDetails;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @medicalInformation.
  ///
  /// In en, this message translates to:
  /// **'Medical Information'**
  String get medicalInformation;

  /// No description provided for @living.
  ///
  /// In en, this message translates to:
  /// **'Living'**
  String get living;

  /// No description provided for @passedAway.
  ///
  /// In en, this message translates to:
  /// **'Passed Away'**
  String get passedAway;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get birthDate;

  /// No description provided for @downloadCsv.
  ///
  /// In en, this message translates to:
  /// **'Download CSV'**
  String get downloadCsv;

  /// No description provided for @deleteRootWarning.
  ///
  /// In en, this message translates to:
  /// **'You are about to delete the root member of your family. After deleting, it will affect your family organisation tree.'**
  String get deleteRootWarning;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this member?'**
  String get deleteConfirmMessage;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @selectFields.
  ///
  /// In en, this message translates to:
  /// **'Select Fields'**
  String get selectFields;

  /// No description provided for @createPdf.
  ///
  /// In en, this message translates to:
  /// **'Create PDF'**
  String get createPdf;

  /// No description provided for @spouseIsAlive.
  ///
  /// In en, this message translates to:
  /// **'Spouse is Alive'**
  String get spouseIsAlive;

  /// No description provided for @alive.
  ///
  /// In en, this message translates to:
  /// **'Alive'**
  String get alive;

  /// No description provided for @memberDataUpdated.
  ///
  /// In en, this message translates to:
  /// **'Member Data Updated'**
  String get memberDataUpdated;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @errorLoadingEvents.
  ///
  /// In en, this message translates to:
  /// **'Error loading events'**
  String get errorLoadingEvents;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date:'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time:'**
  String get time;

  /// No description provided for @place.
  ///
  /// In en, this message translates to:
  /// **'Place:'**
  String get place;

  /// No description provided for @noEventsOnThisDay.
  ///
  /// In en, this message translates to:
  /// **'No events on this day'**
  String get noEventsOnThisDay;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @event.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get event;

  /// No description provided for @pleaseSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Please select date'**
  String get pleaseSelectDate;

  /// No description provided for @eventCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Event Created Successfully'**
  String get eventCreatedSuccessfully;

  /// No description provided for @viewEvents.
  ///
  /// In en, this message translates to:
  /// **'View Events'**
  String get viewEvents;

  /// No description provided for @planNewEvent.
  ///
  /// In en, this message translates to:
  /// **'Plan a New Event'**
  String get planNewEvent;

  /// No description provided for @markSpecialOccasions.
  ///
  /// In en, this message translates to:
  /// **'Mark special occasions and keep your family connected with upcoming events.'**
  String get markSpecialOccasions;

  /// No description provided for @enterDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter Description'**
  String get enterDescription;

  /// No description provided for @saveEvent.
  ///
  /// In en, this message translates to:
  /// **'Save Event'**
  String get saveEvent;

  /// No description provided for @controlPanel.
  ///
  /// In en, this message translates to:
  /// **'Control Panel'**
  String get controlPanel;

  /// No description provided for @chooseVisibleData.
  ///
  /// In en, this message translates to:
  /// **'Choose data to be visible in tree view'**
  String get chooseVisibleData;

  /// No description provided for @treeVisibilitySettings.
  ///
  /// In en, this message translates to:
  /// **'Tree Visibility Settings'**
  String get treeVisibilitySettings;

  /// No description provided for @saveSettings.
  ///
  /// In en, this message translates to:
  /// **'Save Settings'**
  String get saveSettings;

  /// No description provided for @controlVisibleInfo.
  ///
  /// In en, this message translates to:
  /// **'Control which information is visible in the family tree.'**
  String get controlVisibleInfo;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Info'**
  String get personalInfo;

  /// No description provided for @showPhotos.
  ///
  /// In en, this message translates to:
  /// **'Show Photos'**
  String get showPhotos;

  /// No description provided for @showDOB.
  ///
  /// In en, this message translates to:
  /// **'Show Date of Birth'**
  String get showDOB;

  /// No description provided for @showBloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Show Blood Group'**
  String get showBloodGroup;

  /// No description provided for @showLocation.
  ///
  /// In en, this message translates to:
  /// **'Show Location'**
  String get showLocation;

  /// No description provided for @relationships.
  ///
  /// In en, this message translates to:
  /// **'Relationships'**
  String get relationships;

  /// No description provided for @contactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact Info'**
  String get contactInfo;

  /// No description provided for @showContactDetails.
  ///
  /// In en, this message translates to:
  /// **'Show Contact Details'**
  String get showContactDetails;

  /// No description provided for @showEmail.
  ///
  /// In en, this message translates to:
  /// **'Show Email'**
  String get showEmail;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @showAliveDeadStatus.
  ///
  /// In en, this message translates to:
  /// **'Show Alive/Dead Status'**
  String get showAliveDeadStatus;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully!'**
  String get settingsSaved;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download App from Google Drive'**
  String get download;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'gu', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'gu': return AppLocalizationsGu();
    case 'hi': return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
