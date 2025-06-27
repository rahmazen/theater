import 'package:flutter/material.dart';
import 'package:theater/pages/ContentPage.dart';
import 'package:theater/pages/TheaterHomePage.dart';
import 'package:theater/pages/TicketHistoryPage.dart';
import 'package:theater/pages/profile_page.dart';
import '../crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _currentIndex = 0;

  // List of pages corresponding to each tab
  final List<Widget> _pages = [
    TheaterHomePage(),
    ContentPage(),
    TicketHistoryPage(),
    ProfilePage(),
  ];

  // Navigation bar items
  final List<CrystalNavigationBarItem> _navBarItems = [
    CrystalNavigationBarItem(
      icon: Icons.home_rounded,
      unselectedIcon: Icons.home_rounded,
      selectedColor: Colors.red,
      unselectedColor: Colors.white,
    ),
    CrystalNavigationBarItem(
      icon: Icons.movie_creation_rounded,
      unselectedIcon: Icons.movie_outlined,
      selectedColor: Colors.red,
      unselectedColor: Colors.white,
    ),
    CrystalNavigationBarItem(
      icon: Icons.confirmation_num,
      unselectedIcon: Icons.confirmation_num_outlined,
      selectedColor: Colors.red,
      unselectedColor: Colors.white,
    ),
    CrystalNavigationBarItem(
      icon: Icons.person,
      unselectedIcon: Icons.person_outline,
      selectedColor: Colors.red,
      unselectedColor: Colors.white,
      badge: const Badge(
        label: Text('3'),
        backgroundColor: Colors.amber,
      ),
    ),
  ];

  void _onMessageButtonPressed() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[500],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ChatPopup(scrollController: scrollController),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Pages take full screen
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),

          // Floating Message Button positioned above nav bar
          Positioned(
            bottom: 80,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15),
                color: Colors.red.withOpacity(01),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: _onMessageButtonPressed,
                icon: Icon(LucideIcons.messageCircle),
                color: Colors.white,
                iconSize: 29,
              ),
            ),
          ),

          // Navigation bar as overlay at the bottom
          Positioned(
            bottom: -30,
            left: 0,
            right: 0,
            child: CrystalNavigationBar(
              items: _navBarItems,
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              selectedItemColor: Colors.red,
              unselectedItemColor: Colors.white,
              backgroundColor: Colors.black.withOpacity(0.3),
              outlineBorderColor: Colors.white.withOpacity(0.2),
              borderWidth: 1.0,
              borderRadius: 25,
              height: 80,
              marginR: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              paddingR: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              enableFloatingNavBar: true,
              indicatorColor: Colors.red,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// API Service Class
class ChatApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/aichat/messages/';

  static Future<List<ChatMessage>> getMessages(int? sessionId) async {
    try {
      // Build URL with query parameters if sessionId is provided
      String url = baseUrl;
      if (sessionId != null) {
        url += '?session_id=$sessionId';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUxMDEwNTExLCJpYXQiOjE3NTA5ODY1MTEsImp0aSI6Ijg2NmZiNzU2M2I0NzRhMDdhMDU3YWNmOTNiN2FhM2YwIiwidXNlcm5hbWUiOiJvayJ9.Bl2x7GeXJct3XZBuuz3yzK8iHPimC_tsn0t-egdGNtE'
        },
      );

      print('GET request URL: $url'); // Debug print
      print('Response status: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        List<ChatMessage> messages = jsonData.map((item) => ChatMessage.fromJson(item)).toList();
        print('Parsed ${messages.length} messages'); // Debug print
        return messages;
      } else {
        print('Error: HTTP ${response.statusCode}'); // Debug print
        throw Exception('Failed to load messages: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching messages: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> sendMessage(String message, int? sessionId) async {
    try {
      Map<String, dynamic> body = {'message': message};
      if (sessionId != null) {
        body['session_id'] = sessionId;
      }

      print('Sending message: $body'); // Debug print

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUxMDEwNTExLCJpYXQiOjE3NTA5ODY1MTEsImp0aSI6Ijg2NmZiNzU2M2I0NzRhMDdhMDU3YWNmOTNiN2FhM2YwIiwidXNlcm5hbWUiOiJvayJ9.Bl2x7GeXJct3XZBuuz3yzK8iHPimC_tsn0t-egdGNtE'
        },
        body: json.encode(body),
      );

      print('POST response status: ${response.statusCode}'); // Debug print
      print('POST response body: ${response.body}'); // Debug print

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending message: $e');
      return {};
    }
  }
}

// Session Manager
class SessionManager {
  static const String _sessionKey = 'chat_session_id';

  static Future<int?> getSessionId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_sessionKey);
  }

  static Future<void> saveSessionId(int sessionId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sessionKey, sessionId);
  }

  static Future<void> clearSessionId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}

// Popup Chat Widget
class ChatPopup extends StatefulWidget {
  final ScrollController scrollController;

  const ChatPopup({Key? key, required this.scrollController}) : super(key: key);

  @override
  _ChatPopupState createState() => _ChatPopupState();
}

class _ChatPopupState extends State<ChatPopup> {
  final TextEditingController _messageController = TextEditingController();
  List<ChatMessage> _messages = [];
  int? _sessionId;
  bool _isLoading = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadChatHistory(showLoading: true);
  }

  Future<void> _loadChatHistory({bool showLoading = true}) async {
    if (showLoading) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      _sessionId = await SessionManager.getSessionId();
      List<ChatMessage> messages = await ChatApiService.getMessages(_sessionId);

      setState(() {
        _messages = messages;
        if (showLoading) _isLoading = false;
      });
    } catch (e) {
      setState(() {
        if (showLoading) _isLoading = false;
      });
      _showErrorSnackBar('Failed to load chat history');
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _isSending) return;

    String messageText = _messageController.text.trim();
    _messageController.clear();

    setState(() {
      _isSending = true;
    });

    try {
      Map<String, dynamic> response = await ChatApiService.sendMessage(messageText, _sessionId);

      if (response.isNotEmpty) {
        // Save session ID if it's a new session
        if (_sessionId == null && response['session_id'] != null) {
          _sessionId = response['session_id'];
          await SessionManager.saveSessionId(_sessionId!);
        }

        // Refresh the entire chat history from the database
        await _loadChatHistory(showLoading: false);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to send message');
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Drag handle
        Container(
          width: 40,
          height: 4,
          margin: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        // Header
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.red[800],
                radius: 20,
                child: Text(
                  'M',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Maestro Ai',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _sessionId != null ? 'Session: $_sessionId' : 'Your AI Agent',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.refresh, color: Colors.black),
                onPressed: () => _loadChatHistory(showLoading: true),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),

        // Chat messages
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: _isLoading
                ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            )
                : Container(
              padding: EdgeInsets.all(16),
              child: ListView.builder(
                controller: widget.scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(_messages[index]);
                },
              ),
            ),
          ),
        ),

        // Message input
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: message.isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: message.isSent ? Colors.red[800] : Colors.grey[800],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              message.content,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _messageController,
                style: GoogleFonts.poppins(color: Colors.white),
                decoration: InputDecoration(
                  hintText: _isSending ? 'Sending...' : 'Message...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                  border: InputBorder.none,
                ),
                enabled: !_isSending,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: _isSending ? Colors.grey[600] : Colors.red[800],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: _isSending
                  ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : Icon(Icons.arrow_upward_rounded, color: Colors.white),
              onPressed: _isSending ? null : _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final int id;
  final int sessionId;
  final String sender;
  final String content;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.sessionId,
    required this.sender,
    required this.content,
    required this.timestamp,
  });

  bool get isSent => sender == 'user';

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      sessionId: json['session_id'],
      sender: json['sender'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_id': sessionId,
      'sender': sender,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}