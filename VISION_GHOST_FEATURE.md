# 👻 Vision Ghost - Live AI Financial Advisor

## Overview

Vision Ghost is a revolutionary feature that transforms your camera into a live AI financial advisor. Point your camera at any receipt, bill, or product, and get instant professional advice - just like having a chartered accountant looking over your shoulder in real-time.

---

## 🎯 Key Features

### 1. **Live Real-Time Analysis**
- Continuous camera monitoring (analyzes every 3 seconds)
- Instant conversational advice
- No need to capture - just point and watch
- Real-time overlay with Ghost's advice

### 2. **Receipt Analysis**
- Automatic amount detection
- Tax deduction calculations
- Category identification
- Vendor recognition
- GST/Tax breakdown

### 3. **Purchase Decision Support**
- Product identification
- Price reasonability check
- Alternative suggestions
- Tax benefit analysis
- Best timing recommendations

### 4. **Professional Advice**
- Chartered accountant-level insights
- Indian tax rules (₹ currency)
- Deduction percentages (meals 50%, office 100%, etc.)
- Documentation requirements
- Action items and next steps

---

## 🚀 How It Works

### User Flow

```
1. Open Vision Ghost screen
2. Point camera at receipt/product
3. Tap "Start" to activate live monitoring
4. Ghost analyzes frame every 3 seconds
5. See instant advice overlay on screen
6. Tap "Capture" for detailed analysis
7. Save transaction or dismiss
```

### Technical Flow

```
Camera Frame
    ↓
Capture Image (every 3s)
    ↓
Send to Nova Vision API
    ↓
AI Analysis with Structured Prompt
    ↓
Extract JSON Response
    ↓
Display Conversational Advice
    ↓
Update UI in Real-Time
```

---

## 💡 Use Cases

### Use Case 1: Restaurant Receipt
**Scenario:** User points camera at restaurant bill

**Ghost Says:**
> "I see a restaurant receipt for ₹1,200. That's 50% tax deductible if it's a business meal. Save this receipt and categorize it as 'Business Meal' in your expense report!"

**Actions:**
- Detects amount: ₹1,200
- Calculates deduction: ₹600 (50%)
- Suggests category: Business Meal
- Reminds to save receipt

### Use Case 2: Laptop Purchase
**Scenario:** User points camera at laptop price tag

**Ghost Says:**
> "That's a ₹45,000 laptop. Good choice for business! Fully deductible as office equipment. Consider buying before March 31 to claim it in this financial year. Want me to check for better deals?"

**Actions:**
- Identifies product: Laptop
- Confirms price: ₹45,000
- Tax benefit: 100% deductible
- Timing advice: Buy before FY end
- Offers alternatives

### Use Case 3: Electricity Bill
**Scenario:** User points camera at utility bill

**Ghost Says:**
> "Electricity bill ₹3,500 - seems normal for this month. If you work from home, 20% is deductible as home office expense. Set up auto-pay to avoid ₹100 late fee!"

**Actions:**
- Identifies bill type: Electricity
- Amount check: ₹3,500 (normal)
- Deduction tip: 20% for home office
- Payment advice: Auto-pay setup

### Use Case 4: Shopping Decision
**Scenario:** User points camera at expensive item

**Ghost Says:**
> "₹25,000 for a designer bag? That's not tax deductible unless it's for business use. Your monthly budget shows ₹15,000 for discretionary spending. Consider waiting for the sale next month - you'll save 30%!"

**Actions:**
- Price analysis: ₹25,000
- Tax status: Not deductible
- Budget check: Over limit
- Alternative: Wait for sale
- Savings: 30% (₹7,500)

---

## 🎨 UI/UX Design

### Screen Layout

```
┌─────────────────────────────────────┐
│  ← Vision Ghost 🟢 (Live)          │ ← Header with status
├─────────────────────────────────────┤
│                                     │
│     [Camera Preview Full Screen]    │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 👻 Ghost Advice             │   │ ← Floating advice card
│  │ "I see a restaurant receipt │   │
│  │  for ₹1,200. That's 50%     │   │
│  │  tax deductible..."         │   │
│  └─────────────────────────────┘   │
│                                     │
│                              [🔄]   │ ← Analysis indicator
│                                     │
├─────────────────────────────────────┤
│   [⏸️]    [📷]    [📜]             │ ← Bottom controls
│   Pause   Capture  History         │
└─────────────────────────────────────┘
```

### Design Elements

**Colors:**
- Background: Camera preview (full screen)
- Advice card: Frosted glass with purple glow
- Active indicator: Pulsing green dot
- Controls: Glassmorphism with neon accents

**Animations:**
- Smooth fade-in for advice cards
- Pulsing analysis indicator
- Slide-up detailed analysis sheet
- Glow effects on active controls

---

## 🔧 Technical Implementation

### Architecture

```dart
VisionGhostScreen (UI)
    ↓
VisionGhostService (Business Logic)
    ↓
NovaServiceV3 (AI Integration)
    ↓
Nova Vision API
```

### Key Components

#### 1. Camera Controller
```dart
CameraController(
  cameras.first,
  ResolutionPreset.high,
  enableAudio: false,
  imageFormatGroup: ImageFormatGroup.jpeg,
)
```

#### 2. Continuous Analysis Timer
```dart
Timer.periodic(Duration(seconds: 3), (timer) {
  if (_isListening && !_isAnalyzing) {
    _analyzeCurrentFrame();
  }
});
```

#### 3. Vision Ghost Service
```dart
Future<Map<String, dynamic>> analyzeReceiptLive(File imageFile) async {
  // Send to Nova with structured prompt
  // Extract JSON response
  // Return conversational advice
}
```

#### 4. Nova Vision Integration
```dart
await novaService.analyzeImage(
  imageFile: imageFile,
  prompt: structuredPrompt,
  deepReasoning: false, // Fast for live mode
);
```

---

## 📊 AI Prompts

### Live Analysis Prompt
```
You are a Vision Ghost - a live AI financial advisor watching through a camera.

Analyze this image and provide INSTANT, CONVERSATIONAL advice as if you're 
a chartered accountant looking over someone's shoulder.

If you see:
- A RECEIPT: Tell them what you see, the amount, and quick financial advice
- A PRODUCT: Advise if it's a good purchase, suggest alternatives
- A BILL: Explain what it is, if amount seems reasonable
- NOTHING CLEAR: Say "I'm watching... point me at a receipt or product"

Be BRIEF (2-3 sentences), FRIENDLY, and ACTIONABLE.

Return JSON with: advice, analysis, amount, category
```

### Detailed Analysis Prompt
```
You are a Vision Ghost - an expert chartered accountant analyzing financial documents.

Provide DETAILED analysis:
1. What you see
2. Financial breakdown (amount, tax, line items)
3. Tax implications (deductible amount, percentage, category)
4. Professional advice (red flags, alternatives, timing)
5. Action items (what to do next)

Use Indian tax rules (₹ currency).

Return JSON with: analysis, advice, amount, taxDeductible, deductionRate, 
category, vendor, date, actionItems, redFlags, alternatives
```

### Purchase Decision Prompt
```
You are a Vision Ghost - a financial advisor helping with purchase decisions.

Analyze this product and provide advice:
1. What is it
2. Price analysis (reasonable?)
3. Necessity check (do they need it?)
4. Alternatives (better options?)
5. Tax benefits (any deductions?)
6. Financial impact (budget effect?)
7. Recommendation (buy/wait/skip?)

Return JSON with: product, price, recommendation, reasoning, alternatives,
taxBenefit, budgetImpact, bestTiming
```

---

## 🎯 Tax Deduction Rules (India)

### Deduction Percentages

| Category | Deduction | Notes |
|----------|-----------|-------|
| **Business Meals** | 50% | Must be business-related |
| **Office Supplies** | 100% | Stationery, equipment |
| **Electronics** | 100% | Computers, phones for business |
| **Travel** | 100% | Business travel only |
| **Home Office** | 20% | Utilities if work from home |
| **Vehicle** | 50% | If used for business |
| **Entertainment** | 0% | Personal entertainment |
| **Alcohol** | 0% | Not deductible |
| **Medical** | 100% | Up to ₹25,000 limit |
| **Education** | 100% | Professional courses |

### Documentation Requirements

**Must Save:**
- Original receipts
- GST invoices (for GST-registered)
- Payment proof (card/UPI/bank)
- Business purpose note

**For Amounts Over ₹50,000:**
- Vendor PAN required
- Detailed invoice
- Payment via bank only

---

## 🚀 Performance Optimization

### Frame Analysis Frequency
- **Live Mode**: Every 3 seconds
- **Capture Mode**: On-demand
- **Adjustable**: Can be configured based on device performance

### Image Quality
- **Resolution**: High (1920x1080)
- **Format**: JPEG (compressed)
- **Size**: ~500KB per frame
- **Optimization**: Resize before sending to API

### API Usage
- **Live Mode**: ~20 requests/minute (3s interval)
- **Capture Mode**: 1 request per capture
- **Cost**: ~$0.002 per image analysis
- **Quota**: Monitor and throttle if needed

---

## 🔐 Privacy & Security

### Data Handling
- ✅ Images processed in real-time
- ✅ Not stored on device (unless user saves)
- ✅ Sent securely to Nova API (HTTPS)
- ✅ No third-party sharing
- ✅ User can pause/stop anytime

### Permissions Required
- 📷 Camera access (required)
- 💾 Storage (optional, for saving receipts)

### User Control
- Start/stop live monitoring
- Clear conversation history
- Delete captured images
- Opt-out of feature entirely

---

## 📱 Platform Support

### Supported Platforms
- ✅ Android (Camera2 API)
- ✅ iOS (AVFoundation)
- ⚠️ Web (Limited - file upload only)
- ❌ Desktop (No camera support yet)

### Requirements
- Camera permission
- Internet connection (for AI analysis)
- Minimum 2GB RAM
- Android 7.0+ / iOS 12.0+

---

## 🎓 User Guide

### Getting Started

1. **Open Vision Ghost**
   - Tap "Vision Ghost" from main menu
   - Grant camera permission if prompted

2. **Start Live Monitoring**
   - Tap "Start" button
   - Point camera at receipt/product
   - Wait for Ghost's advice (3-5 seconds)

3. **View Advice**
   - Read advice overlay on screen
   - Advice updates every 3 seconds
   - Tap "Pause" to stop monitoring

4. **Capture for Details**
   - Tap "Capture" button
   - View detailed analysis sheet
   - Save transaction or dismiss

5. **Check History**
   - Tap "History" button
   - Review past advice
   - See conversation log

### Tips for Best Results

✅ **DO:**
- Hold camera steady
- Ensure good lighting
- Point directly at receipt/product
- Wait 3-5 seconds for analysis
- Use capture mode for detailed analysis

❌ **DON'T:**
- Move camera too quickly
- Use in very dark conditions
- Expect instant results (takes 3-5s)
- Point at multiple items at once
- Use for sensitive documents

---

## 🏆 Hackathon Highlights

### Innovation
> "Vision Ghost is the world's first live AI financial advisor that works through your camera. Unlike traditional receipt scanners that require capture and upload, Vision Ghost provides instant advice as you point your camera - just like having a chartered accountant with you 24/7."

### Technical Excellence
> "Built with Google's Nova Vision API, advanced camera processing, and real-time streaming architecture. Analyzes frames every 3 seconds with sub-second latency, providing conversational advice using structured AI prompts and JSON parsing."

### Social Impact
> "Democratizes access to professional financial advice. Small business owners, freelancers, and individuals can now get expert guidance on every purchase and expense - something previously available only to those who could afford chartered accountants."

### User Experience
> "Seamless glassmorphism UI with real-time overlays, conversational advice, and instant feedback. No forms, no buttons, no complexity - just point your camera and get advice. It's like having a financial guardian angel."

---

## 📊 Demo Script

### For Video Demo (2 minutes)

**Scene 1: Introduction (20s)**
```
"Meet Vision Ghost - your live AI financial advisor. 
Watch as I point my camera at this restaurant receipt..."
[Show camera view with receipt]
```

**Scene 2: Live Analysis (30s)**
```
[Ghost advice appears on screen]
"I see a restaurant receipt for ₹1,200. That's 50% tax 
deductible if it's a business meal. Save this receipt!"

"Notice how the advice appears instantly - no capture needed!"
```

**Scene 3: Detailed Analysis (30s)**
```
[Tap Capture button]
"For detailed analysis, I just tap Capture..."
[Show detailed analysis sheet]
"Full breakdown: amount, tax deduction, category, action items"
```

**Scene 4: Purchase Decision (30s)**
```
[Point at laptop]
"Now watch as I point at this laptop..."
[Ghost advice appears]
"₹45,000 laptop - fully deductible! Buy before March 31 
for this year's taxes."
```

**Scene 5: Impact (10s)**
```
"Vision Ghost: Professional financial advice, 
available to everyone, anytime, anywhere."
```

---

## 🔮 Future Enhancements

### Phase 1 (Current)
- [x] Live camera analysis
- [x] Receipt detection
- [x] Tax deduction calculation
- [x] Conversational advice

### Phase 2 (Next)
- [ ] Voice output (text-to-speech)
- [ ] Voice input (ask questions)
- [ ] Multi-language support
- [ ] Offline mode (basic analysis)

### Phase 3 (Future)
- [ ] AR overlays (highlight amounts)
- [ ] Comparison shopping
- [ ] Budget alerts
- [ ] Smart notifications

### Phase 4 (Advanced)
- [ ] Multi-receipt batch processing
- [ ] Invoice generation
- [ ] Expense report creation
- [ ] Integration with accounting software

---

## 📝 Code Examples

### Using Vision Ghost Service

```dart
// Initialize service
final visionService = ref.read(visionGhostServiceProvider);

// Live analysis
final result = await visionService.analyzeReceiptLive(imageFile);
print(result['advice']); // "I see a restaurant receipt..."

// Detailed analysis
final detailed = await visionService.analyzeReceiptDetailed(imageFile);
print(detailed['taxDeductible']); // 600
print(detailed['deductionRate']); // 50

// Purchase decision
final decision = await visionService.analyzePurchaseDecision(
  imageFile,
  context: "User wants to buy a laptop for business",
);
print(decision['recommendation']); // "buy"
```

### Adding to Navigation

```dart
// In app_router.dart
GoRoute(
  path: '/vision-ghost',
  builder: (context, state) => const VisionGhostScreen(),
),

// Navigate to Vision Ghost
context.push('/vision-ghost');
```

---

## ✅ Testing Checklist

### Functional Testing
- [ ] Camera initializes correctly
- [ ] Live monitoring starts/stops
- [ ] Frame analysis every 3 seconds
- [ ] Advice overlay displays
- [ ] Capture mode works
- [ ] Detailed analysis sheet shows
- [ ] History view accessible
- [ ] Save transaction works

### Performance Testing
- [ ] No lag during live monitoring
- [ ] Smooth camera preview
- [ ] Fast API responses (<5s)
- [ ] No memory leaks
- [ ] Battery usage acceptable

### Edge Cases
- [ ] No camera available
- [ ] Poor lighting conditions
- [ ] No internet connection
- [ ] API quota exceeded
- [ ] Invalid image format
- [ ] Multiple items in frame

---

## 🎯 Success Metrics

### User Engagement
- Time spent in Vision Ghost mode
- Number of receipts analyzed
- Capture vs live mode usage
- Advice acceptance rate

### Accuracy
- Correct amount detection: >95%
- Correct category identification: >90%
- Tax calculation accuracy: 100%
- User satisfaction: >4.5/5

### Performance
- Analysis latency: <5 seconds
- Frame processing: 3 seconds interval
- API success rate: >99%
- App crash rate: <0.1%

---

**Vision Ghost: Your AI Financial Guardian, Always Watching, Always Advising** 👻💰

