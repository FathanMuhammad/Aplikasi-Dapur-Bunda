# Panduan Penggunaan Aplikasi Dapur Bunda Bahagia

## Daftar Isi
1. [Login dan Akses](#login-dan-akses)
2. [Dashboard](#dashboard)
3. [Manajemen Produk](#manajemen-produk)
4. [Sistem Pemesanan](#sistem-pemesanan)
5. [Manajemen Pesanan](#manajemen-pesanan)
6. [Laporan Penjualan](#laporan-penjualan)
7. [Tips dan Trik](#tips-dan-trik)

## Login dan Akses

### Cara Login
1. Buka aplikasi Dapur Bunda Bahagia
2. Masukkan email dan password (jika sudah ada akun)
3. Atau klik "Skip Login (Demo Mode)" untuk mencoba aplikasi

### Demo Mode
- Tidak memerlukan autentikasi
- Semua fitur dapat diakses
- Data akan tersimpan di Firebase
- Cocok untuk testing dan demo

## Dashboard

Dashboard adalah halaman utama yang menampilkan:

### Menu Utama
- **Produk**: Kelola menu makanan dan minuman
- **Pesanan Baru**: Buat pesanan untuk pelanggan
- **Riwayat Pesanan**: Lihat dan kelola pesanan yang ada
- **Laporan**: Analisis penjualan dan performa

### Navigasi
- Gunakan bottom navigation bar untuk berpindah antar tab
- Klik card di dashboard untuk akses cepat ke fitur

## Manajemen Produk

### Melihat Daftar Produk
1. Buka tab "Produk"
2. Lihat semua produk yang tersedia
3. Gunakan filter kategori untuk menyaring produk

### Menambah Produk Baru
1. Klik tombol "+" di pojok kanan atas
2. Isi informasi produk:
   - **Nama Produk**: Nama menu (contoh: "Nasi Gudeg")
   - **Deskripsi**: Penjelasan singkat menu
   - **Harga**: Harga dalam Rupiah
   - **Stok**: Jumlah porsi tersedia
   - **Kategori**: Pilih dari Makanan Utama, Appetizer, atau Minuman
3. Klik "Simpan"

### Mengedit Produk
1. Klik produk yang ingin diedit
2. Ubah informasi yang diperlukan
3. Klik "Simpan" untuk menyimpan perubahan

### Menghapus Produk
1. Klik produk yang ingin dihapus
2. Klik tombol "Hapus" (warna merah)
3. Konfirmasi penghapusan

### Tips Manajemen Produk
- Pastikan stok selalu update
- Gunakan deskripsi yang menarik
- Kategorisasi produk dengan benar
- Harga harus realistis dan kompetitif

## Sistem Pemesanan

### Membuat Pesanan Baru
1. Buka tab "Pesanan" atau klik "Pesanan Baru" di dashboard
2. Klik tombol "+" untuk pesanan baru

### Mengisi Informasi Pelanggan
1. **Nama Pelanggan**: Wajib diisi
2. **No. Telepon**: Opsional tapi disarankan
3. **Metode Pembayaran**: Pilih Tunai, Kartu Debit, atau Kartu Kredit

### Memilih Produk
1. Scroll daftar produk yang tersedia
2. Klik tombol "+" untuk menambah quantity
3. Klik tombol "-" untuk mengurangi quantity
4. Produk yang habis akan ditandai "Habis"

### Menyelesaikan Pesanan
1. Review ringkasan pesanan
2. Tambahkan catatan jika diperlukan
3. Pastikan total sudah benar (termasuk pajak 10%)
4. Klik "Simpan Pesanan"

### Perhitungan Otomatis
- Subtotal dihitung otomatis
- Pajak 10% ditambahkan otomatis
- Total final ditampilkan dengan jelas

## Manajemen Pesanan

### Melihat Daftar Pesanan
1. Buka tab "Pesanan"
2. Lihat semua pesanan dengan status terbaru di atas
3. Gunakan filter status untuk menyaring pesanan

### Status Pesanan
- **Menunggu**: Pesanan baru, belum dikonfirmasi
- **Dikonfirmasi**: Pesanan sudah dikonfirmasi, siap diproses
- **Sedang Diproses**: Pesanan sedang disiapkan di dapur
- **Siap**: Pesanan sudah siap, menunggu diambil
- **Selesai**: Pesanan sudah diselesaikan
- **Dibatalkan**: Pesanan dibatalkan

### Mengupdate Status Pesanan
1. Klik pesanan yang ingin diupdate
2. Klik menu titik tiga (⋮) di pojok kanan
3. Pilih aksi yang sesuai:
   - **Konfirmasi**: Untuk pesanan "Menunggu"
   - **Mulai Proses**: Untuk pesanan "Dikonfirmasi"
   - **Siap**: Untuk pesanan "Sedang Diproses"
   - **Selesai**: Untuk pesanan "Siap"
   - **Batalkan**: Untuk membatalkan pesanan

### Melihat Detail Pesanan
1. Klik pesanan untuk expand detail
2. Lihat informasi lengkap:
   - Detail item dan quantity
   - Informasi pelanggan
   - Total pembayaran
   - Status pembayaran
   - Catatan khusus

### Mencetak Struk
1. Klik menu pada pesanan
2. Pilih "Cetak Struk"
3. Dialog struk akan muncul
4. Klik "Cetak" atau "Bagikan"

## Laporan Penjualan

### Dashboard Laporan
Menampilkan ringkasan:
- **Penjualan Hari Ini**: Revenue dan jumlah pesanan
- **Penjualan Minggu Ini**: Akumulasi mingguan
- **Penjualan Bulan Ini**: Akumulasi bulanan
- **Rata-rata Harian**: Estimasi berdasarkan data bulanan

### Generate Laporan Detail
1. Pilih periode laporan:
   - **Harian**: Laporan untuk hari tertentu
   - **Mingguan**: Laporan untuk minggu ini
   - **Bulanan**: Laporan untuk bulan ini
   - **Tahunan**: Laporan untuk tahun ini
   - **Kustom**: Pilih tanggal mulai dan akhir sendiri

2. Atur tanggal jika diperlukan
3. Klik "Generate Laporan"

### Analisis Produk Terlaris
- Lihat 5 produk dengan penjualan tertinggi
- Data berdasarkan quantity terjual
- Berguna untuk planning menu

### Performa Kategori
- Analisis revenue per kategori produk
- Persentase kontribusi setiap kategori
- Visualisasi dengan progress bar

### Tips Analisis Laporan
- Review laporan harian untuk monitoring
- Gunakan laporan mingguan untuk evaluasi
- Laporan bulanan untuk planning strategis
- Perhatikan tren produk terlaris
- Analisis performa kategori untuk optimasi menu

## Tips dan Trik

### Operasional Harian
1. **Pagi Hari**:
   - Cek stok semua produk
   - Update ketersediaan menu
   - Review pesanan yang pending

2. **Siang Hari**:
   - Monitor pesanan masuk
   - Update status pesanan secara real-time
   - Pastikan stok tidak habis

3. **Sore Hari**:
   - Review penjualan hari ini
   - Siapkan laporan harian
   - Update stok untuk hari berikutnya

### Manajemen Stok
- Set reminder untuk produk dengan stok rendah
- Update stok setelah restock
- Nonaktifkan produk yang habis

### Customer Service
- Selalu isi nama pelanggan dengan benar
- Catat nomor telepon untuk follow-up
- Gunakan catatan untuk permintaan khusus
- Konfirmasi pesanan dengan cepat

### Optimasi Penjualan
- Analisis produk terlaris untuk promosi
- Perhatikan jam sibuk dari laporan
- Sesuaikan stok dengan demand
- Monitor feedback pelanggan

### Backup Data
- Data otomatis tersimpan di Firebase
- Lakukan export laporan secara berkala
- Simpan backup lokal untuk data penting

### Troubleshooting
- **Aplikasi lambat**: Cek koneksi internet
- **Data tidak sync**: Restart aplikasi
- **Error saat save**: Cek koneksi Firebase
- **Stok tidak update**: Refresh halaman produk

## Dukungan

Jika mengalami masalah:
1. Cek panduan troubleshooting di atas
2. Restart aplikasi
3. Cek koneksi internet
4. Hubungi tim support jika masalah berlanjut

---

**Selamat menggunakan Aplikasi Dapur Bunda Bahagia!**
Semoga aplikasi ini membantu meningkatkan efisiensi operasional restoran Anda.
