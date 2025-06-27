import 'package:flutter/material.dart';
import 'package:theater/pages/ContentPage.dart';
import 'package:theater/pages/TheaterHomePage.dart';
import 'package:theater/pages/TicketHistoryPage.dart';
import 'package:theater/pages/profile_page.dart';
import '../crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../pointBalence.dart';

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
                  offset:  Offset(0, 5),
                ),
              ],
            ),
          ),
          Positioned(
            top: 15,
            right: 16,
            child: const PointsBalance(),
          ),
        ],
      ),
    );
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
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "I need recs",
      isSent: true,
    ),
    ChatMessage(
      text: "Hello, of course. Here is a list of what you might like",
      isSent: false,
    ),
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(
          text: _messageController.text.trim(),
          isSent: true,
        ));
      });
      _messageController.clear();
    }
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
                      'Your Ai Agent',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
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
            child: Container(
              padding: EdgeInsets.all(16),
              child: ListView.builder(
                controller: widget.scrollController,
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(_messages[_messages.length - 1 - index]);
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
        mainAxisAlignment:
        message.isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
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
              message.text,
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
                  hintText: 'Message...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.red[800],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_upward_rounded, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isSent;

  ChatMessage({
    required this.text,
    required this.isSent,
  });
}