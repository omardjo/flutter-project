import 'package:flutter/material.dart';
import 'package:teamsyncai/screens/home.dart';

class CreateTrialCardScreen extends StatefulWidget {
  const CreateTrialCardScreen({Key? key}) : super(key: key);

  @override
  _CreateTrialCardScreenState createState() => _CreateTrialCardScreenState();
}

class _CreateTrialCardScreenState extends State<CreateTrialCardScreen> {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expirationDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  // Error messages
  String? cardNumberError;
  String? expirationDateError;
  String? cvvError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Trial Card'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/credit_card.png',
                        height: 150,
                      ),
                      TextField(
                        controller: cardNumberController,
                        decoration: InputDecoration(
                          labelText: 'Card Number',
                          errorText: cardNumberError,
                        ),
                        onChanged: (value) {
                          setState(() {
                            cardNumberError = value.length != 16 ? 'Invalid card number' : null;
                          });
                        },
                      ),
                      TextField(
                        controller: expirationDateController,
                        decoration: InputDecoration(
                          labelText: 'Expiration Date (MM/YY)',
                          errorText: expirationDateError,
                        ),
                        onChanged: (value) {
                          setState(() {
                            expirationDateError = !RegExp(r'^\d{2}/\d{2}$').hasMatch(value)
                                ? 'Invalid expiration date format'
                                : null;
                          });
                        },
                      ),
                      TextField(
                        controller: cvvController,
                        decoration: InputDecoration(
                          labelText: 'CVV',
                          errorText: cvvError,
                        ),
                        onChanged: (value) {
                          setState(() {
                            cvvError = value.length != 3 ? 'Invalid CVV' : null;
                          });
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Simple validation
                          if (cardNumberError == null && expirationDateError == null && cvvError == null) {
                            // Validation passed - Do something with the card data
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const home(email:'')));
                          } 
                        },
                        child: Text('Create Trial Card'),
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

