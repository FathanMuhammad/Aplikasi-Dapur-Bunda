# 🔥 Firebase Setup Guide - Dapur Bunda Bahagia

## 🚨 PENTING: Panduan Lengkap Koneksi Firebase

### Prerequisites
- Flutter SDK installed
- Android Studio atau VS Code
- Google account
- Koneksi internet stabil

## 📋 Step 1: Create Firebase Project
1. Buka [Firebase Console](https://console.firebase.google.com)
2. Klik "Create a project" atau "Tambah project"
3. Masukkan nama project: `dapur-bunda-bahagia` atau nama lain
4. **PENTING**: Catat Project ID yang dibuat otomatis
5. Enable Google Analytics (opsional)
6. Klik "Create project"
7. Tunggu hingga project selesai dibuat

## 📱 Step 2: Add Android App
1. Di Firebase console, klik ikon Android atau "Add app"
2. **PENTING**: Masukkan package name: `com.example.dapurbunda`
   - Harus sama persis dengan yang ada di `android/app/build.gradle`
3. Masukkan app nickname: `Dapur Bunda Bahagia`
4. SHA-1 certificate (opsional untuk development)
5. Klik "Register app"

## 📄 Step 3: Download Configuration File
1. Download file `google-services.json`
2. **SANGAT PENTING**: Letakkan file ini di folder `android/app/`
   - Path lengkap: `android/app/google-services.json`
   - Jangan letakkan di folder lain!
3. Pastikan file tidak corrupt dan bisa dibuka

## ⚙️ Step 4: Configure Android Build Files

### 4.1 Edit `android/build.gradle` (Project level)
```gradle
buildscript {
    ext.kotlin_version = '1.7.10'
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:7.3.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        // TAMBAHKAN BARIS INI:
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

### 4.2 Edit `android/app/build.gradle` (App level)
Tambahkan di bagian atas file (setelah apply plugin):
```gradle
apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'
apply plugin: 'dev.flutter.flutter-gradle-plugin'
// TAMBAHKAN BARIS INI:
apply plugin: 'com.google.gms.google-services'
```

Tambahkan di dependencies:
```gradle
dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
    // TAMBAHKAN BARIS INI:
    implementation 'com.google.firebase:firebase-analytics'
    implementation 'com.google.firebase:firebase-firestore'
    implementation 'com.google.firebase:firebase-auth'
}
```

## 🔐 Step 5: Enable Firebase Services

### 5.1 Firestore Database
1. Di Firebase console, pilih "Firestore Database"
2. Klik "Create database"
3. **Pilih "Start in test mode"** (untuk development)
4. Pilih location: **asia-southeast1** (Singapore - terdekat dengan Indonesia)
5. Klik "Done"

### 5.2 Authentication
1. Di Firebase console, pilih "Authentication"
2. Klik "Get started"
3. Pilih tab "Sign-in method"
4. Enable **Email/Password** provider
5. Klik "Save"

## 🛡️ Step 6: Configure Firestore Security Rules

**UNTUK DEVELOPMENT** (rules permissive):
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

## 🧪 Step 7: Test Connection

### 7.1 Jalankan Aplikasi
```bash
flutter clean
flutter pub get
flutter run
```

### 7.2 Check Console Output
Cari pesan seperti:
```
Firebase initialized successfully
Default users already exist (atau user creation messages)
```

### 7.3 Test Login
1. Buka aplikasi
2. Klik tombol "Test Admin" atau "Test User"
3. Jika berhasil, akan masuk ke dashboard

## 🚨 Troubleshooting - Solusi Masalah Umum

### Error: "Default FirebaseApp is not initialized"
**Solusi:**
1. Pastikan `google-services.json` ada di `android/app/`
2. Pastikan package name sama persis
3. Restart aplikasi dengan `flutter clean && flutter pub get`

### Error: "No matching client found for package name"
**Solusi:**
1. Cek package name di `android/app/build.gradle`:
   ```gradle
   defaultConfig {
       applicationId "com.example.dapurbunda"  // Harus sama dengan Firebase
   }
   ```
2. Re-download `google-services.json` jika perlu

### Error: "FirebaseException: PERMISSION_DENIED"
**Solusi:**
1. Cek Firestore rules - pastikan dalam test mode
2. Pastikan Authentication sudah enable
3. Cek koneksi internet

### Error: "PlatformException: sign_in_failed"
**Solusi:**
1. Pastikan Email/Password provider sudah enable
2. Cek apakah user test sudah dibuat
3. Restart aplikasi

### Error: "MissingPluginException"
**Solusi:**
```bash
flutter clean
flutter pub get
cd android && ./gradlew clean && cd ..
flutter run
```

## 📊 Step 8: Verify Data in Firebase Console

### 8.1 Check Users Collection
1. Buka Firestore Database
2. Lihat collection `users`
3. Harus ada 2 dokumen: admin@test.com dan user@test.com

### 8.2 Check Products Collection
1. Lihat collection `products`
2. Harus ada sample products (Nasi Gudeg, Soto Ayam, dll)

### 8.3 Test Create Order
1. Login sebagai user
2. Buat pesanan
3. Cek collection `orders` di Firestore

## 🎯 Quick Test Commands

```bash
# Clean dan rebuild
flutter clean && flutter pub get && flutter run

# Check Firebase connection
flutter run --verbose

# Build APK untuk testing
flutter build apk --debug
```

---

**INGAT**: Untuk production, selalu gunakan security rules yang ketat!

### 9. Test Koneksi
1. Jalankan aplikasi dengan `flutter run`
2. Jika berhasil, Anda akan melihat data sample di aplikasi
3. Coba buat pesanan baru untuk memastikan database berfungsi

## Troubleshooting

### Error: google-services.json not found
- Pastikan file `google-services.json` ada di folder `android/app/`
- Restart aplikasi setelah menambahkan file

### Error: Firebase not initialized
- Pastikan `firebase_core` sudah diinisialisasi di `main.dart`
- Cek apakah `DefaultFirebaseOptions.currentPlatform` sudah benar

### Error: Permission denied
- Cek Firestore security rules
- Untuk development, gunakan rules yang mengizinkan semua akses

### Error: Network issues
- Pastikan device/emulator terhubung internet
- Cek apakah Firebase project sudah aktif

## Monitoring dan Analytics

### Setup Crashlytics (Opsional)
1. Tambahkan `firebase_crashlytics` di pubspec.yaml
2. Ikuti setup guide di dokumentasi Firebase

### Setup Analytics (Opsional)  
1. Tambahkan `firebase_analytics` di pubspec.yaml
2. Ikuti setup guide di dokumentasi Firebase

## Backup dan Restore

### Export Data
Gunakan Firebase CLI untuk export data:
```bash
firebase firestore:export gs://your-bucket-name/exports/
```

### Import Data
```bash
firebase firestore:import gs://your-bucket-name/exports/
```

## Catatan Penting

1. **Keamanan**: Jangan commit file `google-services.json` ke repository public
2. **Environment**: Gunakan project Firebase terpisah untuk development dan production
3. **Billing**: Monitor usage Firebase untuk menghindari biaya tak terduga
4. **Backup**: Lakukan backup data secara berkala
5. **Updates**: Update Firebase SDK secara berkala untuk keamanan

## Support

Jika mengalami masalah:
1. Cek [Firebase Documentation](https://firebase.google.com/docs)
2. Cek [FlutterFire Documentation](https://firebase.flutter.dev/)
3. Buka issue di repository ini
