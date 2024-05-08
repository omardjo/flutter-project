import 'package:flutter/material.dart';
import 'package:teamsyncai/model/reclamation.dart';
import 'package:teamsyncai/services/ReclamationService.dart';
import 'package:teamsyncai/screens/screenrec/filterDialog.dart';
import 'package:teamsyncai/screens/screenrec/details.dart';
import 'package:teamsyncai/screens/screenrec/deleteDialog.dart';
class ManagmentScreen extends StatefulWidget {
   final String email;
  const ManagmentScreen({super.key, required this.email});
  @override
  _ManagmentScreenState createState() => _ManagmentScreenState();
}

class _ManagmentScreenState extends State<ManagmentScreen> {
  List<Reclamation> allManagments = [];
  List<Reclamation> managments = [];
  int numberOfSuggestions = 0; 

  @override
  void initState() {
    super.initState();
    _fetchManagments();
  }


String getCurrentUserEmail() {

    return widget.email; 
  }
 Future<void> _fetchManagments() async {
  try {
    String userEmail = getCurrentUserEmail(); 

    Map<String, dynamic> result = await ReclamationService.fetchReclamations('task%20and%20project%20management', userEmail);
    List<Reclamation> suggestions = result['reclamations'];

    setState(() {
      allManagments = suggestions;
      managments = suggestions;
      numberOfSuggestions = suggestions.length; // Mettre à jour le nombre initial
    });

    if (numberOfSuggestions == 0) {
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
    print("Error fetching management: $e");
  }
}


  void updateNumberOfSuggestions() {
    setState(() {
      numberOfSuggestions = managments.length;
          print('Number of management: $numberOfSuggestions'); 

    });
  }

  Widget _buildManagmentItem(Reclamation managment) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(
              reclamation: managment,
              reclamationList: managments,
              setStateCallback: () {
                setState(() {});
              },
            ),
          ),
        );
      },
      child: Dismissible(
        key: Key(managment.id),
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

  ReclamationService.deleteReclamation(managment.id,  managments, () {
    setState(() {
      updateNumberOfSuggestions(); 
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
                  managment.title,
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 20.0),
                Text(
                  managment.description.length > 40
                      ? '${managment.description.substring(0, 40)}...'
                      : managment.description,
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
                          managment.projectName,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    _buildStatusCircle(managment.status),
                    SizedBox(width: 10),
                    Text(
                      managment.status,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    Spacer(),
                    Text(
                      '${managment.date.substring(8, 10)}-${managment.date.substring(5, 7)}-${managment.date.substring(0, 4)}',
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
          backgroundColor: Colors.orange, // Changer la couleur de l'AppBar en orange

        title: Text(
          'Task and project management',
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
    itemCount: managments.length,
    itemBuilder: (context, index) {
      // Tri de managments par date (de la plus récente à la plus ancienne)
      managments.sort((a, b) => b.date.compareTo(a.date));
      
      final managment = managments[index];
      return _buildManagmentItem(managment);
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
              managments = List.from(allManagments);

              if (status != null) {
                managments = managments.where((reclamation) {
                  return reclamation.status.toLowerCase() ==
                      status.toLowerCase();
                }).toList();
              }
              if (date != null && filterType != null) {
                switch (filterType) {
                  case DateFilterType.Year:
                    managments = managments.where((reclamation) {
                      DateTime reclamationDate =
                          DateTime.parse(reclamation.date);
                      return reclamationDate.year == date.year;
                    }).toList();
                    break;
                  case DateFilterType.Month:
                    managments = managments.where((reclamation) {
                      DateTime reclamationDate =
                          DateTime.parse(reclamation.date);
                      int monthFromDatabase = int.parse(
                          reclamationDate.month.toString().padLeft(2, '0'));
                      return monthFromDatabase == date.month;
                    }).toList();
                    break;
                  case DateFilterType.FullDate:
                    managments = managments.where((reclamation) {
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
                managments = managments.where((reclamation) {
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