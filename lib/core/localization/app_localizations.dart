import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
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
    Locale('ar'),
    Locale('en')
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'AI Connect'**
  String get appName;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Check your connection.'**
  String get networkError;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get invalidEmail;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required.'**
  String get passwordRequired;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please check your credentials.'**
  String get loginFailed;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @otp.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get otp;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP sent to your email'**
  String get enterOtp;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @announcements.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get announcements;

  /// No description provided for @courses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get courses;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @newAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'New Announcement'**
  String get newAnnouncement;

  /// No description provided for @noAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'No announcements yet'**
  String get noAnnouncements;

  /// No description provided for @markAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get markAsRead;

  /// No description provided for @unread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unread;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @important.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get important;

  /// No description provided for @urgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get urgent;

  /// No description provided for @assignment.
  ///
  /// In en, this message translates to:
  /// **'Assignment'**
  String get assignment;

  /// No description provided for @material.
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get material;

  /// No description provided for @deadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get deadline;

  /// No description provided for @noCourses.
  ///
  /// In en, this message translates to:
  /// **'No courses available'**
  String get noCourses;

  /// No description provided for @courseDetails.
  ///
  /// In en, this message translates to:
  /// **'Course Details'**
  String get courseDetails;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @newMessage.
  ///
  /// In en, this message translates to:
  /// **'New Message'**
  String get newMessage;

  /// No description provided for @noMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get noMessages;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessage;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @lastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last seen'**
  String get lastSeen;

  /// No description provided for @accountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account Info'**
  String get accountInfo;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkMode;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemDefault;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @logOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOutTitle;

  /// No description provided for @logOutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of your WE School Suez account?'**
  String get logOutMessage;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @studentId.
  ///
  /// In en, this message translates to:
  /// **'Student ID'**
  String get studentId;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @student.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get student;

  /// No description provided for @doctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctor;

  /// No description provided for @teachingAssistant.
  ///
  /// In en, this message translates to:
  /// **'Teaching Assistant'**
  String get teachingAssistant;

  /// No description provided for @others.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get others;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get faq;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @madeWith.
  ///
  /// In en, this message translates to:
  /// **'Made with ❤️ by WE School Suez Team'**
  String get madeWith;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully.'**
  String get passwordChanged;

  /// No description provided for @oldPasswordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Old password is incorrect.'**
  String get oldPasswordIncorrect;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @emptyChat.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet.\nStart chatting!'**
  String get emptyChat;

  /// No description provided for @typeAMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeAMessage;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @deleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteMessage;

  /// No description provided for @editMessage.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editMessage;

  /// No description provided for @announceToAll.
  ///
  /// In en, this message translates to:
  /// **'All Students'**
  String get announceToAll;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @postedBy.
  ///
  /// In en, this message translates to:
  /// **'Posted by'**
  String get postedBy;

  /// No description provided for @audience.
  ///
  /// In en, this message translates to:
  /// **'Audience'**
  String get audience;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @noAttachments.
  ///
  /// In en, this message translates to:
  /// **'No attachments'**
  String get noAttachments;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @upcomingAssignments.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Assignments'**
  String get upcomingAssignments;

  /// No description provided for @noUpcomingAssignments.
  ///
  /// In en, this message translates to:
  /// **'No upcoming assignments'**
  String get noUpcomingAssignments;

  /// No description provided for @submitAssignment.
  ///
  /// In en, this message translates to:
  /// **'Submit Assignment'**
  String get submitAssignment;

  /// No description provided for @submitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get submitted;

  /// No description provided for @notSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Not Submitted'**
  String get notSubmitted;

  /// No description provided for @quiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get quiz;

  /// No description provided for @generateQuiz.
  ///
  /// In en, this message translates to:
  /// **'Generate Quiz'**
  String get generateQuiz;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully.'**
  String get profileUpdated;

  /// No description provided for @universityEmail.
  ///
  /// In en, this message translates to:
  /// **'University Email'**
  String get universityEmail;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @announcementTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get announcementTitle;

  /// No description provided for @announcementDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get announcementDetails;

  /// No description provided for @enterAnnouncementTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter announcement title...'**
  String get enterAnnouncementTitle;

  /// No description provided for @writeAnnouncementContent.
  ///
  /// In en, this message translates to:
  /// **'Write your announcement content here...'**
  String get writeAnnouncementContent;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @loadingCourses.
  ///
  /// In en, this message translates to:
  /// **'Loading your courses…'**
  String get loadingCourses;

  /// No description provided for @selectDeadline.
  ///
  /// In en, this message translates to:
  /// **'Select deadline date & time…'**
  String get selectDeadline;

  /// No description provided for @editAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Edit Announcement'**
  String get editAnnouncement;

  /// No description provided for @deleteAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Delete Announcement'**
  String get deleteAnnouncement;

  /// No description provided for @postAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Post Announcement'**
  String get postAnnouncement;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @addLink.
  ///
  /// In en, this message translates to:
  /// **'Add Link'**
  String get addLink;

  /// No description provided for @attach.
  ///
  /// In en, this message translates to:
  /// **'Attach'**
  String get attach;

  /// No description provided for @attachAFile.
  ///
  /// In en, this message translates to:
  /// **'Attach a file'**
  String get attachAFile;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @document.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get document;

  /// No description provided for @link.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get link;

  /// No description provided for @searchUsers.
  ///
  /// In en, this message translates to:
  /// **'Search users by name or ID…'**
  String get searchUsers;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// No description provided for @assistant.
  ///
  /// In en, this message translates to:
  /// **'Assistant'**
  String get assistant;

  /// No description provided for @newChat.
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get newChat;

  /// No description provided for @searchByNameOrId.
  ///
  /// In en, this message translates to:
  /// **'Search by name or student ID…'**
  String get searchByNameOrId;

  /// No description provided for @findSomeoneToChatWith.
  ///
  /// In en, this message translates to:
  /// **'Find Someone to Chat With'**
  String get findSomeoneToChatWith;

  /// No description provided for @noUsersFoundFor.
  ///
  /// In en, this message translates to:
  /// **'No users found for \"{query}\"'**
  String noUsersFoundFor(String query);

  /// No description provided for @tryDifferentName.
  ///
  /// In en, this message translates to:
  /// **'Try a different name or student ID'**
  String get tryDifferentName;

  /// No description provided for @copyMessage.
  ///
  /// In en, this message translates to:
  /// **'Copy message'**
  String get copyMessage;

  /// No description provided for @editMessageAction.
  ///
  /// In en, this message translates to:
  /// **'Edit message'**
  String get editMessageAction;

  /// No description provided for @deleteMessageAction.
  ///
  /// In en, this message translates to:
  /// **'Delete message'**
  String get deleteMessageAction;

  /// No description provided for @editMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Edit your message…'**
  String get editMessageHint;

  /// No description provided for @searchMessages.
  ///
  /// In en, this message translates to:
  /// **'Search messages…'**
  String get searchMessages;

  /// No description provided for @sendALink.
  ///
  /// In en, this message translates to:
  /// **'Send a Link'**
  String get sendALink;

  /// No description provided for @shareContent.
  ///
  /// In en, this message translates to:
  /// **'Share Content'**
  String get shareContent;

  /// No description provided for @chooseWhatToSend.
  ///
  /// In en, this message translates to:
  /// **'Choose what you would like to send'**
  String get chooseWhatToSend;

  /// No description provided for @failedToLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get failedToLoadProfile;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @editName.
  ///
  /// In en, this message translates to:
  /// **'Edit Name'**
  String get editName;

  /// No description provided for @enterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterYourFullName;

  /// No description provided for @noCoursesYet.
  ///
  /// In en, this message translates to:
  /// **'No Courses Yet'**
  String get noCoursesYet;

  /// No description provided for @noCoursesDescription.
  ///
  /// In en, this message translates to:
  /// **'You have no courses assigned this semester.\nCheck back later for updates.'**
  String get noCoursesDescription;

  /// No description provided for @generatingQuiz.
  ///
  /// In en, this message translates to:
  /// **'Generating your quiz…'**
  String get generatingQuiz;

  /// No description provided for @generatingQuizDesc.
  ///
  /// In en, this message translates to:
  /// **'The AI is reading the lecture and creating\n10 questions just for you.'**
  String get generatingQuizDesc;

  /// No description provided for @couldNotGenerateQuiz.
  ///
  /// In en, this message translates to:
  /// **'Could not generate quiz'**
  String get couldNotGenerateQuiz;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your university account'**
  String get signInSubtitle;

  /// No description provided for @enterOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtpTitle;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a verification code'**
  String get forgotPasswordSubtitle;

  /// No description provided for @createStrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Create a strong new password'**
  String get createStrongPassword;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password Reset!'**
  String get passwordResetSuccess;

  /// No description provided for @passwordResetMessage.
  ///
  /// In en, this message translates to:
  /// **'Your password has been successfully reset.\nYou can now sign in with your new password.'**
  String get passwordResetMessage;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrCode;

  /// No description provided for @alignQrCode.
  ///
  /// In en, this message translates to:
  /// **'Align the QR code within the frame'**
  String get alignQrCode;

  /// No description provided for @deleteAnnouncementConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this announcement?'**
  String get deleteAnnouncementConfirm;

  /// No description provided for @deleteAnnouncementPermanent.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete the announcement. This action cannot be undone.'**
  String get deleteAnnouncementPermanent;

  /// No description provided for @announcementSaved.
  ///
  /// In en, this message translates to:
  /// **'Announcement saved successfully!'**
  String get announcementSaved;

  /// No description provided for @assignmentCreated.
  ///
  /// In en, this message translates to:
  /// **'Assignment created successfully!'**
  String get assignmentCreated;

  /// No description provided for @failedToDeleteAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete announcement'**
  String get failedToDeleteAnnouncement;

  /// No description provided for @messageCopied.
  ///
  /// In en, this message translates to:
  /// **'Message copied'**
  String get messageCopied;

  /// No description provided for @imageSavedToGallery.
  ///
  /// In en, this message translates to:
  /// **'Image saved to gallery'**
  String get imageSavedToGallery;

  /// No description provided for @couldNotSaveImage.
  ///
  /// In en, this message translates to:
  /// **'Could not save image'**
  String get couldNotSaveImage;

  /// No description provided for @saveToGallery.
  ///
  /// In en, this message translates to:
  /// **'Save to gallery'**
  String get saveToGallery;

  /// No description provided for @downloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get downloadFailed;

  /// No description provided for @micPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission denied. Enable it in Settings.'**
  String get micPermissionDenied;

  /// No description provided for @micPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission is required to record voice messages.'**
  String get micPermissionRequired;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @universityId.
  ///
  /// In en, this message translates to:
  /// **'University ID'**
  String get universityId;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your account password'**
  String get changePasswordSubtitle;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get enterCurrentPassword;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @newPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Create a strong password'**
  String get newPasswordHint;

  /// No description provided for @atLeast8CharsRequired.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters required'**
  String get atLeast8CharsRequired;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @reEnterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your new password'**
  String get reEnterNewPassword;

  /// No description provided for @passwordChangedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully!'**
  String get passwordChangedSuccess;

  /// No description provided for @passwordRequirements.
  ///
  /// In en, this message translates to:
  /// **'Password requirements'**
  String get passwordRequirements;

  /// No description provided for @atLeast8Chars.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get atLeast8Chars;

  /// No description provided for @oneUppercaseLetter.
  ///
  /// In en, this message translates to:
  /// **'One uppercase letter (A–Z)'**
  String get oneUppercaseLetter;

  /// No description provided for @oneLowercaseLetter.
  ///
  /// In en, this message translates to:
  /// **'One lowercase letter (a–z)'**
  String get oneLowercaseLetter;

  /// No description provided for @oneNumber.
  ///
  /// In en, this message translates to:
  /// **'One number (0–9)'**
  String get oneNumber;

  /// No description provided for @oneSpecialChar.
  ///
  /// In en, this message translates to:
  /// **'One special character (!@#…)'**
  String get oneSpecialChar;

  /// No description provided for @faqQuestion1.
  ///
  /// In en, this message translates to:
  /// **'How do I reset my password?'**
  String get faqQuestion1;

  /// No description provided for @faqAnswer1.
  ///
  /// In en, this message translates to:
  /// **'Go to Account → Change Password. You\'ll need your current password. If you\'ve forgotten it, use Forgot Password on the login screen.'**
  String get faqAnswer1;

  /// No description provided for @faqQuestion2.
  ///
  /// In en, this message translates to:
  /// **'How are announcements filtered?'**
  String get faqQuestion2;

  /// No description provided for @faqAnswer2.
  ///
  /// In en, this message translates to:
  /// **'Announcements are filtered by your role, level, and enrolled courses. Use the filter chips on the home screen to narrow down by type.'**
  String get faqAnswer2;

  /// No description provided for @faqQuestion3.
  ///
  /// In en, this message translates to:
  /// **'Can I submit assignments here?'**
  String get faqQuestion3;

  /// No description provided for @faqAnswer3.
  ///
  /// In en, this message translates to:
  /// **'Yes — open the relevant course, navigate to the assignment card, and tap Submit. Accepted formats: PDF, Word, ZIP.'**
  String get faqAnswer3;

  /// No description provided for @faqQuestion4.
  ///
  /// In en, this message translates to:
  /// **'Who can see my messages?'**
  String get faqQuestion4;

  /// No description provided for @faqAnswer4.
  ///
  /// In en, this message translates to:
  /// **'Direct messages are private between you and the recipient. Group channels are visible to all enrolled members of that course.'**
  String get faqAnswer4;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @reportIssue.
  ///
  /// In en, this message translates to:
  /// **'Report an Issue'**
  String get reportIssue;

  /// No description provided for @reportIssueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Something broken? Tell us'**
  String get reportIssueSubtitle;

  /// No description provided for @contactUsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll get back to you as soon as possible'**
  String get contactUsSubtitle;

  /// No description provided for @describeIssue.
  ///
  /// In en, this message translates to:
  /// **'Describe your issue in detail…'**
  String get describeIssue;

  /// No description provided for @messageSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Message sent. We\'ll respond shortly!'**
  String get messageSentSuccess;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessage;

  /// No description provided for @appInfo.
  ///
  /// In en, this message translates to:
  /// **'App Info'**
  String get appInfo;

  /// No description provided for @organization.
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get organization;

  /// No description provided for @organizationValue.
  ///
  /// In en, this message translates to:
  /// **'WE Applied Technology School - Suez'**
  String get organizationValue;

  /// No description provided for @builtWith.
  ///
  /// In en, this message translates to:
  /// **'Built with'**
  String get builtWith;

  /// No description provided for @builtWithValue.
  ///
  /// In en, this message translates to:
  /// **'Flutter + FastAPI'**
  String get builtWithValue;

  /// No description provided for @releaseLabel.
  ///
  /// In en, this message translates to:
  /// **'Release'**
  String get releaseLabel;

  /// No description provided for @releaseValue.
  ///
  /// In en, this message translates to:
  /// **'May 2026'**
  String get releaseValue;

  /// No description provided for @versionValue.
  ///
  /// In en, this message translates to:
  /// **'1.0.0-beta'**
  String get versionValue;

  /// No description provided for @quizComplete.
  ///
  /// In en, this message translates to:
  /// **'Quiz Complete!'**
  String get quizComplete;

  /// No description provided for @quizScore.
  ///
  /// In en, this message translates to:
  /// **'{correct} / {total} Correct'**
  String quizScore(int correct, int total);

  /// No description provided for @quizExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent work!'**
  String get quizExcellent;

  /// No description provided for @quizGoodEffort.
  ///
  /// In en, this message translates to:
  /// **'Good effort — keep practicing!'**
  String get quizGoodEffort;

  /// No description provided for @quizKeepStudying.
  ///
  /// In en, this message translates to:
  /// **'Keep studying and try again!'**
  String get quizKeepStudying;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @retakeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Retake Quiz'**
  String get retakeQuiz;

  /// No description provided for @reviewAnswers.
  ///
  /// In en, this message translates to:
  /// **'Review Your Answers'**
  String get reviewAnswers;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Smart Campus\nPlatform'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Experience university life reimagined\nwith AI-powered tools built for WE School Suez.'**
  String get onboarding1Subtitle;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Instant Academic\nAnnouncements'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Stay informed with real-time updates\nfrom your professors and departments.'**
  String get onboarding2Subtitle;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Courses &\nMaterials'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Access lectures, assignments and\ncourse content — all in one place.'**
  String get onboarding3Subtitle;

  /// No description provided for @onboarding4Title.
  ///
  /// In en, this message translates to:
  /// **'Direct Faculty\nCommunication'**
  String get onboarding4Title;

  /// No description provided for @onboarding4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Chat directly with professors and TAs.\nGet answers when you need them.'**
  String get onboarding4Subtitle;

  /// No description provided for @onboarding5Title.
  ///
  /// In en, this message translates to:
  /// **'Your Platform\nAwaits'**
  String get onboarding5Title;

  /// No description provided for @onboarding5Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your university credentials\nand begin your smart campus journey.'**
  String get onboarding5Subtitle;

  /// No description provided for @announcementsSubtitleStudent.
  ///
  /// In en, this message translates to:
  /// **'Stay up to date with your courses'**
  String get announcementsSubtitleStudent;

  /// No description provided for @announcementsSubtitleDoctor.
  ///
  /// In en, this message translates to:
  /// **'Manage and view all announcements'**
  String get announcementsSubtitleDoctor;

  /// No description provided for @announcementsSubtitleAdmin.
  ///
  /// In en, this message translates to:
  /// **'University-wide announcements'**
  String get announcementsSubtitleAdmin;

  /// No description provided for @myCourses.
  ///
  /// In en, this message translates to:
  /// **'My Courses'**
  String get myCourses;

  /// No description provided for @coursesSubtitleStudent.
  ///
  /// In en, this message translates to:
  /// **'Your enrolled courses this semester'**
  String get coursesSubtitleStudent;

  /// No description provided for @coursesSubtitleDoctor.
  ///
  /// In en, this message translates to:
  /// **'Courses you are currently teaching'**
  String get coursesSubtitleDoctor;

  /// No description provided for @conversations.
  ///
  /// In en, this message translates to:
  /// **'{count} conversations'**
  String conversations(int count);

  /// No description provided for @profileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your account & preferences'**
  String get profileSubtitle;

  /// No description provided for @newPost.
  ///
  /// In en, this message translates to:
  /// **'New Post'**
  String get newPost;

  /// No description provided for @announcementDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Announcement Details'**
  String get announcementDetailsTitle;

  /// No description provided for @setYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Set Your Password'**
  String get setYourPassword;

  /// No description provided for @ourMission.
  ///
  /// In en, this message translates to:
  /// **'Our Mission'**
  String get ourMission;

  /// No description provided for @missionText.
  ///
  /// In en, this message translates to:
  /// **'To bridge the gap between students and educators at WE School Suez — making academic communication seamless, transparent, and empowering every member of the university community.'**
  String get missionText;

  /// No description provided for @connectingEru.
  ///
  /// In en, this message translates to:
  /// **'Connecting WE School Suez community'**
  String get connectingEru;

  /// No description provided for @developmentTeam.
  ///
  /// In en, this message translates to:
  /// **'Development Team'**
  String get developmentTeam;

  /// No description provided for @flutterDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Flutter Developer'**
  String get flutterDeveloper;

  /// No description provided for @backendArchitecture.
  ///
  /// In en, this message translates to:
  /// **'Backend & Architecture'**
  String get backendArchitecture;

  /// No description provided for @noConversationsYet.
  ///
  /// In en, this message translates to:
  /// **'No Conversations Yet'**
  String get noConversationsYet;

  /// No description provided for @noConversationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Start a conversation with your professors,\nteaching assistants, or administrators.'**
  String get noConversationsDesc;

  /// No description provided for @tapBelowToStart.
  ///
  /// In en, this message translates to:
  /// **'Tap the button below to start'**
  String get tapBelowToStart;

  /// No description provided for @noResultsFor.
  ///
  /// In en, this message translates to:
  /// **'No results for \"{query}\"'**
  String noResultsFor(String query);

  /// No description provided for @firstLoginBannerText.
  ///
  /// In en, this message translates to:
  /// **'Your account was created with a temporary password. Please set a secure personal password to continue.'**
  String get firstLoginBannerText;

  /// No description provided for @strongPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Use a strong password with a mix of letters, numbers and symbols.'**
  String get strongPasswordHint;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @myAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'My Announcements'**
  String get myAnnouncements;

  /// No description provided for @targetAudience.
  ///
  /// In en, this message translates to:
  /// **'Target Audience'**
  String get targetAudience;

  /// No description provided for @selectSubject.
  ///
  /// In en, this message translates to:
  /// **'Select Subject'**
  String get selectSubject;

  /// No description provided for @filterByCourse.
  ///
  /// In en, this message translates to:
  /// **'Filter by course'**
  String get filterByCourse;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get optional;

  /// No description provided for @tapToAttachFiles.
  ///
  /// In en, this message translates to:
  /// **'Tap to attach files'**
  String get tapToAttachFiles;

  /// No description provided for @attachmentFormats.
  ///
  /// In en, this message translates to:
  /// **'PDF · DOCX · PPT · Images · ZIP · Links'**
  String get attachmentFormats;

  /// No description provided for @addFile.
  ///
  /// In en, this message translates to:
  /// **'Add File'**
  String get addFile;

  /// No description provided for @addAnotherFile.
  ///
  /// In en, this message translates to:
  /// **'Add another file'**
  String get addAnotherFile;

  /// No description provided for @postType.
  ///
  /// In en, this message translates to:
  /// **'Post Type'**
  String get postType;

  /// No description provided for @noAnnouncementsYet.
  ///
  /// In en, this message translates to:
  /// **'No Announcements Yet'**
  String get noAnnouncementsYet;

  /// No description provided for @noAnnouncementsDesc.
  ///
  /// In en, this message translates to:
  /// **'There are no announcements at the moment.\nCheck back later for updates.'**
  String get noAnnouncementsDesc;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong'**
  String get errorTitle;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get readMore;

  /// No description provided for @students.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get students;

  /// No description provided for @doctors.
  ///
  /// In en, this message translates to:
  /// **'Doctors'**
  String get doctors;

  /// No description provided for @assistants.
  ///
  /// In en, this message translates to:
  /// **'Assistants'**
  String get assistants;

  /// No description provided for @specificUsers.
  ///
  /// In en, this message translates to:
  /// **'Specific Users'**
  String get specificUsers;

  /// No description provided for @courseStudents.
  ///
  /// In en, this message translates to:
  /// **'Course\nStudents'**
  String get courseStudents;

  /// No description provided for @specificStudents.
  ///
  /// In en, this message translates to:
  /// **'Specific\nStudents'**
  String get specificStudents;

  /// No description provided for @announcementLabel.
  ///
  /// In en, this message translates to:
  /// **'Announcement'**
  String get announcementLabel;

  /// No description provided for @visibleToAll.
  ///
  /// In en, this message translates to:
  /// **'Visible to all students, doctors and assistants'**
  String get visibleToAll;

  /// No description provided for @visibleToAllStudents.
  ///
  /// In en, this message translates to:
  /// **'Visible to all students'**
  String get visibleToAllStudents;

  /// No description provided for @visibleToAllDoctors.
  ///
  /// In en, this message translates to:
  /// **'Visible to all doctors'**
  String get visibleToAllDoctors;

  /// No description provided for @visibleToAllAssistants.
  ///
  /// In en, this message translates to:
  /// **'Visible to all teaching assistants'**
  String get visibleToAllAssistants;

  /// No description provided for @visibleToSelectedUsers.
  ///
  /// In en, this message translates to:
  /// **'Visible to selected users'**
  String get visibleToSelectedUsers;

  /// No description provided for @visibleToStudentsIn.
  ///
  /// In en, this message translates to:
  /// **'Visible to students in {parts}'**
  String visibleToStudentsIn(String parts);

  /// No description provided for @am.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get am;

  /// No description provided for @pm.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get pm;

  /// No description provided for @selectDeadlineDate.
  ///
  /// In en, this message translates to:
  /// **'Select deadline date'**
  String get selectDeadlineDate;

  /// No description provided for @selectDeadlineTime.
  ///
  /// In en, this message translates to:
  /// **'Select deadline time'**
  String get selectDeadlineTime;

  /// No description provided for @validUrlError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL (https://…)'**
  String get validUrlError;

  /// No description provided for @deptCourse.
  ///
  /// In en, this message translates to:
  /// **'Dept. Course'**
  String get deptCourse;

  /// No description provided for @deptSuffix.
  ///
  /// In en, this message translates to:
  /// **'dept.'**
  String get deptSuffix;

  /// No description provided for @course.
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get course;

  /// No description provided for @selectedUsers.
  ///
  /// In en, this message translates to:
  /// **'Selected Users'**
  String get selectedUsers;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @enterPlatform.
  ///
  /// In en, this message translates to:
  /// **'Enter Platform'**
  String get enterPlatform;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @mathematics.
  ///
  /// In en, this message translates to:
  /// **'Mathematics'**
  String get mathematics;

  /// No description provided for @physics.
  ///
  /// In en, this message translates to:
  /// **'Physics'**
  String get physics;

  /// No description provided for @aiSystems.
  ///
  /// In en, this message translates to:
  /// **'AI Systems'**
  String get aiSystems;

  /// No description provided for @admAdministration.
  ///
  /// In en, this message translates to:
  /// **'ADM · Administration'**
  String get admAdministration;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @noContentYet.
  ///
  /// In en, this message translates to:
  /// **'No Content Yet'**
  String get noContentYet;

  /// No description provided for @noContentDesc.
  ///
  /// In en, this message translates to:
  /// **'Nothing has been posted for this course yet.\nCheck back later for updates.'**
  String get noContentDesc;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get items;

  /// No description provided for @hrs.
  ///
  /// In en, this message translates to:
  /// **'hrs'**
  String get hrs;

  /// No description provided for @subjectCourse.
  ///
  /// In en, this message translates to:
  /// **'Subject / Course'**
  String get subjectCourse;

  /// No description provided for @materialDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Material Details'**
  String get materialDetailsTitle;

  /// No description provided for @assignmentDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Assignment Details'**
  String get assignmentDetailsTitle;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
