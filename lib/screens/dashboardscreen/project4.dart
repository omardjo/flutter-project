import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../model/module.dart';
import '../../model/task.dart';
import '../../services/api_service.dart';
import 'charts/radialP.dart';


class ProjectFourth extends StatefulWidget {
  final String? projectId;
  final String? projectName;

  const ProjectFourth({Key? key, required this.projectId, this.projectName}) : super(key: key);

  @override
  _ProjectFourthState createState() => _ProjectFourthState();
}

class _ProjectFourthState extends State<ProjectFourth> {
  List<Task> tasks = [];
  List<Module> modules = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchModulesAndTasks();
  }

  Future<void> fetchModulesAndTasks() async {
    try {
      final modules = await ApiService.fetchModules(widget.projectId ?? '');
      final List<Task> allTasks = [];
      for (var module in modules) {
        final moduleTasks = await ApiService.fetchTasks(module.module_id);
        allTasks.addAll(moduleTasks);
      }
      setState(() {
        this.modules = modules;
        tasks = allTasks;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching modules and tasks: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.projectName ?? '',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color(0xFFE89F16),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: _isLoading ? _buildLoadingWidget() : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              _buildCompletionStatus(),
              const SizedBox(height: 20),
              _buildModulesProgressCards(),
              const SizedBox(height: 20),
              _buildTasksPieChart(tasks),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildCompletionStatus() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Project Completion Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE89F16)),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 180,
              width: 180,
              child: CustomPaint(
                painter: RadialPainter(
                  bgColor: const Color(0xFF8D6322),
                  lineColor: Colors.orange,
                  percent: _calculateProjectCompletionPercentage(),
                  width: 15.0,
                ),
                child: Center(
                  child: Text(
                    '${_calculateProjectCompletionPercentage().toStringAsFixed(1)}%',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(color: Colors.orange, label: 'Completed'),
                const SizedBox(width: 20),
                _buildLegendItem(color: const Color(0xFF8D6322), label: 'Pending'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  double _calculateProjectCompletionPercentage() {
    int completedTasks = tasks.where((task) => task.completed).length;
    int totalTasks = tasks.length;
    return totalTasks == 0 ? 0 : completedTasks / totalTasks * 100;
  }

  Widget _buildModulesProgressCards() {
    if (modules.isEmpty) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: modules.map((module) {
        int completedTasks = tasks.where((task) => task.moduleId == module.module_id && task.completed).length;
        int totalTasks = tasks.where((task) => task.moduleId == module.module_id).length;
        double completionPercentage = totalTasks == 0 ? 0 : completedTasks / totalTasks;
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  module.module_name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: completionPercentage,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(completionPercentage * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.orange),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTasksPieChart(List<Task> tasks) {
    if (tasks.isEmpty) {
      return Container();
    }
    int completedTaskCount = tasks.where((task) => task.completed).length;
    int pendingTaskCount = tasks.length - completedTaskCount;

    if (completedTaskCount > 0 && pendingTaskCount > 0) {
      List<PieChartSectionData> pieChartData = [
        PieChartSectionData(
          color: Colors.green,
          value: completedTaskCount.toDouble(),
          title: '${((completedTaskCount / tasks.length) * 100).toStringAsFixed(1)}%',
          radius: 100,
          titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        PieChartSectionData(
          color: Colors.red,
          value: pendingTaskCount.toDouble(),
          title: '${((pendingTaskCount / tasks.length) * 100).toStringAsFixed(1)}%',
          radius: 100,
          titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ];

      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Task Status',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE89F16)),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                        sections: pieChartData,
                        centerSpaceRadius: 0,
                        sectionsSpace: 0,
                        startDegreeOffset: -90,
                        borderData: FlBorderData(show: false),
                        pieTouchData: PieTouchData(enabled: false),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem(color: Colors.green, label: 'Completed'),
                  const SizedBox(width: 10),
                  _buildLegendItem(color: Colors.red, label: 'Pending'),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return const Text(
        'No data available for task status',
        style: TextStyle(fontSize: 16),
      );
    }
  }
}