# dapurbunda

## Getting Started

![Login Dapur Bunda](gambar(1).jpg)


# Dapur Bunda Bahagia - Sistem Manajemen Restoran

Aplikasi Android untuk mengelola operasional restoran "Dapur Bunda Bahagia" yang dibuat menggunakan Flutter dan Firebase.

## Fitur Utama

### 1. Manajemen Produk
- Tambah, edit, dan hapus produk
- Kategorisasi produk (Makanan Utama, Appetizer, Minuman)
- Manajemen stok produk
- Status ketersediaan produk

### 2. Sistem Pemesanan
- Buat pesanan baru dengan mudah
- Pilih produk dan jumlah
- Input informasi pelanggan
- Pilih metode pembayaran (Tunai, Debit, Kredit)
- Tambah catatan khusus

### 3. Manajemen Pesanan
- Lihat semua pesanan
- Filter berdasarkan status pesanan
- Update status pesanan (Pending → Confirmed → Preparing → Ready → Completed)
- Batalkan pesanan
- Cetak struk pembayaran

### 4. Laporan Penjualan
- Dashboard ringkasan penjualan (harian, mingguan, bulanan)
- Generate laporan detail berdasarkan periode
- Analisis produk terlaris
- Performa kategori produk
- Grafik penjualan

### 5. Sistem Pembayaran
- Dukungan pembayaran tunai dan non-tunai
- Perhitungan pajak otomatis (10%)
- Status pembayaran tracking

## Teknologi yang Digunakan

- **Flutter**: Framework untuk pengembangan aplikasi mobile
- **Firebase**: Backend as a Service
  - Firestore: Database NoSQL
  - Firebase Auth: Autentikasi pengguna
  - Firebase Storage: Penyimpanan file
- **Provider**: State management
- **Intl**: Formatting mata uang dan tanggal

## Struktur Database (Firestore)

### Collection: products
```json
{
  "id": "string",
  "name": "string",
  "description": "string",
  "price": "number",
  "category": "string", // makananUtama, appetizer, minuman
  "stock": "number",
  "imageUrl": "string",
  "isAvailable": "boolean",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Collection: orders
```json
{
  "id": "string",
  "customerName": "string",
  "customerPhone": "string",
  "items": [
    {
      "productId": "string",
      "productName": "string",
      "productPrice": "number",
      "quantity": "number",
      "subtotal": "number",
      "notes": "string"
    }
  ],
  "subtotal": "number",
  "tax": "number",
  "total": "number",
  "status": "string", // pending, confirmed, preparing, ready, completed, cancelled
  "paymentMethod": "string", // cash, debit, credit
  "paymentStatus": "string", // pending, paid, failed, refunded
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "notes": "string"
}
```

### Collection: reports
```json
{
  "id": "string",
  "startDate": "timestamp",
  "endDate": "timestamp",
  "period": "string", // daily, weekly, monthly, yearly, custom
  "totalOrders": "number",
  "totalRevenue": "number",
  "totalTax": "number",
  "productSales": "map", // productId -> quantity
  "categoryRevenue": "map", // category -> revenue
  "paymentMethodCount": "map", // method -> count
  "dailySales": "array",
  "generatedAt": "timestamp"
}
```

## Instalasi dan Setup

### Prerequisites
- Flutter SDK (versi 3.9.2 atau lebih baru)
- Android Studio atau VS Code
- Firebase project

### Langkah Instalasi

1. **Clone repository**
   ```bash
   git clone <repository-url>
   cd dapurbunda
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Setup Firebase**
   - Buat project baru di [Firebase Console](https://console.firebase.google.com)
   - Aktifkan Firestore Database
   - Aktifkan Authentication (Email/Password)
   - Download `google-services.json` dan letakkan di `android/app/`
   - Jalankan `flutterfire configure` untuk setup otomatis

4. **Jalankan aplikasi**
   ```bash
   flutter run
   ```

## Cara Penggunaan

### Login
- Gunakan tombol "Skip Login (Demo Mode)" untuk masuk tanpa autentikasi
- Atau buat akun melalui Firebase Console untuk login dengan email/password

### Dashboard
- Lihat ringkasan operasional restoran
- Akses cepat ke semua fitur utama

### Kelola Produk
1. Buka tab "Produk"
2. Klik tombol "+" untuk menambah produk baru
3. Isi informasi produk (nama, deskripsi, harga, stok, kategori)
4. Klik "Simpan"

### Buat Pesanan
1. Buka tab "Pesanan"
2. Klik tombol "+" untuk pesanan baru
3. Isi informasi pelanggan
4. Pilih produk dan jumlah
5. Pilih metode pembayaran
6. Klik "Simpan Pesanan"

### Kelola Pesanan
1. Lihat daftar pesanan di tab "Pesanan"
2. Klik pesanan untuk melihat detail
3. Gunakan menu untuk update status atau cetak struk

### Lihat Laporan
1. Buka tab "Laporan"
2. Lihat ringkasan penjualan
3. Generate laporan detail dengan memilih periode
4. Analisis performa produk dan kategori

## Kontribusi

Untuk berkontribusi pada project ini:

1. Fork repository
2. Buat branch fitur baru (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

## License

Project ini menggunakan MIT License. Lihat file `LICENSE` untuk detail lengkap.
=======
# Aplikasi-Dapur-Bunda
>>>>>>> cea13887d757fae77380500a674377a89f3ea69b
