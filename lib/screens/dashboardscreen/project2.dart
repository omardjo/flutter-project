import 'package:flutter/material.dart';
import 'package:teamsyncai/screens/dashboardscreen/project3.dart';
import '../../model/project.dart';
import '../../services/api_service.dart';


class ProjectSecond extends StatefulWidget {
  final String projectName;
  final DateTime? startDate;
  final DateTime? endDate;
  final String description;

  const ProjectSecond({
    key,
    required this.projectName,
    required this.startDate,
    required this.endDate,
    required this.description,
  });

  @override
  _ProjectSecondState createState() => _ProjectSecondState();
}

class _ProjectSecondState extends State<ProjectSecond> {
  TextEditingController teamLeaderController = TextEditingController();
  TextEditingController membersController = TextEditingController();
  TextEditingController keywordsController = TextEditingController();

  bool _isLoading = false;

  Future<void> createProject() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String teamLeader = teamLeaderController.text;
      String members = membersController.text;
      String keywords = keywordsController.text;

      List<String> memberList =
      members.isNotEmpty ? members.split(',') : [];
      if (teamLeader.isNotEmpty) {
        memberList.add(teamLeader);
      }
      List<String> keywordList =
      keywords.isNotEmpty ? keywords.split(',') : [];

      DateTime startDate = widget.startDate ?? DateTime.now();
      DateTime endDate = widget.endDate ?? DateTime.now();

      Project project = Project(
        name: widget.projectName,
        startDate: startDate,
        endDate: endDate,
        description: widget.description,
        keywords: keywordList,
        teamLeader: teamLeader,
        members: memberList,
      );

      Map<String, dynamic>? projectData =
      await ApiService.createProject(project);

      if (projectData.containsKey('projectID')) {
        String projectId = projectData['projectID'];

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProjectThird(
              projectId: projectId,
              projectName: project.name,
              teamLeader: project.teamLeader,
              members: project.members,
              keywords: project.keywords,
              startDate: project.startDate,
              endDate: project.endDate,
            ),
          ),
        );
      } else {
        throw Exception(
            'Project data is null or does not contain projectID field');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Empty Fields'),
            content: const Text('All fields must be non-empty.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creating The Project'),
        backgroundColor: const Color(0xFFE89F16),
      ),
      backgroundColor: const Color(0xFFFFFFFF),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Project Leader',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: teamLeaderController,
                      decoration: InputDecoration(
                        labelText: 'Enter the email of the project leader',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintStyle: TextStyle(color: Colors.grey.withOpacity(0.0)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Members (emails)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: membersController,
                      decoration: InputDecoration(
                        labelText: 'Enter the emails of the members',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintStyle: TextStyle(color: Colors.grey.withOpacity(0.0)),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Keywords',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: keywordsController,
                      decoration: InputDecoration(
                        labelText: 'Enter words that describe the project',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintStyle: TextStyle(color: Colors.grey.withOpacity(0.0)),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 150),
                    ElevatedButton(
                      onPressed: createProject,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE89F16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Create',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.orange,
                ),
              ),
            ),
        ],
      ),
    );
  }
}