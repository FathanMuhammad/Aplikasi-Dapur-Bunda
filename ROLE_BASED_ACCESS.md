# 👥 Role-Based Access Control - Dapur Bunda Bahagia

## 🎯 Overview
Aplikasi ini memiliki 2 jenis user dengan akses yang berbeda:

### 👤 **USER** (Pelanggan)
- **Akses**: Hanya bisa melihat menu, memesan, dan melakukan pembayaran
- **Fitur yang tersedia**:
  - ✅ Melihat menu makanan dan minuman
  - ✅ Menambah item ke keranjang
  - ✅ Membuat pesanan baru
  - ✅ Memilih metode pembayaran
  - ✅ Melihat total dengan pajak

### 👨‍💼 **ADMIN** (Pengelola Restoran)
- **Akses**: Full access ke semua fitur manajemen
- **Fitur yang tersedia**:
  - ✅ Semua fitur USER +
  - ✅ Mengelola produk (CRUD)
  - ✅ Mengelola stok
  - ✅ Melihat dan mengelola semua pesanan
  - ✅ Update status pesanan
  - ✅ Melihat laporan penjualan
  - ✅ Analytics dan dashboard

## 🔐 Login Credentials

### Test Mode (Untuk Development)
Di halaman login, tersedia tombol test mode:

#### 🔴 **Test Admin**
- **Email**: admin@test.com
- **Password**: test123
- **Akses**: Full admin dashboard

#### 🔵 **Test User** 
- **Email**: user@test.com
- **Password**: test123
- **Akses**: User interface (menu & order)

### Manual Login
Anda juga bisa login manual dengan:
- Email: admin@test.com / user@test.com
- Password: test123

## 📱 User Interface Differences

### 🔵 USER Interface
```
┌─────────────────────────────────────┐
│ Selamat Datang, User Test    🛒 📤  │
├─────────────────────────────────────┤
│                                     │
│  🍽️ Nasi Gudeg     🥗 Gado-gado    │
│     Rp 25,000         Rp 15,000     │
│     [Tambah]          [Tambah]      │
│                                     │
│  🥤 Es Teh Manis   🍽️ Soto Ayam    │
│     Rp 5,000          Rp 20,000     │
│     [Tambah]          [Tambah]      │
│                                     │
└─────────────────────────────────────┘
         [Checkout (Rp XX,XXX)]
```

**Fitur User:**
- Grid view menu dengan harga
- Tombol "Tambah" untuk setiap item
- Keranjang belanja (icon 🛒)
- Tombol checkout dengan total
- Logout button

### 🔴 ADMIN Interface
```
┌─────────────────────────────────────┐
│ Dapur Bunda Bahagia                 │
├─────────────────────────────────────┤
│ [Produk] [Pesanan] [Laporan]        │
├─────────────────────────────────────┤
│                                     │
│  📊 Dashboard Cards:                │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐│
│  │Produk   │ │Pesanan  │ │Laporan  ││
│  │Baru     │ │Baru     │ │         ││
│  └─────────┘ └─────────┘ └─────────┘│
│                                     │
│  📋 Management Features:            │
│  • CRUD Produk                      │
│  • Kelola Stok                      │
│  • Update Status Pesanan            │
│  • Generate Laporan                 │
│                                     │
└─────────────────────────────────────┘
```

**Fitur Admin:**
- Bottom navigation (Produk, Pesanan, Laporan)
- Dashboard dengan quick access cards
- Full CRUD operations
- Order management
- Sales reporting

## 🚀 How to Test

### 1. Test sebagai USER
```bash
1. Buka aplikasi
2. Klik tombol "Test User" (biru)
3. Akan masuk ke user interface
4. Coba tambah item ke keranjang
5. Lakukan checkout
```

### 2. Test sebagai ADMIN
```bash
1. Buka aplikasi
2. Klik tombol "Test Admin" (merah)
3. Akan masuk ke admin dashboard
4. Coba kelola produk di tab "Produk"
5. Lihat pesanan di tab "Pesanan"
6. Check laporan di tab "Laporan"
```

## 🔄 Switching Between Roles

### Logout dan Login Ulang
1. Klik tombol logout (📤) di pojok kanan atas
2. Pilih role yang berbeda di halaman login
3. Test fitur yang berbeda

### Quick Switch (Development)
- Gunakan tombol test mode untuk switch cepat
- Tidak perlu input email/password

## 📋 Feature Comparison

| Fitur | USER | ADMIN |
|-------|------|-------|
| Lihat Menu | ✅ | ✅ |
| Tambah ke Keranjang | ✅ | ✅ |
| Buat Pesanan | ✅ | ✅ |
| Pilih Pembayaran | ✅ | ✅ |
| Kelola Produk | ❌ | ✅ |
| Kelola Stok | ❌ | ✅ |
| Lihat Semua Pesanan | ❌ | ✅ |
| Update Status Pesanan | ❌ | ✅ |
| Cetak Struk | ❌ | ✅ |
| Lihat Laporan | ❌ | ✅ |
| Analytics Dashboard | ❌ | ✅ |

## 🛡️ Security Implementation

### Permission-Based Access
```dart
// User permissions
UserRole.user.permissions = [
  'view_menu',
  'create_order', 
  'make_payment'
];

// Admin permissions  
UserRole.admin.permissions = [
  'manage_products',
  'manage_orders',
  'manage_users',
  'view_reports',
  'manage_settings',
  'view_dashboard'
];
```

### Route Protection
- User otomatis diarahkan ke interface yang sesuai
- Admin → HomeScreen (full dashboard)
- User → UserHomeScreen (menu only)

### Data Access Control
- User hanya bisa buat pesanan untuk dirinya
- Admin bisa lihat dan kelola semua data
- Firestore rules mengatur akses database

## 🎨 UI/UX Differences

### USER Experience
- **Simple & Clean**: Focus pada menu dan ordering
- **Mobile-First**: Optimized untuk customer experience
- **Quick Actions**: Tambah ke keranjang, checkout cepat
- **Visual Appeal**: Grid layout dengan gambar produk

### ADMIN Experience  
- **Comprehensive**: Full management capabilities
- **Data-Rich**: Tables, charts, analytics
- **Workflow-Oriented**: Multi-step processes
- **Professional**: Business-focused interface

## 🔧 Development Notes

### Adding New Roles
Untuk menambah role baru:
1. Update `UserRole` enum di `lib/models/user.dart`
2. Tambah permissions di `UserRoleExtension`
3. Buat screen baru jika diperlukan
4. Update routing logic di `login_screen.dart`

### Customizing Permissions
Edit permissions di `UserRoleExtension`:
```dart
List<String> get permissions {
  switch (this) {
    case UserRole.admin:
      return ['manage_products', 'view_reports', ...];
    case UserRole.user:
      return ['view_menu', 'create_order', ...];
  }
}
```

## 📞 Support

Jika ada masalah dengan role-based access:
1. Pastikan user sudah login dengan role yang benar
2. Check permissions di console log
3. Verify Firebase user data
4. Test dengan tombol test mode

---

**Happy Testing! 🚀**
