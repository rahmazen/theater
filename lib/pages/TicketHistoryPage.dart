import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theater/pages/payement/TicketPage.dart';

class TicketHistoryPage extends StatelessWidget {
  const TicketHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Your tickets',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500
        ),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
        padding:  EdgeInsets.only(left: 16, right:16 , top:16 , bottom: 80),
        itemCount: ticketHistory.length,
        itemBuilder: (context, index) {
          final ticket = ticketHistory[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () {

              },
              child: TicketCard(ticket: ticket),
            )

          );
        },
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final Ticket ticket;

  const TicketCard({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isExpired = ticket.isExpired;

    return Container(
      height: 100,
      child: Stack(
        children: [
          // Main ticket container
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(ticket.imageUrl),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  isExpired
                      ? Colors.black.withOpacity(0.8)
                      : Colors.black.withOpacity(0.4),
                  BlendMode.darken,
                ),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Left section with movie details
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ticket.showTitle,
                          style: GoogleFonts.poppins(
                            color: isExpired ? Colors.grey[400] : Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                                    ticket.showDate,
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
                                    ticket.showTime,
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
                  height: 60,
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
                                data: ticket.orderId,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ticket.orderId,
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

          // Expired badge
          if (isExpired)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:  Text(
                  'EXPIRED',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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

class Ticket {
  final String showTitle;
  final String showDate;
  final String showTime;
  final String orderId;
  final String imageUrl;
  final bool isExpired;

  Ticket({
    required this.showTitle,
    required this.showDate,
    required this.showTime,
    required this.orderId,
    required this.imageUrl,
    required this.isExpired,
  });
}

// Sample data
final List<Ticket> ticketHistory = [
  Ticket(
    showTitle: 'AVATAR: THE WAY OF WATER',
    showDate: '06.20',
    showTime: '7:30 PM',
    orderId: 'K4F5H6M',
    imageUrl: 'https://images.unsplash.com/photo-1635805737707-575885ab0820?w=800&h=400&fit=crop',
    isExpired: false,
  ),
  Ticket(
    showTitle: 'TOP GUN: MAVERICK',
    showDate: '06.18',
    showTime: '9:15 PM',
    orderId: 'M7K3L9P',
    imageUrl: 'https://images.unsplash.com/photo-1489599904335-af5b66e05f5c?w=800&h=400&fit=crop',
    isExpired: false,
  ),
  Ticket(
    showTitle: 'SPIDER-MAN: NO WAY HOME',
    showDate: '06.15',
    showTime: '6:00 PM',
    orderId: 'P2N8Q5R',
    imageUrl: 'https://images.unsplash.com/photo-1594909122845-11baa439b7bf?w=800&h=400&fit=crop',
    isExpired: true,
  ),


  Ticket(
    showTitle: 'THE BATMAN',
    showDate: '06.12',
    showTime: '8:45 PM',
    orderId: 'X9Y4Z1W',
    imageUrl: 'https://images.unsplash.com/photo-1478720568477-b834d1819944?w=800&h=400&fit=crop',
    isExpired: true,
  ),
  Ticket(
    showTitle: 'DUNE: PART TWO',
    showDate: '06.10',
    showTime: '7:00 PM',
    orderId: 'A5B8C2D',
    imageUrl: 'https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=800&h=400&fit=crop',
    isExpired: true,
  ),
];