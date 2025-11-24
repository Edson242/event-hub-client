class DiscountCoupons {
  final String code;
  final double discountValue;
  final String discountType;
  final DateTime validUntil;
  final int maxUsers;
  final int eventId;
  final DateTime createdAt;
  final DateTime updatedAt;

  DiscountCoupons({
    required this.code,
    required this.discountValue,
    required this.discountType,
    required this.validUntil,
    required this.maxUsers,
    required this.eventId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DiscountCoupons.fromJson(Map<String, dynamic> json) {
    return DiscountCoupons(
      code: json['code'],
      discountValue: json['discount_value'].toDouble(),
      discountType: json['discount_type'],
      validUntil: DateTime.parse(json['valid_until']),
      maxUsers: json['max_users'],
      eventId: json['event_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'discount_value': discountValue,
      'discount_type': discountType,
      'valid_until': validUntil.toIso8601String(),
      'max_users': maxUsers,
      'event_id': eventId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}