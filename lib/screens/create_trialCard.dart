import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamsyncai/providers/trialCard_provider.dart';
import 'package:teamsyncai/screens/home.dart'; // Import your TrialCardProvider

class CreateTrialCardScreen extends StatelessWidget {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expirationDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final trialCardProvider = context.read<TrialCardProvider>(); // Use context.read to access the provider

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Trial Card'),
        backgroundColor: Colors.orange, // Set the app bar color to orange
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/credit_card.png', // Replace with your image path
                    height: 150, // Adjust the height as needed
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextField(
                          controller: cardNumberController,
                          decoration: InputDecoration(labelText: 'Card Number'),
                        ),
                        TextField(
                          controller: expirationDateController,
                          decoration: InputDecoration(labelText: 'Expiration Date'),
                        ),
                        TextField(
                          controller: cvvController,
                          decoration: InputDecoration(labelText: 'CVV'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Create trial card
                            trialCardProvider.createTrialCard(
                              cardNumber: cardNumberController.text,
                              expirationDate: expirationDateController.text,
                              cvv: cvvController.text,
                            );
                            Navigator.pop(context); // Go back to the previous screen
                            Navigator.push(context, MaterialPageRoute(builder: (context) => home(email: ''))); // Navigate to the Home page
                          },
                          child: Text('Create Trial Card'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}