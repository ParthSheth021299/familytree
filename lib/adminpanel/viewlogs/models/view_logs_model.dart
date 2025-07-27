class ViewLogsModel {
  final String email;
  final String password;
  final String createdAt;
  final bool isActive;

  ViewLogsModel({
    required this.email,
    required this.password,
    required this.createdAt,
    required this.isActive,
  });
  factory ViewLogsModel.fromJson(Map<String, dynamic> json) {
    return ViewLogsModel(
      email: json['email'].toString(),
      password: json['password'].toString(),
      createdAt: json['createdAt'].toString(),
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email.toString(),
      'password': password.toString(),
      'createdAt': createdAt.toString(),
      'isActive': isActive,
    };
  }

  factory ViewLogsModel.empty() =>
      ViewLogsModel(email: '', password: '', createdAt: '', isActive: true);
}
