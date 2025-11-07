# 📝 Flutter Notes App with Firebase

A simple and elegant **Notes App** built using **Flutter** and **Firebase**.  
You can **add**, **edit**, and **delete** notes — all synced with **Cloud Firestore**.

---

## 🚀 Features

- ✨ Add new notes  
- 🛠️ Edit existing notes  
- 🗑️ Delete notes  
- 🔔 Shows success messages after actions  
- 🔄 Auto redirect to Home screen after saving  
- ☁️ Firebase Firestore integration  
- 🧱 Clean code structure with MVC pattern

---

## 🧰 Tech Stack

| Technology | Description |
|-------------|-------------|
| **Flutter** | Cross-platform UI framework |
| **Firebase** | Backend service |
| **Cloud Firestore** | Stores notes data |
| **UUID** | For unique note IDs |
| **Dart** | Programming language for Flutter |

---

## ⚙️ Setup Instructions

### 1️⃣ Clone this repository
```bash
git clone https://github.com/rojinvgeo/Notes_Cloud_App.git
```

```bash
cd _notes_cloud_app
```

### 2️⃣ Install dependencies
```bash
flutter pub get
```
### 3️⃣ Setup Firebase

Create Firebase project 
Enable Authentication (Email/Password)

Then Run in terminal: 
```bash
dart pub global activate flutterfire_cli
```
**Then Run:**
```bash
flutterfire configure
```
select the project and add android 

This will:
Create a Firebase project
Add Android/iOS/web config automatically
Generate firebase_options.dart inside lib/

### 4️⃣ Run the app
```bash
flutter run
```




 
 




