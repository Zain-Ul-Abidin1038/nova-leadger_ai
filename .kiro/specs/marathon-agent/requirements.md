# Requirements Document: Marathon Agent

## Introduction

The Marathon Agent is an autonomous expense prediction system that monitors user location and proactively suggests expenses when the user remains stationary at commercial locations. It leverages Nova 3 Pro for intelligent expense prediction, displays reasoning through the Ghost Trace interface, and validates expenses against current tax laws before persisting to AWS DynamoDB.

## Glossary

- **Marathon_Agent**: The autonomous background service that monitors location and triggers expense predictions
- **Nova_3**: The Nova 3 Pro AI model used for expense prediction and logic auditing
- **Ghost_Trace**: The glassmorphic UI component that displays AI reasoning in real-time
- **Safe_Layer**: The validation layer that ensures expenses comply with 2026 tax laws before persistence
- **Commercial_Coordinate**: A GPS location identified as a business or commercial establishment
- **Stationary_Event**: A condition where the user remains within a defined radius for a specified duration
- **Logic_Audit**: A validation process performed by Nova 3 to verify expense compliance with tax regulations
- **Expense_Prediction**: An AI-generated suggestion for a potential expense based on location and context

## Requirements

### Requirement 1: Autonomous Location Monitoring

**User Story:** As a user, I want the app to automatically monitor my location in the background, so that I don't have to manually track when I'm at expense-worthy locations.

#### Acceptance Criteria

1. WHEN the app is running in the background, THE Marathon_Agent SHALL continuously monitor the user's GPS location
2. WHEN location permissions are granted, THE Marathon_Agent SHALL request location updates at appropriate intervals to balance battery life and accuracy
3. WHEN location permissions are denied or revoked, THE Marathon_Agent SHALL notify the user and pause monitoring
4. WHILE monitoring is active, THE Marathon_Agent SHALL maintain a location history buffer for stationary detection
5. THE Marathon_Agent SHALL respect system battery optimization settings and adjust monitoring frequency accordingly

### Requirement 2: Stationary Detection at Commercial Locations

**User Story:** As a user, I want the system to detect when I'm stationary at a business location for more than 15 minutes, so that it can predict likely expenses without false triggers.

#### Acceptance Criteria

1. WHEN the user remains within a 50-meter radius for 15 consecutive minutes, THE Marathon_Agent SHALL classify this as a Stationary_Event
2. WHEN a Stationary_Event is detected, THE Marathon_Agent SHALL query a location database to determine if the coordinates correspond to a Commercial_Coordinate
3. IF the location is not a Commercial_Coordinate, THEN THE Marathon_Agent SHALL continue monitoring without triggering a prediction
4. WHEN a Stationary_Event occurs at a Commercial_Coordinate, THE Marathon_Agent SHALL trigger an Expense_Prediction workflow
5. THE Marathon_Agent SHALL prevent duplicate predictions for the same location within a 4-hour window

### Requirement 3: AI-Powered Expense Prediction

**User Story:** As a user, I want Nova 3 to predict likely expenses based on my location and context, so that I can quickly log expenses without manual entry.

#### Acceptance Criteria

1. WHEN a Stationary_Event at a Commercial_Coordinate is detected, THE Marathon_Agent SHALL invoke Nova_3 with location context, business type, time of day, and user expense history
2. WHEN Nova_3 receives a prediction request, THE Nova_3 SHALL generate an Expense_Prediction including amount estimate, category, deduction percentage, and confidence score
3. WHEN the prediction is generated, THE Marathon_Agent SHALL display the prediction to the user via the Ghost_Trace interface
4. IF Nova_3 cannot generate a confident prediction, THEN THE Marathon_Agent SHALL log the event without user notification
5. THE Nova_3 SHALL include reasoning steps in the prediction response for Ghost_Trace display

### Requirement 4: Ghost Trace Reasoning Display

**User Story:** As a user, I want to see the AI's reasoning process in a beautiful glassmorphic interface, so that I understand and trust the expense predictions.

#### Acceptance Criteria

1. WHEN an Expense_Prediction is generated, THE Ghost_Trace SHALL display a glassmorphic bottom-sheet with sigma blur of 25
2. WHEN displaying reasoning, THE Ghost_Trace SHALL show each reasoning step from Nova_3 in chronological order with neon teal (#00F2FF) accents
3. WHEN the user interacts with the Ghost_Trace, THE Ghost_Trace SHALL allow expanding/collapsing reasoning details
4. WHEN the prediction is displayed, THE Ghost_Trace SHALL provide action buttons for "Accept", "Edit", and "Dismiss"
5. THE Ghost_Trace SHALL automatically dismiss after 30 seconds if no user interaction occurs

### Requirement 5: Safe Layer Logic Audit

**User Story:** As a user, I want the system to validate expenses against current tax laws before saving them, so that my records remain compliant and accurate.

#### Acceptance Criteria

1. WHEN the user accepts an Expense_Prediction, THE Safe_Layer SHALL invoke Nova_3 to perform a Logic_Audit
2. WHEN performing a Logic_Audit, THE Nova_3 SHALL validate the expense against 2026 tax law rules including deduction percentages, category compliance, and documentation requirements
3. IF the Logic_Audit identifies compliance issues, THEN THE Safe_Layer SHALL flag the expense with warnings and request user confirmation
4. WHEN the Logic_Audit passes, THE Safe_Layer SHALL proceed with persistence to AWS DynamoDB
5. THE Safe_Layer SHALL log all audit results for compliance tracking and future reference

### Requirement 6: Secure Expense Persistence

**User Story:** As a user, I want my predicted expenses to be securely saved to the cloud, so that I can access them across devices and maintain a reliable audit trail.

#### Acceptance Criteria

1. WHEN a Logic_Audit passes, THE Marathon_Agent SHALL persist the expense to AWS DynamoDB via Amplify
2. WHEN persisting an expense, THE Marathon_Agent SHALL include all metadata: timestamp, GPS coordinates, business name, prediction confidence, audit results, and reasoning trace
3. IF the persistence operation fails, THEN THE Marathon_Agent SHALL queue the expense for retry and notify the user
4. WHEN an expense is successfully persisted, THE Marathon_Agent SHALL update the local cache and trigger a sync event
5. THE Marathon_Agent SHALL encrypt sensitive expense data before transmission to AWS

### Requirement 7: User Control and Privacy

**User Story:** As a user, I want to control when the Marathon Agent is active and what data it collects, so that I maintain privacy and battery life.

#### Acceptance Criteria

1. THE Marathon_Agent SHALL provide a settings toggle to enable/disable autonomous monitoring
2. WHEN autonomous monitoring is disabled, THE Marathon_Agent SHALL stop all background location tracking
3. THE Marathon_Agent SHALL provide a setting to adjust the stationary duration threshold (default 15 minutes, range 5-30 minutes)
4. THE Marathon_Agent SHALL display battery usage statistics in the settings screen
5. THE Marathon_Agent SHALL allow users to view and delete location history data

### Requirement 8: Integration with Existing Systems

**User Story:** As a developer, I want the Marathon Agent to seamlessly integrate with existing app features, so that the user experience remains consistent and maintainable.

#### Acceptance Criteria

1. WHEN displaying predictions, THE Marathon_Agent SHALL use the existing Ghost_Trace service and glassmorphism components (GlassCard, NeonButton, GlassNotification)
2. WHEN persisting expenses, THE Marathon_Agent SHALL use the existing Safe Layer sync service and AWS Amplify configuration
3. WHEN requesting location data, THE Marathon_Agent SHALL use the existing geolocator service and permission handling
4. WHEN invoking Nova 3, THE Marathon_Agent SHALL use the existing firebase_vertexai integration
5. THE Marathon_Agent SHALL emit events that integrate with the existing proactive service infrastructure
