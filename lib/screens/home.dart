import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:teamsyncai/screens/appbar.dart';
import 'package:teamsyncai/screens/calenderscreen/calendar_screen.dart';
import 'package:teamsyncai/screens/chatscreen/chatroom.dart';
import 'package:teamsyncai/screens/dashboardscreen/plus.dart';
import 'package:teamsyncai/screens/dashboardscreen/project4.dart';
import 'package:teamsyncai/screens/profile.dart';
import 'package:teamsyncai/screens/task.dart/modulesList.dart';
import 'package:teamsyncai/screens/task.dart/taskPage.dart';
import 'package:teamsyncai/screens/task.dart/taskmain.dart';
import 'package:http/http.dart' as http;
import '../../model/module.dart';
import '../../model/project.dart';
import '../../model/task.dart';
import '../../services/api_service.dart';
import '../../services/task_module_service.dart';


class home extends StatefulWidget {
  final String email;

  const home({required this.email});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<home> with Task_Module_service {
  late ScrollController _scrollController;
  int _selectedIndex = 0;
  List<Project> projects = [];
  late Future<List<Module>> _modulesFuture;

  @override
  void initState() {
    super.initState();
    fetchProjectsByEmail();
    _modulesFuture = fetchModulesByEmail(widget.email);

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == 0) {
      setState(() {
        _modulesFuture = fetchModulesByEmail(widget.email);
        fetchProjectsByEmail();
      });
    }
  }
  Future<void> _refreshData() async {
    setState(() {
      fetchProjectsByEmail();
      _modulesFuture = fetchModulesByEmail(widget.email);
    });
  }



  void fetchProjectsByEmail() async {
    try {
      List<Project> fetchedProjects = await ApiService.fetchProjects(
          email: widget.email);
      setState(() {
        projects = fetchedProjects;
      });
    } catch (e) {
      print('Error fetching projects: $e');
    }
  }
  Future<Map<String, dynamic>> fetchProjects() async {
    final response =
    await http.get(Uri.parse('http://192.168.128.222:3000/projectss'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load projects');
    }
  }


  Future<String> fetchProjectName(String projectId) async {
    try {
      final response = await http.get(Uri.parse('http://192.168.128.222:3000/project/$projectId'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['projectName'];
      } else {
        throw Exception('Failed to fetch project name');
      }
    } catch (error) {
      print('Error fetching project name: $error');
      throw Exception('Failed to fetch project name');
    }
  }
  double calculateCompletionPercentage(List<Task> tasks) {
    if (tasks.isEmpty) return 0;
    int completedCount = 0;
    for (var task in tasks) {
      if (task.completed) completedCount++;
    }
    return (completedCount / tasks.length) * 100;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => taskmain(email: widget.email)),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProjectFirst(email: widget.email)),
      );
    }
        if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CalendarScreen(email: widget.email)),
      );
    }

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatroomListPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 25.0,
              backgroundImage: AssetImage('assets/images/zz.png'),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning !',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.email.split('@').first,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Spacer(),
            Text(
              'TeamSyncAi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              children: const [
                SizedBox(width: 15),
                Text(
                  'Projects',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < projects.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: SizedBox(
                      width: 250,
                      height: 200,
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.orangeAccent,
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.business, // Default project icon
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      projects[i].name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Team Leader: ${projects[i].teamLeader.split('@').first}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProjectFourth(
                                            projectId: projects[i].id ?? '',
                                            projectName: projects[i].name,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'End Date: ${formatDate(projects[i].endDate)}',
                                      style: const TextStyle(
                                        color: Colors.orange,
                                        fontSize: 14,
                                      ),
                                    ),
                                    if (projects[i].teamLeader == widget.email)
                                      GestureDetector(
                                        onTap: () async {
                                          final bool confirmDelete = await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Confirm Delete'),
                                                content: const Text('Are you sure you want to delete this project?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.of(context).pop(false),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () => Navigator.of(context).pop(true),
                                                    child: const Text('Delete'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          if (confirmDelete == true) {
                                            // Delete the project
                                            await ApiService.deleteProject(projects[i].id!);
                                            setState(() {
                                              projects.removeAt(i);
                                            });
                                          }
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.orange,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ),
                  ),
              ],
            ),
          ),
            const SizedBox(height: 8),
            Row(
              children: const [
                SizedBox(width: 15),
                Text(
                  'Modules',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<Module>>(
                future: _modulesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<Module> modules = snapshot.data!;
                    return ListView.builder(
                      itemCount: modules.length,
                      itemBuilder: (context, index) {
                        var module = modules[index];
                        return FutureBuilder<String>(
                          future: fetchProjectName(module.projectID),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              String projectName = snapshot.data!;
                              return FutureBuilder<double>(
                                future: fetchCompletionPercentage(
                                    module.module_id),
                                builder: (context, completionSnapshot) {
                                  double completionPercentage =
                                      completionSnapshot.data ?? 0.0;
                                  return ListTileModule(
                                    projectTitle: projectName,
                                    moduleTitle: module.module_name,
                                    teamMembers: module.teamM,
                                    profileImagePaths: const [
                                      'assets/images/zz.png'
                                    ],
                                    percentage: completionPercentage,
                                    imagePath: 'assets/images/orange.jpg',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TasksPage(
                                            moduleId: module.module_id,
                                            moduleName: module.module_name,
                                            teamMembers: module.teamM,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            }
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Profile(email: widget.email)),
          );
        },
        child: const Icon(Icons.person_remove),
      ),
    );
  }
}


class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.orange,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.black,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.plus_one_outlined),
          label: 'Plus',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_view_week_rounded),
          label: 'Calander',
        ),
        
      ],
    );
  }
}