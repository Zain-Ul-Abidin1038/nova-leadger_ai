# Receipt Pipeline Integration - Requirements

**Feature Name**: receipt-pipeline-integration  
**Created**: February 9, 2026  
**Status**: Draft

## Overview

Integrate the new production-grade Receipt Pipeline (with Nova V3, validation, and confidence gating) into the Camera Screen UI to replace the legacy receipt service implementation.

## Background

A new `ReceiptPipeline` service has been created that provides:
- Nova V3 vision analysis with structured JSON output
- Response validation and confidence scoring
- Automatic confidence gating (auto-approve ≥75% confidence)
- Manual review workflow for low-confidence receipts
- Error handling with graceful degradation

The existing `CameraScreen` UI currently uses the legacy `receiptServiceProvider` and needs to be updated to use the new pipeline.

## User Stories

### 1. High-Confidence Receipt Auto-Approval
**As a** user  
**I want** receipts with high AI confidence (≥75%) to be automatically saved  
**So that** I don't have to manually review obvious receipts

**Acceptance Criteria**:
- Receipt with confidence ≥ 0.75 is automatically approved and saved to Hive
- User sees success notification with "Auto-approved" indicator
- Receipt appears immediately on dashboard
- Nova Trace shows confidence score

### 2. Low-Confidence Receipt Manual Review
**As a** user  
**I want** receipts with low AI confidence (<75%) to show a review screen  
**So that** I can verify and correct the extracted data before saving

**Acceptance Criteria**:
- Receipt with confidence < 0.75 shows review screen instead of auto-saving
- Review screen displays:
  - Confidence score with visual indicator (color-coded)
  - All extracted fields (vendor, total, tax, category, deductible amount)
  - Original receipt image
  - Edit buttons for each field
- User can approve, edit, mark as personal, or reject
- Nova Trace shows "Requires Review" reasoning

### 3. Receipt Error Handling
**As a** user  
**I want** clear error messages when receipt analysis fails  
**So that** I understand what went wrong and can retry

**Acceptance Criteria**:
- Network errors show "Connection failed - retry?" message
- Invalid image shows "Could not read receipt - try another photo"
- API errors show "Analysis failed - please try again"
- Error receipts are saved with error notes for debugging
- User can retry or cancel

### 4. Visual Confidence Indicators
**As a** user  
**I want** to see visual indicators of AI confidence  
**So that** I know how reliable the extracted data is

**Acceptance Criteria**:
- Confidence score displayed as percentage (e.g., "87% confident")
- Color-coded confidence:
  - Green (≥75%): High confidence, auto-approved
  - Yellow (60-74%): Medium confidence, review recommended
  - Red (<60%): Low confidence, manual review required
- Confidence badge shown in result sheet
- Nova Trace includes confidence reasoning

### 5. Receipt Repository Integration
**As a** user  
**I want** all receipts (approved and pending) stored in the repository  
**So that** I can access them later for review or tax reporting

**Acceptance Criteria**:
- Auto-approved receipts saved with `isApproved: true`
- Pending review receipts saved with `requiresReview: true`
- Repository provides methods to query by status
- Dashboard shows both approved and pending counts

## Technical Requirements

### Architecture
- Use `receiptPipelineProvider` instead of `receiptServiceProvider`
- Maintain glassmorphism UI design (frosted glass, neon accents)
- Preserve Nova Trace integration for AI reasoning display
- Follow feature-first clean architecture pattern

### Dependencies
- `receipt_pipeline.dart` - New pipeline service
- `receipt_repository.dart` - Hive storage
- `nova_service_v3.dart` - AI analysis
- `nova_validator.dart` - Confidence validation

### UI Components Needed
1. **Confidence Badge Widget** - Shows confidence score with color coding
2. **Review Screen** - For manual review of low-confidence receipts
3. **Edit Field Widget** - Inline editing of receipt fields
4. **Action Buttons** - Approve, Edit, Mark Personal, Reject

### Data Flow
```
Camera → Capture Image → ReceiptPipeline.process()
  ↓
Nova V3 Analysis → Validator → Confidence Check
  ↓
If confidence ≥ 75%:
  → Auto-approve → Save to Hive → Show success → Go to dashboard
  
If confidence < 75%:
  → Save as pending → Show review screen → User action → Update & save
```

## Design Considerations

### Glassmorphism UI
- Frosted glass effect for all cards and modals
- Neon accents: Teal (#00F2FF) for primary, Purple (#B388FF) for secondary
- Confidence indicators use gradient overlays
- Nova Trace terminal maintains existing style

### Performance
- Image processing should show loading state with Nova Eyes animation
- Confidence calculation happens server-side (no client delay)
- Review screen should load instantly (data already fetched)

### Accessibility
- Confidence colors also have text labels (not color-only)
- All buttons have clear labels
- Error messages are descriptive

## Out of Scope

- Receipt image editing (crop, rotate, enhance)
- Bulk receipt processing
- Receipt categorization rules engine
- OCR fallback for offline mode
- Receipt export/sharing

## Success Metrics

- 75%+ of receipts auto-approved (high confidence)
- <5% user rejection rate on auto-approved receipts
- <10s average time from capture to save
- Zero data loss on errors (all receipts saved, even errors)

## Dependencies

- Nova V3 migration must be complete ✅
- Receipt domain model must have confidence field ✅
- Receipt repository must be initialized ✅
- Validator must have requiresManualReview() method ✅

## Notes

- The new pipeline is already implemented and tested
- This spec focuses on UI integration only
- Existing Nova Trace integration should be preserved
- Camera screen styling already matches design system
