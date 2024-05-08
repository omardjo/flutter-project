import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../model/task.dart';

class TaskDetailsPage extends StatefulWidget {
  final Task task;
  final Function(Task) markAsCompleted;

  const TaskDetailsPage({
    Key? key,
    required this.task,
    required this.markAsCompleted, required List<String> members,
  }) : super(key: key);

  @override
  _TaskDetailsPageState createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  late List<String> steps;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    steps = [];
    generateSteps();
  }

  Future<void> generateSteps() async {
    try {
      final response = await http
          .get(
          Uri.parse('http://192.168.128.222:3000/task/${widget.task.taskId}'));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final dynamic stepsData = responseData['steps'];

        if (stepsData is List<dynamic>) {
          setState(() {
            steps = stepsData.cast<String>().toList();
            isLoading = false; // Update loading state when data is fetched
          });
        } else if (stepsData is String) {
          setState(() {
            steps = [stepsData];
            isLoading = false; // Update loading state when data is fetched
          });
        } else {
          print('Invalid steps data format');
        }
      } else {
        print('Failed to load steps: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching steps: $e');
    }
  }

  void _showCompletionMessage(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('You completed a task!'),
      backgroundColor: Colors.orange,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Details',
          style: TextStyle(
            fontSize: 17.0, // Adjust the font size
            fontWeight: FontWeight.bold, // Bold font weight
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: isLoading
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text(
                  'Loading data for steps...',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.task.taskDescription,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
                height: 20,
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Due:',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        widget.task.endDate != null
                            ? DateFormat('EEEE, h:mm a').format(
                            widget.task.endDate!)
                            : 'No due date',
                        style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 233, 142, 5),
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Team Members:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.task.team.length,
                itemBuilder: (context, index) {
                  final member = widget.task.team[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      member,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
              if (steps.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text(
                  'Steps:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                for (final step in steps)
                  Text(
                    step,
                    style: const TextStyle(fontSize: 16),
                  ),
              ],
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    widget.markAsCompleted(widget.task);
                    // Show completion message
                    _showCompletionMessage(context);
                    // Navigate back
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      fixedSize: const Size(300.0, 50.0)),
                  child: const Text(
                    'Mark as Completed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}