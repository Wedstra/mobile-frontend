import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedstra_mobile_app/constants/app_constants.dart';
import 'package:wedstra_mobile_app/data/services/Auth_Service/user_services/user_services.dart';
import 'package:wedstra_mobile_app/presentations/widgets/snakbar_component/snakbars.dart';

import '../../../../../data/models/task.dart';

class TasksTab extends StatefulWidget {
  const TasksTab({super.key});

  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  List<Task> tasks = [];
  List<Map<String, dynamic>> groupedTasks = [];
  bool isLoading = true;
  String? token;
  String? userId;
  Map<String, dynamic>? _userDetails;
  final TextEditingController _taskController = TextEditingController();

  static const List<String> PHASE_ORDER = [
    '12 – 9 Months Before',
    '9 – 6 Months Before',
    '6 – 4 Months Before',
    '3 – 2 Months Before',
    '1 Month Before',
    'Wedding Week',
    'Post-Wedding',
    'custom',
  ];

  @override
  void initState() {
    super.initState();
    // loadUserDetails();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('jwt_token');
    final userJson = prefs.getString('user_data');
    if (token != null && userJson != null) {
      // Decode once
      var firstDecode = json.decode(userJson);

      // Check if it's still a String
      var parsedJson = firstDecode is String
          ? json.decode(firstDecode)
          : firstDecode;

      _userDetails = parsedJson;
      userId = _userDetails?["id"];

      await _fetchTasks();
    }
  }

  void loadUserDetails() async {
    String? userDetailsString = await getLoggedInUserDetails();
    if (userDetailsString != null) {
      try {
        // Decode once
        var firstDecode = json.decode(userDetailsString);

        // Check if it's still a String
        var parsedJson = firstDecode is String
            ? json.decode(firstDecode)
            : firstDecode;

        _userDetails = parsedJson;
        userId = _userDetails?["id"];

        await _fetchTasks();
      } catch (e) {
        print('JSON Decode Error: $e');
      }
    } else {
      print('No user data found in SharedPreferences');
    }
  }

  Future<void> _fetchTasks() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${AppConstants.BASE_URL}/tasks/all-tasks-with-status/${userId}',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          tasks = data.map((e) => Task.fromJson(e)).toList();
          groupedTasks = _groupByPhase(tasks);
          isLoading = false;
        });
      } else {
        print("Failed to fetch tasks");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Exception: $e");
      setState(() => isLoading = false);
    }
  }

  List<Map<String, dynamic>> _groupByPhase(List<Task> taskList) {
    Map<String, List<Task>> map = {};
    for (var t in taskList) {
      final p = t.phase.isEmpty ? 'Un-categorised' : t.phase;
      map[p] = (map[p] ?? [])..add(t);
    }

    return PHASE_ORDER
        .where((p) => map[p] != null)
        .map((p) => {'phase': p, 'items': map[p]!})
        .toList();
  }

  Future<void> _saveCustomTask(String title) async {
    try {
      final response = await http.post(
        Uri.parse('https://your-api.com/tasks/create'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': title,
          'task': title,
          'phase': 'custom',
          'createdBy': userId,
          'type': 'custom',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final task = Task.fromJson(jsonDecode(response.body));
        setState(() {
          tasks.add(task);
          groupedTasks = _groupByPhase(tasks);
        });
        _taskController.clear();
        Navigator.of(context).pop();
      }
    } catch (e) {
      print("Failed to save task: $e");
    }
  }

  Future<void> _markTaskStatus(Task task, bool nextCompleted) async {
    try {
      if (!task.completed) {
        final now = DateTime.now();
        final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

        final jsonBody = jsonEncode({
          'userId': userId,
          'taskId': task.id,
          'completed': true,
          'completedAt': formattedDate,
        });

        final res = await http.post(
          Uri.parse('${AppConstants.BASE_URL}/tasks/mark-complete'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonBody,
        );

        if (res.statusCode == 200 || res.statusCode == 201) {
          setState(() {
            task.completed = true;
          });
          showSnack(context, 'Task Completed!');
        }
      } else {
        final res = await http.delete(
          Uri.parse(
            '${AppConstants.BASE_URL}/tasks/${task.id}/completion?userId=$userId',
          ),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (res.statusCode == 204) {
          showSnack(context, 'Something went wrong!', success: false);
          setState(() {
            task.completed = false;
          });
        }
      }
    } catch (e) {
      print("Error updating task status: $e");
    }
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Custom Task"),
        content: TextField(
          controller: _taskController,
          decoration: const InputDecoration(hintText: "Enter task title"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => _saveCustomTask(_taskController.text),
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Tasks")),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
      body: groupedTasks.isEmpty
          ? const Center(child: Text("No tasks found"))
          : Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.symmetric(horizontal:18, vertical: 15),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color(AppConstants.primaryColor),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Task Board',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '8/10',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),

                      // Progress bar with percentage
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: 0.8,
                                backgroundColor: Colors.white.withOpacity(0.3),
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                minHeight: 10,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '80%',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              // Handle view custom Tasks
                            },
                            child: Text('View Custom Tasks'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.indigo,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: _showAddTaskDialog,
                            child: Text('Add Task'),
                          ),
                        ],
                      ),
                    ],
                  )
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: groupedTasks.length,
                    itemBuilder: (context, index) {
                      final phaseGroup = groupedTasks[index];
                      final isCustomPhase = phaseGroup['phase'].toLowerCase() == 'custom';

                      return ExpansionTile(
                        title: Text(
                          phaseGroup['phase'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        children: (phaseGroup['items'] as List<Task>).map((task) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: task.completed,
                                  onChanged: (val) {
                                    _markTaskStatus(task, val ?? false);
                                  },
                                  activeColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    task.task,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                if (isCustomPhase) // ✅ Show delete only for "custom" phase
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _deleteTask(task); // define this function
                                    },
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),


              ],
            ),
    );
  }

  void _deleteTask(Task task) {}
}
