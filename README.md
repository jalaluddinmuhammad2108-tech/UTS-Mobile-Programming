# My Book

## Deskripsi
My Book adalah aplikasi katalog buku berbasis Flutter yang menampilkan data buku dari **Open Library API**. Pengguna dapat mencari buku, menelusuri berdasarkan kategori, dan melihat detail buku. Dibuat untuk tugas UTS Pemrograman Mobile.

## Fitur Utama
- Daftar buku dalam tampilan grid beserta sampul, judul, dan penulis
- Pencarian buku (judul, penulis, topik)
- Filter kategori (Fiksi, Fantasi, Sains, Sejarah, Romansa, Teknologi)
- Pengurutan (rating, terbaru, terlama, edisi terbanyak)
- Halaman detail: sampul, tahun terbit, jumlah halaman, edisi, subjek, dan deskripsi
- Penanganan state **loading, success, error** dengan `FutureBuilder` + tombol coba lagi
- Pull-to-refresh

## Teknologi
- Flutter & Dart
- Package `http` (permintaan HTTP)
- API: `https://openlibrary.org/search.json` dan `https://openlibrary.org/works/{id}.json`

## Struktur Folder
```
lib/
├── main.dart
├── models/book.dart
├── services/book_service.dart
├── pages/home_page.dart
├── pages/detail_page.dart
└── widgets/book_card.dart
```

## Langkah Menjalankan
1. Pastikan Flutter SDK terpasang (`flutter doctor`).
2. Clone repositori: `git clone <url-repo>` lalu `cd book_app`
3. Jika folder platform (android/ios) belum ada: `flutter create .`
4. Install dependensi: `flutter pub get`
5. Jalankan: `flutter run`
