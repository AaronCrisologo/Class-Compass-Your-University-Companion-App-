# Class Compass: Your University Companion App

## 👥 Team Members

* Crisologo, Aaron Angelo
* Bacsa, Angel Mae
* Barcelona, Nielle
* Ramos, Mark Kevin

## 📱 Project Overview

Class Compass is a comprehensive mobile application designed to streamline and enhance the student experience by consolidating critical academic information and updates into a single, user-friendly interface. Built using the Flutter framework for the frontend and Node.js with MySQL for the backend, Class Compass provides students with real-time notifications about class cancellations, school holidays, emergency announcements, and other vital information that could affect their academic schedule.

The application features a robust login system that detects the student's department, ensuring that each user receives tailored updates relevant to their specific academic environment. In addition to providing timely alerts, Class Compass also aggregates essential information such as the school's academic calendar and national holidays, enabling students to stay organized and informed. Furthermore, the app empowers students to create and manage their own class schedules, with the ability to mark and track cancellations as they occur.

## ✨ Features

- **User Authentication**: Secure login and registration system with department-based personalization
- **Real-time Notifications**: Instant alerts for class cancellations, emergency announcements, and important updates
- **Academic Calendar**: View school holidays, important dates, and academic events
- **Announcements System**: Post and view department-specific announcements (with admin capabilities)
- **Schedule Manager**: Create, modify, and track personal class schedules with cancellation tracking
- **Resource Hub**: Access to valuable academic resources and emergency contact information
- **Profile Management**: View and update user profile information
- **Bottom Navigation**: Intuitive navigation between Home, Calendar, Announcements, and Schedule sections

## 🛠️ Technologies Used

### Frontend
- **Flutter Framework**: Cross-platform UI toolkit for building native-like mobile applications
- **Dart Programming Language**: Optimized for building fast, expressive Flutter applications
- **Font Awesome Icons**: Enhanced iconography for improved visual communication

### Backend
- **Node.js**: JavaScript runtime for building scalable server-side applications
- **Express.js**: Web application framework for Node.js (implied by standard Node.js backend structure)
- **MySQL**: Relational database management system for storing user data, schedules, and announcements
- **MySQL Workbench**: Visual tool for database design, administration, and maintenance

### Development Tools
- **Visual Studio Code**: Primary IDE with Flutter and Dart extensions
- **Android Studio**: Android emulator and device testing environment
- **Git & GitHub**: Version control and collaborative development platform

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (version 2.0.0 or higher)
- Node.js (version 14.0.0 or higher)
- MySQL Server (version 8.0 or higher)
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/AaronCrisologo/Class-Compass-Your-University-Companion-App-.git
   cd Class-Compass-Your-University-Companion-App-
   ```

2. **Setup Backend**
   ```bash
   cd calendar-backend
   npm install
   # Create .env file based on the example below
   cp .env.example .env   # If example exists, otherwise create manually
   # Edit .env with your MySQL credentials
   npm start
   ```

3. **Setup Frontend**
   ```bash
   cd ..
   flutter pub get
   flutter run
   ```

### Environment Variables (.env)
Create a `.env` file in the `calendar-backend` directory with:
```
MYSQL_HOST="localhost"
MYSQL_USER="root"
MYSQL_PASSWORD="your_password"
MYSQL_DATABASE="class_compass"
```

## 📁 Project Structure

```
Class-Compass-Your-University-Companion-App-
├── android/                   # Android-specific project files
├── assets/                    # Static assets (images, icons)
├── calendar-backend/          # Node.js backend server
│   ├── .env                   # Environment variables
│   ├── package.json           # Node.js dependencies
│   └── server.js              # Main server entry point (inferred)
├── lib/                       # Flutter/Dart source code
│   ├── main.dart              # Application entry point
│   ├── home_screen.dart       # Home screen implementation
│   ├── calendar_screen.dart   # Calendar screen implementation
│   ├── announcements_screen.dart # Announcements screen
│   ├── schedule_screen.dart   # Schedule management screen
│   ├── login_screen.dart      # Authentication screens
│   ├── registration_screen.dart
│   ├── profile_screen.dart    # User profile screen
│   └── resources.dart         # Shared resources and constants
├── Database/                  # MySQL database schema files
│   ├── *.sql                  # Database table creation scripts
└── README.md                  # This file
```

## 🌱 Climate Action Commitment

The Class Compass project aligns with Sustainable Development Goal 4 (Quality Education), which aims to ensure inclusive and equitable quality education and promote lifelong learning opportunities for all. By providing students with a centralized platform for accessing critical academic information and resources, Class Compass supports Goal 4 by:

- **Increasing Access to Information**: By aggregating academic calendars, event information, and emergency contacts in one accessible app, Class Compass enhances students' access to essential educational resources, promoting informed decision-making and improving overall educational outcomes.
- **Enhancing Educational Quality**: By facilitating effective communication between students and academic institutions, Class Compass helps streamline administrative processes and reduce disruptions in students' learning experiences. This contributes to a more efficient and effective educational environment.
- **Promoting Digital Innovation**: Class Compass leverages digital technology to innovate how educational information is accessed and managed, promoting sustainable practices and enhancing the efficiency of educational services.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing cross-platform framework
- Node.js and MySQL communities for robust backend technologies
- All contributors and team members for their dedication and hard work