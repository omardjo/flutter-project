class User {
  final String? username;
  final String? email;
  final String? numTel;
  final String? password;
  final String? specialty;
  final String? role;
  final bool termsAccepted;

  const User({
    this.username,
    this.email,
    this.numTel,
    this.password,
    this.specialty,
    this.role = 'Client',
    this.termsAccepted = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final String role = json['role']?.toLowerCase() ?? 'Client';
    final validRoles = ['teamleader', 'client']; // Changed 'Client' to 'client'
    final selectedRole = validRoles.contains(role) ? role : 'client'; // Changed 'Client' to 'client'

    return User(
      username: json['username'],
      email: json['email'],
      numTel: json['numTel'],
      password: json['password'],
      specialty: json['specialty'],
      role: selectedRole,
      termsAccepted: json['termsAccepted'] ?? false,
    );
  }

  const User.empty()
      : username = null,
        email = null,
        numTel = null,
        password = null,
        specialty = null,
        role = null,
        termsAccepted = false;
}