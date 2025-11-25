import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/dto/user.dto.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/ui/_core/widgets/app_bar.dart';
import 'package:myapp/ui/_core/widgets/bottom_menu.dart';
import 'package:myapp/ui/_core/widgets/drawer_menu.dart';
import 'package:myapp/services/event_service.dart';
import 'package:myapp/services/user_service.dart';
import 'package:myapp/ui/event_details/event_details_screen.dart';
import 'package:myapp/ui/events/create_event_screen.dart';
import 'package:myapp/ui/home/widgets/event_card.dart';

import 'package:myapp/ui/userPage/user_page_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final pageController = PageController();
  UserDTO? _currentUser;
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _fetchUser();

    // Start timer for banner carousel
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (pageController.hasClients) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeIn,
        );
      }
    });
  }

  Future<void> _fetchUser() async {
    final user = await UserService().getCurrentUser();
    if (mounted) {
      setState(() {
        _currentUser = user;
        _isLoadingUser = false;
      });
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool canCreateEvent = false;
    if (_currentUser != null) {
      final role = _currentUser!.role.toUpperCase();
      canCreateEvent = role == 'ORGANIZER' || role == 'ADMIN';
    }

    return Scaffold(
      drawer: const DrawerMenu(),
      appBar: getAppBar(
        context: context,
        onProfileTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserpageScreen()),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "O que deseja para hoje?",
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.mainColorBlue,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: AppColors.mainColorBlue,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),

              // Events Section Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Próximos Eventos",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack01Color,
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // Events List
              FutureBuilder<List<EventDTO>>(
                future: EventService().getEvents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro ao carregar eventos: ${snapshot.error}',
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Nenhum evento encontrado.'),
                    );
                  }

                  final events = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return EventCard(
                        event: event,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => EventDetailsScreen(event: event),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomMenu(initialIndex: 0),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          canCreateEvent
              ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateEventScreen(),
                    ),
                  );
                },
                backgroundColor: AppColors.mainColorBlue,
                elevation: 2.0,
                shape: const CircleBorder(),
                child: const Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }
}
