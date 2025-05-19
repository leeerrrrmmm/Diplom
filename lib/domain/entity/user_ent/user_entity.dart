class UserEntity {
  final String uid;
  final String displayName;
  final String email;
  final String? photoUrl;
  final DateTime? createdAt;

  UserEntity({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.createdAt,
    this.photoUrl,
  });
}
