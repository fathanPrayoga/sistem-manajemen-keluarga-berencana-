import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Penting untuk membatasi input angka
import 'package:provider/provider.dart';
import '../model/kb_model.dart';
import '../viewmodels/kb_view_model.dart';

class KbFormPage extends StatefulWidget {
  const KbFormPage({super.key});

  @override
  State<KbFormPage> createState() => _KbFormPageState();
}

class _KbFormPageState extends State<KbFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _nikController = TextEditingController();
  final _hpController = TextEditingController();
  final _alamatController = TextEditingController();
  
  String? _layananTerpilih;
  DateTime _tanggalTerpilih = DateTime.now();
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final data = ModalRoute.of(context)?.settings.arguments as KbModel?;
      if (data != null) {
        _namaController.text = data.nama;
        _nikController.text = data.nik;
        _hpController.text = data.hp;
        _alamatController.text = data.alamat;
        _layananTerpilih = data.layanan;
        _tanggalTerpilih = data.tanggal;
      }
      _isInit = false;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalTerpilih,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) setState(() => _tanggalTerpilih = picked);
  }

  void _submit() async {
    if (_formKey.currentState!.validate() && _layananTerpilih != null) {
      final dataLama = ModalRoute.of(context)?.settings.arguments as KbModel?;
      final dataBaru = KbModel(
        nama: _namaController.text,
        nik: _nikController.text,
        hp: _hpController.text,
        alamat: _alamatController.text,
        layanan: _layananTerpilih!,
        tanggal: _tanggalTerpilih,
      );

      try {
        await context.read<KbViewModel>().simpanPendaftaran(
          data: dataBaru,
          isEdit: dataLama != null,
          id: dataLama?.id,
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color inputFillColor = Color(0xFFE8F5E9);
    const Color iconColor = Color(0xFF388E3C);
    final viewModel = context.watch<KbViewModel>();
    String formattedDate = "${_tanggalTerpilih.day}/${_tanggalTerpilih.month}/${_tanggalTerpilih.year}";

    return Scaffold(
      appBar: AppBar(title: const Text('Form Pendaftaran KB')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildField('Nama Lengkap :', 'Masukkan nama lengkap', _namaController),
              
              // NIK hanya angka
              _buildField(
                'NIK :', 'Sesuai KTP', _nikController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              
              // HP hanya angka
              _buildField(
                'No Handphone :', 'Nomor aktif', _hpController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              
              _buildField('Alamat :', 'Alamat sekarang', _alamatController),

              const Text('Tanggal :', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(color: inputFillColor, borderRadius: BorderRadius.circular(30)),
                  child: Row(children: [const Icon(Icons.calendar_today, color: iconColor), const SizedBox(width: 10), Text(formattedDate)]),
                ),
              ),
              const SizedBox(height: 16),

              const Text('Jenis Layanan KB :', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              RadioListTile<String>(title: const Text('Jangka Pendek'), value: 'Jangka Pendek', groupValue: _layananTerpilih, onChanged: (v) => setState(() => _layananTerpilih = v), activeColor: iconColor),
              RadioListTile<String>(title: const Text('Jangka Panjang'), value: 'Jangka Panjang', groupValue: _layananTerpilih, onChanged: (v) => setState(() => _layananTerpilih = v), activeColor: iconColor),

              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: viewModel.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(backgroundColor: iconColor, padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                  child: viewModel.isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("SIMPAN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String hint, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, List<TextInputFormatter>? inputFormatters}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType, // BARU
            inputFormatters: inputFormatters, // BARU
            validator: (v) => v!.isEmpty ? 'Tidak boleh kosong' : null,
            decoration: InputDecoration(
              hintText: hint, filled: true, fillColor: const Color(0xFFE8F5E9),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}