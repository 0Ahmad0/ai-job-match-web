# 🤖 AI Job Matcher

[![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![GetX](https://img.shields.io/badge/State%20Management-GetX-red?style=for-the-badge)](https://pub.dev/packages/get)
[![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)](LICENSE)

> **The ultimate bridge between talent and opportunity.**  
> An intelligent recruitment platform that uses AI to parse resumes, rank candidates, and generate ATS-friendly CVs.

---

## 📱 Screenshots & Demo

| Splash & Onboarding | AI CV Analyzer | ATS CV Builder | Job Tracking |
|:---:|:---:|:---:|:---:|
| ![Splash](assets/screenshots/splash.png) | ![Analyzer](assets/screenshots/analyzer.png) | ![Builder](assets/screenshots/builder.png) | ![Tracking](assets/screenshots/track.png) |

| Employer Dashboard | Candidate Ranking | Job Details | Dark Mode |
|:---:|:---:|:---:|:---:|
| ![Dashboard](assets/screenshots/dashboard.png) | ![Ranking](assets/screenshots/candidates.png) | ![Job](assets/screenshots/job.png) | ![Dark](assets/screenshots/dark.png) |

*(Please replace the image paths above with your actual screenshots)*

---

## ✨ Key Features

### 👨‍💻 For Job Seekers
*   **🧠 AI CV Analyzer:** Upload your PDF resume and get an instant score, keyword analysis, and improvement tips.
*   **📄 ATS Resume Builder:** Create a professional, ATS-compliant resume in minutes.
    *   Supports 3 Templates (Modern, Classic, Minimalist).
    *   Auto-formatted dates and "Present" status.
    *   PDF Export.
*   **💼 Job Search:** Filter jobs by type, salary, and location.
*   **📊 Application Tracking:** Real-time timeline for your applications (Submitted -> Viewed -> Interview -> Offer/Reject).
*   **🔔 Smart Notifications:** Get notified about application updates instantly.

### 🏢 For Employers
*   **📈 Smart Dashboard:** Visual statistics for active jobs, new candidates, and interviews.
*   **🤖 AI Candidate Ranking:** Candidates are automatically sorted by matching score based on job requirements.
*   **✍️ AI Job Posting:** "Magic Button" that auto-writes job descriptions based on the job title.
*   **📂 Candidate Management:** Shortlist, Interview, or Reject candidates with a single click.

### 🌍 General Features
*   **Localization:** Full support for **Arabic (RTL)** and **English (LTR)**.
*   **Theming:** Beautiful **Dark & Light** modes.
*   **Responsive:** Fully responsive design using `flutter_screenutil`.

---

## 🛠️ Tech Stack & Architecture

This project is built using **Clean Architecture** principles to ensure scalability and testability.

*   **Framework:** Flutter (Web & Mobile).
*   **State Management:** GetX (Controllers, Bindings, Dependency Injection).
*   **Architecture:** Feature-based Clean Architecture.
*   **PDF Generation:** `pdf` package with custom layouts.
*   **Animations:** `animate_do` for smooth UI transitions.
*   **Storage:** `get_storage` for local data persistence.

### 📂 Project Structure

```bash
lib/
├── core/                  # Core configurations (Theme, Localization, Utils)
├── data/                  # Data layer (Models, Services)
├── global_widgets/        # Reusable UI components
├── modules/               # Feature modules (View, Controller, Binding)
│   ├── ai_analyzer/       # AI Analysis Logic
│   ├── cv_builder/        # Resume Generation Logic
│   ├── jobs/              # Job Listing & Details
│   ├── employer_dashboard/# Company Side
│   └── ...
└── routes/                # Navigation & App Pages
```
### 🚀 Getting Started
Follow these steps to run the project locally.

Prerequisites
Flutter SDK (3.0 or higher)
Dart SDK
Installation
Clone the repository

```Bash

git clone https://github.com/your-username/ai-job-matcher.git
```
```bash
cd ai-job-matcher
```
Install dependencies

```Bash

flutter pub get
Run the app
```
```Bash

flutter run
# For web:
flutter run -d chrome
```
### 🤝 Contributing
Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are greatly appreciated.

Fork the Project
Create your Feature Branch (git checkout -b feature/AmazingFeature)
Commit your Changes (git commit -m 'Add some AmazingFeature')
Push to the Branch (git push origin feature/AmazingFeature)
Open a Pull Request

### 📄 License
Distributed under the MIT License. See LICENSE for more information.

### 📞 Contact
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Ahmad_Hariri-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/ahmadhariri/)
[![Email](https://img.shields.io/badge/Gmail-mr.ahmed.alhariri%40gmail.com-EA4335?style=for-the-badge&logo=gmail&logoColor=white)](mailto:mr.ahmed.alhariri@gmail.com)

### 🔗 Project-Link
[![GitHub Repo](https://img.shields.io/badge/GitHub_Repo-ai--job--matcher-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/your-username/ai-job-matcher)

