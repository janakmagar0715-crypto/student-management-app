# EduTrack — Student Management App
### Assignment 1 | Mobile Application Development

---

## Project Overview

**EduTrack** is a fully-featured Flutter mobile application for managing student records. Built for Android, it demonstrates comprehensive use of Flutter's widget ecosystem, state management, form handling, navigation, local data persistence, and polished UI design.

The app goes beyond the basic requirements by implementing:
- Persistent local storage (data survives app restarts)
- Real-time search and department filtering
- Edit student records (not just add/delete)
- Department statistics dashboard
- Hero animations for smooth transitions
- Sample data pre-loaded on first run

---

## Features Implemented

### Required Features
| Feature | Status | Details |
|---|---|---|
| Splash Screen | ✅ | Animated logo, progress bar, gradient background |
| App Logo | ✅ | Custom school icon with branded design |
| AppBar | ✅ | Present on all screens with contextual actions |
| Drawer Menu | ✅ | Home, Add Student, Statistics, About, Exit |
| Student List | ✅ | ListView.builder with profile image, name, ID, dept |
| Add Student Form | ✅ | 6 fields + notes, all with validation |
| Form Validation | ✅ | Email regex, phone digits, required fields, duplicate ID check |
| Submit & Reset | ✅ | With loading state and confirmation dialogs |
| View Details | ✅ | Full detail screen with all fields |
| Delete Student | ✅ | With confirmation dialog |
| Navigation/Routing | ✅ | Named routes + push/pop between 5 screens |
| Popup Menu (AppBar) | ✅ | Sort Students, Clear Student List, About App |
| Confirmation Dialogs | ✅ | Before delete and clear all |
| About Screen | ✅ | Student info, app description, feature list |
| Local Images (3+) | ✅ | Configured in assets/images/ |

### Extra Features (Bonus)
| Feature | Details |
|---|---|
| **Local Persistence** | All data saved via SharedPreferences, survives restarts |
| **Real-time Search** | Search by name, ID, email, or department instantly |
| **Department Filter** | Filter chip in AppBar + bottom sheet picker |
| **Multi-sort Options** | 6 sort modes: name A-Z, name Z-A, ID, department, newest, oldest |
| **Edit Student** | Full edit support, navigated from detail screen |
| **Statistics Dialog** | Dept breakdown with progress bars, accessible from drawer |
| **Hero Animations** | Profile image animates between list and detail screen |
| **Duplicate ID Check** | Form prevents adding two students with same ID |
| **Sample Data** | 5 sample students pre-loaded on first launch |
| **Notes Field** | Optional notes per student shown in detail view |
| **Department Color Coding** | Each department has a unique color across all screens |
| **Stats Bar** | Total / Departments / Showing counts at top of home |

---

## Screens

1. **Splash Screen** — Animated logo + progress bar → navigates to Home
2. **Home Screen** — Student list with search, filter, sort, drawer, FAB, popup menu
3. **Add Student Screen** — Full form with validation; reused for Edit mode
4. **Student Detail Screen** — SliverAppBar with profile photo hero, all fields, edit/delete
5. **About Screen** — Developer info, app features, tech stack

---

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   └── student.dart             # Student data model
├── providers/
│   └── student_provider.dart    # State management (Provider pattern)
├── screens/
│   ├── splash_screen.dart       # Animated splash
│   ├── home_screen.dart         # Main screen with list
│   ├── add_student_screen.dart  # Add/Edit student form
│   ├── student_detail_screen.dart # Full student view
│   └── about_screen.dart        # About the app
├── widgets/
│   ├── student_card.dart        # Reusable student list card
│   └── stats_card.dart          # Stats bar widget
└── utils/
    └── app_theme.dart           # Theme, colors, constants
```

---

## How to Run

```bash
# Install dependencies
flutter pub get

# Run on connected device/emulator
flutter run

# Build APK
flutter build apk --release
```

**Requirements:** Flutter SDK ≥ 3.0.0, Dart ≥ 3.0.0

---

## Dependencies

```yaml
provider: ^6.1.1              # State management
shared_preferences: ^2.2.2    # Local data persistence
cached_network_image: ^3.3.1  # Efficient image loading
uuid: ^4.2.2                  # Unique IDs for students
```

---

## Challenges Faced

1. **State management across screens** — Solved by using the Provider pattern with `ChangeNotifier`. Any screen that modifies data automatically triggers UI updates everywhere.

2. **Form validation with real-time feedback** — Flutter's `FormField` validators only trigger on submit by default. Implemented `onChanged` listeners for the URL field to show live preview while also keeping full validation on submit.

3. **Data persistence** — `SharedPreferences` only stores primitives. Solved by serializing the Student list to JSON using `jsonEncode`/`jsonDecode` with custom `toMap()`/`fromMap()` methods on the model.

4. **Hero animation constraints** — Hero widgets require the same tag across routes and cannot be inside a `ListView` that rebuilds aggressively. Solved by using stable `student.id`-based tags.

5. **Duplicate ID prevention** — Needed to check existing records during form validation, which requires accessing the Provider from within a validator function (which doesn't receive context). Solved by reading the provider in the surrounding `State` class and passing it in.

---

## What I Learned

- The **Provider pattern** for clean state management in Flutter
- How to build **complex forms** with multiple validation rules including regex
- Using `SharedPreferences` for **local data persistence**
- Implementing **Hero animations** for seamless screen transitions
- Building **custom SliverAppBar** layouts for rich detail screens
- **CachedNetworkImage** for efficient profile picture loading with fallbacks
- Using `CustomScrollView` + `SliverList` for flexible scrolling layouts
- Flutter's `PopupMenuButton` and `ModalBottomSheet` for contextual UI

---

## Future Enhancements

1. **Cloud sync** using Firebase Firestore for multi-device access
2. **Authentication** — Teacher/Admin login with role-based access
3. **Photo upload** using `image_picker` to capture or select photos from the device gallery
4. **Export to PDF/Excel** — Generate class reports
5. **Attendance tracking** — Mark and track student attendance per session
6. **Grade management** — Add subject-wise grades and compute GPA
7. **Push notifications** — Reminders and announcements
8. **Dark mode** — Theme toggle persisted in preferences
9. **Bulk import** — Import students from CSV file
10. **QR code** — Generate a QR code per student for quick ID scanning

---

*Assignment 1 | Course: Mobile Application Development | Semester: Spring 2025*
