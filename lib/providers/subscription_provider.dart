import 'dart:core';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teamsyncai/model/subscription_model.dart';
import 'package:teamsyncai/providers/userprovider.dart';
import 'package:teamsyncai/services/subscription_service.dart'; // Import your service class

class SubscriptionProvider extends ChangeNotifier {
  String _selectedPlan = ''; // Track the selected plan

  String get selectedPlan => _selectedPlan;

  // List of available subscription plans (replace with actual data)
  List<String> _subscriptionPlans = ['1 month', '1 week', '1 year', 'trial'];

  List<String> get subscriptionPlans => _subscriptionPlans;

  void selectTrialPlan() {
    _selectedPlan = 'trial'; // Set the selected plan to trial
    notifyListeners(); // Notify listeners of the change
  }

   set selectedPlan(String value) {
    _selectedPlan = value; // Setter for selectedPlan
    notifyListeners(); // Notify listeners of the change
  }

  Future<List<Subscription>> getSubscriptions() async {
    try {
      return await SubscriptionService.getSubscriptions();
    } catch (e) {
      throw Exception('Failed to load subscriptions');
    }
  }

  Future<Subscription> createSubscription(String subscriptionType) async {
    try {
      // Get the user email asynchronously from UserProvider
      String userEmail = (await UserProvider().getUserEmailShared()) ?? '';
      // Pass the user email to the service method
      Subscription newSubscription = await SubscriptionService.createSubscription(userEmail, subscriptionType);
      
      // Save the subscription ID
      await saveSubscriptionId(newSubscription.id);

      return newSubscription;
    } catch (e) {
      throw Exception('Failed to create subscription');
    }
  }

  Future<void> saveSubscriptionId(String subscriptionId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('subscriptionId', subscriptionId);
  }

  Future<String?> getSubscriptionId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('subscriptionId');
  }
}