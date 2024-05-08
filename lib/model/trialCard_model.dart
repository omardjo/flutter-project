class TrialCard {
  final String cardNumber;
  final DateTime expirationDate;
  final String cvv;

  TrialCard({
    required this.cardNumber,
    required this.expirationDate,
    required this.cvv,
  });

  factory TrialCard.fromJson(Map<String, dynamic> json) {
    return TrialCard(
      cardNumber: json['cardNumber'],
      expirationDate: DateTime.parse(json['expirationDate']),
      cvv: json['cvv'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cardNumber': cardNumber,
      'expirationDate': expirationDate.toIso8601String(),
      'cvv': cvv,
    };
  }
}