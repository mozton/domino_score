import 'package:equatable/equatable.dart';

class ContactEntity extends Equatable {
  final String id; // ID único del contacto en esta agenda
  final String?
  registeredUserId; // Si el amigo tiene cuenta en la app, guardamos su UID aquí
  final bool
  isRegisteredUser; // Para saber si invitarlo por push notification o solo anotarlo
  final String displayName;
  final String? nickname;
  final String? avatarUrl;
  final DateTime addedAt;

  const ContactEntity({
    required this.id,
    this.registeredUserId,
    required this.isRegisteredUser,
    required this.displayName,
    this.nickname,
    this.avatarUrl,
    required this.addedAt,
  });

  @override
  List<Object?> get props => [
    id,
    registeredUserId,
    isRegisteredUser,
    displayName,
    nickname,
    avatarUrl,
    addedAt,
  ];
}
