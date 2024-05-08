import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:teamsyncai/model/reclamation.dart';
import 'package:teamsyncai/screens/screenrec/typesreclamation/ideesuggestion.dart';
import 'package:teamsyncai/screens/screenrec/typesreclamation/signalement.dart';
import 'package:teamsyncai/screens/screenrec/typesreclamation/help.dart';
import 'package:teamsyncai/screens/screenrec/typesreclamation/health.dart';
import 'package:teamsyncai/screens/screenrec/typesreclamation/feedback.dart';
import 'package:teamsyncai/screens/screenrec/typesreclamation/managment.dart';
import 'package:teamsyncai/screens/screenrec/addReclamation.dart';
import 'package:teamsyncai/services/ReclamationService.dart';
import 'package:teamsyncai/screens/screenrec/detailsReception.dart';


class RecType {
  String type;
  int count;

  RecType({required this.type, required this.count});
}

class RecTypeState {
  final List<RecType> recTypes;

  RecTypeState(this.recTypes);

  RecTypeState copyWith({
    List<RecType>? recTypes,
  }) {
    return RecTypeState(recTypes ?? this.recTypes);
  }
}

class RecTypeScreen extends StatefulWidget {
  final String email;

  const RecTypeScreen({super.key, required this.email});
  @override
  _RecTypeScreenState createState() => _RecTypeScreenState();
}


class _RecTypeScreenState extends State<RecTypeScreen> {
  int _selectedIndex = 0;
  late RecTypeState state;
    String selectedType = "All"; // Variable pour suivre l'élément sélectionné
  late List<Reclamation> receivedData;


 void initState() {
    state = RecTypeState([]);
    super.initState();
    fetchRecTypes();
      _horizontalScrollController = ScrollController();

  }
  String getCurrentUserEmail() {
    // Logique pour obtenir l'e-mail de l'utilisateur actuellement connecté
    // Par exemple, si vous utilisez une authentification, vous pouvez le récupérer à partir de là
    return widget.email; // Remplacez ceci par la logique réelle
  }
  void fetchRecTypes() {
  List<String> types = [
    'Ideas and suggestions',
    'Reporting problems',
    'Support Requests',
    'Task and project management',
    'Feedback',
    'Health',
  ];

 for (String type in types) {
  ReclamationService.fetchReclamations(type, getCurrentUserEmail()).then((data) {
    setState(() {
      state = RecTypeState([
        ...state.recTypes,
        RecType(type: type, count: data['count']),
      ]);
    });
  }).catchError((error) {
    print("Error fetching recTypes for $type: $error");
  });
}

}
void updateRecTypeCount(String type) {
  setState(() {
    var index = state.recTypes.indexWhere((element) => element.type.toLowerCase() == type.toLowerCase());
    if (index != -1) {
      state.recTypes[index].count--;
    }
  });
}



 void refreshRecTypes() {
    fetchRecTypes();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orange, 

        elevation: 0, 
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kBottomNavigationBarHeight),
          child: Material(
            child: Container(
              child: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list),
                    label: 'My Complaints',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.archive),
                    label: 'Received',
                  ),
                ],
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                selectedItemColor: Colors.orange,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ),
      ),
      body: _selectedIndex == 0 ? _buildMyComplaints() : _buildReceived(),
    );
  }
Widget _buildMyComplaints() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0, right: 16.0, bottom: 16.0),
          child: ListView.builder(
            itemCount: state.recTypes.length,
            itemBuilder: (context, index) {
              final recType = state.recTypes[index];
              return Dismissible(
                key: Key(recType.type),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.orange,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                  
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: const Text(
                          "Are you sure you want to clear this type of complaint?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        actions: <Widget>[
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextButton.icon(
                                  onPressed: () async {
                                    try {
                                      String reclamationType = state.recTypes[index].type.toLowerCase();

                                      print('Swiped reclamation type: $reclamationType');

                                      Map<String, dynamic> result = await ReclamationService.fetchReclamations('type', getCurrentUserEmail());
                                      List<Reclamation> reclamationList = result['reclamations'];

                                      String userEmail = getCurrentUserEmail();

                                      await ReclamationService.deleteReclamationsByType(
                                        reclamationType,
                                        userEmail,
                                        reclamationList,
                                        setState,
                                      );

                                      setState(() {
                                        state.recTypes[index].count = 0;

                                        List<RecType> updatedRecTypes = List.from(state.recTypes);
                                        updatedRecTypes.removeWhere((element) =>  false);
                                        state = RecTypeState(updatedRecTypes);
                                        refreshRecTypes();
                                      });

                                      refreshRecTypes();

                                      Navigator.of(context).pop(true);
                                    } catch (e) {
                                      print('Error fetching all reclamations: $e');
                                    }
                                    Navigator.of(context).pop(true);
                                  },
                                 icon: const Icon(Icons.clear, color: Colors.orange),
                                  label: const Text(
                                    "Clear",
                                    style: TextStyle(color: Colors.orange),
                                  ),
                                ),
                                const SizedBox(width: 20), 
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  icon: const Icon(Icons.cancel, color: Colors.black),
                                  label: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: GestureDetector(
                  onTap: () {
                    Widget targetScreen = Container();
                    switch (recType.type) {
                      case 'Ideas and suggestions':
                        targetScreen =  IdeeSuggestionScreen(email:widget.email);
                        break;
                      case 'Reporting problems':
                        targetScreen =  SignalementScreen(email:widget.email);
                        break;
                      case 'Support Requests':
                        targetScreen =  HelpScreen(email:widget.email);
                        break;
                      case 'Task and project management':
                        targetScreen =  ManagmentScreen(email:widget.email);
                        break;
                      case 'Feedback':
                        targetScreen =  FeedbackScreen(email:widget.email);
                        break;
                      case 'Health':
                        targetScreen = HealthScreen(email: widget.email);
                        break;
                      default:
                        print('Unhandled recType type: ${recType.type}');
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => targetScreen),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(color: Colors.orange, width: 2.0),
                    ),
                    child: ListTile(
                      title: Text(recType.type),
                      trailing: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(recType.count.toString()),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
        Container(
        alignment: Alignment.bottomCenter,
        child: Image.asset(
          'assets/imageRec/rectype.png', 
          height: 200, 
          width: 400, 
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
        child: FloatingActionButton(
          onPressed: () async {
            String? type = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddReclamation(email: widget.email)),
            );

            if(type != null){
              setState(() {
                var existingRecTypeIndex = state.recTypes.indexWhere((element) => element.type.toLowerCase() == type);
                if(existingRecTypeIndex != -1){
                  state.recTypes[existingRecTypeIndex].count++;
                } else {
                  state.recTypes.add(RecType(type: type, count: 1));
                }
              });
            }
          },
         child: const Icon(Icons.add, color: Colors.white),
    backgroundColor:  Colors.orange, 
    foregroundColor: Colors.orange, 
    elevation: 1.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      ),
    ],
  );
}



ScrollController _horizontalListScrollController = ScrollController();

ScrollController _horizontalScrollController = ScrollController();
@override
Widget _buildReceived() {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/imageRec/flow.png"),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
          Colors.white.withOpacity(0.2),
          BlendMode.dstATop,
        ),
      ),
    ),
    child: RefreshIndicator(
      onRefresh:_refreshList,
      child: FutureBuilder<List<Reclamation>>(
        future: ReclamationService.getReclamationsForUserManager(getCurrentUserEmail()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            receivedData = snapshot.data!;
            List<Reclamation> filteredData = selectedType == "all"
                ? receivedData
                : receivedData.where((reclamation) => reclamation.type == selectedType).toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                    controller:  _horizontalListScrollController,


                  child: Row(
                    children: [
                      SizedBox(width: 20.0),
                      _buildHorizontalScrollItem("All", 0),
                      _buildHorizontalScrollItem("Ideas and suggestions", 1),
                      _buildHorizontalScrollItem("Reporting problems", 2),
                      _buildHorizontalScrollItem("Task and project management", 3),
                      _buildHorizontalScrollItem("Feedback", 4),
                      _buildHorizontalScrollItem("Health", 5),
                      _buildHorizontalScrollItem("Support Requests", 6),
                      SizedBox(width: 20.0),
                    ],
                  ),
                ),
                SizedBox(height: 30.0),
                Expanded(
                  child: ListView.builder(
                    controller:_horizontalScrollController,
                    itemCount: filteredData.length,
                    itemBuilder: (BuildContext context, int index) {
                      filteredData.sort((a, b) => b.date.compareTo(a.date));

                      Reclamation reclamation = filteredData[index];
                      return GestureDetector(
                        onTap: () {
                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>DetailsReceptionScreen(
        reclamation: reclamation,
        reclamationList: receivedData,
        setStateCallback: () {
          setState(() {}); 
        },
        context: context, 
      ),

                            ),
                          );
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
                                    reclamation.title,
                                    style: const TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 20.0),
                                  Text(
                                    reclamation.description.length > 40
                                        ? '${reclamation.description.substring(0, 40)}...'
                                        : reclamation.description,
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
                                            reclamation.projectName,
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
                                        '${reclamation.date.substring(8, 10)}-${reclamation.date.substring(5, 7)}-${reclamation.date.substring(0, 4)}',
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
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    ),
  );
}
void _navigateToDetails(Reclamation reclamation) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DetailsReceptionScreen(
        reclamation: reclamation,
        reclamationList: receivedData,
        setStateCallback: () {
          setState(() {}); 
        },
        context: context, 
      ),
    ),
  );
  setState(() {}); 
}


Future<void> _refreshList() async {
  setState(() {
    
  });
}

List<String> types = ["All", "Ideas and suggestions", "Reporting problems", "Task and project management", "Feedback", "Health", "Support Requests"];

// Définir un contrôleur de défilement pour la liste horizontale

Widget _buildHorizontalScrollItem(String text, int index) {
  Color textColor = selectedType == types[index] ? Colors.orange : Colors.black;
  Color borderColor = selectedType == types[index] ? Colors.orange : Colors.black;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: GestureDetector(
      onTap: () {
        setState(() {
          selectedType = types[index] = text.toLowerCase();
          _scrollToSelected(index);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor), 
          borderRadius: BorderRadius.circular(15.0), 
          color: Colors.white, 
        ),
        padding: EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    ),
  );
}

void _scrollToSelected(int index) {
  // Calcul de la position de défilement pour centrer l'élément sélectionné
  final double screenWidth = MediaQuery.of(context).size.width;
  final double itemWidth = screenWidth + 20.0; // Largeur de chaque élément dans la liste
  final double selectedOffset = (itemWidth * index) - (screenWidth / 2) + (itemWidth / 2);

  // Vérifier si l'élément sélectionné est proche des bords
  if (selectedOffset < 0) {
    // Si l'élément est proche du bord gauche, défilez pour le ramener au centre
    _horizontalScrollController.jumpTo(0);
  } else if (selectedOffset > _horizontalScrollController.position.maxScrollExtent) {
    // Si l'élément est proche du bord droit, défilez pour le ramener au centre
    _horizontalScrollController.jumpTo(_horizontalScrollController.position.maxScrollExtent);
  } else {
    // Sinon, défilez pour centrer l'élément sélectionné
    _horizontalScrollController.animateTo(
      selectedOffset,
      duration: Duration(milliseconds: 500), // Animation de défilement
      curve: Curves.easeInOut, // Courbe d'animation
    );
  }
}






}