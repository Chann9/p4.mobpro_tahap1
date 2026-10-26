# Tahap 1 - Persiapan Sqflite

## Yang diubah
- Menambahkan dependensi `sqflite` untuk mengakses SQLite dari Flutter.
- Menambahkan dependensi `path` untuk membantu membentuk lokasi file database secara lintas platform.
- Dependensi lama `shared_preferences` dan `hive_flutter` tetap dipertahankan agar fitur Notes App dan Contact App tidak rusak.

## Langkah di komputer
1. Ekstrak folder proyek ini.
2. Buka folder `p4.mobpro` di VS Code atau Android Studio.
3. Pastikan terminal berada di folder yang berisi `pubspec.yaml`.
4. Jalankan `flutter pub get`.
5. Jika selesai tanpa error, jalankan `flutter analyze`.

## Catatan
Tahap ini baru menyiapkan dependensi. Database SQLite, halaman CRUD, dan ObjectBox belum ditambahkan pada tahap ini.
