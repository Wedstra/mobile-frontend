class Expense {
  final String id;
  final String userId;
  final String title;
  final double amount;
  final String category;
  final String date;

  Expense({
    required this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      amount: json['amount'].toDouble(),
      category: json['category'],
      date: json['date'],
    );
  }
}
