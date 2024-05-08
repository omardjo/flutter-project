import 'package:flutter/material.dart';
import 'package:teamsyncai/screens/dashboardscreen/project6.dart';
import '../../model/module.dart';
import '../../model/task.dart';
import '../../services/api_service.dart';



class ProjectFifth extends StatefulWidget {
  final String moduleId;
  final String moduleName;
  final String projectId;
  final List<String> teamM;



  const ProjectFifth({key, required this.moduleId, required this.moduleName, required this.projectId, required this.teamM});

  @override
  State<ProjectFifth> createState() => _ProjectFifthState();
}

class _ProjectFifthState extends State<ProjectFifth> {
  List<Task> tasks = [];
  bool isLoading = true;
  late TextEditingController _moduleNameController;

  @override
  void initState() {
    super.initState();
    _moduleNameController = TextEditingController(text: widget.moduleName);
    fetchTasks();
  }

  @override
  void dispose() {
    _moduleNameController.dispose();
    super.dispose();
  }

  Future<void> fetchTasks() async {
    try {
      List<Task> fetchedTasks = await ApiService.fetchTasks(widget.moduleId);
      setState(() {
        tasks = fetchedTasks;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<void> _addDefaultTask() async {
    try {
      setState(() {
        isLoading = true;
      });

      Task newTask = await ApiService.createDefaultTask(widget.projectId, widget.moduleId);
      setState(() {
        tasks.add(newTask);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Module Tasks'),
        backgroundColor: const Color(0xFFE89F16),
      ),
      body: isLoading
          ? const Center
        (
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Module Name:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Enter Module Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintStyle: TextStyle(color: Colors.grey.withOpacity(0.0)),
              ),
              controller: _moduleNameController,
              onChanged: (value) {
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: updateModule,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE89F16),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text("Update Module Name"),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tasks:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tasks.length + 1,
              itemBuilder: (context, index) {
                if (index == tasks.length) {
                  return IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addDefaultTask,
                  );
                }
                Task task = tasks[index];
                return GestureDetector(
                  onTap: () {
                    navigateToProjectSixth(task);
                  },
                  child: Dismissible(
                    key: Key(task.taskId),
                    onDismissed: (direction) {
                      setState(() {
                        tasks.remove(task);
                      });
                      ApiService.deleteTask(task.taskId)
                          .then((_) {})
                          .catchError((error) {
                        setState(() {
                          tasks.add(task);
                        });
                      });
                    },
                    background: Container(
                      color: const Color(0xFFE89F16),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                task.taskDescription,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

          ],
        ),
      ),
    );
  }

  Future<void> updateModule() async {
    try {
      Module updatedModule = Module(
        module_id: widget.moduleId,
        module_name: _moduleNameController.text,
        projectID: widget.projectId,
        teamM: widget.teamM,
      );

      await ApiService.updateModule(widget.moduleId, updatedModule);

      Navigator.of(context).pop();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update module name'),
          backgroundColor: Color(0xFFE89F16),
        ),
      );
    }
  }


  void navigateToProjectSixth(Task task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectSixth(taskId: task.taskId, initialTaskDescription: task.taskDescription),
      ),
    );

    if (result == true) {
      fetchTasks();
    }
  }
}