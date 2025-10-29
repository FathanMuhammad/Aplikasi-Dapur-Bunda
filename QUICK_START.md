# Quick Start Guide - Dapur Bunda Bahagia

## 🚀 Langkah Cepat untuk Menjalankan Aplikasi

### Prerequisites
- Flutter SDK (3.9.2+)
- Android Studio atau VS Code
- Android device atau emulator
- Firebase project (opsional untuk demo)

### 1. Clone dan Setup
```bash
# Clone repository (jika dari Git)
git clone <repository-url>
cd dapurbunda

# Atau jika sudah ada folder, masuk ke direktori
cd dapurbunda

# Install dependencies
flutter pub get
```

### 2. Setup Firebase (Opsional)
Untuk demo, Anda bisa skip langkah ini dan menggunakan "Demo Mode".

Jika ingin setup Firebase:
1. Buat project di [Firebase Console](https://console.firebase.google.com)
2. Aktifkan Firestore dan Authentication
3. Download `google-services.json`
4. Letakkan di `android/app/google-services.json`

Detail lengkap ada di `FIREBASE_SETUP.md`

### 3. Jalankan Aplikasi

#### Cara 1: Menggunakan Script (Windows)
```bash
# Double-click file run_app.bat
# Atau jalankan di command prompt:
run_app.bat
```

#### Cara 2: Manual
```bash
# Cek device yang tersedia
flutter devices

# Jalankan aplikasi
flutter run
```

### 4. Login ke Aplikasi
- **Demo Mode**: Klik "Skip Login (Demo Mode)" - Tidak perlu setup Firebase
- **Login Normal**: Masukkan email/password (perlu setup Firebase)

### 5. Mulai Menggunakan

#### Langkah Pertama
1. Buka tab "Produk"
2. Aplikasi akan otomatis membuat data sample:
   - Nasi Gudeg (Rp 25,000)
   - Soto Ayam (Rp 20,000)
   - Gado-gado (Rp 15,000)
   - Es Teh Manis (Rp 5,000)
   - Jus Jeruk (Rp 8,000)

#### Coba Fitur Utama
1. **Tambah Produk**: Klik "+" di tab Produk
2. **Buat Pesanan**: Klik "+" di tab Pesanan
3. **Lihat Laporan**: Buka tab Laporan

## 🎯 Demo Scenario

### Skenario 1: Kelola Produk
1. Buka tab "Produk"
2. Klik "+" untuk tambah produk baru
3. Isi: Nama "Ayam Bakar", Harga 30000, Kategori "Makanan Utama"
4. Simpan dan lihat produk muncul di daftar

### Skenario 2: Buat Pesanan
1. Buka tab "Pesanan", klik "+"
2. Isi nama pelanggan: "John Doe"
3. Pilih produk: Nasi Gudeg (2x), Es Teh Manis (1x)
4. Pilih pembayaran: Tunai
5. Simpan pesanan

### Skenario 3: Kelola Pesanan
1. Lihat pesanan yang baru dibuat
2. Klik pesanan untuk lihat detail
3. Klik menu (⋮) dan pilih "Konfirmasi"
4. Update status menjadi "Sedang Diproses"
5. Cetak struk dengan klik "Cetak Struk"

### Skenario 4: Lihat Laporan
1. Buka tab "Laporan"
2. Lihat ringkasan penjualan hari ini
3. Coba generate laporan mingguan
4. Lihat produk terlaris dan performa kategori

## 🔧 Build APK

### Untuk Distribusi
```bash
# Menggunakan script (Windows)
build_apk.bat

# Atau manual
flutter build apk --release
```

APK akan tersedia di: `build/app/outputs/flutter-apk/app-release.apk`

## 📱 Fitur Utama yang Bisa Dicoba

### ✅ Manajemen Produk
- Tambah/edit/hapus produk
- Kategorisasi (Makanan Utama, Appetizer, Minuman)
- Manajemen stok
- Filter berdasarkan kategori

### ✅ Sistem Pemesanan
- Input informasi pelanggan
- Pilih produk dan quantity
- Pilih metode pembayaran
- Perhitungan otomatis (subtotal + pajak 10%)

### ✅ Manajemen Pesanan
- Lihat semua pesanan
- Update status pesanan
- Filter berdasarkan status
- Cetak struk pembayaran

### ✅ Laporan Penjualan
- Dashboard ringkasan (harian/mingguan/bulanan)
- Generate laporan detail
- Analisis produk terlaris
- Performa kategori

## 🐛 Troubleshooting

### Masalah Umum

#### "Flutter not found"
- Install Flutter SDK dari [flutter.dev](https://flutter.dev)
- Tambahkan Flutter ke PATH

#### "No devices found"
- Hubungkan Android device dengan USB debugging
- Atau start Android emulator

#### "Firebase error"
- Gunakan "Demo Mode" untuk skip Firebase
- Atau setup Firebase sesuai `FIREBASE_SETUP.md`

#### "Build failed"
- Jalankan `flutter clean` dan `flutter pub get`
- Pastikan Android SDK terinstall

### Tips Performance
- Gunakan device/emulator dengan RAM minimal 4GB
- Pastikan koneksi internet stabil untuk Firebase
- Close aplikasi lain saat development

## 📚 Dokumentasi Lengkap

- `README.md` - Dokumentasi teknis lengkap
- `USER_GUIDE.md` - Panduan penggunaan detail
- `FIREBASE_SETUP.md` - Setup Firebase step-by-step
- `PROJECT_SUMMARY.md` - Ringkasan project dan fitur

## 🎉 Selamat!

Anda sekarang siap menggunakan aplikasi Dapur Bunda Bahagia!

Untuk pertanyaan atau masalah, silakan:
1. Cek dokumentasi di atas
2. Lihat troubleshooting guide
3. Buka issue di repository

---

**Happy Coding! 🚀**
