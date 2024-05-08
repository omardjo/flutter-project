import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:teamsyncai/model/trialCard_model.dart';


class TrialCardService {
  static const String baseUrl = 'https://backend-2-le95.onrender.com/trialCards';

  static Future<List<TrialCard>> getTrialCards() async {
    final response = await http.get(Uri.parse('$baseUrl/get'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => TrialCard.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load trial cards');
    }
  }

  static Future<TrialCard> createTrialCard(TrialCard card,String subscriptionId,String userEmail) async {
  


    final response = await http.post(
      Uri.parse('$baseUrl/add?subscriptionId=$subscriptionId&email=$userEmail'),
      body: json.encode(card.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      return TrialCard.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create trial card');
    }
  }

}