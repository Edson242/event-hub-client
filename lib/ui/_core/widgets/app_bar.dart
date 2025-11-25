import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/services/location_service.dart';

AppBar getAppBar({
  required BuildContext context,
  String title = '',
  VoidCallback? onNotificationTap,
  VoidCallback? onProfileTap,
}) {
  return AppBar(
    backgroundColor: AppColors.mainColorBlue,
    elevation: 0,
    centerTitle: true, // Ensure the title or location is centered
    leading: Builder(
      builder:
          (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
    ),
    title:
        title != ''
            ? Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )
            : FutureBuilder<String?>(
              future: LocationService().getCurrentCity(),
              builder: (context, snapshot) {
                final city = snapshot.data ?? 'Localização indisponível';
                return Text(
                  city,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontFamily: 'AirbnbCerealApp',
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
    actions:
        title == ''
            ? <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => _showComingSoonDialog(context),
              ),
            ]
            : null,
  );
}

void _showComingSoonDialog(BuildContext context) {
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
                        Icons.notifications,
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
                  "EM BREVE!",
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
                  "Estamos trabalhando nesta funcionabilidade incrível!",
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
