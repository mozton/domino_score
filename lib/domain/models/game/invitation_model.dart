enum InvitationStatus { pending, accepted, rejected }

class InvitationModel {
  final String id;
  final String groupId;
  final String fromUserId;
  final String toUserEmail;

  final InvitationStatus status;
  final DateTime createdAt;

  InvitationModel({
    required this.id,
    required this.groupId,
    required this.fromUserId,
    required this.toUserEmail,
    required this.status,
    required this.createdAt,
  });

  factory InvitationModel.fromJson(Map<String, dynamic> json) =>
      InvitationModel(
        id: json['id'],
        groupId: json['groupId'],
        fromUserId: json['fromUserId'],
        toUserEmail: json['toUserEmail'],
        status: InvitationStatus.values.firstWhere(
          (e) => e.toString() == json['status'],
        ),
        createdAt: DateTime.parse(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "groupId": groupId,
    "fromUserId": fromUserId,
    "toUserEmail": toUserEmail,
    "status": status.toString(),
    "createdAt": createdAt.toIso8601String(),
  };
}
