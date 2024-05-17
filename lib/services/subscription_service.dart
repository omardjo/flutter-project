import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:teamsyncai/model/subscription_model.dart';

class SubscriptionService {
  static const String baseUrl = 'http://192.168.1.11:3000/subscriptions';
  static Future<List<Subscription>> getSubscriptions() async {
    final response = await http.get(Uri.parse('$baseUrl/get'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => _mapSubscriptionFromJson(model)).toList();
    } else {
      throw Exception('Failed to load subscriptions');
    }
  }

  static Subscription _mapSubscriptionFromJson(Map<String, dynamic> json) {
    return Subscription(
      type: json['type'] ?? '', // Handle null if necessary
      features: List<String>.from(json['features'] ?? []),
      price: json['price'] ?? 0,
    );
  }

  static Future<Subscription> createSubscription(String userEmail, String subscriptionType) async {
  final response = await http.post(
    Uri.parse('$baseUrl/create?email=$userEmail'), // Include userEmail in req.query
    body: json.encode({'type': subscriptionType}), // Send subscriptionType in the body
    headers: {'Content-Type': 'application/json'},
  );
  if (response.statusCode == 201) {
    return Subscription.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create subscription');
  }
}

}