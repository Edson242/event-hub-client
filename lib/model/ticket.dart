int? _toInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is String) return int.tryParse(v);
  if (v is BigInt) return v.toInt();
  return null;
}

DateTime? _toDateTime(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  if (v is String) return DateTime.tryParse(v);
  return null;
}

class Ticket {
  final int? id;
  final int? ticketTypeId;
  final int? participantId;
  final int? discountCouponId;
  final String? ticketCode;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? issuedAt;
  final int? eventId;

  const Ticket({
    this.id,
    this.ticketTypeId,
    this.participantId,
    this.discountCouponId,
    this.ticketCode,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.issuedAt,
    this.eventId,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: _toInt(json['id']),
      ticketTypeId: _toInt(json['ticket_type_id']),
      participantId: _toInt(json['participant_id']),
      discountCouponId: _toInt(json['discount_coupon_id']),
      ticketCode: json['ticket_code'] as String?,
      status: json['status'] as String?,
      createdAt: _toDateTime(json['created_at']),
      updatedAt: _toDateTime(json['updated_at']),
      issuedAt: _toDateTime(json['issued_at']),
      eventId: _toInt(json['event_id']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'ticket_type_id': ticketTypeId,
        'participant_id': participantId,
        'discount_coupon_id': discountCouponId,
        'ticket_code': ticketCode,
        'status': status,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'issued_at': issuedAt?.toIso8601String(),
        'event_id': eventId,
      };

  Ticket copyWith({
    int? id,
    int? ticketTypeId,
    int? participantId,
    int? discountCouponId,
    String? ticketCode,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? issuedAt,
    int? eventId,
  }) {
    return Ticket(
      id: id ?? this.id,
      ticketTypeId: ticketTypeId ?? this.ticketTypeId,
      participantId: participantId ?? this.participantId,
      discountCouponId: discountCouponId ?? this.discountCouponId,
      ticketCode: ticketCode ?? this.ticketCode,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      issuedAt: issuedAt ?? this.issuedAt,
      eventId: eventId ?? this.eventId,
    );
  }

  @override
  String toString() {
    return 'Ticket(id: $id, ticketTypeId: $ticketTypeId, participantId: $participantId, '
        'discountCouponId: $discountCouponId, ticketCode: $ticketCode, status: $status, '
        'createdAt: $createdAt, updatedAt: $updatedAt, issuedAt: $issuedAt, eventId: $eventId)';
  }
}