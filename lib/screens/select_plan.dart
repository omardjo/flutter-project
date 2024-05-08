import 'package:flutter/material.dart';
import 'package:teamsyncai/providers/subscription_provider.dart'; 
import 'package:teamsyncai/screens/create_trialCard.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final SubscriptionProvider _provider = SubscriptionProvider();
  late String selectedPlan = 'trial'; // Initialize with a default value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
  title: const Text('Subscription Plans'),
  backgroundColor: Colors.orange, // Set the app bar color to orange
),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Subscription Plans',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            buildSubscriptionPlanTile('Trial', '30 days', '\$0', [
              'Access to AI for task management, chatroom suggestions, and calendar management',
              'Chatroom discussion without email notification and translation feature',
              'Suggestions while chatting with others'
            ]),
                const SizedBox(height: 20),
            buildSubscriptionPlanTile('1 week', '7 days', '\$4', [
              'Access to AI for task management, chatroom suggestions, and calendar management',
              'Chatroom discussion without email notification and translation feature',
              'Suggestions while chatting with others'
            ]),
                   const SizedBox(height: 20),
            buildSubscriptionPlanTile('1 month', '30 days', '\$15', [
              'Access to AI for task management, chatroom suggestions, and calendar management',
              'Chatroom discussion without email notification and translation feature',
              'Suggestions while chatting with others'
            ]),
                 const SizedBox(height: 20),
            buildSubscriptionPlanTile('1 year', '365 days', '\$150', [
              'Access to AI for task management, chatroom suggestions, and calendar management',
              'Chatroom discussion without email notification and translation feature',
              'Suggestions while chatting with others'
            ]),
            // Other subscription plan tiles
            const SizedBox(height: 20),
            const Text(
              'Select a subscription type:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedPlan,
              onChanged: (value) async {
                setState(() {
                  selectedPlan = value!;
                });
              },
              items: const [
                DropdownMenuItem(value: 'trial', child: Text('Trial')),
                DropdownMenuItem(value: '1 week', child: Text('1 Week')),
                DropdownMenuItem(value: '1 month', child: Text('1 Month')),
                DropdownMenuItem(value: '1 year', child: Text('1 Year')),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (selectedPlan.isEmpty) {
                    // Show an error message or handle the case where no plan is selected
                    return;
                  }
                  // Create subscription based on the selected plan
                  await _provider.createSubscription(selectedPlan);
                  // Navigate to CreateTrialCardScreen after successful subscription creation
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  CreateTrialCardScreen(),
                    ),
                  );
                } catch (e) {
                  // Handle error if subscription creation fails
                  print('Failed to create subscription: $e');
                }
              },
              child: const Text('Select'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSubscriptionPlanTile(
      String title, String duration, String price, List<String> features) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Duration: $duration'),
            const SizedBox(height: 8),
            Text('Price: $price'),
            const SizedBox(height: 8),
            const Text('Features:'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: features.map((feature) => Text('- $feature')).toList(),
            ),
          ],
        ),
      ),
    );
  }
}