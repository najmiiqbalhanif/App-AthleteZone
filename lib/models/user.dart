class User {
  final String username;
  final String email;
  final String fullname;
  final String? profileImage;
  final String? password; // Optional, hanya dipakai saat register/login
  final int? id; // ID user dari backend, nullable karena tidak selalu dikirim dari client

  User({
    required this.username,
    required this.email,
    required this.fullname,
    this.profileImage,
    this.password,
    this.id,
  });

  // Digunakan saat ingin mengirim data ke backend (register/login)
  Map<String, dynamic> toJson() {
    final data = {
      'username': username,
      'email': email,
      'fullName': fullname,
      'profileImage': profileImage ?? '',
    };
    if (password != null) {
      data['password'] = password!;
    }
    return data;
  }

  // Digunakan saat menerima data dari backend (login response)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      fullname: json['fullName'],
      profileImage: json['profileImage'],
    );
  }
}