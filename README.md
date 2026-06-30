# 🌟 DaySūtra

<p align="center">
  <img src="assets/logo.png" alt="DaySūtra Logo" width="160" height="160" />
</p>

<p align="center">
  <strong>Mastercard-inspired, high-aesthetic productivity app designed to keep your daily focus in orbit.</strong>
</p>

---

## 📖 Overview

**DaySūtra** (deriving from the Sanskrit *Sūtra*, meaning "thread" or "guideline") is an offline-first daily checklist and goal-tracking application built with **Flutter**, **Riverpod**, and **Hive**. 

Designed with an editorial-magazine aesthetic inspired by Mastercard’s modern design language, DaySūtra is not your typical sterile productivity tool. It blends premium visuals with lighthearted, sarcastic accountability to nudge you to finish your daily tasks and keep your life goals front and center.

---

## ✨ Key Features

### 🎨 Mastercard-Inspired Design System
Following the principles in our [DESIGN.md](file:///d:/daysutra/DESIGN.md):
* **Canvas Cream (`#F3F0EE`)**: All editorial surfaces sit on a warm putty-toned canvas that replaces harsh, generic whites.
* **Stadium & Pill Corners**: Cards, nav bars, and buttons feature extreme border radii (20px, 40px, or 999px) for a soft, premium touch.
* **Connective Orbits**: Decorative curved lines in Light Signal Orange (`#F37338`) trace paths between circular portrait elements, symbolizing task and goal trajectories.
* **Oversized Circular Crop**: Key imagery is automatically masked into perfect circles, accented with floating white satellite CTA buttons.

### 🎯 Life Goals & Motivation
* **Core Life Goals**: Set a central, long-term ambition with an optional inspiration image that crops into a custom circular frame.
* **Morning Motivation (8:00 AM)**: Wake up to a scheduled reminder referencing your current life goal to set a purposeful tone for the day.

### 📝 Smart Checklist & Folders
* **Daily Tasks**: Clean task checklists that automatically reset or carry forward via a background `DailyRefreshManager`.
* **Foldered Organization**: Categorize tasks and notes into high-level directories to keep projects separated.
* **Rich Notes**: Integrated scratchpads to store quick thoughts, links, and detailed task steps.

### 💬 Sarcastic Accountability (Humorous Reminders)
* **Evening Reality Check (9:00 PM)**: If you have pending tasks, DaySūtra fires off a random, humorous sarcastic notification (e.g., *"Another day, another set of incomplete goals. Consistency is key, I guess?"*) to keep you accountable.
* **Clean Sweep Celebration**: Complete all of your tasks for the day and get rewarded with a confetti-laced congratulations notification.

### 📱 Real-time Home Screen Widgets
Fully integrated with the Android and iOS `home_widget` plugin, enabling:
* **Inspiration & Goal Widgets**: Keeps your life goal visible directly on your home screen.
* **Folder & To-Do List Widgets**: See pending tasks at a glance, automatically synchronized in real-time as tasks are updated.

---

## 🛠️ Technology Stack & Packages

* **State Management**: [Riverpod (flutter_riverpod)](https://pub.dev/packages/flutter_riverpod) — Reactive and testable state architecture.
* **Local Database**: [Hive & Hive Flutter](https://pub.dev/packages/hive) — Fast, lightweight, offline-first NoSQL database.
* **Animations**: [Flutter Animate](https://pub.dev/packages/flutter_animate) & [Animations](https://pub.dev/packages/animations) — Smooth, fluid micro-interactions.
* **Typography**: [Google Fonts](https://pub.dev/packages/google_fonts) — Loaded with Sofia Sans / Sofia Sans Cond (our geometric fallback typeface).
* **Notifications**: [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications) & [Timezone](https://pub.dev/packages/timezone) — Highly robust daily cron notifications.
* **UI Elements**: [Glassmorphism](https://pub.dev/packages/glassmorphism), [Lucide Icons Flutter](https://pub.dev/packages/lucide_icons_flutter), and [Phosphor Flutter](https://pub.dev/packages/phosphor_flutter).
* **Home Widgets**: [Home Widget Plugin (home_widget)](https://pub.dev/packages/home_widget) — Native home widget communications.

---

## 📁 Project Architecture

DaySūtra follows clean code principles, separating core services, domain logic, data models, and features:

```text
lib/
├── core/
│   ├── constants/        # Global colors, spacing, and styling tokens
│   ├── navigation/       # Screen transition details
│   ├── router/           # App routes and page setup
│   ├── services/         # HomeWidgetManager and background sync
│   ├── settings/         # Theme toggles and preferences
│   ├── theme/            # AppTheme (Light & Dark Mastercard styles)
│   └── utils/            # NotificationService, DailyRefreshManager, DateUtils
├── data/
│   ├── repositories/     # HiveRepository & local data layers
│   └── providers.dart    # Riverpod data streams (goals, tasks, folders, etc.)
├── domain/
│   └── models/           # Hive models: Folder, LifeGoal, Note, TodoTask
├── features/
│   ├── folders/          # Folder views, management, and creation
│   ├── goals/            # LifeGoal editor and detail view
│   ├── home/             # Primary home screen & asymmetric layouts
│   ├── notes/            # Notebook editor and note listing
│   ├── search/           # Global task, folder, and note search
│   ├── settings/         # ThemeMode and notification options
│   ├── splash/           # Launch splash and premium onboarding flow
│   └── todo/             # Task listing, checklist actions, and statistics
└── main.dart             # Application initialization entry point
```

---

## 🚀 Getting Started

### Prerequisites
* Flutter SDK (Version `>= 3.11.5`)
* Dart SDK

### Installation & Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/daysutra.git
   cd daysutra
   ```

2. **Retrieve dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate Hive database adapters:**
   DaySūtra utilizes `hive_generator` to compile data schemas. Run the code builder:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the application:**
   ```bash
   flutter run
   ```

---

## 📐 Design Token Cheat-Sheet

If you are developing new screens or components, strictly adhere to these constants:

| Token Category | Value / Hex Code | Role |
|---|---|---|
| **Canvas Background** | `#F3F0EE` (Canvas Cream) | Muted putty background canvas (default) |
| **Primary Text / CTA** | `#141413` (Ink Black) | Text headers, buttons, dark footer |
| **Accent Orbit Lines**| `#F37338` (Light Signal Orange) | Decorative orbital arcs |
| **Legal / Consent** | `#CF4500` (Signal Orange) | Save, settings actions, warning cues |
| **Elevated Surface** | `#FCFBFA` (Lifted Cream) | Card backgrounds |
| **Radius - Small** | `20px` | CTA buttons |
| **Radius - Medium** | `40px` | Hero frames, page containers |
| **Radius - Large** | `999px` | Navigation pills, stadium shapes |

---

## 🔔 How Notifications Work

The `NotificationService` handles scheduled alarms:
1. **Morning Motivation (ID `2`)**: Schedules at `8:00 AM` local time. If a Life Goal is present, it displays the goal description. If none exists, it displays *"Empty Ambitions? You haven't even set a life goal yet."*
2. **Evening Sarcastic Accountability (ID `1`)**: Schedules at `9:00 PM` local time. Fired only if there are active, uncompleted tasks. If all tasks are completed, the notification cancels itself.
3. **Congrats Notification (ID `3`)**: Fired immediately when all daily tasks are completed, displaying a cheerful success message.
