# 🌿 WasteWise
**WasteWise** adalah aplikasi Flutter berbasis *GetX* yang bertujuan membantu pengguna untuk melaporkan lokasi sampah, menemukan tempat sampah terdekat, dan mendapatkan edukasi lingkungan secara praktis.

---

## 🧱 Tech Stack
| Komponen | Teknologi yang Digunakan |
|-----------|---------------------------|
| Framework | [Flutter](https://flutter.dev/) (Dart SDK ^3.7.2) |
| State Management | [GetX](https://pub.dev/packages/get) |
| Architecture | MVC (Modules, Controllers, Views) |
| Design System | Material 3 + Custom Green Theme |
| Font | Roboto (local assets, offline-safe) |

---

## ⚙️ Struktur Folder
```
lib/
└── app/
    ├── modules/
    │   ├── home/
    │   │   ├── controllers/
    │   │   ├── views/
    │   ├── login/
    │   │   ├── controllers/
    │   │   ├── views/
    │   ├── register/
    │   │   ├── controllers/
    │   │   ├── views/
    ├── routes/
    │   ├── app_pages.dart
    │   ├── app_routes.dart
    └── theme/
        ├── app_colors.dart
        ├── app_theme.dart
main.dart
```

---

## 🚀 Cara Menjalankan Project

### 1️⃣ Clone Repository
```bash
git clone https://github.com/<username>/wastewise.git
cd wastewise
```

### 2️⃣ Install Dependencies
Pastikan kamu udah install Flutter SDK versi `3.7.2` atau lebih tinggi.
```bash
flutter pub get
```

### 3️⃣ Jalankan di Emulator / Web
Untuk menjalankan di Chrome:
```bash
flutter run -d chrome
```

Atau di Android Emulator:
```bash
flutter run -d emulator-5554
```

---

## 🧩 Setup Font Lokal (Roboto)
Font Roboto disimpan di folder lokal agar tidak fetch dari Google Fonts (menghindari CORS di web).

Struktur:
```
assets/fonts/roboto/
├── Roboto-Regular.ttf
├── Roboto-Medium.ttf
├── Roboto-Bold.ttf
```

Pastikan `pubspec.yaml` sudah memiliki konfigurasi ini:
```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/fonts/roboto/
  fonts:
    - family: Roboto
      fonts:
        - asset: assets/fonts/roboto/Roboto-Regular.ttf
        - asset: assets/fonts/roboto/Roboto-Medium.ttf
        - asset: assets/fonts/roboto/Roboto-Bold.ttf
```

---

## 🧠 Arsitektur GetX (Pattern)
- **Controller:** menangani logic & state (misal `LoginController`, `HomeController`)
- **View:** UI yang reaktif terhadap perubahan state dari controller
- **Binding:** menghubungkan controller dengan view (auto-inject GetX)

Contoh route:
```dart
GetPage(
  name: _Paths.LOGIN,
  page: () => const LoginView(),
  binding: LoginBinding(),
),
```

---

## 🧭 Navigasi
| Dari | Ke | Aksi | Metode |
|------|----|------|---------|
| Login | Register | Ganti halaman | `Get.offNamed(Routes.REGISTER)` |
| Register | Login | Ganti halaman | `Get.offNamed(Routes.LOGIN)` |
| Login/Register | Home | Hapus semua halaman sebelumnya | `Get.offAllNamed(Routes.HOME)` |

---

## 🧰 Fitur Saat Ini
✅ Login dummy (langsung redirect ke Home)  
✅ Register dummy  
✅ Bottom Navigation 5 tab  
✅ Reusable color & theme system  
✅ Font offline (Roboto)  
✅ Fix bug “TextEditingController disposed” via `fenix: true` bindings  
✅ Ready untuk integrasi Supabase

---

## 🧪 Rencana Integrasi Supabase
Nanti akan ditambahkan:
- **Auth:** Email & password Supabase
- **Storage:** Upload foto laporan sampah
- **Database:** Menyimpan data laporan, leaderboard, dan lokasi tempat sampah

---

## 👥 Kontributor
| Nama | Peran |
|-------|--------|
| Athila Ramdani Saputra | Developer & UI Designer |
| (Tambah anggota lain jika ada) | |

---

## 🪶 Lisensi
MIT License © 2025 — **WasteWise Project**  
Feel free to fork and contribute 🌍💚

---

## 💡 Tips Dev
- Gunakan `flutter clean` sebelum build ulang tema/font
- Jangan hot reload pas ubah route/controller → **Hot Restart**
- Untuk debugging GetX: aktifkan log lewat `Get.config(enableLog: true)`

---

> “Small steps toward cleaner Earth.” 🌎✨


---

# ⚙️ Pengembangan Menggunakan Get CLI

Proyek **WasteWise** dibuat dengan bantuan **Get CLI**, alat resmi dari GetX untuk mempercepat proses pengembangan module, controller, view, dan binding.

## ⚡️ Instalasi Get CLI

Pastikan kamu sudah punya **Dart SDK** & **Flutter**.

```bash
dart pub global activate get_cli
```

Tambahkan Get CLI ke PATH agar bisa dijalankan dari mana saja.

- **Windows (PowerShell):**
  ```bash
  setx PATH "%PATH%;%USERPROFILE%\AppData\Local\Pub\Cache\bin"
  ```
- **Mac / Linux (bash/zsh):**
  ```bash
  export PATH="$PATH":"$HOME/.pub-cache/bin"
  ```

Cek apakah Get CLI sudah aktif:
```bash
get --version
```

---

## 🏗️ Membuat Proyek Baru
Buat proyek Flutter baru dengan Get CLI:
```bash
get create project wastewise
```

Lalu pilih:
```
1) Flutter Project
Domain: com.telkomuniversity.wastewise
iOS Language: Swift
Android Language: Kotlin
Use Linter: Yes
```

---

## 🧩 Membuat Module Baru
Perintah untuk membuat module:
```bash
get create page:<nama_module>
```

Contoh untuk WasteWise:
```bash
get create page:home
get create page:login
get create page:register
```

CLI akan otomatis membuat struktur folder berikut:
```
lib/app/modules/<nama_module>/
  ├── bindings/
  ├── controllers/
  └── views/
```

---

## 🔄 Generate File Terpisah

| Perintah | Fungsi |
|-----------|--------|
| `get create controller:<nama>` | Membuat controller baru |
| `get create view:<nama>` | Membuat view baru |
| `get create binding:<nama>` | Membuat binding baru |
| `get create model:<nama>` | Membuat model data |
| `get create provider:<nama>` | Membuat provider untuk API |

Contoh:
```bash
get create controller:auth
get create model:user
```

---

## 🧭 Routing Otomatis
Get CLI akan otomatis memperbarui `app_pages.dart` dan `app_routes.dart` setiap kali module baru dibuat.

Contoh hasil otomatis:
```dart
GetPage(
  name: _Paths.LOGIN,
  page: () => const LoginView(),
  binding: LoginBinding(),
),
```

> ⚠️ Jangan import `app_routes.dart` langsung di controller. Gunakan `app_pages.dart` agar tidak muncul error “part-of directive”.

---

## 🧠 Tips Penting
- Gunakan `fenix: true` di bindings agar controller bisa hidup kembali setelah di-dispose.
- Hindari `Get.put()` manual di dalam view kalau sudah pakai binding.
- Gunakan `Get.offNamed()` untuk mengganti halaman (bukan menumpuk).
- Jalankan `flutter clean` setelah banyak perubahan di struktur CLI.

---

## 🧾 Workflow CLI (Contoh)
1️⃣ Buat module baru:  
```bash
get create page:profile
```

2️⃣ Edit file yang dihasilkan di `controllers/profile_controller.dart` dan `views/profile_view.dart`.

3️⃣ Jalankan aplikasi:  
```bash
flutter run
```

---

📚 Dokumentasi resmi: [Get CLI on pub.dev](https://pub.dev/packages/get_cli)

> “Code smarter, not harder — Get CLI saves hours of setup.” ⚙️
