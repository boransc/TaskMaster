# 📱 TaskMaster

**TaskMaster** is a cross-platform Flutter app that helps users stay productive and build better habits through task tracking, gamification, and motivational tools like productivity timers and visual progress dashboards.

---

## 🚀 Features

- ✅ **Task Management** — Add, view, complete, and delete tasks with priorities, deadlines, reminders, and recurrence.
- 📅 **Calendar Integration** — Visualize your task schedule and filter by day.
- 🎮 **Gamified Progress (Task Garden)** — Earn coins by completing tasks and build a virtual garden.
- ⏱ **Productivity Mode** — Launch focus sessions and get rewarded for your time.
- 📊 **Statistics Dashboard** — Monitor your streaks, completion rates, and task priorities.
- 🎨 **Custom Themes** — Choose from light/dark/high-contrast and color-themed modes.
- 🔐 **Secure Auth with Firebase** — Register, log in, and personalize your experience.
- 🛎️ **Reminder Notifications** — Get reminded before task deadlines using local notifications.

---

## 🛠 Tech Stack

| Area                | Tech Used                             |
|---------------------|----------------------------------------|
| Frontend            | Flutter (Dart)                        |
| Local Storage       | Hive                                  |
| Authentication      | Firebase Auth                         |
| Notifications       | flutter_local_notifications + timezone |
| Environment Config  | flutter_dotenv                        |
| Task Scheduling     | Custom logic with reminders & recurrence |
| UI Calendar         | table_calendar                        |

---

## 📦 Installation

1. **Clone the repository**

```bash
git clone https://github.com/boransc/TaskMaster.git
cd TaskMaster
```

2. **Create a `.env` file**

Create `assets/.env` and add your Firebase config:

```env
ANDROID_API_KEY=...
ANDROID_APP_ID=...
IOS_API_KEY=...
WEB_API_KEY=...
# etc...
```

3. **Register the `.env` in `pubspec.yaml`**

```yaml
flutter:
  assets:
    - assets/.env
```

4. **Install dependencies**

```bash
flutter pub get
```

5. **Run the app**

```bash
flutter run
```

---

## 🔐 Security

- API keys and other secrets are managed using `.env` files and `flutter_dotenv`.
- `.env` is ignored using `.gitignore` to prevent accidental exposure.
- Firebase rules and Cloud Console restrictions are used to lock API key access.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

## ✨ Author

Built with 💙 by [@boransc](https://github.com/boransc)
