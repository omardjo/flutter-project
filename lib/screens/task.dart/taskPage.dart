import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:teamsyncai/screens/task.dart/tasksDetails.dart';

import '../../model/task.dart';

final DateFormat mongoDBDateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");

class TasksPage extends StatefulWidget {
  final String moduleId;
  final String moduleName;
  final List<String> teamMembers;

  const TasksPage({
    Key? key,
    required this.moduleId,
    required this.moduleName,
    required this.teamMembers,
  }) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late Future<List<Task>> _todayTasks;
  late Future<List<Task>> _upcomingTasks;
  late List<Task> _completedTasks;
  late bool _showTodayTasks;
  late bool _showCompletedTasks;

  @override
  void initState() {
    super.initState();
    _showTodayTasks = true;
    _showCompletedTasks = false;
    _completedTasks = [];
    _todayTasks = fetchTodayTasks(widget.moduleId);
    _upcomingTasks = fetchUpcomingTasks();

    fetchAndCategorizeTasks().then((_) {
      _toggleShowCompletedTasks(false);
      _toggleShowTodayTasks(true);
    });
  }

  Future<void> fetchAndCategorizeTasks() async {
    try {
      final List<Task> tasks = await fetchAllTasks(widget.moduleId);
      setState(() {
        _completedTasks = tasks.where((task) => task.completed).toList();
        _showCompletedTasks = _completedTasks.isNotEmpty;
      });
    } catch (e) {
      print('Error fetching and categorizing tasks: $e');
    }
  }

  Future<List<Task>> fetchAllTasks(String moduleId) async {
    final response = await http.get(
      Uri.parse('http://192.168.128.222:3000/tasks/modul/$moduleId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic>? data = jsonDecode(response.body)['tasks'];
      if (data != null) {
        final List<Task> allTasks = data.map<Task>((taskData) {
          return Task.fromJson(taskData);
        }).toList();

        return allTasks;
      } else {
        throw Exception('Tasks data is null');
      }
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<List<Task>> fetchTodayTasks(String moduleId) async {
    final response = await http
        .get(Uri.parse('http://192.168.128.222:3000/tasks/modul/$moduleId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['tasks'];
      final today = DateTime.now();
      final List<Task> todayTasks = [];

      for (var taskData in data) {
        final task = Task.fromJson(taskData);
        if (task.endDate != null &&
            task.endDate!.year == today.year &&
            task.endDate!.month == today.month &&
            task.endDate!.day == today.day &&
            !task.completed) {
          todayTasks.add(task);
        }
      }

      print('Today tasks response: $todayTasks');
      return todayTasks;
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<List<Task>> fetchUpcomingTasks() async {
    final response = await http.get(
        Uri.parse('http://192.168.128.222:3000/tasks/modul/${widget.moduleId}'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['tasks'];
      print('Upcoming tasks response: $data');

      final today = DateTime.now();
      final List<Task> upcomingTasks = [];

      for (var taskData in data) {
        final task = Task.fromJson(taskData);
        if (task.endDate != null &&
            task.endDate!.isAfter(today) &&
            (task.endDate!.year != today.year ||
                task.endDate!.month != today.month ||
                task.endDate!.day != today.day) &&
            !task.completed) {
          upcomingTasks.add(task);
        }
      }

      print('Filtered upcoming tasks response: $upcomingTasks');
      return upcomingTasks;
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  void _toggleShowTodayTasks(bool showToday) {
    setState(() {
      _showTodayTasks = showToday;
      _showCompletedTasks = false;
    });
  }

  void _toggleShowCompletedTasks(bool showCompleted) {
    setState(() {
      _showCompletedTasks = showCompleted;
      _showTodayTasks = false;
    });
  }

  void _markAsCompleted(Task task) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.128.222:3000/tasks/${task.taskId}/completed'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _upcomingTasks = _upcomingTasks.then((tasks) {
            tasks.removeWhere((t) => t.taskId == task.taskId);
            return Future.value(tasks);
          });

          _todayTasks = _todayTasks.then((tasks) {
            tasks.removeWhere((t) => t.taskId == task.taskId);
            return Future.value(tasks);
          });

          _completedTasks.add(task);

          _toggleShowCompletedTasks(true);
        });
      } else {
        throw Exception('Failed to mark task as completed');
      }
    } catch (e) {
      print('Error marking task as completed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          'Tasks for Module ${widget.moduleName}',
          style: const TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => _toggleShowTodayTasks(true),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor:
                  _showTodayTasks ? Colors.orange : Colors.transparent,
                ),
                child: Text(
                  'Today',
                  style: TextStyle(
                    color: _showTodayTasks ? Colors.white : Colors.orange,
                  ),
                ),
              ),
              const SizedBox(width: 35),
              TextButton(
                onPressed: () => _toggleShowTodayTasks(false),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: !_showTodayTasks && !_showCompletedTasks
                      ? Colors.orange
                      : Colors.transparent,
                ),
                child: Text(
                  'Upcoming',
                  style: TextStyle(
                    color: !_showTodayTasks && !_showCompletedTasks
                        ? Colors.white
                        : Colors.orange,
                  ),
                ),
              ),
              const SizedBox(width: 35),
              TextButton(
                onPressed: () => _toggleShowCompletedTasks(true),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor:
                  _showCompletedTasks ? Colors.orange : Colors.transparent,
                ),
                child: Text(
                  'Completed',
                  style: TextStyle(
                    color: _showCompletedTasks ? Colors.white : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: _showCompletedTasks
                ? ListView.builder(
              itemCount: _completedTasks.length,
              itemBuilder: (context, index) {
                final Task task = _completedTasks[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      task.taskDescription,
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Completed: ${DateFormat('EEEE, h:mm a').format(task.endDate!)}',
                          ),
                        ),
                        const VerticalDivider(),
                        const Text(
                          'Done',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 20, 3),
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
                : FutureBuilder<List<Task>>(
              future: _showTodayTasks ? _todayTasks : _upcomingTasks,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error}'));
                } else {
                  final List<Task> tasks = snapshot.data!;
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final Task task = tasks[index];
                      return Card(
                        child: ListTile(
                          title: Text(task.taskDescription),
                          subtitle: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Due: ${DateFormat('EEEE, h:mm a').format(task.endDate!)}',
                                ),
                              ),
                              const VerticalDivider(),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TaskDetailsPage(
                                            task: task,
                                            markAsCompleted: _markAsCompleted,
                                            members: widget.teamMembers,
                                          ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                      255, 5, 223, 252),
                                ),
                                child: const Text(
                                  'In Progress',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskDetailsPage(
                                  task: task,
                                  markAsCompleted: _markAsCompleted,
                                  members: widget.teamMembers,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}