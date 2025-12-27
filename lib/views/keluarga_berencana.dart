import 'package:flutter/material.dart';

class KbFormPage extends StatefulWidget {
  const KbFormPage({super.key});

  @override
  State<KbFormPage> createState() => _KbFormPageState();
}

class _KbFormPageState extends State<KbFormPage> {
  // 1. GlobalKey untuk Form
  final _formKey = GlobalKey<FormState>();

  // State Management
  String? _layananTerpilih;
  DateTime _tanggalTerpilih = DateTime.now();

  // Controller untuk menyimpan nilai input
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _hpController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  // Fungsi untuk menampilkan Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalTerpilih,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          // Kustomisasi warna Date Picker agar sesuai tema hijau
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF388E3C), // Warna header
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF388E3C),
            ), // Warna tombol
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _tanggalTerpilih) {
      setState(() {
        _tanggalTerpilih = picked;
      });
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _hpController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  // Fungsi saat tombol "Daftar" ditekan
  void _submitForm() {
    // 2. Validasi Form
    if (_formKey.currentState!.validate()) {
      // Validasi tambahan untuk Radio Button
      if (_layananTerpilih == null) {
        // Tampilkan pesan error untuk radio button/layanan
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mohon pilih Jenis Layanan KB.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        // Jika semua valid, lanjutkan proses:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Formulir berhasil divalidasi dan dikirim!'),
            backgroundColor: Colors.green,
          ),
        );
        // Logika pengiriman data ke server atau navigasi
        print('Nama: ${_namaController.text}');
        print('Layanan: $_layananTerpilih');
        print('Tanggal: $_tanggalTerpilih');
      }
    } else {
      // Tampilkan pesan jika ada error di TextFormField
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon isi semua kolom yang diperlukan.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Styling dasar yang digunakan berulang
    const Color inputFillColor = Color(0xFFE8F5E9); // Hijau muda
    const Color iconColor = Color(0xFF388E3C); // Hijau gelap
    const Color errorColor = Colors.red; // Merah untuk border error

    // Fungsi untuk membuat TextField yang telah di-style
    Widget buildStyledTextField({
      required String label,
      required String hint,
      required TextEditingController controller,
      // 3. Tambahkan fungsi validator
      String? Function(String?)? validator,
    }) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller,
              // 4. Implementasikan validator
              validator: validator,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: inputFillColor,
                // Gaya default/enable border (tanpa border)
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                // Gaya **Error Border**
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: errorColor, width: 2.0),
                ),
                // Gaya Focused Error Border
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: errorColor, width: 2.0),
                ),
                // Gaya Focused Border (opsional, bisa sama dengan error/default)
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: iconColor, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 20.0,
                ),
              ),
            ),
          ],
        ),
      );
    }

    String formattedDate =
        '${_tanggalTerpilih.day}/${_tanggalTerpilih.month}/${_tanggalTerpilih.year}';

    return Scaffold(
      // 1. AppBar
      appBar: AppBar(
        title: const Text(
          'Keluarga Berencana',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF66BB6A), // Warna hijau AppBar
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      // 2. Body Formulir dibungkus dengan Form widget
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, // Pasang GlobalKey di sini
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // --- Bidang Input Teks dengan Controller & Validator ---
              buildStyledTextField(
                label: 'Nama Lengkap :',
                hint: 'harus dengan nama lengkap',
                controller: _namaController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Lengkap harus diisi.';
                  }
                  return null;
                },
              ),
              buildStyledTextField(
                label: 'NIK :',
                hint: 'harus sesuai dengan KTP',
                controller: _nikController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'NIK harus diisi.';
                  }
                  // Tambahkan validasi NIK lain jika perlu (misal: 16 digit)
                  return null;
                },
              ),
              buildStyledTextField(
                label: 'No Handphone :',
                hint: 'nomor harus aktif',
                controller: _hpController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor Handphone harus diisi.';
                  }
                  return null;
                },
              ),
              buildStyledTextField(
                label: 'Alamat :',
                hint: 'alamat tempat tinggal sekarang',
                controller: _alamatController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat harus diisi.';
                  }
                  return null;
                },
              ),

              // --- Jenis Layanan KB (Radio Buttons) ---
              const Text(
                'Jenis Layanan KB :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              RadioListTile<String>(
                title: const Text('Konstrasepsi jangka pendek'),
                value: 'pendek',
                groupValue: _layananTerpilih,
                onChanged: (String? value) {
                  setState(() {
                    _layananTerpilih = value;
                  });
                },
                activeColor: iconColor,
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile<String>(
                title: const Text('Konstrasepsi jangka panjang'),
                value: 'panjang',
                groupValue: _layananTerpilih,
                onChanged: (String? value) {
                  setState(() {
                    _layananTerpilih = value;
                  });
                },
                activeColor: iconColor,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),

              // --- Tanggal (Date Picker) ---
              const Text(
                'Tanggal :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              // Elemen tanggal ini tidak menggunakan validator Form
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: inputFillColor,
                    borderRadius: BorderRadius.circular(30.0),
                    border: Border.all(color: Colors.transparent),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.calendar_today, color: iconColor),
                      const SizedBox(width: 10),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: iconColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Tombol Simpan
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm, // Panggil fungsi _submitForm
                  style: ElevatedButton.styleFrom(
                    backgroundColor: iconColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Daftar',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
