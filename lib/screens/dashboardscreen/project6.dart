import 'package:flutter/material.dart';

import '../../model/task.dart';
import '../../services/api_service.dart';


class ProjectSixth extends StatefulWidget {
  final String taskId;
  final String initialTaskDescription;

  const ProjectSixth({key, required this.taskId, required this.initialTaskDescription,});

  @override
  _ProjectSixthState createState() => _ProjectSixthState();
}

class _ProjectSixthState extends State<ProjectSixth> {
  late TextEditingController _taskDescriptionController;
  late String taskDescription;

  @override
  void initState() {
    super.initState();
    _taskDescriptionController = TextEditingController(text: widget.initialTaskDescription);
    taskDescription = widget.initialTaskDescription;
  }

  @override
  void dispose() {
    _taskDescriptionController.dispose();
    super.dispose();
  }

  Future<void> updateTaskDescription() async {
    try {

      Task updatedTask = Task(
        taskId: widget.taskId,
        taskDescription: taskDescription,
        moduleId: '', projectID: '', completed: false, team: [],
      );


      await ApiService.updateTask(widget.taskId, updatedTask);


      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Task description updated successfully'),
      ));

      Navigator.pop(context, true);
    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to update task description'),
        backgroundColor: Color(0xFFE89F16),
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
        backgroundColor: const Color(0xFFE89F16),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Task Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _taskDescriptionController,
              decoration: InputDecoration(
                labelText: 'Enter task description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintStyle: TextStyle(color: Colors.grey.withOpacity(0.0)),
              ),
              onChanged: (value) {
                setState(() {
                  taskDescription = value;
                });
              },
            ),
            const SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    updateTaskDescription();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE89F16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Change',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}