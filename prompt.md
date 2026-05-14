# Antigravity Flutter Code Generation Prompt
## Project: Anexee — Analytical Excellence ML Platform Companion App

---

## 1. Project Overview

Build a Flutter (Dart) ML platform companion application called **Anexee — Analytical Excellence**. The app enables users to manage training profiles, run multi-step model training wizard workflows, and compare model performance on a leaderboard.

The UI must be **pixel-accurate** to the provided design references. Every API call, navigation transition, and state mutation is driven exclusively by API responses — no optimistic or mocked navigation.

---

## 2. Exact Folder Structure

Replicate this structure verbatim. Do not invent additional top-level directories.

```
lib/
├── main.dart
└── app/
    ├── core/
    │   ├── constants/
    │   │   ├── api_constants.dart
    │   │   ├── app_strings.dart
    │   │   └── asset_constants.dart
    │   ├── errors/
    │   │   ├── exceptions.dart
    │   │   └── failures.dart
    │   ├── theme/
    │   │   ├── app_colors.dart
    │   │   ├── app_text_styles.dart
    │   │   ├── app_theme.dart
    │   │   └── app_dimensions.dart
    │   ├── utils/
    │   │   ├── validators.dart
    │   │   ├── extensions.dart
    │   │   └── logger.dart
    │   └── widgets/
    │       ├── app_button.dart
    │       ├── app_text_field.dart
    │       ├── app_loader.dart
    │       ├── app_error_widget.dart
    │       ├── app_snackbar.dart
    │       ├── app_badge.dart
    │       ├── app_sidebar.dart
    │       └── step_progress_indicator.dart
    ├── data/
    │   ├── local/
    │   │   ├── db/
    │   │   │   └── app_database.dart
    │   │   └── preference/
    │   │       ├── preference_keys.dart
    │   │       └── app_preferences.dart
    │   ├── model/
    │   │   ├── profile_model.dart
    │   │   ├── leaderboard_model.dart
    │   │   ├── leaderboard_entry_model.dart
    │   │   ├── model_parameter_model.dart
    │   │   ├── upload_session_model.dart
    │   │   ├── feature_model.dart
    │   │   ├── use_case_model.dart
    │   │   ├── training_config_model.dart
    │   │   └── training_result_model.dart
    │   └── remote/
    │       ├── api_client.dart
    │       ├── interceptors/
    │       │   ├── auth_interceptor.dart
    │       │   └── logging_interceptor.dart
    │       └── endpoints/
    │           ├── profile_endpoints.dart
    │           ├── training_endpoints.dart
    │           ├── leaderboard_endpoints.dart
    │           └── model_endpoints.dart
    ├── flavors/
    │   ├── flavor_config.dart
    │   ├── development.dart
    │   └── production.dart
    ├── modules/
    │   ├── dashboard/
    │   │   ├── bloc/
    │   │   │   ├── dashboard_bloc.dart
    │   │   │   ├── dashboard_event.dart
    │   │   │   └── dashboard_state.dart
    │   │   ├── repository/
    │   │   │   └── profile_repository.dart
    │   │   ├── service/
    │   │   │   └── profile_service.dart
    │   │   ├── widgets/
    │   │   │   ├── profile_list_tile.dart
    │   │   │   ├── profile_icon_badge.dart
    │   │   │   └── tag_count_badge.dart
    │   │   └── screens/
    │   │       └── profile_dashboard_screen.dart
    │   ├── leaderboard/
    │   │   ├── bloc/
    │   │   │   ├── leaderboard_bloc.dart
    │   │   │   ├── leaderboard_event.dart
    │   │   │   └── leaderboard_state.dart
    │   │   ├── repository/
    │   │   │   └── leaderboard_repository.dart
    │   │   ├── service/
    │   │   │   └── leaderboard_service.dart
    │   │   ├── widgets/
    │   │   │   ├── leaderboard_table.dart
    │   │   │   ├── leaderboard_row.dart
    │   │   │   ├── expanded_model_detail.dart
    │   │   │   ├── metric_cell.dart
    │   │   │   └── dataset_chip.dart
    │   │   └── screens/
    │   │       └── leaderboard_screen.dart
    │   └── training/
    │       ├── bloc/
    │       │   ├── training_wizard_bloc.dart
    │       │   ├── training_wizard_event.dart
    │       │   └── training_wizard_state.dart
    │       ├── repository/
    │       │   └── training_repository.dart
    │       ├── service/
    │       │   └── training_service.dart
    │       ├── widgets/
    │       │   ├── wizard_step_header.dart
    │       │   ├── wizard_navigation_bar.dart
    │       │   ├── parquet_upload_zone.dart
    │       │   ├── feature_selection_list.dart
    │       │   ├── use_case_selector.dart
    │       │   ├── hyperparameter_table.dart
    │       │   ├── general_settings_form.dart
    │       │   └── profile_exists_banner.dart
    │       └── screens/
    │           ├── training_wizard_screen.dart
    │           ├── steps/
    │           │   ├── step1_data_source.dart
    │           │   ├── step2_features.dart
    │           │   ├── step3_use_case.dart
    │           │   └── step4_configuration.dart
    ├── network/
    │   ├── dio_client.dart
    │   ├── network_info.dart
    │   └── response_handler.dart
    └── routes/
        ├── app_router.dart
        ├── route_names.dart
        └── route_guards.dart
```

---

## 3. Design System & Theme

### Color Palette

```dart
// app_colors.dart
class AppColors {
  // Brand
  static const Color primary        = Color(0xFF00B5AD);  // teal — sidebar active, buttons
  static const Color primaryLight   = Color(0xFFE0F7F6);  // tag badge backgrounds
  static const Color primaryDark    = Color(0xFF007A75);

  // Sidebar
  static const Color sidebarBg      = Color(0xFFFFFFFF);
  static const Color sidebarBorder  = Color(0xFFE5E7EB);
  static const Color activeNavBg    = Color(0xFF00B5AD);  // filled teal for active item
  static const Color activeNavText  = Color(0xFFFFFFFF);
  static const Color inactiveNavText = Color(0xFF6B7280);

  // Surface
  static const Color scaffoldBg     = Color(0xFFF9FAFB);
  static const Color cardBg         = Color(0xFFFFFFFF);
  static const Color tableBorder    = Color(0xFFE5E7EB);
  static const Color expandedRowBg  = Color(0xFFF0FAFA);

  // Text
  static const Color textPrimary    = Color(0xFF111827);
  static const Color textSecondary  = Color(0xFF6B7280);
  static const Color textTertiary   = Color(0xFF9CA3AF);
  static const Color textLink       = Color(0xFF00B5AD);

  // Status
  static const Color statusActive   = Color(0xFF10B981);  // green dot
  static const Color statusInactive = Color(0xFF9CA3AF);  // grey dot
  static const Color infoBg         = Color(0xFFEFF6FF);
  static const Color infoBorder     = Color(0xFFBFDBFE);
  static const Color infoText       = Color(0xFF1D4ED8);

  // Input
  static const Color inputBorder    = Color(0xFFD1D5DB);
  static const Color inputFocused   = Color(0xFF00B5AD);
  static const Color checkboxActive = Color(0xFF00B5AD);

  // Misc
  static const Color divider        = Color(0xFFE5E7EB);
  static const Color white          = Color(0xFFFFFFFF);
  static const Color uploadZoneBg   = Color(0xFFF9FAFB);
  static const Color uploadZoneBorder = Color(0xFF9CA3AF); // dashed
}
```

### Typography

```dart
// app_text_styles.dart
// Font family: Inter (Google Fonts package)
class AppTextStyles {
  static const TextStyle pageTitle     = TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static const TextStyle pageSubtitle  = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary);
  static const TextStyle sectionTitle  = TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static const TextStyle tableHeader   = TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary);
  static const TextStyle tableRow      = TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary);
  static const TextStyle tableRowNum   = TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textTertiary);
  static const TextStyle sidebarBrand  = TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static const TextStyle sidebarSub    = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary);
  static const TextStyle sidebarNav    = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
  static const TextStyle buttonLabel   = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.white);
  static const TextStyle badgeLabel    = TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primary);
  static const TextStyle wizardStepLabel = TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
  static const TextStyle formLabel     = TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary);
  static const TextStyle metricValue   = TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary);
  static const TextStyle paramChip     = TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary);
}
```

### Dimensions

```dart
// app_dimensions.dart
class AppDimensions {
  static const double sidebarWidth      = 240.0;
  static const double topBarHeight      = 64.0;
  static const double contentPadding    = 32.0;
  static const double cardRadius        = 12.0;
  static const double buttonRadius      = 8.0;
  static const double inputRadius       = 8.0;
  static const double tableCellPadH     = 20.0;
  static const double tableCellPadV     = 18.0;
  static const double wizardModalWidth  = 660.0;
  static const double wizardModalMaxH   = 600.0;
  static const double iconBadgeSize     = 36.0;
  static const double stepCircleSize    = 32.0;
  static const double uploadZoneHeight  = 220.0;
}
```

---

## 4. Navigation & Routing

### Route Names

```dart
// route_names.dart
class RouteNames {
  static const String dashboard   = '/';
  static const String leaderboard = '/leaderboard';
  static const String training    = '/training';
}
```

### Router

Use `go_router` package. Define:

- `/` → `ProfileDashboardScreen` (initial location)
- `/leaderboard` → `LeaderboardScreen` — accepts `profileId` and `profileName` as query parameters
- Training wizard is a **modal dialog/sheet** launched over the dashboard, not a separate route

### Navigation Rules (non-negotiable)

- App launches directly to `ProfileDashboardScreen`. No splash, no auth screen.
- **Sidebar does NOT contain a Leaderboard menu item.** Sidebar items: Dashboard, Models, Training, Settings, (bottom) Help Center, Sign Out.
- Leaderboard is accessed **only** by tapping a profile row in the dashboard table.
- The Training wizard opens as a `showDialog` or `showGeneralDialog` overlay from the Dashboard's "Train" button (top-right of Profile Dashboard).
- Wizard is not a route; it is a stateful dialog managed by `TrainingWizardBloc`.
- After successful `Train Model` submission (Step 4), close the dialog and trigger a `ProfileDashboardBloc` refresh event.

---

## 5. Sidebar / Navigation Drawer

### Component: `AppSidebar`

Pixel-accurate implementation:

```
┌──────────────────────────┐
│  [■] Anexee              │  ← teal square logo icon + brand name bold
│      Analytical Excellence│  ← subtitle grey
├──────────────────────────┤
│  [+] New Experiment       │  ← filled teal rounded button, full width
├──────────────────────────┤
│  [grid]  Dashboard        │
│  [model] Models           │
│  [sync]  Training         │  ← active state: teal bg, white text, rounded
│  [chart] Settings         │
├──────────────────────────┤  ← spacer + bottom divider
│  [?]     Help Center      │
│  [→|]    Sign Out         │
└──────────────────────────┘
```

- Width: 240px fixed, white background, right border `Color(0xFFE5E7EB)`.
- Active nav item: background `AppColors.primary`, text white, border-radius 8px, full-width padding horizontal 12px, vertical 10px.
- Inactive: transparent bg, icon + text `AppColors.inactiveNavText`.
- "New Experiment" button: teal filled, white text, icon `+`, height 44px, border-radius 8px, full width with 16px horizontal margin.
- Sidebar is always visible on desktop (≥1024px). On tablet/mobile it becomes a drawer.

---

## 6. Top Navigation Bar

Shared across Dashboard and Leaderboard screens.

```
[Anexee Companion]    [Projects] [Runs] [Assets]      [Create Model btn] [🔔] [👤]
```

- Left: "Anexee Companion" bold text.
- Center: text nav links — Projects, Runs, Assets. No active state styling needed (passive links).
- Right: "Create Model" outlined button with border `AppColors.primary`, text `AppColors.primary`; bell icon; avatar circle.
- Height: 64px, white bg, bottom border divider.

On Leaderboard screen, the top bar shows the same layout but "Create Model" is a **filled** teal button.

---

## 7. Screen: Profile Dashboard

**Route:** `/`  
**BLoC:** `DashboardBloc`

### Layout

```
[Sidebar] | [TopBar]
           [Content]
             Page Title: "Profile Dashboard"
             Subtitle:   "Manage and configure your active training profiles."
             Right:      [Search field "Search profiles..."] [Train Button filled teal]
           [Profile Table]
```

### Profile Table

Columns: `#` | `Profile Name` | `Data Volume` | `Actions`

Each row:
- `#` column: two-digit zero-padded index (`01`, `02`, `03`)
- `Profile Name`: icon badge (vehicle icon, teal light bg) + profile name text
- `Data Volume`: teal badge chip with "{n} tags" text
- `Actions`: empty in design (reserved)
- Row height: ~72px, bottom divider `Color(0xFFE5E7EB)`
- Row is tappable — entire row navigates to Leaderboard
- Hover state: row background `Color(0xFFF9FAFB)`

### Icon Badge

Circular or rounded-square container, background `AppColors.primaryLight` (light teal), containing a vehicle/category icon in `AppColors.primary`. Size 36×36px, border-radius 8px.

### Tag Count Badge

Rounded pill, background `AppColors.primaryLight`, text `"{n} tags"`, text style `AppTextStyles.badgeLabel`, horizontal padding 12px, vertical 6px.

### "Train" Button (Dashboard top-right)

- Filled teal, white text, prefix `+` icon, border-radius 8px.
- `onPressed`: opens Training Wizard dialog.

### Search Field

- Width: 280px on desktop.
- Prefix search icon `AppColors.textTertiary`.
- Placeholder "Search profiles..."
- Filters profile list client-side by name match.

### State Management

```dart
// Events
LoadProfiles
SearchProfiles(String query)
RefreshProfiles  // triggered after training completes

// States
DashboardInitial
DashboardLoading
DashboardLoaded(List<ProfileModel> profiles, String searchQuery)
DashboardError(String message)
```

---

## 8. API: Profile Endpoints

### `GET /api/v1/profiles`

**Response:**
```json
{
  "data": [
    {
      "id": "string",
      "name": "string",
      "icon_type": "string",   // e.g. "car", "bus"
      "tag_count": 10,
      "created_at": "ISO8601"
    }
  ],
  "total": 3
}
```

**Repository method:**
```dart
Future<Either<Failure, List<ProfileModel>>> getProfiles();
```

Map `icon_type` to Flutter icon or SVG asset. Supported values: `car`, `bus`, `truck`, `default`.

---

## 9. Screen: Leaderboard

**Route:** `/leaderboard?profileId=X&profileName=Y`  
**BLoC:** `LeaderboardBloc`

Opened **only** by tapping a profile row in the dashboard. Back navigation returns to Dashboard.

### Layout

```
[Sidebar — same as Dashboard, "Training" active] | [TopBar — "Create Model" filled]
[Content]
  Page Title: "Leaderboards"
  Subtitle:   "Compare model performance across primary metrics."
  Right:      [Filter button — outlined, with filter icon]
[Leaderboard Table]
```

### Leaderboard Table

Columns: ` ` (expand toggle) | `Models` | `Use Case` | `Precision` | `Accuracy` | `Recall` | `Actions`

Each row:
- Toggle cell: `[+]` or `[-]` square icon button to expand/collapse detail
- Model name with colored status dot (green = active, grey = inactive)
- Use case text
- Precision / Accuracy / Recall: numeric values formatted to 3 decimal places
- Actions: download icon button (teal)

Expanded row (spans all columns):
- Background `AppColors.expandedRowBg`
- Three sections side by side:
  - **Parameter** — chip tags (e.g. `epochs: 50`, `batch: 32`, `lr: 0.001`)
  - **Metrics** — key-value rows (F1 Score: 0.913, Val Loss: 0.142)
  - **File trained on** — file chip with arrow link (e.g. `dataset_v2.csv →`)

### State Management

```dart
// Events
LoadLeaderboard(String profileId)
ToggleModelExpansion(String modelId)
DownloadModel(String modelId)

// States
LeaderboardInitial
LeaderboardLoading
LeaderboardLoaded(List<LeaderboardEntryModel> entries, Set<String> expandedIds)
LeaderboardError(String message)
```

### API: `GET /api/v1/profiles/{profileId}/leaderboard`

**Response:**
```json
{
  "data": [
    {
      "id": "string",
      "name": "string",
      "use_case": "string",
      "precision": 0.942,
      "accuracy": 0.961,
      "recall": 0.915,
      "status": "active",
      "parameters": {
        "epochs": 50,
        "batch": 32,
        "lr": 0.001
      },
      "metrics": {
        "f1_score": 0.913,
        "val_loss": 0.142
      },
      "trained_on_file": "dataset_v2.csv",
      "trained_on_file_url": "string"
    }
  ]
}
```

---

## 10. Training Wizard

**Trigger:** "Train" button on Profile Dashboard  
**Mechanism:** `showDialog` (barrier dismissible: false)  
**BLoC:** `TrainingWizardBloc`  
**Modal dimensions:** max-width 660px, constrained height with scroll on overflow.

### Step Indicator (shared across all steps)

Horizontal stepper at modal top. 4 steps:

```
[1 filled teal] ──── [2 grey] ──── [3 grey] ──── [4 grey]
 Data Source          Features       Use Case      Configuration
```

- Active step: filled teal circle, white number, label bold teal.
- Completed step: teal circle with checkmark.
- Incomplete step: grey circle, grey label.
- Connector line between steps: grey, turns teal when step is completed.

Use `StepProgressIndicator` reusable widget. Props: `currentStep` (1-indexed), `totalSteps`, `stepLabels`.

### Wizard Navigation Bar (bottom of each step)

```
[Cancel]                                          [Next →]  or  [Train Model →]
```

- Cancel: text button, closes dialog without confirmation.
- Next: filled teal button, disabled when current step is invalid.
- Step 4 final action: "Train Model" button with right-arrow icon.
- Back button appears from Step 2 onwards (left side, outlined).

---

## 11. Wizard Step 1: Data Source

**Header title:** "Model Training Configuration"  
**Step label:** "Data Source"

### Profile Exists Banner (conditional)

When the API response on upload indicates a pre-existing profile:

```
[ℹ] Profile already exists
    Adding in that profile only.
```

Background `AppColors.infoBg`, border `AppColors.infoBorder`, icon teal, rounded 8px.

### Upload Zone

```
┌─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─┐  ← dashed border 1.5px, radius 12px
│                                   │
│        [upload icon]              │
│   Drop your file here             │  bold 16px
│   Parquet file (.parquet)         │  grey 13px
│                                   │
│        [Browse Files]             │  ← outlined button
│                                   │
└─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─┘
```

- Drag-and-drop enabled via `desktop_drop` package.
- Only `.parquet` files accepted (validate extension before upload).
- On file selected: show file name chip below upload zone with remove `×` button.
- On "Next" click with a valid file: call `POST /api/v1/training/upload` with `multipart/form-data`.
- During upload: show linear progress indicator inside upload zone; disable "Next".
- On success: advance to Step 2 and store `sessionId` from response.
- On error: show inline error text below upload zone in red, do not advance.

### API: `POST /api/v1/training/upload`

**Request:** `multipart/form-data`  
- Field `file`: `.parquet` file  
- Field `profile_name` (optional): string

**Response:**
```json
{
  "session_id": "string",
  "profile_exists": true,
  "profile_name": "string",
  "inferred_schema": {
    "columns": ["col1", "col2"],
    "row_count": 12000
  }
}
```

---

## 12. Wizard Step 2: Features

**Step label:** "Features"

Display list of inferred features from `session.inferred_schema.columns`. Each row:
- Checkbox (teal when checked)
- Feature name
- Inferred data type chip

Default: all features selected.

Validation: at least one feature must be selected.

On "Next": call `POST /api/v1/training/{sessionId}/features` with selected columns.

**API:** `POST /api/v1/training/{sessionId}/features`

**Request:**
```json
{ "selected_features": ["col1", "col2"] }
```

**Response:**
```json
{ "session_id": "string", "feature_count": 2 }
```

---

## 13. Wizard Step 3: Use Case

**Step label:** "Use Case"

Display selectable cards or radio tiles for use case types. Examples from leaderboard data:
- Text Classification
- Sentiment Analysis
- Entity Extraction
- Custom (free-text input appears)

Validation: exactly one use case selected.

On "Next": call `POST /api/v1/training/{sessionId}/usecase`.

**API:** `POST /api/v1/training/{sessionId}/usecase`

**Request:**
```json
{ "use_case": "Text Classification" }
```

**Response:**
```json
{ "session_id": "string", "use_case": "string" }
```

---

## 14. Wizard Step 4: Configuration

**Wizard title:** "New Model Training"  
**Step label:** "Configuration" (progress bar shown, not circle stepper)  
**Step header text:** "Step 3: Configuration" ← display exactly as shown

### Layout: Two-column

**Left column — General Settings**
- Section title: "General Settings"
- Subtitle: "Define the foundational parameters for your model run."
- `Model Name` label + text input (pre-filled e.g. `XGBoost_v1.2_prod`)
- `CV Fold` label + dropdown (options: 3, 5, 10; default 5)
- `Train Split` label + numeric input with `%` suffix unit (default 0.8)

**Right column — Hyperparameters**
- Section title: "Hyperparameters" + "Select All" teal link
- Table with columns: checkbox | Parameter | Default Value
- Rows: `learning_rate` 0.01, `max_depth` 6, `n_estimators` 100, `subsample` 0.8, `colsample_bytree` 0.8
- Checked rows: learning_rate, max_depth, subsample (match design; n_estimators and colsample_bytree unchecked)
- Checkbox: teal when checked

### Validation Rules

- `Model Name`: required, min 3 chars, no spaces (underscores OK), max 64 chars.
- `CV Fold`: required, must be integer from dropdown.
- `Train Split`: required, numeric, range 0.1–0.99.
- At least one hyperparameter selected.

### "Train Model" Button

Triggers `POST /api/v1/training/{sessionId}/train`.  
During submission: button shows circular loader, all inputs disabled.  
On success: close dialog, dispatch `RefreshProfiles` event to DashboardBloc.  
On error: show `AppSnackbar` error toast, remain on Step 4 with inputs re-enabled.

### API: `POST /api/v1/training/{sessionId}/train`

**Request:**
```json
{
  "model_name": "XGBoost_v1.2_prod",
  "cv_fold": 5,
  "train_split": 0.8,
  "hyperparameters": {
    "learning_rate": 0.01,
    "max_depth": 6,
    "subsample": 0.8
  }
}
```

**Response:**
```json
{
  "run_id": "string",
  "model_id": "string",
  "status": "training_started",
  "estimated_duration_seconds": 120
}
```

---

## 15. State Management Architecture

Use `flutter_bloc` package with `Cubit` for simple states, `Bloc` for event-driven flows.

### TrainingWizardBloc

```dart
// Events
StartWizard
UploadFile(File file)
ConfirmFeatures(List<String> features)
ConfirmUseCase(String useCase)
SubmitTraining(TrainingConfigModel config)
GoToStep(int step)
CancelWizard

// States
WizardInitial
WizardStep1(bool isUploading, String? error, String? fileName)
WizardStep2(UploadSessionModel session, List<String> selectedFeatures)
WizardStep3(String sessionId, List<String> features, String? selectedUseCase)
WizardStep4(String sessionId, List<String> features, String useCase, bool isSubmitting, String? error)
WizardSuccess(TrainingResultModel result)
WizardError(String message)
```

---

## 16. Repository & Service Layer

### Pattern

```
UI (Screen) → BLoC → Repository → Service → ApiClient (Dio)
```

- **Service**: raw HTTP calls, returns `Response`.
- **Repository**: calls service, maps response to models, wraps in `Either<Failure, T>` (using `dartz` package).
- **BLoC**: calls repository, emits states.

### Example: ProfileRepository

```dart
abstract class IProfileRepository {
  Future<Either<Failure, List<ProfileModel>>> getProfiles();
}

class ProfileRepository implements IProfileRepository {
  final ProfileService _service;
  ProfileRepository(this._service);

  @override
  Future<Either<Failure, List<ProfileModel>>> getProfiles() async {
    try {
      final response = await _service.fetchProfiles();
      final models = (response.data['data'] as List)
          .map((e) => ProfileModel.fromJson(e))
          .toList();
      return Right(models);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
```

Apply this pattern identically for `LeaderboardRepository` and `TrainingRepository`.

---

## 17. Data Models

### ProfileModel

```dart
class ProfileModel extends Equatable {
  final String id;
  final String name;
  final String iconType;   // "car" | "bus" | "truck" | "default"
  final int tagCount;
  final DateTime createdAt;
}
```

### LeaderboardEntryModel

```dart
class LeaderboardEntryModel extends Equatable {
  final String id;
  final String name;
  final String useCase;
  final double precision;
  final double accuracy;
  final double recall;
  final String status;        // "active" | "inactive"
  final Map<String, dynamic> parameters;
  final Map<String, double> metrics;
  final String trainedOnFile;
  final String trainedOnFileUrl;
}
```

### UploadSessionModel

```dart
class UploadSessionModel extends Equatable {
  final String sessionId;
  final bool profileExists;
  final String? profileName;
  final List<String> columns;
  final int rowCount;
}
```

### TrainingConfigModel

```dart
class TrainingConfigModel extends Equatable {
  final String sessionId;
  final String modelName;
  final int cvFold;
  final double trainSplit;
  final Map<String, dynamic> hyperparameters;
}
```

---

## 18. Network Layer

### DioClient Configuration

```dart
// network/dio_client.dart
class DioClient {
  static Dio create(FlavorConfig config) {
    final dio = Dio(BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    dio.interceptors.addAll([
      AuthInterceptor(),
      LoggingInterceptor(),
    ]);
    return dio;
  }
}
```

### ResponseHandler

```dart
class ResponseHandler {
  static T handle<T>(Response response, T Function(Map<String, dynamic>) fromJson) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return fromJson(response.data as Map<String, dynamic>);
    }
    throw ServerException(
      message: response.data['message'] ?? 'Unexpected error',
      statusCode: response.statusCode,
    );
  }
}
```

---

## 19. API Constants

```dart
class ApiConstants {
  static const String baseUrl = 'https://api.anexee.io';  // override per flavor

  // Profiles
  static const String profiles = '/api/v1/profiles';

  // Leaderboard
  static String leaderboard(String profileId) =>
      '/api/v1/profiles/$profileId/leaderboard';

  // Training
  static const String trainingUpload   = '/api/v1/training/upload';
  static String trainingFeatures(String sid)  => '/api/v1/training/$sid/features';
  static String trainingUseCase(String sid)   => '/api/v1/training/$sid/usecase';
  static String trainingTrain(String sid)     => '/api/v1/training/$sid/train';
}
```

---

## 20. Error & Loading State Handling

### Loading States

- **Full screen load** (Dashboard initial, Leaderboard initial): centered `CircularProgressIndicator` with teal color inside content area. Sidebar and TopBar remain visible.
- **Inline wizard step load** (file upload, step API calls): show `LinearProgressIndicator` at top of modal content area. Disable "Next" button (opacity 0.5, ignorePointer).
- **Button submit load** (Train Model): replace button label with `SizedBox(width:20, height:20, child: CircularProgressIndicator(color: white, strokeWidth: 2))`.

### Error States

- **Full screen error**: `AppErrorWidget` — centered column with error icon, error message text, and "Retry" outlined button that re-dispatches the load event.
- **Inline wizard error**: red text below the relevant input/zone. Message from API `error.message` field. Clears when user modifies input.
- **Snackbar**: for training submission errors — `AppSnackbar.showError(context, message)`. Bottom of screen, red background, white text, 4s duration, auto-dismiss.

### Validation Display

- Validate on "Next" tap (not on-change except for Model Name which validates on-change after first attempt).
- Show error text below each invalid field in `AppColors.error` (`Color(0xFFDC2626)`), font size 12px.
- "Next" button remains enabled; validation blocks advance.

---

## 21. Local Storage

### AppPreferences (SharedPreferences)

```dart
class PreferenceKeys {
  static const String authToken       = 'auth_token';
  static const String lastProfileId   = 'last_profile_id';
  static const String userEmail       = 'user_email';
}
```

Persist: auth token (injected via AuthInterceptor into every request header as `Authorization: Bearer {token}`).

### AppDatabase (Hive or sqflite)

Cache leaderboard entries per profileId for offline viewing. Cache TTL: 5 minutes. If cached data is fresh, use it; otherwise fetch from API.

---

## 22. Dependency Injection

Use `get_it` package with `injectable` for DI annotation. Register all services, repositories, and blocs.

```dart
// di setup order
1. FlavorConfig (singleton)
2. DioClient (singleton)
3. ProfileService, LeaderboardService, TrainingService (lazy singleton)
4. ProfileRepository, LeaderboardRepository, TrainingRepository (lazy singleton)
5. DashboardBloc, LeaderboardBloc, TrainingWizardBloc (factory — new instance per screen)
```

---

## 23. Responsive Layout

### Breakpoints

```dart
class Breakpoints {
  static const double mobile  = 600;
  static const double tablet  = 900;
  static const double desktop = 1200;
}
```

### Behavior

- **≥1024px (desktop)**: Sidebar always visible (permanent). Two-column layout for Step 4. Table shows all columns.
- **768–1023px (tablet)**: Sidebar collapses to rail (icon only). Wizard modal width: 90% of screen. Step 4: single column stacked.
- **<768px (mobile)**: Sidebar becomes a bottom nav or hamburger drawer. Wizard is full-screen. Table uses horizontal scroll.

Use `LayoutBuilder` + `AdaptiveSidebar` wrapper widget.

---

## 24. Packages (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.5
  dartz: ^0.10.1
  equatable: ^2.0.5
  dio: ^5.4.3+1
  get_it: ^7.6.7
  injectable: ^2.3.2
  go_router: ^13.2.0
  google_fonts: ^6.2.1
  shared_preferences: ^2.2.3
  hive_flutter: ^1.1.0
  desktop_drop: ^0.4.4
  file_picker: ^8.0.3
  intl: ^0.19.0
  shimmer: ^3.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.7
  mocktail: ^1.0.3
  injectable_generator: ^2.4.1
  build_runner: ^2.4.8
  hive_generator: ^2.0.1
```

---

## 25. Naming Conventions

| Artifact | Convention | Example |
|---|---|---|
| Files | `snake_case.dart` | `profile_dashboard_screen.dart` |
| Classes | `PascalCase` | `ProfileDashboardScreen` |
| Variables/methods | `camelCase` | `fetchProfiles()` |
| Constants | `camelCase` in class | `AppColors.primary` |
| BLoC events | Noun+Verb | `LoadProfiles`, `ToggleModelExpansion` |
| BLoC states | Noun+Adjective | `DashboardLoaded`, `WizardStep1` |
| API methods | verb+Noun | `fetchProfiles`, `uploadTrainingFile` |
| Widget files | widget purpose | `profile_list_tile.dart` |
| Model files | `_model.dart` suffix | `profile_model.dart` |

---

## 26. Reusable Widget Specifications

### `AppButton`

Props: `label`, `onPressed`, `isLoading`, `isOutlined`, `prefixIcon`, `width`, `height (default 44)`  
Disabled state: opacity 0.5.  
Loading state: replace label with 20px CircularProgressIndicator.

### `AppTextField`

Props: `label`, `controller`, `errorText`, `suffixText`, `hintText`, `keyboardType`, `validator`  
Style: border radius 8px, border `inputBorder`, focused border `inputFocused`.

### `AppLoader`

Centered `CircularProgressIndicator` in `AppColors.primary`. Wrap in `Padding(all: 48)`.

### `AppErrorWidget`

Props: `message`, `onRetry`.  
Layout: Column — error icon (grey 48px), message text, retry button.

### `AppSnackbar`

Static methods: `showError(context, message)`, `showSuccess(context, message)`.  
Error: red background. Success: teal background. Duration: 4 seconds.

### `StepProgressIndicator`

Props: `currentStep`, `totalSteps`, `stepLabels`.  
Renders circle + connector + label for each step.  
Supports two visual modes: circles (Steps 1–3 in modal) and progress bar (Step 4 variant).

### `ParquetUploadZone`

Props: `onFilePicked`, `uploadedFileName`, `isUploading`, `errorText`.  
Implements drag-drop using `desktop_drop` and file pick via `file_picker`.  
Validates `.parquet` extension. Shows file chip on selection.

### `HyperparameterTable`

Props: `parameters` (List), `selectedParameters` (Set), `onToggle`, `onSelectAll`.  
Renders table with checkbox, name, default value columns.

---

## 27. API Integration Sequence (Complete Wizard Flow)

```
User taps [Train]
  → Open TrainingWizardDialog
  → Dispatch StartWizard
  → Render Step 1

Step 1: User selects .parquet file + taps [Next]
  → Validate extension
  → POST /api/v1/training/upload (multipart)
  → On success: store sessionId, check profile_exists, advance to Step 2
  → On error: show inline error, remain on Step 1

Step 2: User selects features + taps [Next]
  → Validate at least 1 selected
  → POST /api/v1/training/{sessionId}/features
  → On success: advance to Step 3
  → On error: show error toast, remain on Step 2

Step 3: User selects use case + taps [Next]
  → Validate selection
  → POST /api/v1/training/{sessionId}/usecase
  → On success: advance to Step 4
  → On error: show error toast, remain on Step 3

Step 4: User fills config + selects hyperparams + taps [Train Model]
  → Validate all fields
  → POST /api/v1/training/{sessionId}/train
  → On success: close dialog, dispatch RefreshProfiles to DashboardBloc
  → On error: show error snackbar, remain on Step 4
```

---

## 28. Code Generation Expectations for Antigravity

1. Generate **all files** listed in the folder structure. No placeholder stubs — every file must be fully implemented.
2. Every screen must have its own BLoC with complete event/state coverage.
3. Every API call must be wrapped: service → repository → bloc. No direct API calls from UI.
4. Wizard steps must be individual widgets in `steps/` subfolder, composed inside `training_wizard_screen.dart` via `IndexedStack` or `PageView.builder` (no animation needed between steps).
5. All models must implement `fromJson`, `toJson`, `copyWith`, and `Equatable` props.
6. Route parameter passing (profileId, profileName to Leaderboard) must use `go_router` `extra` or query parameters — not global state.
7. The `AppSidebar` must be a single shared widget with a `selectedRoute` parameter for active state.
8. Flavor configs must differentiate `apiBaseUrl` between development and production.
9. Inject `DashboardBloc` at router level so profile refresh after wizard close works correctly.
10. `main.dart` must initialize DI, configure flavors, run the app with `MultiBlocProvider` at root, and apply the centralized `AppTheme`.

---

## 29. main.dart Initialization Order

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies(Environment.dev); // injectable setup
  await AppPreferences.init();                  // SharedPreferences
  await AppDatabase.init();                     // Hive
  runApp(const AnexeeApp());
}
```

---

## 30. Final Notes

- Do not implement authentication screens. The app assumes a valid token is stored in preferences and injected by `AuthInterceptor`.
- Do not add a Leaderboard item to the sidebar under any condition.
- The wizard modal must not be dismissible by tapping outside it (`barrierDismissible: false`).
- All numeric metric values on the leaderboard must be formatted to exactly 3 decimal places using `NumberFormat('0.000')`.
- The "Filter" button on the Leaderboard is UI-only (no API call needed — prepare the handler but leave logic as a TODO).
- Icons: use `material_symbols_icons` or `lucide_icons` package for sidebar and action icons. Match icon shapes from the design exactly (grid, settings gear, brain/sync icon for Training, bar chart for Leaderboard equivalent).
- Do not use any third-party UI component libraries (e.g. FlutterFlow components). Build everything from Flutter primitives and the packages listed in Section 24.
