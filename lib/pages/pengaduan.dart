import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../style/colors.dart';
import '../style/text_style.dart';
import '../widget/bottom_navbar.dart';

class PengaduanPage extends StatefulWidget {
  final String kategori;
  const PengaduanPage({super.key, required this.kategori});

  @override
  State<PengaduanPage> createState() => _PengaduanPageState();
}

class _PengaduanPageState extends State<PengaduanPage> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.background),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.kategori.toUpperCase(),
          style: AppTextStyles.headline1,
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        centerTitle: true,
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Nama Lengkap', 'Harus dengan nama lengkap'),
              _buildTextField('NIK', 'Harus sesuai dengan KTP'),
              _buildTextField('No Handphone', 'Nomor harus akti!'),
              _buildTextField('Alamat', 'Alamat tempat tinggal sekarang'),
              _buildTextField(
                'Keluhan',
                'Isi sesuai dengan keluhan anda',
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              Text(
                'Bukti :',
                style: AppTextStyles.bodyText.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary),
                    color: AppColors.secondary.withOpacity(0.15),
                  ),
                  child: _image == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.camera_alt,
                              color: AppColors.primary,
                              size: 40,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tambahkan Foto',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Laporan berhasil dikirim!'),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Kirim Laporan',
                    style: AppTextStyles.buttonText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: AppTextStyles.caption,
          hintStyle: AppTextStyles.caption,
          filled: true,
          fillColor: AppColors.secondary.withOpacity(0.1),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
        validator: (value) => value!.isEmpty ? 'Bagian ini wajib diisi' : null,
      ),
    );
  }
}
