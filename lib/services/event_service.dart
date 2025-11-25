import 'package:dio/dio.dart';
import 'package:myapp/services/api_service.dart';
import 'package:myapp/model/ticket_type.dart';

class EventDTO {
  final int id;
  final String title;
  final String description;
  final DateTime eventDate;
  final String location;
  final int maxParticipants;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventDTO({
    required this.id,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.location,
    required this.maxParticipants,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventDTO.fromJson(Map<String, dynamic> json) {
    return EventDTO(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      eventDate: DateTime.parse(json['eventDate']),
      location: json['location'],
      maxParticipants: json['maxParticipants'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class EventService {
  static final EventService _instance = EventService._internal();
  factory EventService() => _instance;
  EventService._internal();

  final ApiService _apiService = ApiService();

  Future<List<EventDTO>> getEvents() async {
    try {
      final response = await _apiService.dio.get('/events');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => EventDTO.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load events');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load events: ${e.message}');
    }
  }

  Future<bool> createEvent(Map<String, dynamic> eventData) async {
    try {
      print(eventData);
      final response = await _apiService.dio.post('/events', data: eventData);
      return response.statusCode == 201 || response.statusCode == 200;
    } on DioException catch (e) {
      print('Error creating event: ${e.message}');
      return false;
    }
  }

  // Mocked method to get ticket types
  Future<List<TicketType>> getTicketTypes(int eventId) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // Return mock data
    return [
      TicketType(
        id: 1,
        name: 'Pista',
        price: 120.00,
        description: 'Acesso à área comum do evento.',
      ),
      TicketType(
        id: 2,
        name: 'VIP',
        price: 250.00,
        description: 'Acesso à área VIP com open bar.',
      ),
      TicketType(
        id: 3,
        name: 'Backstage',
        price: 500.00,
        description: 'Acesso total, incluindo camarim.',
      ),
    ];
  }

  // Mocked method to purchase ticket
  Future<bool> purchaseTicket(int eventId, int ticketTypeId) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  // Mocked method to get user's events/tickets
  Future<List<Map<String, dynamic>>> getMyEvents() async {
    await Future.delayed(const Duration(seconds: 1));

    // Mock Event "Teste"
    final testEvent = EventDTO(
      id: 999,
      title: "Evento de Teste",
      description: "Evento simulado para testar a compra de ingressos.",
      eventDate: DateTime.now().add(const Duration(days: 5)),
      location: "São Paulo, SP",
      maxParticipants: 100,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Mock Ticket "Pista"
    final pistaTicket = TicketType(
      id: 1,
      name: "Pista",
      price: 120.00,
      description: "Acesso à área comum.",
    );

    return [
      {'event': testEvent, 'ticket': pistaTicket},
    ];
  }
}
