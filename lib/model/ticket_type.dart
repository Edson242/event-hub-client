class TicketType {
  final int id;
  final String name;
  final double price;
  final String description;

  TicketType({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
  });

  factory TicketType.fromJson(Map<String, dynamic> json) {
    return TicketType(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
    );
  }
}
