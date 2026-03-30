class SubscriptionModel {
  final String id;
  final String type;
  final DateTime startDate;
  final DateTime endDate;

  SubscriptionModel({
    required this.id,
    required this.type,
    required this.startDate,
    required this.endDate,
  });

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  SubscriptionModel copyWith({
    String? id,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
