import 'package:flutter/material.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/ui/_core/snackbar.dart';
import 'package:myapp/ui/home/home_screen.dart';
import 'package:myapp/ui/signup/signup_screen.dart';
import 'package:myapp/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  // Instancia o AuthService (que agora usa Dio e SecureStorage)
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_isLoading) return;

    // Valida o formulário
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      try {
        // Chama o login do AuthService
        String? error = await _authService.loginUser(
          email: email,
          password: password,
        );

        // O 'mounted' é importante para verificar se o widget ainda está na tela
        if (mounted) {
          if (error != null) {
            // Mostra erro se o serviço retornar uma mensagem
            showSnackBar(context: context, message: error, duration: 3);
          } else {
            // Sucesso
            showSnackBar(
              context: context,
              message: "Usuário logado com sucesso!",
              isError: false,
              duration: 3,
            );
            // Navega para a HomeScreen e remove a LoginScreen da pilha
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        }
      } catch (e) {
        // Pega qualquer erro inesperado (embora o AuthService já trate a maioria)
        if (mounted) {
          showSnackBar(
            context: context,
            message: "Ocorreu um erro inesperado.",
            duration: 3,
          );
        }
      } finally {
        // Garante que o loading pare, mesmo se der erro
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  //
  // FUNÇÃO _loginWithGoogle() REMOVIDA
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // LOGO
                Image.asset("assets/logo.png", width: 180),
                const SizedBox(height: 24),

                const Text(
                  "Bem-vindo(a) de volta!",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mainColorBlue,
                  ),
                ),
                const SizedBox(height: 32),

                // EMAIL
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppColors.mainColorBlue),
                  decoration: InputDecoration(
                    labelText: "email@email.com",
                    helperText: "Insira seu e-mail",
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: AppColors.mainColorBlue,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.mainColorBlue),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.mainColorBlue),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor, insira seu e-mail.";
                    }
                    if (!value.contains("@")) {
                      return "Por favor, insira um e-mail válido.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // SENHA
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  style: const TextStyle(color: AppColors.mainColorBlue),
                  decoration: InputDecoration(
                    labelText: "Sua Senha",
                    helperText: "Insira sua senha",
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.mainColorBlue,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.mainColorBlue,
                      ),
                      onPressed: () => setState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.mainColorBlue),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.mainColorBlue),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor, insira sua senha.";
                    }
                    if (value.length < 6) {
                      return "A senha deve ter pelo menos 6 caracteres.";
                    }
                    if (value.length > 20) {
                      return "A senha não pode ter mais de 20 caracteres.";
                    }
                    if (value.contains(" ")) {
                      return "A senha não pode conter espaços.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // LEMBRAR-ME E ESQUECI SENHA
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) =>
                              setState(() => _rememberMe = value ?? false),
                          activeColor: AppColors.mainColorBlue,
                        ),
                        const Text("Lembrar-me"),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Implementar tela de "Esqueci minha senha"
                      },
                      child: const Text(
                        "Esqueci minha senha",
                        style: TextStyle(
                          color: AppColors.mainColorBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // BOTÃO LOGIN
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.mainColorBlue,
                        AppColors.mainColorCyan,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
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
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "ENTRAR",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.backgroundWhiteColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_outlined,
                                color: Colors.white,
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                //
                // BOTÃO LOGIN GOOGLE REMOVIDO
                //

                // CRIAR CONTA
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Ainda não tem conta? Cadastre-se!",
                    style: TextStyle(
                      color: AppColors.mainColorBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}