import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:myapp/dto/user.dto.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/services/user_service.dart';
import 'package:myapp/ui/home/home_screen.dart';
import 'package:myapp/ui/splash/splash_screen.dart';
import 'package:myapp/ui/userPage/user_page_screen.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 40, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30, // Adjust size as needed
                    backgroundColor: const Color(0x1A5669ff),
                    child: const Icon(
                      Icons.account_circle,
                      size: 60, // Icon size to fill the avatar
                      color: AppColors.mainColorBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FutureBuilder<UserDTO?>(
                    future: UserService().getCurrentUser(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(
                          "Carregando...",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textBlack01Color,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return const Text(
                          "Erro ao carregar",
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        );
                      } else if (snapshot.hasData) {
                        return Text(
                          snapshot.data!.name,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textBlack01Color,
                          ),
                        );
                      } else {
                        return const Text(
                          "Usuário",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textBlack01Color,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.person_outline,
                    title: "Home",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.person_outline,
                    title: "Perfil",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserpageScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.calendar_today_outlined,
                    title: "Meus eventos",
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.bookmark_border,
                    title: "Favoritos",
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.mail_outline,
                    title: "Contato",
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.settings_outlined,
                    title: "Configurações",
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.help_outline,
                    title: "Ajuda & FAQs",
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.logout,
                    title: "Sair",
                    onTap: () async {
                      await AuthService().logoutUser();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SplashScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            // Upgrade Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: GestureDetector(
                onTap: () => _showUpgradeSuccessDialog(context),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0FBF9), // Light cyan background
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.workspace_premium,
                        color: Color(0xFF00F8FF),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Upgrade Pro",
                        style: TextStyle(
                          color: Color(0xFF00F8FF),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpgradeSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x1A000000),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ícone animado
                  Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0x1A5669ff),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.emoji_events,
                          size: 60,
                          color: AppColors.mainColorBlue,
                        ),
                      )
                      .animate()
                      .scale(duration: 600.ms, curve: Curves.elasticOut)
                      .shimmer(delay: 400.ms, duration: 1200.ms),

                  const SizedBox(height: 24),

                  // Título
                  const Text(
                    "PARABÉNS!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack01Color,
                      letterSpacing: 1.2,
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 12),

                  // Mensagem
                  const Text(
                    "VOCÊ AGORA VIROU UM\nUSUÁRIO PRO!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textBlack03Color,
                      height: 1.5,
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 32),

                  // Botão Fechar
                  SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainColorBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "INCRÍVEL!",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 600.ms)
                      .scale(
                        begin: const Offset(0.8, 0.8),
                        curve: Curves.easeOutBack,
                      ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    int? badgeCount,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textBlack01Color, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.textBlack01Color,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing:
          badgeCount != null
              ? Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.accentOrangeColor, // Using orange for badge
                  shape: BoxShape.circle,
                ),
                child: Text(
                  badgeCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
              : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      dense: true,
      onTap: onTap,
    );
  }
}
