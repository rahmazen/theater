import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:theater/pages/payement/TicketPage.dart';
import 'dart:convert';

import 'Account/authProvider.dart';

class TicketHistoryPage extends StatefulWidget {
  const TicketHistoryPage({Key? key}) : super(key: key);

  @override
  State<TicketHistoryPage> createState() => _TicketHistoryPageState();
}

class _TicketHistoryPageState extends State<TicketHistoryPage> {
  List<dynamic> ticketHistory = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthAndLoadTickets();
    });
  }

  void _checkAuthAndLoadTickets() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isAuthenticated || authProvider.authData == null) {
      // Redirect to sign-in if not authenticated
      Navigator.of(context).pushReplacementNamed('/signin');
      return;
    }

    // Load tickets if authenticated
    _loadTicketHistory();
  }

  Future<void> _loadTicketHistory() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final tickets = await _fetchTicketHistory(authProvider.authData!.accessToken , authProvider.authData!.username);

      setState(() {
        ticketHistory = tickets ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load ticket history: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<List<dynamic>?> _fetchTicketHistory(String accessToken , username) async {
    try {
      // Replace with your actual API endpoint
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/client/tickets/${username}/'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data;
      }
    } catch (e) {
      // For development/testing - return mock data if API fails
      print('API Error: $e');
      return _getMockTicketData();
    }
    return null;
  }

  // Mock data for testing - remove this when your API is ready
  List<Map<String, dynamic>> _getMockTicketData() {
    return [
      {
        "id": 24,
        "event": {
          "id": 3,
          "content": {
            "id": 2,
            "title": "BALLET",
            "description": "European ballet is a classical dance form known for its grace, precision, and storytelling.",
            "type": "other",
            "duration_minutes": 120,
            "release_year": null,
            "poster": "/media/catalogue/posters/ballet2.jpg",
            "trailer_url": null,
            "rating": null,
            "language": null,
            "subtitles": false
          },
          "artists": [
            {
              "id": 1,
              "image": "/media/artists/photos/nacera.PNG",
              "name": "Nacera Belaza",
              "bio": "Founded by Algerian-born choreographer Nacera Belaza, this troupe is based in France and performs internationally — blending minimalism, contemporary movement, and spiritual depth.",
              "artist_type": "dancer"
            }
          ],
          "start_time": "2025-06-26T22:00:00Z",
          "event_type": "play",
          "end_time": "2025-06-26T23:40:00Z",
          "ticket_price": "1000.00",
          "minimum_age": 0,
          "is_sold_out": false
        },
        "price_paid": "1000.00",
        "purchased_at": "2025-06-26T16:22:14.302987Z",
        "ticket_code": "45f30e7c-7e17-4a6f-8de2-0e7490f7b7c1",
        "is_scanned": false,
        "scanned_at": null,
        "user": "dib_g",
        "seat": 2
      }
    ];
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }

  String _formatTime(String timeStr) {
    try {
      final date = DateTime.parse(timeStr);
      final time = TimeOfDay.fromDateTime(date);
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      return '$hour:${time.minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return timeStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Redirect if not authenticated
        if (!authProvider.isAuthenticated || authProvider.authData == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('/signin');
          });
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Your tickets',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadTicketHistory,
              ),
            ],
          ),
          backgroundColor: Colors.black,
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadTicketHistory,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Retry',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        ),
      );
    }

    if (ticketHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.confirmation_num_outlined,
              color: Colors.grey,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'No tickets found',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your ticket history will appear here',
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTicketHistory,
      color: Colors.red,
      backgroundColor: Colors.black,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
        itemCount: ticketHistory.length,
        itemBuilder: (context, index) {
          final ticket = ticketHistory[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TicketPage(ticketData: ticket),
                  ),
                );
              },
              child: TicketCard(ticket: ticket),
            ),
          );
        },
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final Map<String, dynamic> ticket;

  const TicketCard({Key? key, required this.ticket}) : super(key: key);

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }

  String _formatTime(String timeStr) {
    try {
      final date = DateTime.parse(timeStr);
      final time = TimeOfDay.fromDateTime(date);
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      return '$hour:${time.minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return timeStr;
    }
  }

  String _getEventTypeDisplay(String eventType) {
    switch (eventType) {
      case 'play':
        return 'Theater';
      case 'movie':
        return 'Cinema';
      case 'concert':
        return 'Concert';
      default:
        return 'Event';
    }
  }

  bool _isExpired(String? endTimeStr) {
    if (endTimeStr == null) return false;
    try {
      final endTime = DateTime.parse(endTimeStr);
      return DateTime.now().isAfter(endTime);
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract data from new structure
    final event = ticket['event'] ?? {};
    final content = event['content'] ?? {};
    final isScanned = ticket['is_scanned'] ?? false;
    final isExpired = _isExpired(event['end_time']);

    final showTitle = content['title'] ?? 'Unknown Show';
    final showDate = _formatDate(event['start_time'] ?? '');
    final showTime = _formatTime(event['start_time'] ?? '');
    final orderId = ticket['ticket_code'] ?? '';
    final imageUrl = content['poster'] ?? '';
    final eventType = _getEventTypeDisplay(event['event_type'] ?? '');
    final seatNumbers = ticket['seat'] != null ? 'Seat ${ticket['seat']}' : '';

    return Container(
      height: 120,
      child: Stack(
        children: [
          // Main ticket container
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: imageUrl.isNotEmpty
                  ? DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  isExpired
                      ? Colors.black.withOpacity(0.8)
                      : Colors.black.withOpacity(0.4),
                  BlendMode.darken,
                ),
              )
                  : null,
              color: imageUrl.isEmpty ? Colors.grey[800] : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Left section with event details
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          showTitle,
                          style: GoogleFonts.poppins(
                            color: isExpired ? Colors.grey[400] : Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          eventType,
                          style: GoogleFonts.poppins(
                            color: isExpired ? Colors.grey[500] : Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Date',
                                    style: GoogleFonts.poppins(
                                      color: isExpired ? Colors.grey[500] : Colors.white70,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    showDate,
                                    style: GoogleFonts.poppins(
                                      color: isExpired ? Colors.grey[400] : Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Time',
                                    style: GoogleFonts.poppins(
                                      color: isExpired ? Colors.grey[500] : Colors.white70,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    showTime,
                                    style: GoogleFonts.poppins(
                                      color: isExpired ? Colors.grey[400] : Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (seatNumbers.isNotEmpty)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Seat',
                                      style: GoogleFonts.poppins(
                                        color: isExpired ? Colors.grey[500] : Colors.white70,
                                        fontSize: 10,
                                      ),
                                    ),
                                    Text(
                                      seatNumbers,
                                      style: GoogleFonts.poppins(
                                        color: isExpired ? Colors.grey[400] : Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Perforated divider
                Container(
                  width: 1,
                  height: 80,
                  child: CustomPaint(
                    painter: VerticalDashedLinePainter(
                      color: isExpired ? Colors.grey[600]! : Colors.white70,
                    ),
                  ),
                ),

                // Right section with QR code
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            child: CustomPaint(
                              painter: QRCodePainter(
                                color: isExpired ? Colors.grey[600]! : Colors.white,
                                data: orderId,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          orderId.length >= 8 ? orderId.substring(0, 8).toUpperCase() : orderId.toUpperCase(),
                          style: GoogleFonts.poppins(
                            color: isExpired ? Colors.grey[500] : Colors.white70,
                            fontSize: 8,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Status badges
          Positioned(
            top: 8,
            right: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isScanned)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'USED',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (isExpired && !isScanned)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'EXPIRED',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Semi-circular cuts on top and bottom
          Positioned(
            top: -10,
            left: 0,
            right: 0,
            child: Row(
              children: [
                Expanded(flex: 3, child: Container()),
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(flex: 1, child: Container()),
              ],
            ),
          ),

          Positioned(
            bottom: -10,
            left: 0,
            right: 0,
            child: Row(
              children: [
                Expanded(flex: 3, child: Container()),
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(flex: 1, child: Container()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VerticalDashedLinePainter extends CustomPainter {
  final Color color;

  VerticalDashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const dashHeight = 3.0;
    const dashSpace = 3.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class QRCodePainter extends CustomPainter {
  final Color color;
  final String data;

  QRCodePainter({required this.color, required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    // Simple 6x6 grid for a cleaner look
    final gridSize = 6;
    final moduleSize = size.width / gridSize;
    final gap = moduleSize * 0.1; // Small gap between squares
    final squareSize = moduleSize - gap;

    // Create a simple pattern based on the order ID
    final pattern = _generateSimplePattern(data, gridSize);

    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (pattern[row][col]) {
          final rect = Rect.fromLTWH(
            col * moduleSize + gap / 2,
            row * moduleSize + gap / 2,
            squareSize,
            squareSize,
          );
          canvas.drawRRect(
            RRect.fromRectAndRadius(rect, Radius.circular(squareSize * 0.2)),
            paint,
          );
        }
      }
    }
  }

  List<List<bool>> _generateSimplePattern(String data, int size) {
    final pattern = List.generate(size, (i) => List.filled(size, false));

    // Add corner squares
    pattern[0][0] = true;
    pattern[0][size - 1] = true;
    pattern[size - 1][0] = true;
    pattern[size - 1][size - 1] = true;

    // Generate a simple pattern based on data hash
    int hash = data.hashCode.abs();
    for (int i = 1; i < size - 1; i++) {
      for (int j = 1; j < size - 1; j++) {
        pattern[i][j] = (hash % (i * j + 1)) % 3 == 0;
      }
    }

    return pattern;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}