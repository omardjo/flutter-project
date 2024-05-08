import 'package:teamsyncai/model/trialCard_model.dart';

class Subscription {
  final String id;
  final String type;
  final List<String> features;
  final bool valid;
  final List<TrialCard> trialCards;
  final int price;
  final int duration;

  Subscription({
    required this.type,
    this.id = '',
    this.features = const [],
    this.valid = false,
    this.trialCards = const [],
    this.price = 0,
    this.duration = 0,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['_id'],
      type: json['type'],
      features: List<String>.from(json['features']),
      valid: json['valid'] ?? false,
      trialCards: (json['trialCards'] as List).map((card) => TrialCard.fromJson(card)).toList(),
      price: json['price'] ?? 0,
      duration: json['duration'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'features': features,
      'valid': valid,
      'trialCards': trialCards.map((card) => card.toJson()).toList(),
      'price': price,
      'duration': duration,
    };
  }
}