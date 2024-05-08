class Reclamation {
  final String id; // Ajoutez l'attribut id

  final String title;
  final String description;
  final String date;
  final String status;
  final String type;
  final String emailManager;
  final String projectName;
  final String userEmail;

  Reclamation({
    required this.id, // Assurez-vous d'inclure id dans le constructeur
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.type,
    required this.emailManager,
    required this.projectName,
    required this.userEmail,
  });

  factory Reclamation.fromJson(Map<String, dynamic> json) {
    return Reclamation(
      id: json['_id'], // Assurez-vous d'extraire correctement l'id du JSON
      title: json['title'],
      description: json['description'],
      date: json['date'],
      status: json['status'],
      type: json['type'],
      emailManager: json['emailManager'],
      projectName: json['projectName'],
      userEmail:json['userEmail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'status': status,
      'type': type,
      'emailManager': emailManager,
      'projectName': projectName,
      'userEmail' : userEmail
    };
  }
}