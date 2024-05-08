import 'package:flutter/material.dart';
import 'package:teamsyncai/model/reclamation.dart';
import 'package:teamsyncai/services/ReclamationService.dart';
import 'package:teamsyncai/screens/screenrec/filterDialog.dart';
import 'package:teamsyncai/screens/screenrec/details.dart';
import 'package:teamsyncai/screens/screenrec/deleteDialog.dart';

class FeedbackScreen extends StatefulWidget {
 final String email;
  const FeedbackScreen({super.key, required this.email});
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  List<Reclamation> allFeedbacks = [];
  List<Reclamation> feedbacks = [];
  int numberOfSuggestions = 0; 

  @override
  void initState() {
    super.initState();
    _fetchFeedbacks();
  }

String getCurrentUserEmail() {

    return widget.email;
  }
 Future<void> _fetchFeedbacks() async {
  try {
    String userEmail = getCurrentUserEmail(); 

    Map<String, dynamic> result = await ReclamationService.fetchReclamations('feedback', userEmail);
    List<Reclamation> suggestions = result['reclamations'];

    setState(() {
      allFeedbacks = suggestions;
      feedbacks = suggestions;
      numberOfSuggestions = suggestions.length; 
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
    print("Error fetching idea suggestions: $e");
  }
}


  void updateNumberOfSuggestions() {
    setState(() {
      numberOfSuggestions = feedbacks.length;
          print('Number of suggestions: $numberOfSuggestions'); 

    });
  }

  Widget _buildFeedbackItem(Reclamation feedback) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(
              reclamation: feedback,
              reclamationList: feedbacks,
              setStateCallback: () {
                setState(() {});
              },
            ),
          ),
        );
      },
      child: Dismissible(
        key: Key(feedback.id),
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

  ReclamationService.deleteReclamation(feedback.id, feedbacks, () {
    setState(() {
      updateNumberOfSuggestions(); 
    });
  });
},

        child: Container(
          height: 150, // Fixed height of 150
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
                  feedback.title,
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 20.0),
                Text(
                  feedback.description.length > 40
                      ? '${feedback.description.substring(0, 40)}...'
                      : feedback.description,
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
                          feedback.projectName,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                   
                    Spacer(),
                    Text(
                      '${feedback.date.substring(8, 10)}-${feedback.date.substring(5, 7)}-${feedback.date.substring(0, 4)}',
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
          'Feedbacks',
          style: TextStyle(fontWeight: FontWeight.bold ),
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
    itemCount: feedbacks.length,
    itemBuilder: (context, index) {
      feedbacks.sort((a, b) => b.date.compareTo(a.date));
      
      final feedback = feedbacks[index];
      return _buildFeedbackItem(feedback);
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
              feedbacks = List.from(allFeedbacks);

              
              if (date != null && filterType != null) {
                switch (filterType) {
                  case DateFilterType.Year:
                    feedbacks = feedbacks.where((reclamation) {
                      DateTime reclamationDate =
                          DateTime.parse(reclamation.date);
                      return reclamationDate.year == date.year;
                    }).toList();
                    break;
                  case DateFilterType.Month:
                    feedbacks = feedbacks.where((reclamation) {
                      DateTime reclamationDate =
                          DateTime.parse(reclamation.date);
                      int monthFromDatabase = int.parse(
                          reclamationDate.month.toString().padLeft(2, '0'));
                      return monthFromDatabase == date.month;
                    }).toList();
                    break;
                  case DateFilterType.FullDate:
                    feedbacks = feedbacks.where((reclamation) {
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
                feedbacks = feedbacks.where((reclamation) {
                  return reclamation.projectName.toLowerCase().contains(project.toLowerCase());
                }).toList();
              }

            });
          },
        );
      },
    );
  }


}