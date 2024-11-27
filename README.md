# Perbandingan State Management di Flutter: Ephemeral vs App State Management
  Ketika membuat aplikasi Flutter, ada dua cara utama untuk mengelola state:
  
**1. Ephemeral State Management**, biasanya menggunakan StatefulWidget.

**2. App State Management**, yang sering menggunakan library seperti Scoped Model atau lainnya.

  Keduanya punya kelebihan dan kekurangan, tergantung kebutuhan aplikasi. Berikut pembahasannya:

# Ephemeral State Management
*Apa itu?*

  Ephemeral State adalah state lokal yang hanya digunakan di satu widget tertentu. Contohnya ketika kita menggunakan `StatefulWidget` dan memperbarui UI dengan `setState()`.

*Kapan digunakan?*
1. Cocok untuk data yang hanya diperlukan sementara di dalam satu widget.
   Misalnya: animasi kecil, validasi form, atau state yang sederhana.
   
   Keuntungan:
   1. Mudah dipahami dan diterapkan untuk aplikasi kecil atau fitur spesifik.
   2. Tidak membutuhkan library tambahan.
   
   Kelemahan:
   1. Kurang fleksibel untuk aplikasi besar yang membutuhkan pembagian state antar banyak widget.
   2. Ketika aplikasi menjadi kompleks, kode jadi susah dirawat karena logika bisnis bercampur dengan logika UI.
      
- Contoh (Kode Anda):
```dart
class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Counter Value: $_counter'),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _counter++;
            });
          },
          child: Text('Increment'),
        ),
      ],
    );
  }
}


```
> __Masalahnya__:
>  Kalau ada banyak widget lain yang butuh akses ke nilai `_counter`, kita harus terus-menerus melewatkan state ini melalui constructor atau parameter (disebut prop drilling). Ini bikin kode tidak efisien.


# App State Management
*Apa itu?*
App State adalah state yang digunakan secara global di seluruh aplikasi. Biasanya diimplementasikan dengan bantuan library seperti Scoped Model, Provider, atau lainnya.

*Kapan digunakan?*
- Cocok untuk aplikasi yang membutuhkan data yang dibagikan ke banyak widget.
  Misalnya: autentikasi pengguna, keranjang belanja, pengaturan aplikasi seperti tema atau bahasa.

- Keuntungan:
  1. Memisahkan logika bisnis dari UI, membuat kode lebih terstruktur.
  2. Mudah diakses dari mana saja tanpa harus melewatkan state melalui constructor.
  3. Cocok untuk aplikasi besar.
     
- Kelemahan:
  1. Setup lebih kompleks dibandingkan dengan StatefulWidget.
  2. Kurang efisien jika hanya digunakan untuk kebutuhan lokal atau sederhana.
     
Contoh (Kode Anda):
```dart
Copy code
class CounterModel extends Model {
  int _counter = 0;

  int get counter => _counter;

  void increment() {
    _counter++;
    notifyListeners();
  }
}
```
Kemudian di widget:

```dart
class CounterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CounterModel>(
      builder: (context, child, model) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Counter Value: ${model.counter}'),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                model.increment();
              },
              child: Text('Increment'),
            ),
            ElevatedButton(
              onPressed: () {
                model.decrement();
              },
              child: Text('Decrement'),
            ),
          ],
        ),
      ),
    );
  }
}
```
> __Keunggulannya:__
> State seperti counter bisa diakses langsung oleh widget lain tanpa harus repot-repot melewatkan melalui parameter. Misalnya, bisa digunakan di widget keranjang belanja atau status login pengguna.


# Studi Kasus
Berikut perbandingan penggunaan Ephemeral State dan App State untuk kebutuhan aplikasi besar:

### a. Autentikasi Pengguna
  - Ephemeral State: Status login harus di-pass ke seluruh widget, menyulitkan manajemen state global.
  - App State: Model autentikasi dapat digunakan untuk menyimpan token login yang tersedia di semua widget.
### b. Keranjang Belanja
  - Ephemeral State: Sulit untuk membagikan daftar item keranjang ke beberapa widget.
  - App State: `Scoped Model` (atau alternatif seperti Provider) memungkinkan daftar item dibagikan dan diperbarui secara global.
### c. Pengaturan Aplikasi
  - Ephemeral State: Tidak ideal untuk kebutuhan pengaturan seperti tema atau bahasa.
  -  App State: Mudah diimplementasikan menggunakan model global.

# Perbandingan Langsung
|Aspek	|Ephemeral State Management	|App State Management|
|-------|---------------------------|--------------------|
|Lingkup State	|Lokal (di satu widget)	|Global (dibagikan ke banyak widget)|
|Pengelolaan Data	|Sederhana, cukup untuk data sementara	| Cocok untuk data global yang kompleks|
|Kompleksitas Kode	|Mudah untuk aplikasi kecil	|Terstruktur, ideal untuk aplikasi besar|
|Pemeliharaan Kode	|Sulit di-maintain jika aplikasi jadi kompleks	|Lebih mudah dikelola karena modular|
|Library Tambahan	|Tidak perlu	|Perlu (contoh: Scoped Model, Provider)|

# Kesimpulan
|Kriteria	|Ephemeral State Management	|App State Management|
|---------|---------------------------|--------------------|
|Aplikasi Kecil	|✔ Ideal untuk aplikasi sederhana |	✘ Terlalu berat|
Aplikasi Besar	|✘ Sulit di-maintain dan tidak efisien	|✔ Skalabel, cocok untuk aplikasi kompleks|
State Lokal	|✔ Mudah digunakan	|✘ Overkill|
State Global	|✘ Tidak mendukung	|✔ Sangat cocok|

## Rekomendasi

Gunakan Ephemeral State Management jika:

- Aplikasi kecil.
  State hanya diperlukan di widget tertentu dan bersifat sementara.

Gunakan App State Management jika:

- Aplikasi besar.
- Perlu berbagi data global seperti autentikasi pengguna, keranjang belanja, atau pengaturan aplikasi.
