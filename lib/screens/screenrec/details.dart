
import 'package:flutter/material.dart';
import 'package:teamsyncai/model/reclamation.dart';
import 'package:teamsyncai/services/ReclamationService.dart';

import 'package:teamsyncai/screens/screenrec/deleteDialog.dart';
class DetailsScreen extends StatelessWidget {
  final Reclamation reclamation;
  final List<Reclamation> reclamationList;
  final Function setStateCallback;

  const DetailsScreen({
    Key? key,
    required this.reclamation,
    required this.reclamationList,
    required this.setStateCallback,
  }) : super(key: key);

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
  backgroundColor: Colors.orange, 
  title: Text(
    "Report Details",
    style: TextStyle(
      color: Color.fromARGB(255, 0, 0, 0),
      fontWeight: FontWeight.bold,
    ),
  ),
  centerTitle: true,
  actions: [
    IconButton(
      onPressed: () {
        _showDeleteConfirmationDialog(context);
      },
      icon: Icon(Icons.delete, color: Colors.black),
    )
  ],
),

    body: SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - kToolbarHeight,
        ),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/imageRec/1111.png"),
              fit: BoxFit.cover,
             
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.9), 
    border: Border.all(color: Colors.black.withOpacity(0.8)),
    borderRadius: BorderRadius.circular(10.0),
  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              reclamation.title,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            if (reclamation.type != 'feedback') // Condition ajoutée ici
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildStatusCircle(reclamation.status),
                                  SizedBox(width: 8.0),
                                  Text(
                                    reclamation.status,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Send to: ${reclamation.emailManager}',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 20, color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Project Name: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: '${reclamation.projectName}',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 20, color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Date: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: '${reclamation.date.substring(8, 10)}-${reclamation.date.substring(5, 7)}-${reclamation.date.substring(0, 4)}',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 20, color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Description:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        reclamation.description,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}


  Widget _buildStatusCircle(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'in progress':
        color = Colors.orange;
        break;
      case 'accepted':
        color = Colors.green;
        break;
      case 'rejected':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
        break;
    }

    return Container(
      width: 20.0,
      height: 20.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

 void _showDeleteConfirmationDialog(BuildContext context) {
  DeleteDialogue.showDeleteConfirmationDialog(context).then((confirmed) {
    if (confirmed != null && confirmed) {
      _deleteReclamationEntry(context, reclamation.id);
    }
  });
}


  void _deleteReclamationEntry(BuildContext context, String reclamationId) async {
    await ReclamationService.deleteReclamation(reclamationId, reclamationList, setStateCallback);

    reclamationList.removeWhere((element) => element.id == reclamationId);
  setStateCallback();

    Navigator.of(context).pop();

    
  }
}