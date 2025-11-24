import 'package:myapp/model/ticket.dart';

class Participant {
  final String id;
  final String name;
  final String email;
  final String phone;
  final List<Ticket> ticket;

  Participant({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.ticket,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      ticket: (json['ticket'] as List<dynamic>)
          .map((e) => Ticket.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'ticket': ticket.map((e) => e.toJson()).toList(),
    };
  }
}