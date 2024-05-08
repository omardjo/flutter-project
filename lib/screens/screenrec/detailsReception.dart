import 'package:flutter/material.dart';
import 'package:teamsyncai/model/reclamation.dart';
import 'package:teamsyncai/services/ReclamationService.dart';

class DetailsReceptionScreen extends StatelessWidget {
  final Reclamation reclamation;
  final List<Reclamation> reclamationList;
  final Function setStateCallback;
    final BuildContext context;


  const DetailsReceptionScreen({
    Key? key,
    required this.reclamation,
    required this.reclamationList,
    required this.setStateCallback,
        required this.context, 

  }) : super(key: key);

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Report Details',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.orange ,
    ),
    body: SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              kToolbarHeight,
        ),
        child: Stack(
          children: [
           
             Positioned.fill(
  child: Image(
    image: AssetImage("assets/imageRec/flow.png"),
    fit: BoxFit.cover,
    colorBlendMode: BlendMode.dstATop,
    color: Colors.white.withOpacity(0.2),
  ),
),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.9),
    border: Border.all(color: Colors.black.withOpacity(1)),
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
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            'Received from : ${reclamation.userEmail}',
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
                                text:
                                    '${reclamation.date.substring(8, 10)}-${reclamation.date.substring(5, 7)}-${reclamation.date.substring(0, 4)}',
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
                        SizedBox(height: 20),
                        if (reclamation.type != 'feedback')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Container(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Are you certain you want to proceed with this action?",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Cancel',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);

                                                      acceptComplaint();
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.white,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.check,
                                                            color:
                                                                Colors.green),
                                                        Text('Yes',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.check, color: Colors.green),
                                label: Text('Accept',
                                    style: TextStyle(color: Colors.green)),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Container(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Are you certain you want to proceed with this action?",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Cancel',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      rejectComplaint();
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.white,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.close,
                                                            color:
                                                                Colors.orange),
                                                        Text('Yes',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .orange)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.close, color: Colors.white),
                                label: Text('Reject',
                                    style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                ),
                              ),
                            ],
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
    ),
  );
}
 void acceptComplaint() {
  Map<String, dynamic> updatedInfoData = {'status': 'Accepted'};
  ReclamationService.updateReclamation(reclamation.id, updatedInfoData);

  setStateCallback();
  Navigator.pop(context); 
}

void rejectComplaint() {
  Map<String, dynamic> updatedInfoData = {'status': 'Rejected'};
  ReclamationService.updateReclamation(reclamation.id, updatedInfoData);

  reclamationList.removeWhere((item) => item.id == reclamation.id);
  setStateCallback(); 
    Navigator.pop(context); 

}


}