import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/services/event_service.dart';
import 'package:myapp/services/location_service.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/ui/tickets/ticket_selection_screen.dart';

class EventDetailsScreen extends StatelessWidget {
  final EventDTO event;

  const EventDetailsScreen({Key? key, required this.event}) : super(key: key);

  Future<String> _getLocationAddress() async {
    try {
      final parts = event.location.split(',');
      if (parts.length == 2) {
        final lat = double.tryParse(parts[0].trim());
        final lng = double.tryParse(parts[1].trim());
        if (lat != null && lng != null) {
          final address = await LocationService().getAddressFromCoordinates(
            lat,
            lng,
          );
          return address ?? event.location;
        }
      }
      return event.location;
    } catch (e) {
      return event.location;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Image.asset(
              'assets/banners/event_image.png',
              fit: BoxFit.cover,
            ),
          ),
          // Back and Bookmark Buttons
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_border, color: Colors.white),
                ),
              ],
            ),
          ),
          // Content
          Positioned.fill(
            top: 250,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            event.title,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textBlack01Color,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Date
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.mainColorBlue.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.calendar_today,
                                  color: AppColors.mainColorBlue,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat(
                                      'd MMMM, yyyy',
                                      'pt_BR',
                                    ).format(event.eventDate),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textBlack01Color,
                                    ),
                                  ),
                                  Text(
                                    DateFormat(
                                      'EEEE, HH:mm',
                                      'pt_BR',
                                    ).format(event.eventDate),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textBlack03Color,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Location
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.mainColorBlue.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  color: AppColors.mainColorBlue,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: FutureBuilder<String>(
                                  future: _getLocationAddress(),
                                  builder: (context, snapshot) {
                                    final address =
                                        snapshot.data ?? event.location;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          address,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textBlack01Color,
                                          ),
                                        ),
                                        const Text(
                                          "Ver no mapa", // Placeholder text
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.textBlack03Color,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Organizer
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(12),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                      'assets/banners/event_image.png',
                                    ), // Placeholder avatar
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Edson Silveira", // Placeholder name, API doesn't have creator name yet
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textBlack01Color,
                                    ),
                                  ),
                                  const Text(
                                    "Organizer",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textBlack03Color,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // About Event
                          const Text(
                            "Sobre:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textBlack01Color,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            event.description,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textBlack03Color,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(
                            height: 100,
                          ), // Space for bottom button
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Buy Ticket Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => TicketSelectionScreen(
                            eventId: event.id,
                            eventTitle: event.title,
                          ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColorBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "COMPRAR INGRESSO",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
