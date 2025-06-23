import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';

class TicketPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Your Tickets are on the Way !',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                margin: EdgeInsets.all(20),
                child: Stack(
                  children: [
                    // Main ticket container
                    Container(
                      width:300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
'assets/ballet2.JPG'                          ),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.7), // Image opacity (0.0-1.0)
                            BlendMode.darken,
                          ),
                        ),

                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          // top section
                          Expanded(
                            flex: 2,
                            child: Container(
                            //  margin:  EdgeInsets.all(20),
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Spiderman',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  // Ticket details
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Date',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white70,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                Text(
                                                  'March 12, 2024',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 14,
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
                                                    color: Colors.white70,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                Text(
                                                  '19:00 PM',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 16),

                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Seat',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white70,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                Text(
                                                  'A12, A13',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 14,
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
                                                  'Price',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white70,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                Text(
                                                  '\$42.00',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 16),

                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Cinema',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white70,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                Text(
                                                  'PVR Cinemas',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 14,
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
                                                  'Order',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white70,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                Text(
                                                  'K4F5H6M',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 14,
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
                                ],
                              ),
                            ),
                          ),

                          // Perforated divider
                          Container(
                            height: 1,
                            child: CustomPaint(
                              painter: DashedLinePainter(),
                              size: Size(double.infinity, 1),
                            ),
                          ),

                          // Bottom section with QR code
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // QR Code
                                  Flexible(
                                    child: Container(
                                      width: 200,
                                      height: 200,
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        //color: Colors.black,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: CustomPaint(
                                        painter: QRCodePainter(),
                                        size: Size.infinite,
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),

                    // Semi-circular cuts on sides
                    Positioned(
                      left: -13,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 30,
                        child: Column(
                          children: [
                            Expanded(flex: 2, child: Container()),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(flex: 2, child: Container()),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      right: -13,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 30,
                        child: Column(
                          children: [
                            Expanded(flex: 2, child: Container()),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(flex: 2, child: Container()),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Scan QR Code for Entry',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Order ID: K4F5H6M',
              style: GoogleFonts.poppins(
                color: Colors.white60,
                fontSize: 10,
                letterSpacing: 0.5,
              ),
            ),

            // Checkout button
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  // Handle checkout
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Checkout',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white38
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 8.0;
    const dashSpace = 4.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class QRCodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Simple QR code pattern simulation
    // In a real app, you'd use a proper QR code library
    final random = math.Random(12345); // Fixed seed for consistent pattern
    const int gridSize = 21; // Typical QR code is 21x21 modules
    final double moduleSize = size.width / gridSize;

    // Generate a simple pattern that looks like a QR code
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        bool shouldFill = false;

        // Position detection patterns (corners)
        if ((row < 7 && col < 7) ||
            (row < 7 && col >= gridSize - 7) ||
            (row >= gridSize - 7 && col < 7)) {
          // Create finder pattern
          if ((row == 0 || row == 6) && (col >= 0 && col <= 6)) shouldFill = true;
          if ((col == 0 || col == 6) && (row >= 0 && row <= 6)) shouldFill = true;
          if (row >= 2 && row <= 4 && col >= 2 && col <= 4) shouldFill = true;
        }
        // Timing patterns
        else if (row == 6 && col % 2 == 0) shouldFill = true;
        else if (col == 6 && row % 2 == 0) shouldFill = true;
        // Data area - random pattern
        else if (row > 8 && col > 8) {
          shouldFill = random.nextBool();
        }
        // Some additional structure
        else if ((row + col) % 3 == 0) shouldFill = random.nextBool();

        if (shouldFill) {
          final rect = Rect.fromLTWH(
            col * moduleSize,
            row * moduleSize,
            moduleSize,
            moduleSize,
          );
          canvas.drawRect(rect, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}