import 'package:flutter/material.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/ui/_core/snackbar.dart';
import 'package:myapp/ui/home/home_screen.dart';
import 'package:myapp/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 32.0,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/logo.png", width: 192),
                  Text(
                    "Seja bem-vindo(a) ao nosso aplicativo!",
                    style: TextStyle(fontSize: 22.0),
                  ),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: AppColors.backgroundWhiteColor),
                    decoration: InputDecoration(
                      labelText: "E-mail",
                      helper: Text("Insira seu e-mail"),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.textBlack03Color),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.textBlack03Color),
                      ),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textBlack03Color),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textBlack03Color),
                        )
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
                  Visibility(
                    visible: !isLogin,
                    child: TextFormField(
                      controller: _nameController,
                      style: TextStyle(color: AppColors.backgroundWhiteColor),
                      decoration: InputDecoration(
                        labelText: "Nome",
                        helper: Text("Insira seu nome"),
                        suffixStyle: TextStyle(color: AppColors.textBlack03Color),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textBlack03Color),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textBlack03Color),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textBlack03Color),
                        )
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor, insira sua senha.";
                        }
                        return null;
                      },
                    ),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    style: TextStyle(color: AppColors.backgroundWhiteColor),
                    decoration: InputDecoration(
                      labelText: "Senha",
                      helper: Text("Insira sua senha"),
                      suffixStyle: TextStyle(color: AppColors.backgroundWhiteColor),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.visibility,
                          color: AppColors.backgroundWhiteColor,
                        ),
                        onPressed: () {
                          // Toggle password visibility
                        },
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.textBlack03Color),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.textBlack03Color),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.textBlack03Color),
                      )
                    ),
                    validator: (String? value) {
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
                  Visibility(
                    visible: !isLogin,
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      style: TextStyle(color: AppColors.backgroundWhiteColor),
                      decoration: InputDecoration(
                        labelText: "Confirmar senha",
                        helper: Text("Insira sua senha"),
                        suffixStyle: TextStyle(color: AppColors.backgroundWhiteColor),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.visibility,
                            color: AppColors.backgroundWhiteColor,
                          ),
                          onPressed: () {
                            // Toggle password visibility
                          },
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.backgroundWhiteColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.backgroundWhiteColor),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.backgroundWhiteColor),
                        )
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor, insira sua senha.";
                        }
                        return null;
                      },
                    ),
                  ),
                  (isLogin)
                      ? TextButton(
                        onPressed: () {
                          // Add your forgot password logic here
                        },
                        child: Text(
                          (isLogin) ? "Esqueci minha senha" : "",
                          style: TextStyle(
                            color: AppColors.backgroundWhiteColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                      : SizedBox(height: 0),
                  // SizedBox(height: 20),
                  Column(
                    spacing: 6.0,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            botaoPrincipalClicado();
                          },
                          child: Text((isLogin) ? "Entrar" : "Cadastrar"),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Add your login logic here
                            authService.loginWithGoogle().then((String? error) {
                              if(error != null){
                                showSnackBar(context: context, message: "${error}!", duration: 3);
                              } else {
                                showSnackBar(context: context, message: "Usuário logado com sucesso!", duration: 3, isError: false);
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.backgroundWhiteColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.g_mobiledata,
                                color: Colors.black,
                                size: 36.0,
                              ),
                              Text("Google"),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                (isLogin)
                                    ? "Ainda não tenho conta? Cadastre-se!"
                                    : "Já tem uma conta? Entre!",
                                style: TextStyle(color: AppColors.backgroundWhiteColor),
                              ),
                            ],
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

  botaoPrincipalClicado() {
    String email = _emailController.text;
    String password = _passwordController.text;
    String name = _nameController.text;
    if (_formKey.currentState!.validate()) {
      print("Email: ${_emailController.text}");
      print("Senha: ${_passwordController.text}");
      print("Nome: ${_nameController.text}");

      if(!isLogin) {
        authService.cadastrarUser(email: email, password: password, name: name).then((String? error) {
          if(error != null){
            showSnackBar(context: context, message: "${error}!", duration: 3);
          } else {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          }
        });
      } else {
        authService.loginUser(email: email, password: password).then((String? error) {
          if(error != null){
            showSnackBar(context: context, message: "${error}!", duration: 3);
          }
        });
      }
    }
  }
}
