# Notification System Roadmap

## Overview
This document outlines the planned improvements and features for the notification system, including Dynamic Island support for iOS and enhanced Android notifications.

---

## Phase 1: Notification Setup & Management ✅ (In Progress)

### 1.1 Notification Setup UI
**Goal**: Allow users to configure what notifications they want to receive

**Tasks**:
- [ ] Create notification settings screen/page
- [ ] Add options for:
  - [ ] Which bookmarks to track (already have toggle in bookmarks)
  - [ ] Notification update frequency (30s, 60s, 2min, etc.)
  - [ ] Notification style (compact, detailed)
  - [ ] Sound/vibration preferences
  - [ ] Quiet hours (disable notifications during certain times)
- [ ] Add notification preview/test feature
- [ ] Show notification history/log

**Files to Create/Modify**:
- `lib/components/notifications/notification_settings_screen.dart` (new)
- `lib/components/menu/data_operations_section.dart` (add link to settings)

### 1.2 User Controls (Delete/Active/Finished)
**Goal**: Give users control over notification states

**Tasks**:
- [ ] **Delete/Remove**: Allow users to stop tracking specific bookmarks
  - [ ] Remove from tracked list
  - [ ] Cancel active notifications
- [ ] **Active**: Show which notifications are currently active
  - [ ] List of active tracked bookmarks
  - [ ] Current ETA for each
  - [ ] Last update time
- [ ] **Finished/Completed**: Handle when bus/train arrives
  - [ ] Auto-dismiss when ETA reaches 0 or negative
  - [ ] Show "arrived" or "departed" status
  - [ ] Option to mark as finished manually
  - [ ] Archive completed notifications

**Implementation**:
```dart
// Notification states
enum NotificationState {
  active,      // Currently tracking
  paused,      // Temporarily paused
  finished,    // Bus/train arrived
  cancelled,   // User cancelled
}

// User actions
- Stop tracking (delete)
- Pause/resume tracking
- Mark as finished
- View history
```

**Files to Create/Modify**:
- `lib/components/notifications/notification_management_screen.dart` (new)
- `lib/scripts/notifications/notification_state_service.dart` (new)
- `lib/scripts/notifications/notification_preferences_service.dart` (modify)

### 1.3 Notification Preferences Storage
**Goal**: Store user preferences for notifications

**Tasks**:
- [ ] Add update frequency setting
- [ ] Add quiet hours setting
- [ ] Add notification style preference
- [ ] Add sound/vibration preferences
- [ ] Store in SharedPreferences

**Files to Modify**:
- `lib/scripts/utils/settings_service.dart`
- `lib/scripts/notifications/notification_preferences_service.dart`

---

## Phase 2: Fix Errors & Bugs 🐛

### 2.1 Current Issues to Investigate
**Goal**: Identify and fix existing notification bugs

**Tasks**:
- [ ] Test notification permission flow on iOS
- [ ] Test notification permission flow on Android
- [ ] Verify notifications update correctly
- [ ] Check notification cancellation works
- [ ] Test app background/foreground transitions
- [ ] Verify notification persistence
- [ ] Check memory leaks in tracking service
- [ ] Test multiple tracked bookmarks
- [ ] Verify notification updates don't spam

**Common Issues to Check**:
- [ ] Permission request not showing on iOS
- [ ] Notifications not updating
- [ ] Notifications disappearing unexpectedly
- [ ] Battery drain from frequent updates
- [ ] Multiple notifications instead of one
- [ ] Notification not canceling properly

**Files to Review**:
- `lib/scripts/notifications/notification_service.dart`
- `lib/scripts/notifications/notification_tracking_service.dart`
- `lib/scripts/notifications/notification_preferences_service.dart`
- `lib/main.dart` (startup logic)

### 2.2 Error Handling Improvements
**Goal**: Better error handling and user feedback

**Tasks**:
- [ ] Add try-catch blocks with proper error messages
- [ ] Show user-friendly error messages
- [ ] Log errors for debugging
- [ ] Handle network errors gracefully
- [ ] Handle API rate limiting
- [ ] Handle permission denial gracefully

**Files to Modify**:
- All notification service files
- Add error handling utilities

---

## Phase 3: iOS Dynamic Island Planning 📱

### 3.1 Research & Requirements
**Goal**: Understand iOS Dynamic Island implementation requirements

**Tasks**:
- [ ] Research ActivityKit framework
- [ ] Understand Live Activities API
- [ ] Check iOS version requirements (16.1+)
- [ ] Research Flutter platform channels for iOS
- [ ] Study Apple's Dynamic Island guidelines
- [ ] Review example implementations

**Resources**:
- [Apple ActivityKit Documentation](https://developer.apple.com/documentation/activitykit)
- [Live Activities Tutorial](https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities)
- Flutter platform channels documentation

### 3.2 Architecture Design
**Goal**: Design the architecture for iOS Dynamic Island support

**Tasks**:
- [ ] Design platform channel interface
- [ ] Plan native iOS code structure
- [ ] Design Live Activity data model
- [ ] Plan update mechanism
- [ ] Design compact vs expanded views
- [ ] Plan error handling

**Architecture**:
```
Flutter App
    ↓
Platform Channel (Method Channel)
    ↓
Native iOS Code (Swift)
    ↓
ActivityKit Framework
    ↓
Dynamic Island / Live Activities
```

**Files to Create**:
- `ios/Runner/NotificationActivityManager.swift` (new)
- `lib/scripts/notifications/ios_live_activity_service.dart` (new)
- Platform channel setup in `ios/Runner/AppDelegate.swift`

### 3.3 Implementation Plan
**Goal**: Step-by-step implementation plan

**Phase 3.3.1: Setup**
- [ ] Create platform channel
- [ ] Set up native iOS project structure
- [ ] Add ActivityKit framework
- [ ] Create basic Live Activity structure

**Phase 3.3.2: Basic Implementation**
- [ ] Implement start Live Activity
- [ ] Implement update Live Activity
- [ ] Implement end Live Activity
- [ ] Test basic functionality

**Phase 3.3.3: Integration**
- [ ] Integrate with existing notification service
- [ ] Add fallback to regular notifications
- [ ] Handle iOS version checks
- [ ] Test on physical device (iPhone 14 Pro+)

**Phase 3.3.4: Polish**
- [ ] Add animations
- [ ] Optimize update frequency
- [ ] Add error handling
- [ ] User testing

**Estimated Time**: 2-3 weeks (depending on iOS development experience)

---

## Phase 4: Android Island Notifications Planning 🤖

### 4.1 Research & Enhancement Opportunities
**Goal**: Improve Android notification experience

**Tasks**:
- [ ] Research Android notification best practices
- [ ] Study custom notification layouts
- [ ] Research edge-to-edge display
- [ ] Study Material Design 3 notification styles
- [ ] Research notification channels optimization
- [ ] Study battery optimization for notifications

**Resources**:
- [Android Notification Best Practices](https://developer.android.com/develop/ui/views/notifications)
- [Custom Notification Layouts](https://developer.android.com/develop/ui/views/notifications/custom-layout)
- Material Design 3 guidelines

### 4.2 Enhancement Ideas
**Goal**: Improve Android notification appearance and functionality

**Tasks**:
- [ ] **Custom Notification Layout**
  - [ ] Design custom layout for ETA display
  - [ ] Add icons for routes
  - [ ] Improve visual hierarchy
  - [ ] Add color coding (KMB vs CTB vs MTR)
  
- [ ] **Notification Actions**
  - [ ] Add "Open App" action button
  - [ ] Add "Stop Tracking" action button
  - [ ] Add "View Details" action button
  
- [ ] **Notification Grouping**
  - [ ] Group multiple ETAs in one notification
  - [ ] Expandable notification with details
  - [ ] Summary notification
  
- [ ] **Visual Enhancements**
  - [ ] Add route icons
  - [ ] Color-coded by operator
  - [ ] Progress indicators
  - [ ] Better typography

**Files to Create/Modify**:
- `lib/scripts/notifications/android_notification_enhancer.dart` (new)
- `lib/scripts/notifications/notification_service.dart` (modify)
- Custom notification layouts (XML for Android)

### 4.3 Implementation Plan
**Goal**: Step-by-step Android improvements

**Phase 4.3.1: Custom Layout**
- [ ] Create custom notification layout XML
- [ ] Design layout for ETA display
- [ ] Add icons and colors
- [ ] Test on different Android versions

**Phase 4.3.2: Actions & Interactions**
- [ ] Add notification actions
- [ ] Implement action handlers
- [ ] Add deep linking to app
- [ ] Test user interactions

**Phase 4.3.3: Grouping & Organization**
- [ ] Implement notification grouping
- [ ] Add expandable notifications
- [ ] Create summary notifications
- [ ] Optimize for multiple tracked items

**Phase 4.3.4: Polish**
- [ ] Material Design 3 styling
- [ ] Animation improvements
- [ ] Battery optimization
- [ ] User testing

**Estimated Time**: 1-2 weeks

---

## Implementation Priority

### High Priority (Do First)
1. ✅ Phase 1.1: Notification Setup UI
2. ✅ Phase 1.2: User Controls (Delete/Active/Finished)
3. ✅ Phase 2: Fix Errors & Bugs

### Medium Priority (Do Next)
4. Phase 1.3: Notification Preferences Storage
5. Phase 4.2: Android Enhancement Ideas (custom layouts)

### Low Priority (Future)
6. Phase 3: iOS Dynamic Island (requires native iOS development)
7. Phase 4.3: Advanced Android features

---

## Success Metrics

### Phase 1 Success
- [ ] Users can configure notification preferences
- [ ] Users can manage active notifications
- [ ] Users can delete/stop tracking easily
- [ ] Notification states are clear

### Phase 2 Success
- [ ] No crashes related to notifications
- [ ] Permissions work on both platforms
- [ ] Notifications update reliably
- [ ] No battery drain issues

### Phase 3 Success (iOS)
- [ ] Live Activities appear in Dynamic Island
- [ ] Updates work in real-time
- [ ] Fallback to notifications works
- [ ] Works on iPhone 14 Pro+

### Phase 4 Success (Android)
- [ ] Custom notification layouts look good
- [ ] Notification actions work
- [ ] Grouping works for multiple ETAs
- [ ] Better visual integration

---

## Notes

### Current Implementation Status
- ✅ Basic notification service exists
- ✅ Permission handling works
- ✅ Tracking service updates notifications
- ✅ User can enable/disable in settings
- ⚠️ No user management UI yet
- ⚠️ No iOS Dynamic Island support
- ⚠️ Android uses basic notifications

### Dependencies
- `flutter_local_notifications` package
- `permission_handler` package
- iOS: ActivityKit framework (for Dynamic Island)
- Android: Custom layouts (for enhanced notifications)

### Risks & Challenges
1. **iOS Dynamic Island**: Requires native iOS development knowledge
2. **Android Custom Layouts**: May need platform-specific code
3. **Battery Optimization**: Frequent updates may drain battery
4. **Cross-platform Consistency**: Different experiences on iOS vs Android

---

**Last Updated**: 2024
**Status**: Planning Phase
**Next Steps**: Start with Phase 1.1 - Notification Setup UI


