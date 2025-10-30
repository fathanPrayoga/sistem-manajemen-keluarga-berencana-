import 'package:flutter/material.dart';
import 'package:app_pengaduan/style/colors.dart';
import 'package:app_pengaduan/style/text_style.dart';
import 'verification.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _selectedRole;
  bool _isLoading = false;

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda harus memilih salah satu peran.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isLoading = false);

    print('Register (Tampilan Saja) Sukses. Navigasi ke Verifikasi.');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pendaftaran (Simulasi) sukses! Navigasi ke Verifikasi.'),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            VerificationPage(emailOrPhone: _emailController.text),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              'assets/images/rumah_gadang.webp',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: AppColors.authBackgroundOverlay,
          ), // Ganti dengan AppColors

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 40.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 30),
                    const Text(
                      'SALAMAIK DATANG',
                      style: AppTextStyles.headline1,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Daftar Akun Baru',
                      style: AppTextStyles.caption,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    // Input Fields
                    _buildTextField(
                      controller: _nameController,
                      label: 'Nama Lengkap',
                      icon: Icons.person_outline,
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Nama tidak boleh kosong'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Email tidak boleh kosong'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Kata Sandi',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      validator: (value) => (value == null || value.length < 6)
                          ? 'Min. 6 karakter'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _confirmPasswordController,
                      label: 'Konfirmasi Kata Sandi',
                      icon: Icons.lock_open_outlined,
                      isPassword: true,
                      validator: (value) => (value != _passwordController.text)
                          ? 'Kata Sandi tidak cocok'
                          : null,
                    ),

                    const SizedBox(height: 30),
                    const Text(
                      'Masuk sebagai:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ), // Ganti dengan AppColors
                    const SizedBox(height: 12),

                    // Pilihan Peran
                    Row(
                      children: [
                        Expanded(
                          child: _buildRoleSelection(
                            text: 'Tukang Pijat',
                            value: 'tukang_pijat',
                            icon: Icons.accessibility_new,
                            currentGroupValue: _selectedRole,
                            onChanged: (value) =>
                                setState(() => _selectedRole = value),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildRoleSelection(
                            text: 'Mencari Pijat',
                            value: 'mencari_pijat',
                            icon: Icons.search,
                            currentGroupValue: _selectedRole,
                            onChanged: (value) =>
                                setState(() => _selectedRole = value),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.background,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Daftar',
                              style: AppTextStyles.buttonText,
                            ),
                    ),

                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sudah punya akun? ",
                          style: TextStyle(color: AppColors.textLight),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'Masuk',
                            style: AppTextStyles.bodyText.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper _buildTextField diupdate untuk menggunakan AppColors
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        suffixIcon: isPassword
            ? const Icon(Icons.remove_red_eye_outlined)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: AppColors.primary.withOpacity(0.8),
            width: 2.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
      ),
    );
  }

  // Helper _buildRoleSelection diupdate untuk menggunakan AppColors
  Widget _buildRoleSelection({
    required String text,
    required String value,
    required IconData icon,
    required String? currentGroupValue,
    required ValueChanged<String?> onChanged,
  }) {
    final bool isSelected = currentGroupValue == value;
    return InkWell(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.background, // Ganti dengan AppColors
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.textLight.withOpacity(
                    0.5,
                  ), // Ganti dengan AppColors
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textLight,
              size: 30,
            ), // Ganti dengan AppColors
            const SizedBox(height: 5),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textDark, // Ganti dengan AppColors
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
