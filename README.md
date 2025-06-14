# Apex iOS App

This repository contains the Apex sample iOS application. The project is a simple SwiftUI app created as a starting point for experimentation.

## Capabilities
- **iCloud / CloudKit** for data syncing
- **HealthKit** to access workout data
- **SiriKit** so you can start workouts with your voice

The `Info.plist` includes usage descriptions required by iOS. See `apex/Info.plist` for details.

Tests can be run with `xcodebuild test` on macOS.

## User Profile

The app stores demographics and preferences in a `UserProfileModel`. This struct
is `Codable` and syncs through CloudKit. Users can enter their information
during onboarding and update it later from the Profile tab. Fields include name,
age, height, starting/current/goal weight, body fat percentage, activity level,
dietary preferences, GLP‑1 usage and preferred coach personality.
