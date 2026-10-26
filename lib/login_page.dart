import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isRegister = false;
  bool _isLoading = false;
  bool _hidePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _message(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _emailAuth() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_isRegister) {
        final credential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        final name = _nameController.text.trim();

        if (name.isNotEmpty) {
          await credential.user?.updateDisplayName(name);
        }

        _message('Akun berhasil dibuat. Selamat datang!');
      } else {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      }
    } on FirebaseAuthException catch (e) {
      final message = switch (e.code) {
        'email-already-in-use' => 'Email ini sudah terdaftar.',
        'invalid-email' => 'Format email tidak valid.',
        'weak-password' =>
          'Password terlalu lemah. Gunakan minimal 6 karakter.',
        'user-not-found' =>
          'Akun tidak ditemukan. Silakan daftar terlebih dahulu.',
        'wrong-password' => 'Password yang kamu masukkan salah.',
        'invalid-credential' => 'Email atau password salah.',
        'too-many-requests' => 'Terlalu banyak percobaan. Coba lagi nanti.',
        'network-request-failed' => 'Koneksi internet bermasalah.',
        _ => e.message ?? 'Autentikasi gagal. Coba lagi.',
      };

      _message(message);
    } catch (e) {
      _message('Terjadi kesalahan. Coba lagi.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _googleLogin() async {
    if (!kIsWeb) {
      _message('Login Google ini dikonfigurasi untuk Flutter Web.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final provider = GoogleAuthProvider()..addScope('email');
      await _auth.signInWithPopup(provider);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'popup-closed-by-user') {
        _message('Login Google dibatalkan.');
      } else if (e.code == 'unauthorized-domain') {
        _message(
          'Domain belum diizinkan. Periksa Authorized domains di Firebase.',
        );
      } else {
        _message(e.message ?? 'Login Google gagal.');
      }
    } catch (e) {
      _message(
        'Login Google gagal. Periksa konfigurasi Firebase dan koneksi internet.',
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _demoLogin() async {
    setState(() => _isLoading = true);

    try {
      await _auth.signInWithEmailAndPassword(
        email: 'demo@secondhand.test',
        password: '123456',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'invalid-credential' ||
          e.code == 'wrong-password') {
        _message(
          'Akun demo belum dibuat. Buat akun tersebut di Firebase Console.',
        );
      } else {
        _message(e.message ?? 'Login demo gagal.');
      }
    } catch (e) {
      _message('Login demo gagal. Coba lagi.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)) {
      _message('Masukkan email yang valid terlebih dahulu.');
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _message('Jika email terdaftar, instruksi reset akan dikirim.');
    } on FirebaseAuthException catch (e) {
      _message(e.message ?? 'Gagal mengirim reset password.');
    } catch (e) {
      _message('Gagal mengirim reset password.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: AppTheme.isDark ? 'Mode Terang' : 'Mode Gelap',
            onPressed: AppTheme.toggle,
            icon: Icon(
              AppTheme.isDark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.07)
                        : Colors.black.withValues(alpha: 0.06),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.25 : 0.04,
                      ),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo & Identitas Aplikasi
                      Center(
                        child: Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFB6D477), Color(0xFF789449)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF789449)
                                    .withValues(alpha: 0.3),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.directions_car_filled_rounded,
                            color: Color(0xFF1B2211),
                            size: 34,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'SecondHand',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _isRegister
                            ? 'Buat akun untuk mulai menjelajahi unit terbaik.'
                            : 'Showroom mobil & motor bekas berkualitas.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Segmented Switcher Masuk / Daftar
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF141712)
                              : const Color(0xFFF1F4EB),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (_isRegister && !_isLoading) {
                                    setState(() {
                                      _isRegister = false;
                                      _formKey.currentState?.reset();
                                    });
                                  }
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: !_isRegister
                                        ? theme.cardColor
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(11),
                                    boxShadow: !_isRegister
                                        ? [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.05,
                                              ),
                                              blurRadius: 6,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Text(
                                    'Masuk',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: !_isRegister
                                          ? FontWeight.w800
                                          : FontWeight.w500,
                                      color: !_isRegister
                                          ? colors.onSurface
                                          : colors.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (!_isRegister && !_isLoading) {
                                    setState(() {
                                      _isRegister = true;
                                      _formKey.currentState?.reset();
                                    });
                                  }
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _isRegister
                                        ? theme.cardColor
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(11),
                                    boxShadow: _isRegister
                                        ? [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.05,
                                              ),
                                              blurRadius: 6,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Text(
                                    'Daftar Baru',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: _isRegister
                                          ? FontWeight.w800
                                          : FontWeight.w500,
                                      color: _isRegister
                                          ? colors.onSurface
                                          : colors.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      if (_isRegister) ...[
                        TextFormField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Nama lengkap',
                            hintText: 'Masukkan nama lengkapmu',
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                          validator: (value) {
                            if (_isRegister &&
                                (value == null || value.trim().isEmpty)) {
                              return 'Nama tidak boleh kosong.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                      ],

                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        decoration: const InputDecoration(
                          labelText: 'Alamat Email',
                          hintText: 'nama@email.com',
                          prefixIcon: Icon(Icons.mail_outline_rounded),
                        ),
                        validator: (value) {
                          if (value == null ||
                              !RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                                  .hasMatch(value.trim())) {
                            return 'Masukkan email yang valid.';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: _hidePassword,
                        autofillHints: _isRegister
                            ? const [AutofillHints.newPassword]
                            : const [AutofillHints.password],
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Minimal 6 karakter',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _hidePassword = !_hidePassword;
                              });
                            },
                            icon: Icon(
                              _hidePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'Password minimal 6 karakter.';
                          }
                          return null;
                        },
                      ),

                      if (!_isRegister)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _isLoading ? null : _resetPassword,
                            child: const Text(
                              'Lupa password?',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      else
                        const SizedBox(height: 18),

                      const SizedBox(height: 4),

                      FilledButton(
                        onPressed: _isLoading ? null : _emailAuth,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFB6D477),
                          foregroundColor: const Color(0xFF1E231B),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  color: Color(0xFF1E231B),
                                ),
                              )
                            : Text(
                                _isRegister
                                    ? 'Buat Akun Sekarang'
                                    : 'Masuk ke Akun',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: Divider(color: colors.outlineVariant),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'atau akses cepat',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(color: colors.outlineVariant),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      OutlinedButton.icon(
                        onPressed: _isLoading ? null : _googleLogin,
                        icon: const Icon(Icons.g_mobiledata_rounded, size: 28),
                        label: const Text(
                          'Lanjutkan dengan Google',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),

                      if (!_isRegister) ...[
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: _isLoading ? null : _demoLogin,
                          icon: const Icon(
                            Icons.verified_user_outlined,
                            size: 19,
                          ),
                          label: const Text(
                            'Masuk sebagai Akun Demo',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
