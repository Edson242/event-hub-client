import 'package:flutter/material.dart';
import 'package:myapp/dto/role.dto.dart';
import 'package:myapp/services/user_service.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/ui/_core/snackbar.dart';
import 'package:myapp/ui/home/home_screen.dart';
import 'package:myapp/ui/login/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  final UserService userService = UserService();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// 🔹 Lógica principal de cadastro
  Future<void> _handleSignUp() async {
    if (_isLoading) return;

    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        showSnackBar(context: context, message: "As senhas não coincidem!", duration: 3);
        return;
      }

      setState(() => _isLoading = true);

      final name = _fullNameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      try {
        final String? error = await userService.registerUser(
          email: email,
          password: password,
          name: name,
          role: RoleType.user,
        );

        if (mounted) {
          if (error != null) {
            showSnackBar(context: context, message: error, duration: 3);
          } else {
            showSnackBar(
              context: context,
              message: "Usuário cadastrado com sucesso!",
              duration: 3,
              isError: false,
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          showSnackBar(context: context, message: "Erro inesperado. Tente novamente.", duration: 3);
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textBlack01Color),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Criar Conta",
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack01Color,
                    ),
                  ),
                  const SizedBox(height: 32.0),

                  // 🔹 Campo Nome
                  TextFormField(
                    controller: _fullNameController,
                    keyboardType: TextInputType.name,
                    style: const TextStyle(color: AppColors.textBlack02Color),
                    decoration: _buildInputDecoration(
                      label: "Nome completo",
                      icon: Icons.person_outline,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Por favor, insira seu nome completo.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // 🔹 Campo Email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: AppColors.textBlack02Color),
                    decoration: _buildInputDecoration(
                      label: "email@email.com",
                      icon: Icons.email_outlined,
                    ),
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return "Por favor, insira um e-mail válido.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // 🔹 Campo Senha
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: AppColors.textBlack02Color),
                    decoration: _buildInputDecoration(
                      label: "Senha",
                      icon: Icons.lock_outline,
                      isPassword: true,
                      obscureState: _obscurePassword,
                      onToggleVisibility: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return "A senha deve ter pelo menos 6 caracteres.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // 🔹 Campo Confirmar Senha
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    style: const TextStyle(color: AppColors.textBlack02Color),
                    decoration: _buildInputDecoration(
                      label: "Confirme a senha",
                      icon: Icons.lock_outline,
                      isPassword: true,
                      obscureState: _obscureConfirmPassword,
                      onToggleVisibility: () => setState(
                          () => _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return "As senhas não coincidem.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32.0),

                  // 🔹 Botão de Cadastro
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [AppColors.mainColorBlue, AppColors.mainColorCyan],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSignUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                "CADASTRAR",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.backgroundWhiteColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward_outlined,
                                  color: AppColors.backgroundWhiteColor,
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  // 🔹 Link para Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Já tem uma conta?",
                        style: TextStyle(color: AppColors.textBlack02Color),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          );
                        },
                        child: const Text(
                          "Entrar",
                          style: TextStyle(
                            color: AppColors.mainColorBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Método auxiliar para inputs
  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool obscureState = false,
    VoidCallback? onToggleVisibility,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: AppColors.textBlack03Color),
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textBlack03Color),
      filled: true,
      fillColor: AppColors.backgroundWhiteColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.mainColorBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.accentRedColor, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.accentRedColor, width: 2),
      ),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                obscureState
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.textBlack03Color,
              ),
              onPressed: onToggleVisibility,
            )
          : null,
    );
  }
}
