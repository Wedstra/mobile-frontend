import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedstra_mobile_app/constants/app_constants.dart';

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
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('jwt_token');
    final userJson = prefs.getString('user_data');
    if (token != null && userJson != null) {
      final user = jsonDecode(userJson);
      userId = user['id'];
      await _fetchTasks();
    }
  }

  Future<void> _fetchTasks() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL}/tasks/get-predefined-all'),
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
        final res = await http.post(
          Uri.parse('https://your-api.com/tasks/mark-complete'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'userId': userId,
            'taskId': task.id,
            'completed': true,
          }),
        );

        if (res.statusCode == 200 || res.statusCode == 201) {
          setState(() {
            task.completed = true;
          });
        }
      } else {
        final res = await http.delete(
          Uri.parse(
            'https://your-api.com/tasks/${task.id}/completion?userId=$userId',
          ),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (res.statusCode == 204) {
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
          : ListView.builder(
              itemCount: groupedTasks.length,
              itemBuilder: (context, index) {
                final phaseGroup = groupedTasks[index];
                return ExpansionTile(
                  title: Text(phaseGroup['phase']),
                  children: (phaseGroup['items'] as List<Task>).map((task) {
                    return CheckboxListTile(
                      value: task.completed,
                      title: Text(task.title),
                      onChanged: (val) {
                        _markTaskStatus(task, val ?? false);
                      },
                    );
                  }).toList(),
                );
              },
            ),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Tasks',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: Column(
//           children: [
//             InkWell(
//               onTap: () => _dialogBuilder(context),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 16,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Color(0xFFCB0033),
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.3),
//                       blurRadius: 5,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.asset('assets/task_add.png'),
//                     SizedBox(width: 10),
//                     Text(
//                       'Add new task',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 17,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 'Predefined Tasks',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//             SizedBox(height: 7),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     blurRadius: 5,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Checkbox(
//                     checkColor: isChecked ? Colors.white : Colors.white,
//                     fillColor: isChecked
//                         ? WidgetStateProperty.all(Colors.green)
//                         : WidgetStateProperty.all(Colors.white),
//                     value: isChecked,
//                     onChanged: (bool? value) {
//                       setState(() {
//                         isChecked = value!;
//                       });
//                     },
//                   ),
//                   Text(
//                     'Modification for client',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                   ),
//                   Spacer(),
//                   InkWell(
//                     onTap: () => _deleteDialogBuilder(context),
//                     child: Icon(Icons.delete, color: Colors.red),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     blurRadius: 5,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Checkbox(
//                     checkColor: isChecked ? Colors.white : Colors.white,
//                     fillColor: isChecked
//                         ? WidgetStateProperty.all(Colors.green)
//                         : WidgetStateProperty.all(Colors.white),
//                     value: isChecked,
//                     onChanged: (bool? value) {
//                       setState(() {
//                         isChecked = value!;
//                       });
//                     },
//                   ),
//                   Text(
//                     'Modification for client',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                   ),
//                   Spacer(),
//                   InkWell(
//                     onTap: () => _deleteDialogBuilder(context),
//                     child: Icon(Icons.delete, color: Colors.red),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     blurRadius: 5,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Checkbox(
//                     checkColor: isChecked ? Colors.white : Colors.white,
//                     fillColor: isChecked
//                         ? WidgetStateProperty.all(Colors.green)
//                         : WidgetStateProperty.all(Colors.white),
//                     value: isChecked,
//                     onChanged: (bool? value) {
//                       setState(() {
//                         isChecked = value!;
//                       });
//                     },
//                   ),
//                   Text(
//                     'Modification for client',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                   ),
//                   Spacer(),
//                   InkWell(
//                     onTap: () => _deleteDialogBuilder(context),
//                     child: Icon(Icons.delete, color: Colors.red),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 25),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 'Customized Tasks',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//             SizedBox(height: 7),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     blurRadius: 5,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Checkbox(
//                     checkColor: isChecked ? Colors.white : Colors.white,
//                     fillColor: isChecked
//                         ? WidgetStateProperty.all(Colors.green)
//                         : WidgetStateProperty.all(Colors.white),
//                     value: isChecked,
//                     onChanged: (bool? value) {
//                       setState(() {
//                         isChecked = value!;
//                       });
//                     },
//                   ),
//                   Text(
//                     'Modification for client',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                   ),
//                   Spacer(),
//                   InkWell(
//                     onTap: () => _deleteDialogBuilder(context),
//                     child: Icon(Icons.delete, color: Colors.red),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void showSuccessToast() {
//   Fluttertoast.showToast(
//     msg: "Task added Successful.",
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.BOTTOM,
//     timeInSecForIosWeb: 2,
//     backgroundColor: Colors.green,
//     textColor: Colors.white,
//   );
// }
//
// void showErrorToast() {
//   Fluttertoast.showToast(
//     msg: "Error adding task.",
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.BOTTOM,
//     timeInSecForIosWeb: 2,
//     backgroundColor: Colors.red,
//     textColor: Colors.white,
//   );
// }

// Future<void> _deleteDialogBuilder(BuildContext context) {
//   return showDialog<void>(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Create Task'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Enter task',
//                 prefixIcon: Icon(Iconsax.task5, size: 20),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xFF474747), width: 1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xB35484FF), width: 1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 errorBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.red, width: 1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 focusedErrorBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.red, width: 1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 filled: true,
//                 fillColor: Colors.white,
//               ),
//
//               maxLines: 1,
//             ),
//           ],
//         ),
//         actions: <Widget>[
//           ElevatedButton(
//             style: TextButton.styleFrom(
//               textStyle: Theme
//                   .of(context)
//                   .textTheme
//                   .labelLarge,
//               backgroundColor: Colors.grey[500],
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12.0),
//               ),
//             ),
//             child: const Text('close', style: TextStyle(color: Colors.white)),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           ElevatedButton(
//             style: TextButton.styleFrom(
//               backgroundColor: Colors.green[500],
//               textStyle: Theme
//                   .of(context)
//                   .textTheme
//                   .labelLarge,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12.0),
//               ),
//             ),
//             child: const Text(
//               'Add Task',
//               style: TextStyle(color: Colors.white),
//             ),
//             onPressed: () {
//               showSuccessToast();
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );
// }

// Future<void> _dialogBuilder(BuildContext context) {
//   return showDialog<void>(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Create Task'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Enter task',
//                 prefixIcon: Icon(Iconsax.task5, size: 20),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xFF474747), width: 1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xB35484FF), width: 1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 errorBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.red, width: 1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 focusedErrorBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.red, width: 1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 filled: true,
//                 fillColor: Colors.white,
//               ),
//
//               maxLines: 1,
//             ),
//           ],
//         ),
//         actions: <Widget>[
//           ElevatedButton(
//             style: TextButton.styleFrom(
//               textStyle: Theme
//                   .of(context)
//                   .textTheme
//                   .labelLarge,
//               backgroundColor: Colors.grey[500],
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12.0),
//               ),
//             ),
//             child: const Text('close', style: TextStyle(color: Colors.white)),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           ElevatedButton(
//             style: TextButton.styleFrom(
//               backgroundColor: Colors.green[500],
//               textStyle: Theme
//                   .of(context)
//                   .textTheme
//                   .labelLarge,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12.0),
//               ),
//             ),
//             child: const Text(
//               'Add Task',
//               style: TextStyle(color: Colors.white),
//             ),
//             onPressed: () {
//               showSuccessToast();
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
// }
