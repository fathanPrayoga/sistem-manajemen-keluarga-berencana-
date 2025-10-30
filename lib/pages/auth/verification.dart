import 'package:flutter/material.dart';
import 'dart:async';
import '../dashboard.dart';

class VerificationPage extends StatefulWidget {
  final String? emailOrPhone;
  const VerificationPage({super.key, this.emailOrPhone});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(4, (_) => FocusNode());

  Timer? _timer;
  int _resendCooldown = 60;
  bool _isLoading = false;

  final Color primaryColor = const Color(0xFF4CAF50);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _resendCooldown = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_resendCooldown == 0) {
        setState(() => timer.cancel());
      } else {
        setState(() => _resendCooldown--);
      }
    });
  }

  String _getOtp() => _otpControllers.map((c) => c.text).join();

  // Fungsi DUMMY untuk menangani proses Verifikasi
  void _handleVerify() async {
    final otpCode = _getOtp();
    if (otpCode.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan kode verifikasi lengkap (4 digit).'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // --- SIMULASI API (Focus Tampilan) ---
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Navigasi DUMMY ke Dashboard
    print('Verifikasi (Tampilan Saja) Sukses. Navigasi ke Dashboard.');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verifikasi (Simulasi) Berhasil!')),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardPage()),
    );
  }

  // Fungsi DUMMY untuk menangani Kirim Ulang Kode
  void _handleResend() {
    if (_resendCooldown == 0) {
      print('Kirim Ulang Kode (Tampilan Saja).');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kode baru telah dikirimkan (Simulasi).')),
      );
      _startTimer();
    }
  }

  void _onKeypadTap(String value) {
    if (value == 'clear') {
      for (int i = 3; i >= 0; i--) {
        if (_otpControllers[i].text.isNotEmpty) {
          _otpControllers[i].clear();
          if (i > 0) FocusScope.of(context).requestFocus(_otpFocusNodes[i - 1]);
          break;
        }
      }
    } else {
      for (int i = 0; i < 4; i++) {
        if (_otpControllers[i].text.isEmpty) {
          _otpControllers[i].text = value;
          if (i < 3)
            FocusScope.of(context).requestFocus(_otpFocusNodes[i + 1]);
          else
            FocusScope.of(context).unfocus();
          break;
        }
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _otpControllers) c.dispose();
    for (var f in _otpFocusNodes) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 40.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 50),
                    const Text(
                      'KODE VERIFIKASI',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Masukkan kode 4 digit yang dikirimkan ke ${widget.emailOrPhone ?? 'email/nomor Anda'}.',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        4,
                        (index) => _buildOtpField(index),
                      ),
                    ),
                    const SizedBox(height: 40),

                    ElevatedButton(
                      onPressed: (_getOtp().length == 4 && !_isLoading)
                          ? _handleVerify
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Verifikasi',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),

                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: _resendCooldown == 0 ? _handleResend : null,
                        child: Text(
                          _resendCooldown == 0
                              ? 'Kirim Ulang Kode'
                              : 'Kirim Ulang ($_resendCooldown detik)',
                          style: TextStyle(
                            color: _resendCooldown == 0
                                ? primaryColor
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _CustomKeypad(onKeyTap: _onKeypadTap),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpField(int index) {
    return SizedBox(
      width: 60,
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _otpFocusNodes[index],
        keyboardType: TextInputType.none,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class _CustomKeypad extends StatelessWidget {
  final ValueChanged<String> onKeyTap;
  const _CustomKeypad({required this.onKeyTap});

  @override
  Widget build(BuildContext context) {
    final List<String> keys = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '',
      '0',
      'clear',
    ];
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: keys.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final key = keys[index];
          Widget child;
          VoidCallback? onPressed;
          if (key.isEmpty) {
            child = const SizedBox.shrink();
            onPressed = null;
          } else if (key == 'clear') {
            child = const Icon(
              Icons.backspace_outlined,
              color: Colors.black87,
              size: 30,
            );
            onPressed = () => onKeyTap('clear');
          } else {
            child = Text(
              key,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
            );
            onPressed = () => onKeyTap(key);
          }
          return InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(50),
            child: Center(child: child),
          );
        },
      ),
    );
  }
}
