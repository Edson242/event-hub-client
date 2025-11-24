enum TicketStatusType { pendente, ativo, utilizado, cancelado }

extension TicketStatusTypeExtension on TicketStatusType {
  String get value {
    switch (this) {
      case TicketStatusType.pendente:
        return 'PENDENTE';
      case TicketStatusType.ativo:
        return 'ATIVO';
      case TicketStatusType.cancelado:
        return 'CANCELADO';
      case TicketStatusType.utilizado:
        return 'UTILIZADO';
    }
  }

  static TicketStatusType fromValue(String value) {
    switch (value.toUpperCase()) {
      case 'PENDENTE':
        return TicketStatusType.pendente;
      case 'ATIVO':
        return TicketStatusType.ativo;
      case 'CANCELADO':
        return TicketStatusType.cancelado;
      case 'UTILIZADO':
        return TicketStatusType.utilizado;
      default:
        throw ArgumentError('Unknown status: $value');
    }
  }
}

class TicketStatusDTO {
  final TicketStatusType ticketStatus;

  const TicketStatusDTO({required this.ticketStatus});

  factory TicketStatusDTO.fromJson(Map<String, dynamic> json) {
    final ticketStatusValue = json['ticketStatus'] as String?;
    if (ticketStatusValue == null) {
      throw ArgumentError('ticketStatus is required in JSON');
    }
    return TicketStatusDTO(ticketStatus: TicketStatusTypeExtension.fromValue(ticketStatusValue));
  }

  Map<String, dynamic> toJson() => {
        'ticketStatus': ticketStatus.value,
      };

  @override
  String toString() => 'TicketStatusDto(ticketStatus: ${ticketStatus.value})';
}