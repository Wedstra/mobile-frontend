import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedstra_mobile_app/presentations/widgets/snakbar_component/snakbars.dart';
import '../../../constants/app_constants.dart';
import '../../../data/models/expense.dart';
import 'package:intl/intl.dart';

class ExpenseTracker extends StatefulWidget {
  final String userId;
  final double budget;

  const ExpenseTracker({super.key, required this.budget, required this.userId});

  @override
  State<ExpenseTracker> createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  late Future<List<Expense>> _futureExpenses;
  late List<dynamic> _categoryList;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  String? selectedCategory;

  double _expenses = 0;
  String? token;

  Future<List<Expense>> getExpensesForUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('jwt_token');
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL}/expense/user/${widget.userId}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Expense.fromJson(json)).toList();
      } else {
        print('Failed to load expenses. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching expenses: $e');
      return [];
    }
  }

  void _loadCategories() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL}/resources/categories'),
      );
      if (response.statusCode == 200) {
        _categoryList = json.decode(response.body);

        print(_categoryList);
        print(_categoryList.runtimeType);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  void _addExpense() async {
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;

    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final requestBody = {
      "userId": widget.userId.toString(),
      "title": title,
      "amount": amount,
      "category": selectedCategory,
      "date": formattedDate,
    };

    try {
      final response = await http.post(
        Uri.parse('${AppConstants.BASE_URL}/expense'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Only show success and refresh
        showSnack(context, 'Expense Added Success!');
        setState(() {
          _expenses = _expenses + amount;
          _futureExpenses = getExpensesForUser(); // refresh expense list
        });
        Navigator.of(context).pop();
      } else {
        print('Failed: ${response.statusCode}, ${response.body}');
        showSnack(context, 'Failed to add expense', success: false);
      }
    } catch (e) {
      showSnack(context, 'Something went wrong!', success: false);
      print(e);
    }

    _titleController.clear();
    _amountController.clear();
    selectedCategory = null;
  }


  @override
  void initState() {
    super.initState();
    _loadCategories();
    _futureExpenses = getExpensesForUser();
    _futureExpenses.then((expenses) {
      setState(() {
        _expenses = expenses.fold(0, (sum, item) => sum + item.amount);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                margin: EdgeInsets.symmetric(vertical: 16),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0F2027),
                      Color(0xFF203A43),
                      Color(0xFF2C5364),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Simulated chip
                        Container(
                          width: 40,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.amber[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        // Card "logo"
                        Text(
                          'Wedstra',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Total Budget',
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                    Text(
                      '₹${widget.budget.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Expenses',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '₹${_expenses.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        // Optional card number simulation
                        Text(
                          '**** **** **** 1234',
                          style: TextStyle(
                            color: Colors.white30,
                            letterSpacing: 2,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),

                  /// Expense Line Chart Section
                  Text(
                    'Expense Trends',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF474747),
                    ),
                  ),
                  SizedBox(height: 10),
                  FutureBuilder<List<Expense>>(
                    future: _futureExpenses,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError || !snapshot.hasData) {
                        return Text("Error loading chart.");
                      }

                      return ExpenseBarChart(expenses: snapshot.data!);
                    },
                  ),
                  SizedBox(height: 30),

                  /// Expense List Section
                  Text(
                    'All Expenses',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF474747),
                    ),
                  ),
                  SizedBox(height: 10),
                  FutureBuilder<List<Expense>>(
                    future: _futureExpenses,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No expenses found.'));
                      }

                      final expenses = snapshot.data!;

                      return ListView.builder(
                        itemCount: expenses.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final expense = expenses[index];

                          return Dismissible(
                            key: Key(expense.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              color: Colors.redAccent,
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (direction) async {
                              try {
                                final response = await http.delete(
                                  Uri.parse(
                                    '${AppConstants.BASE_URL}/expense/${expense.id}',
                                  ),
                                  headers: {'Authorization': 'Bearer $token'},
                                );

                                if (response.statusCode == 204) {
                                  // Re-fetch updated data
                                  setState(() {
                                    _expenses = _expenses - expense.amount;
                                    _futureExpenses = getExpensesForUser();
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(
                                        'Expense: ${expense.title} deleted!',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Failed to delete ${expense.title}',
                                      ),
                                    ),
                                  );
                                }
                              } on Exception catch (e) {
                                // TODO
                                print(e);
                              }
                            },

                            child: Card(
                              margin: EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 4,
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.grey.shade200,
                                  child: Icon(
                                    Iconsax.money,
                                    color: Colors.black,
                                  ),
                                ),
                                title: Text(
                                  expense.title,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  '${expense.category} • ${expense.date}',
                                ),
                                trailing: Text(
                                  '₹${expense.amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),

                  SizedBox(height: 80),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth:
                            MediaQuery.of(context).size.width *
                            0.9, // 90% of screen
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Add Expense',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: _titleController,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  labelText: 'Title',
                                  prefixIcon: Icon(
                                    Iconsax.text,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white70,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF474747),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(AppConstants.primaryColor),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              TextFormField(
                                controller: _amountController,
                                keyboardType: TextInputType.number,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  labelText: 'Amount',
                                  prefixIcon: Icon(
                                    Iconsax.money,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white70,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF474747),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(AppConstants.primaryColor),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Category',
                                  prefixIcon: Icon(
                                    Iconsax.category,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white70,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF474747),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(AppConstants.primaryColor),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                dropdownColor: Colors.white,
                                iconEnabledColor: Colors.black,
                                value: selectedCategory,
                                items: _categoryList
                                    .map<DropdownMenuItem<String>>((item) {
                                      return DropdownMenuItem<String>(
                                        value: item['category_name'],
                                        child: Text(item['category_name']),
                                      );
                                    })
                                    .toList(),
                                onChanged: (value) {
                                  selectedCategory = value!;
                                },
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text('Cancel'),
                                  ),
                                  SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () => _addExpense(),
                                    child: Text('Add'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
        child: Icon(Iconsax.add),
      ),
    );
  }
}

/// Chart Widget using fl_chart
class ExpenseBarChart extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseBarChart({super.key, required this.expenses});

  Map<String, double> groupByDate() {
    final Map<String, double> grouped = {};
    for (var expense in expenses) {
      grouped.update(
        expense.date,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final data = groupByDate();
    final sortedKeys = data.keys.toList()..sort();
    final barGroups = <BarChartGroupData>[];

    for (int i = 0; i < sortedKeys.length; i++) {
      final date = sortedKeys[i];
      final amount = data[date]!;
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(toY: amount, width: 18, color: Colors.blueAccent),
          ],
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 300,
      child: LineChart(
        curve: Curves.linear,
        LineChartData(
          minY: 0,
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              tooltipMargin: 12,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    'Amount: ₹${spot.y.toStringAsFixed(0)}',
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList();
              },
            ),
            touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
              // Optional: Handle touch events like logging or highlighting
            },
            getTouchedSpotIndicator:
                (LineChartBarData barData, List<int> spotIndexes) {
                  return spotIndexes.map((index) {
                    return TouchedSpotIndicatorData(
                      FlLine(color: Colors.white24, strokeWidth: 1),
                      FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                              radius: 6,
                              color: Colors.white,
                              strokeWidth: 2,
                              strokeColor: Colors.black,
                            ),
                      ),
                    );
                  }).toList();
                },
          ),

          titlesData: FlTitlesData(
            show: true,
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  String formattedValue;
                  if (value >= 1000) {
                    formattedValue = '₹${(value / 1000).toStringAsFixed(0)}k';
                  } else {
                    formattedValue = '₹${value.toInt()}';
                  }
                  return Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      formattedValue,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  );
                },
              ),
              axisNameWidget: SizedBox(), // remove extra label padding
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < expenses.length) {
                    final date = expenses[index].date;
                    return Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Transform.rotate(
                        angle: -0.5,
                        child: Text(
                          date,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
              axisNameWidget: SizedBox(), // removed bottom label padding
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 10000,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.2),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey.shade300),
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: Colors.indigo,
              gradient: LinearGradient(
                colors: [Colors.indigo, Colors.deepPurpleAccent],
              ),
              spots: List.generate(
                expenses.length,
                (index) => FlSpot(index.toDouble(), expenses[index].amount),
              ),
              barWidth: 3,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                      radius: 4,
                      color: Colors.white,
                      strokeColor: Colors.deepPurpleAccent,
                      strokeWidth: 2,
                    ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurpleAccent.withOpacity(0.3),
                    Colors.deepPurpleAccent.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
