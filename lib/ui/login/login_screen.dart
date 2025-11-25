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

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() => setState(() {}));
    _passwordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    print("[LOGIN_DEBUG] _handleLogin() called.");
    if (_isLoading) {
      print("[LOGIN_DEBUG] Already loading, returning.");
      return;
    }

    // Valida o formulário
    if (_formKey.currentState!.validate()) {
      print("[LOGIN_DEBUG] Form is valid.");
      setState(() => _isLoading = true);

      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      print("[LOGIN_DEBUG] Attempting to log in with email: $email");
      // ATENÇÃO: Logar senhas em produção é uma má prática de segurança.
      // Este log é apenas para depuração local.
      print("[LOGIN_DEBUG] Password length: ${password.length}");

      try {
        print("[LOGIN_DEBUG] Calling AuthService.loginUser...");
        // Chama o login do AuthService
        String? error = await _authService.loginUser(
          email: email,
          password: password,
        );
        print(
          "[LOGIN_DEBUG] AuthService.loginUser returned: ${error ?? 'No error (success)'}",
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
      } catch (e, stackTrace) {
        print("[LOGIN_DEBUG] Exception caught in _handleLogin: $e");
        print("[LOGIN_DEBUG] Stack trace: $stackTrace");
        // Pega qualquer erro inesperado (embora o AuthService já trate a maioria)
        if (mounted) {
          showSnackBar(
            context: context,
            message: "Ocorreu um erro inesperado.",
            duration: 3,
          );
        }
      } finally {
        print(
          "[LOGIN_DEBUG] _handleLogin finally block. Setting _isLoading to false.",
        );
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
                // Movido para cima para ficar mais perto do logo
                Transform.translate(
                  offset: const Offset(
                    0,
                    -50.0,
                  ), // Revertido para -50.0 conforme solicitado pelo usuário
                  child: const Text(
                    "EventHub",
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textBlack01Color,
                      fontFamily: "AirbnbCereal",
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // EMAIL
                TextFormField(
                  focusNode: _emailFocusNode,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppColors.mainColorBlue),
                  decoration: InputDecoration(
                    labelText: "email@email.com",
                    helperText: "Insira seu e-mail",
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: _emailFocusNode.hasFocus
                          ? AppColors.mainColorBlue
                          : AppColors.textBlack03Color,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ), // Borda arredondada
                      borderSide: const BorderSide(
                        color: AppColors.mainColorBlue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ), // Borda arredondada
                      borderSide: const BorderSide(
                        color:
                            AppColors
                                .textBlack03Color, // Alterado para cor padrão
                      ),
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
                const SizedBox(height: 16),

                // SENHA
                TextFormField(
                  focusNode: _passwordFocusNode,
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  style: const TextStyle(color: AppColors.mainColorBlue),
                  decoration: InputDecoration(
                    labelText: "Sua Senha",
                    helperText: "Insira sua senha",
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: _passwordFocusNode.hasFocus
                          ? AppColors.mainColorBlue
                          : AppColors.textBlack03Color,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: _passwordFocusNode.hasFocus
                            ? AppColors.mainColorBlue
                            : AppColors.textBlack03Color,
                      ),
                      onPressed:
                          () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // Borda arredondada
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: AppColors.mainColorBlue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      // Borda arredondada
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color:
                            AppColors
                                .textBlack03Color, // Alterado para cor padrão
                      ),
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
                        Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: _rememberMe,
                            onChanged:
                                (value) => setState(() => _rememberMe = value),
                            activeColor: AppColors.mainColorBlue,
                          ),
                        ),
                        const Text(
                          "Lembrar-me",
                          style: TextStyle(color: AppColors.textBlack03Color),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Implementar tela de "Esqueci minha senha"
                      },
                      child: const Text(
                        "Esqueci minha senha",
                        style: TextStyle(
                          color: AppColors.textBlack03Color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // BOTÃO LOGIN
                Container(
                  height: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AppColors.mainColorBlue,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.mainColorBlue.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                            : Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Row(
                                children: [
                                  const Spacer(),
                                  const Text(
                                    "ENTRAR",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                  ),
                ),
                const SizedBox(height: 12),

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
