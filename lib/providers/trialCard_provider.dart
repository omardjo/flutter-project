import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teamsyncai/model/trialCard_model.dart';
import 'package:teamsyncai/providers/subscription_provider.dart';
import 'package:teamsyncai/providers/userprovider.dart';
import 'package:teamsyncai/services/trialCard_service.dart'; // Import your service class

class TrialCardProvider extends ChangeNotifier {
  List<TrialCard> _trialCards = []; // Track the list of trial cards

  List<TrialCard> get trialCards => _trialCards;

  void fetchTrialCards() async {
    try {
      _trialCards = await TrialCardService.getTrialCards();
      notifyListeners(); // Notify listeners of the data change
    } catch (e) {
      throw Exception('Failed to fetch trial cards');
    }
  }



  void createTrialCard({
  required String cardNumber,
  required String expirationDate,
  required String cvv,
}) async {
  try {
    TrialCard card = TrialCard(
      cardNumber: cardNumber,
      expirationDate: DateTime.parse(expirationDate),
      cvv: cvv,
    );

    String subscriptionId = (await SubscriptionProvider().getSubscriptionId()) ?? '';
    String userEmail = (await UserProvider().getUserEmailShared()) ?? '';

    await TrialCardService.createTrialCard(card, subscriptionId, userEmail);
    fetchTrialCards(); // Refresh the list after creating a new trial card
  } catch (e) {
    throw Exception('Failed to create trial card');
  }
}

}