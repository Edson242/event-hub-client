enum DiscountType { porcentagem, fixo }

extension DiscountTypeExtension on DiscountType {
  String get value {
    switch (this) {
      case DiscountType.porcentagem:
        return 'PORCENTAGEM';
      case DiscountType.fixo:
        return 'FIXO';
    }
  }

  static DiscountType fromValue(String value) {
    switch (value.toUpperCase()) {
      case 'PORCENTAGEM':
        return DiscountType.porcentagem;
      case 'FIXO':
        return DiscountType.fixo;
      default:
        throw ArgumentError('Unknown discount type: $value');
    }
  }
}

class DiscountDTO {
  final DiscountType discount;

  const DiscountDTO({required this.discount});

  factory DiscountDTO.fromJson(Map<String, dynamic> json) {
    final discountValue = json['discount'] as String?;
    if (discountValue == null) {
      throw ArgumentError('Discount is required in JSON');
    }
    return DiscountDTO(discount: DiscountTypeExtension.fromValue(discountValue));
  }

  Map<String, dynamic> toJson() => {
        'discount': discount.value,
      };

  @override
  String toString() => 'DiscountDto(discount: ${discount.value})';
}