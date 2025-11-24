import 'package:flutter/material.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/ui/login/login_screen.dart';

class OnboardingPageModel {
  final String imagePath;
  final String title;
  final String description;

  OnboardingPageModel({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageModel> _pages = [
    OnboardingPageModel(
      imagePath: 'assets/banners/cell_splash_01.png',
      title: 'Explore os próximos eventos perto de você',
      description:
          'Nunca mais perca os melhores shows, festivais e workshops. Encontre com facilidade tudo o que está rolando na sua região.',
    ),
    OnboardingPageModel(
      imagePath: 'assets/banners/cell_splash_02.png',
      title: 'Tenha um calendário de eventos moderno',
      description:
          'Organize sua agenda de diversão. Adicione eventos ao seu calendário e receba lembretes para não perder nenhum momento importante.',
    ),
    OnboardingPageModel(
      imagePath: 'assets/banners/cell_splash_03.png',
      title: 'Encontre eventos e atividades próximas',
      description:
          'Explore a cidade de um jeito novo. Navegue pelo nosso mapa interativo e descubra os melhores pontos de diversão ao seu redor.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhiteColor,
      body: Stack(
        children: [
          // Camada 1: O PageView com as imagens do celular
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                // Ajuste o padding para posicionar a imagem
                padding: const EdgeInsets.only(bottom: 200.0),
                child: Image.asset(
                  _pages[index].imagePath,
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
          // Camada 2: O rodapé roxo fixo na parte inferior
          Align(alignment: Alignment.bottomCenter, child: _buildFooter()),
        ],
      ),
    );
  }

  // Widget que constrói o rodapé
  Widget _buildFooter() {
    return Container(
      height: 300, // Altura do container roxo
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
      decoration: const BoxDecoration(
        color: Color(0xFF6A5AE0), // Cor roxa do design
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50), // Cantos arredondados
          topRight: Radius.circular(50),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Textos que mudam de acordo com a página
          Column(
            children: [
              Text(
                _pages[_currentPage].title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _pages[_currentPage].description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),

          // Controles de navegação
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Botão "Skip"
              TextButton(
                onPressed: _navigateToHome,
                child: const Text(
                  'Pular',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),

              // Indicadores de página (bolinhas)
              Row(
                children: List.generate(_pages.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color:
                          _currentPage == index ? Colors.white : Colors.white54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),

              // Botão "Next"
              TextButton(
                onPressed: () {
                  if (_currentPage < _pages.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    _navigateToHome();
                  }
                },
                child: const Text(
                  'Próximo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
