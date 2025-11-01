import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedstra_mobile_app/constants/app_constants.dart';

class ChatRoom extends StatefulWidget {
  final String vendorId;
  final String vendorName;
  final String userId;
  final String username;

  const ChatRoom({
    Key? key,
    required this.vendorId,
    required this.vendorName,
    required this.userId,
    required this.username,
  }) : super(key: key);

  /// call this from other screens
  void openChat(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          width: 350,
          height: 500,
          child: ChatRoom(
            vendorId: vendorId,
            vendorName: vendorName,
            userId: userId,
            username: username,
          ),
        ),
      ),
    );
  }

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  WebSocketChannel? channel;
  List<Map<String, dynamic>> messages = [];
  final TextEditingController messageController = TextEditingController();
  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("jwt_token");
    });
    if (token != null) {
      fetchMessages();
      connectWebSocket();
    }
  }

  void connectWebSocket() {
    channel = WebSocketChannel.connect(
      Uri.parse("wss://wedstra-backend-9886.onrender.com/ws"),
    );

    channel!.stream.listen((event) {
      final payload = jsonDecode(event);
      setState(() {
        messages.add(payload);
      });
    });
  }

  Future<void> fetchMessages() async {
    try {
      final response1 = await http.get(
        Uri.parse(
            "${AppConstants.BASE_URL}/api/messages?senderName=${widget.userId}&receiverName=${widget.vendorId}"),
        headers: {"Authorization": "Bearer $token","Content-Type": "application/json"},
      );

      final response2 = await http.get(
        Uri.parse(
            "${AppConstants.BASE_URL}/api/messages?senderName=${widget.vendorId}&receiverName=${widget.userId}"),
        headers: {"Authorization": "Bearer $token","Content-Type": "application/json"},
      );

      final List msgs1 = jsonDecode(response1.body);
      final List msgs2 = jsonDecode(response2.body);

      final allMessages = [...msgs1, ...msgs2];
      allMessages.sort((a, b) =>
          DateTime.parse(a["date"]).compareTo(DateTime.parse(b["date"])));

      setState(() {
        messages = allMessages.cast<Map<String, dynamic>>();
      });
    } catch (e) {
      debugPrint("Error fetching messages: $e");
    }
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;


    final chatMessage = {
      "senderName": widget.userId,
      "receiverName": widget.vendorId,
      "message": messageController.text.trim(),
      "sName": widget.username,
      "rName": widget.vendorName,
      "date": DateTime.now().toIso8601String(),
      "status": "MESSAGE",
    };

    channel?.sink.add(jsonEncode(chatMessage));

    setState(() {
      messages.add(chatMessage);
    });

    messageController.clear();
  }

  @override
  void dispose() {
    channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Chat with ${widget.vendorName}",
                  style: const TextStyle(color: Colors.white)),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),

        // Messages
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final chat = messages[index];
              final isUser = chat["senderName"] == widget.userId;

              return Align(
                alignment:
                isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.blueAccent : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    chat["message"],
                    style: TextStyle(
                        color: isUser ? Colors.white : Colors.black),
                  ),
                ),
              );
            },
          ),
        ),

        // Input
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    hintText: "Type a message...",
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => sendMessage(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.green),
                onPressed: sendMessage,
              )
            ],
          ),
        ),
      ],
    );
  }
}
