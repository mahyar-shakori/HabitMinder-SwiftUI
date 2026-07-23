//
//  L10n.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 31/03/2025.
//

import Foundation

enum L10n {
    private static func localized(_ key: String) -> String {
        String(localized: String.LocalizationValue(key))
    }

    private static func formatted(_ key: String, _ values: String...) -> String {
        var result = localized(key)

        for value in values {
            if let range = result.range(of: "%@") ?? result.range(of: "%d") {
                result.replaceSubrange(range, with: value)
            }
        }

        return result
    }
    
    enum AppStartup {
        static let errorTitle = localized("appStartupErrorTitle")
        static let errorMessage = localized("appStartupErrorMessage")
    }
    
    enum header {
        static let title = localized("headerTitle")
    }

    enum IntroPage {
        static let firstTitle = localized("introFirstTitle")
        static let firstDescription = localized("introFirstDescription")
        static let secondTitle = localized("introSecondTitle")
        static let secondDescription = localized("introSecondDescription")
        static let skipButton = localized("skipButton")
        static let nextButton = localized("nextButton")
    }

    enum SignInPage {
        static let hiDialog = localized("hiDialog")
        static let signIn = localized("signIn")
        static let or = localized("or")
        static let userNamePlaceholder = localized("userNamePlaceholder")
        static let continueButton = localized("continueButton")
        static let error = localized("error")
    }

    enum WelcomePage {
        static let welcome = localized("welcome")
        static let guest = localized("guest")
    }
    
    enum TabView {
        static let habitsTab = localized("habitsTab")
        static let historyTab = localized("historyTab")
        static let settingsTab = localized("settingsTab")
    }

    enum HomePage {
        static let listTitle = localized("homeListTitle")
        static let listSubtitle = localized("homeListSubtitle")
        static let defaultQuote = localized("defaultQuote")
        static let defaultAuthor = localized("homeDefaultAuthor")
        static let emptyView = localized("emptyView")
        static let watchEmptyView = localized("watchEmptyView")
    }

    enum AddHabitPage {
        static let title = localized("addHabitTitle")
        static let introDescription = localized("addHabitIntroDescription")
        static let notificationAlertTitle = localized("habitNotificationAlertTitle")
        static let notificationAlertMessage = localized("habitNotificationAlertMessage")
        static let inAppNotificationAlertMessage = localized("habitInAppNotificationAlertMessage")
        static let notificationSettingsButton = localized("habitNotificationSettingsButton")
        static let identitySectionTitle = localized("habitIdentitySectionTitle")
        static let titlePlaceholder = localized("habitTitlePlaceholder")
        static let visualAnchorSectionTitle = localized("habitVisualAnchorSectionTitle")
        static let selectIconHint = localized("habitSelectIconHint")
        static let futureHabitToggle = localized("habitFutureToggle")
        static let frequencySectionTitle = localized("habitFrequencySectionTitle")
        static let commitmentSectionTitle = localized("habitCommitmentSectionTitle")
        static let reminderSectionTitle = localized("habitReminderSectionTitle")
        static let reminderSubtitle = localized("habitReminderSubtitle")
        static let startJourneyButton = localized("habitStartJourneyButton")
        static let frequencyDaily = localized("habitFrequencyDaily")
        static let frequencyWeekly = localized("habitFrequencyWeekly")
        static let frequencyCustom = localized("habitFrequencyCustom")

        static func commitmentDays(_ days: Int) -> String {
            L10n.formatted("habitCommitmentDaysFormat", "\(days)")
        }
    }

    enum EditHabitPage {
        static let title = localized("editHabitTitle")
        static let introDescription = localized("editHabitIntroDescription")
        static let missHabitToast = localized("missHabitToast")
        static let missHabitButton = localized("missHabitButton")
    }

    enum HabitHistoryPage {
        static let startNowButton = localized("habitHistoryStartNowButton")
        static let completedTab = localized("habitHistoryCompletedTab")
        static let upcomingTab = localized("habitHistoryFutureTab")
        static let masteryTitle = localized("habitHistoryMasteryTitle")
        static let plannedTitle = localized("habitHistoryPlannedTitle")
        static let plannedSubtitle = localized("habitHistoryPlannedSubtitle")
        static let completedStatus = localized("habitHistoryCompletedStatus")
        static let emptyCompleted = localized("habitHistoryEmptyCompleted")
        static let ritualTipLabel = localized("habitHistoryRitualTipLabel")
        static let ritualTipText = localized("habitHistoryRitualTipText")

        static func startInDays(_ days: Int) -> String {
            L10n.formatted("habitHistoryStartInDaysFormat", "\(days)")
        }

        static func achievementCount(_ count: Int) -> String {
            let key = count == 1 ? "habitHistoryAchievementSingular" : "habitHistoryAchievementPlural"
            return L10n.formatted(key, "\(count)")
        }

        static func finishedDate(_ date: String) -> String {
            L10n.formatted("habitHistoryFinishedDateFormat", date)
        }

        static func streakDays(_ days: Int) -> String {
            L10n.formatted("habitHistoryStreakDaysFormat", "\(days)")
        }
    }

    enum SettingsPage {
        static let userName = localized("userName")
        static let profile = localized("profile")
        static let preferences = localized("preferences")
        static let appSection = localized("settingsAppSection")
        static let notifications = localized("notifications")
        static let notificationsSubtitle = localized("notificationsSubtitle")
        static let appTheme = localized("appTheme")
        static let appThemeSubtitle = localized("appThemeSubtitle")
        static let rateUs = localized("rateUs")
        static let rateUsSubtitle = localized("rateUsSubtitle")
        static let versionTagline = localized("versionTagline")

        static func appVersion(_ version: String) -> String {
            L10n.formatted("appVersionFormat", version)
        }
        
        static func memberSince(_ date: String) -> String {
            L10n.formatted("memberSinceFormat", date)
        }
    }
    
    enum ProfilePage {
        static let userName = localized("userName")
        static let editUserName = localized("editUserName")
        static let enterNewUserName = localized("enterNewUserName")
        static let changePhoto = localized("changePhoto")
        static let email = localized("email")
    }
    
    enum ThemePage {
        static let defaultColor = localized("defaultColor")
        static let appThemeIntroTitle = localized("appThemeIntroTitle")
        static let appThemeIntroDescription = localized("appThemeIntroDescription")
        static let appearanceSection = localized("appearanceSection")
        static let appearanceLight = localized("appearanceLight")
        static let appearanceDark = localized("appearanceDark")
        static let appearanceSystem = localized("appearanceSystem")
        static let accentColorSection = localized("accentColorSection")
        static let customColor = localized("customColor")
        static let customColorSubtitle = localized("customColorSubtitle")
        static let defaultColorSubtitle = localized("defaultColorSubtitle")
    }
    
    enum NotificationPage {
        static let introTitle = localized("notificationSettingsIntroTitle")
        static let introDescription = localized("notificationSettingsIntroDescription")
        static let general = localized("notificationSettingsGeneral")
        static let allowNotifications = localized("notificationSettingsAllowNotifications")
        static let allowNotificationsDescription = localized("notificationSettingsAllowDescription")
        static let ritualReminders = localized("notificationSettingsRitualReminders")
        static let dailyReminders = localized("notificationSettingsDailyReminders")
        static let motivation = localized("notificationSettingsMotivation")
        static let dailyQuotes = localized("notificationSettingsDailyQuotes")
        static let dailyQuotesDescription = localized("notificationSettingsDailyQuotesDescription")
        static let journeyCompletion = localized("notificationSettingsJourneyCompletion")
        static let journeyCompletionDescription = localized("notificationSettingsJourneyCompletionDescription")
    }

    enum Notification {
        static let habitReminderTitle = localized("habitReminderNotificationTitle")
        static let journeyCompletionTitle = localized("journeyCompletionNotificationTitle")

        static func habitReminderBody(_ title: String) -> String {
            L10n.formatted("habitReminderNotificationBodyFormat", title)
        }

        static func journeyCompletionBody(_ title: String) -> String {
            L10n.formatted("journeyCompletionNotificationBodyFormat", title)
        }
    }

    enum Shared {
        static let saveButton = localized("saveButton")
        static let cancelButton = localized("cancelButton")
        static let okButton = localized("okButton")
        static let yesButton = localized("yesButton")

        enum Weekday {
            static let sundayShort = localized("weekdaySundayShort")
            static let mondayShort = localized("weekdayMondayShort")
            static let tuesdayShort = localized("weekdayTuesdayShort")
            static let wednesdayShort = localized("weekdayWednesdayShort")
            static let thursdayShort = localized("weekdayThursdayShort")
            static let fridayShort = localized("weekdayFridayShort")
            static let saturdayShort = localized("weekdaySaturdayShort")
        }
    }

    enum Alert {
        enum Network {
            static let title = localized("networkAlertTitle")
            static let unknownError = localized("networkUnknownError")
            static let invalidURL = localized("networkInvalidURL")
            static let decodingFailed = localized("networkDecodingFailed")
            static let invalidResponse = localized("networkInvalidResponse")
            
            static func unacceptableStatusCode(_ code: Int) -> String {
                L10n.formatted("networkUnacceptableStatusCode", String(code))
            }
        }
    
        enum Habit {
            static let deleteTitle = localized("deleteHabitAlertTitle")
            static let deleteMessage = localized("deleteHabitAlertMessage")

            static func deleteMessage(title: String) -> String {
                L10n.formatted("deleteHabitNamedAlertMessage", title)
            }
        }

        enum Logout {
            static let title = localized("logoutAlertTitle")
            static let logoutButton = localized("logoutButton")
        }
    }

    enum Cell {
        static let daysLeft = localized("habitCellDaysLeft")
        
        static func journey(_ days: Int) -> String {
            L10n.formatted("habitCellJourneyFormat", "\(days)")
        }
        
        static func progressDay(completed: Int, total: Int) -> String {
            L10n.formatted("habitCellProgressFormat", "\(completed)", "\(total)")
        }
        
        static func streak(_ days: Int) -> String {
            L10n.formatted("habitCellStreakFormat", "\(days)")
        }
    }
}
