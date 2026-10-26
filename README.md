# My Book – Aplikasi Eksplorasi Buku

## 1. Nama Aplikasi
**My Book**

## 2. Deskripsi Aplikasi
My Book adalah aplikasi mobile berbasis Flutter yang digunakan untuk mencari, menjelajahi, dan melihat informasi buku. Aplikasi ini memanfaatkan Open Library API untuk mengambil data buku secara online dan menampilkannya dalam antarmuka yang sederhana dan mudah digunakan.

Aplikasi ini dikembangkan sebagai bagian dari tugas UTS mata kuliah Mobile Programming.

## 3. Fitur Utama
- Menampilkan daftar buku dari Open Library API.
- Menampilkan informasi dan detail buku.
- Menampilkan sampul buku.
- Mengelompokkan atau menelusuri buku berdasarkan kategori.
- Mengambil data buku secara online melalui API.
- Menampilkan status loading saat data sedang dimuat.
- Menangani kesalahan ketika data gagal dimuat.

*Catatan: Sesuaikan daftar fitur dengan fitur yang benar-benar tersedia pada aplikasi.*

## 4. Teknologi dan Package yang Digunakan
- **Flutter** — framework untuk membangun aplikasi mobile.
- **Dart** — bahasa pemrograman yang digunakan.
- **Open Library API** — sumber data informasi buku.
- **http** — package untuk melakukan permintaan HTTP ke API.
- **Material Design** — komponen antarmuka pengguna Flutter.

## 5. Persyaratan
Sebelum menjalankan aplikasi, pastikan perangkat telah memiliki:
- Flutter SDK.
- Dart SDK (biasanya sudah termasuk dalam Flutter SDK).
- Android Studio atau Visual Studio Code.
- Android Emulator atau perangkat Android.
- Koneksi internet.

## 6. Langkah Menjalankan Aplikasi

### A. Clone Repository
Jalankan perintah berikut di terminal:

```bash
git clone https://github.com/jalaluddinmuhammad2108-tech/UTS-Mobile-Programming-BookApp.git
```

### B. Masuk ke Folder Project

```bash
cd UTS-Mobile-Programming-BookApp
```

### C. Instalasi Dependency

```bash
flutter pub get
```

### D. Periksa Konfigurasi Flutter

```bash
flutter doctor
```

Pastikan kebutuhan pengembangan Android telah terpenuhi.

### E. Jalankan Aplikasi

Hubungkan perangkat Android atau jalankan emulator, kemudian ketik:

```bash
flutter run
```

## 7. Sumber API
Data buku diperoleh dari Open Library:

https://openlibrary.org/

Dokumentasi API:

https://openlibrary.org/developers/api

## 8. Repository
GitHub: https://github.com/jalaluddinmuhammad2108-tech/UTS-Mobile-Programming-BookApp

## 9. Tujuan Pengembangan
Aplikasi ini dibuat untuk menerapkan konsep pengembangan aplikasi mobile menggunakan Flutter, pengambilan data dari API, pengolahan data JSON, serta penyajian informasi buku melalui antarmuka pengguna.
