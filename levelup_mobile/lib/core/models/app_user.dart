class AppUser {
  final int id;
  final String email;
  final String nickname;
  final String? timezone;

  AppUser({
    required this.id,
    required this.email,
    required this.nickname,
    this.timezone,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: (json['id'] ?? 0) as int,
      email: (json['email'] ?? '') as String,
      nickname: (json['nickname'] ?? '') as String,
      timezone: json['timezone'] as String?,
    );
  }
}