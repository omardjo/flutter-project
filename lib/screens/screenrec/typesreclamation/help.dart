import 'package:flutter/material.dart';
import 'package:teamsyncai/model/reclamation.dart';
import 'package:teamsyncai/services/ReclamationService.dart';
import 'package:teamsyncai/screens/screenrec/filterDialog.dart';
import 'package:teamsyncai/screens/screenrec/details.dart';
import 'package:teamsyncai/screens/screenrec/deleteDialog.dart';
class HelpScreen extends StatefulWidget {
     final String email;
  const HelpScreen({super.key, required this.email});

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  List<Reclamation> allHelps = [];
  List<Reclamation> helps = [];
  int numberOfSuggestions = 0; 

  @override
  void initState() {
    super.initState();
    _fetchHelps();
  }

String getCurrentUserEmail() {

    return widget.email; 
  }
 Future<void> _fetchHelps() async {
  try {
    String userEmail = getCurrentUserEmail(); 

    Map<String, dynamic> result = await ReclamationService.fetchReclamations('support%20requests', userEmail);
    List<Reclamation> suggestions = result['reclamations'];

    setState(() {
      allHelps = suggestions;
      helps = suggestions;
      numberOfSuggestions = helps.length; 
    });

    if (numberOfSuggestions== 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 8),
                Text(
                  "No complaint found",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();

                    },
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.orange),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.transparent,
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  } catch (e) {
    print("Error fetching  Helps: $e");
  }
}


  void updatenumberOfSuggestions() {
    setState(() {
      numberOfSuggestions = helps.length;
          print('Number of Helps: $numberOfSuggestions'); 

    });
  }

  Widget _buildHelpItem(Reclamation help) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(
              reclamation: help,
              reclamationList: helps,
              setStateCallback: () {
                setState(() {});
              },
            ),
          ),
        );
      },
      child: Dismissible(
        key: Key(help.id),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.orange,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
        confirmDismiss: (direction) async {
          return await DeleteDialogue.showDeleteConfirmationDialog(context);
        },
       onDismissed: (direction) {

  ReclamationService.deleteReclamation(help.id, helps, () {
    setState(() {
      updatenumberOfSuggestions(); 
    });
  });
},

        child: Container(
          height: 150, 
          margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            border: Border.all(color: Colors.black.withOpacity(0.8)),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  help.title,
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 20.0),
                Text(
                  help.description.length > 40
                      ? '${help.description.substring(0, 40)}...'
                      : help.description,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 18.0),
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          help.projectName,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    _buildStatusCircle(help.status),
                    SizedBox(width: 10),
                    Text(
                      help.status,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    Spacer(),
                    Text(
                      '${help.date.substring(8, 10)}-${help.date.substring(5, 7)}-${help.date.substring(0, 4)}',
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
        ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orange, 

        title: Text(
          'Support Request',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
        ],
      ),
   body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage("assets/imageRec/1111.png"),
          fit: BoxFit.cover,
         
        ),
      ),
      child: Column(
        children: [
          Expanded(
  child: ListView.builder(
    itemCount: helps.length,
    itemBuilder: (context, index) {
      // Tri de helps par date (de la plus récente à la plus ancienne)
      helps.sort((a, b) => b.date.compareTo(a.date));
      
      final help = helps[index];
      return _buildHelpItem(help);
    },
  ),
),
        ],
      ),
    ),
  );
}
  _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterDialog(
          onFilter: (String? status, DateFilterType? filterType, DateTime? date,
              String? project) {
            setState(() {
              helps = List.from(allHelps);

              if (status != null) {
                helps = helps.where((reclamation) {
                  return reclamation.status.toLowerCase() ==
                      status.toLowerCase();
                }).toList();
              }
              if (date != null && filterType != null) {
                switch (filterType) {
                  case DateFilterType.Year:
                    helps = helps.where((reclamation) {
                      DateTime reclamationDate =
                          DateTime.parse(reclamation.date);
                      return reclamationDate.year == date.year;
                    }).toList();
                    break;
                  case DateFilterType.Month:
                    helps = helps.where((reclamation) {
                      DateTime reclamationDate =
                          DateTime.parse(reclamation.date);
                      int monthFromDatabase = int.parse(
                          reclamationDate.month.toString().padLeft(2, '0'));
                      return monthFromDatabase == date.month;
                    }).toList();
                    break;
                  case DateFilterType.FullDate:
                    helps = helps.where((reclamation) {
                      DateTime reclamationDate =
                          DateTime.parse(reclamation.date);
                      return reclamationDate.year == date.year &&
                          reclamationDate.month == date.month &&
                          reclamationDate.day == date.day;
                    }).toList();
                    break;
                  default:
                }
              }
              if (project != null && project.isNotEmpty) {
                helps = helps.where((reclamation) {
                  return reclamation.projectName.toLowerCase().contains(project.toLowerCase());
                }).toList();
              }
            });
          },
        );
      },
    );
  }

  Widget _buildStatusCircle(String status) {
    Color color;
    switch (status) {
      case 'In progress':
        color = Colors.orange;
        break;
      case 'Accepted':
        color = Colors.green;
        break;
      case 'Rejected':
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
}