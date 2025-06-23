import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CinemaSeatSelectionPage extends StatefulWidget {
  @override
  _CinemaSeatSelectionPageState createState() => _CinemaSeatSelectionPageState();
}

class _CinemaSeatSelectionPageState extends State<CinemaSeatSelectionPage> {
  List<List<SeatStatus>> seats = [];
  List<String> selectedTimes = [];
  String selectedDate = '';

  @override
  void initState() {
    super.initState();
    _initializeSeats();
  }

  void _initializeSeats() {
    // Initialize 8 rows with 10 seats each (matching the image layout)
    seats = List.generate(8, (row) {
      return List.generate(10, (col) {
        // Some reserved seats scattered throughout
        if ((row == 1 && col == 2) || (row == 2 && col == 5) ||
            (row == 3 && col == 1) || (row == 3 && col == 8) ||
            (row == 4 && col == 3) || (row == 4 && col == 6) ||
            (row == 5 && col == 0) || (row == 5 && col == 9) ||
            (row == 6 && col == 4) || (row == 6 && col == 7)) {
          return SeatStatus.reserved;
        }
        return SeatStatus.available;
      });
    });
  }

  void _toggleSeat(int row, int col) {
    if (seats[row][col] == SeatStatus.reserved) return;

    setState(() {
      if (seats[row][col] == SeatStatus.selected) {
        seats[row][col] = SeatStatus.available;
      } else {
        seats[row][col] = SeatStatus.selected;
      }
    });
  }

  int get selectedSeatsCount {
    int count = 0;
    for (var row in seats) {
      for (var seat in row) {
        if (seat == SeatStatus.selected) count++;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      //color: Colors.grey[900],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Spiderman',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 48),
                ],
              ),
            ),

            // Date selection
            Container(
              height: 70,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildDateItem('Thu', '09', isSelected: selectedDate == 'Thu-09'),
                  _buildDateItem('Fri', '10', isSelected: selectedDate == 'Fri-10'),
                  _buildDateItem('Sat', '11', isSelected: selectedDate == 'Sat-11'),
                  _buildDateItem('Sun', '12', isSelected: selectedDate == 'Sun-12'),
                  _buildDateItem('Mon', '13', isSelected: selectedDate == 'Mon-13'),
                  _buildDateItem('Tue', '14', isSelected: selectedDate == 'Tue-14'),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Time selection
            Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildTimeItem('10:30 AM'),
                  _buildTimeItem('11:30 AM'),
                  _buildTimeItem('1:30 PM'),
                  _buildTimeItem('8:30 PM', isSelected: true),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Screen
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: CustomPaint(
                size: Size(double.infinity, 30),
                painter: CurvedScreenPainter(),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Screen',
              style: GoogleFonts.poppins(
                color: Colors.grey[500],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: 30),

            // Seats grid
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int row = 0; row < seats.length; row++)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int col = 0; col < seats[row].length; col++)
                                _buildSeat(row, col),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Legend
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLegendItem(Colors.grey[700]!, 'Available'),
                  _buildLegendItem(Colors.grey[500]!, 'Taken'),
                  _buildLegendItem(Colors.red, 'Selected'),
                ],
              ),
            ),

            // Checkout button
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(20, 10, 20, 30),
              child: ElevatedButton(
                onPressed: selectedSeatsCount > 0 ? () {
                  // Handle checkout
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (context) => Container(
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                            SizedBox(height: 20),

                            // Title
                            Text(
                              'All done!',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),

                            // Description
                            Text(
                              'You have successfully booked $selectedSeatsCount seat${selectedSeatsCount > 1 ? 's' : ''} for this show.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 30),

                            // Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.grey[800],
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Ok, thanks!',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  );
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  disabledBackgroundColor: Colors.grey[700],
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  selectedSeatsCount > 0
                      ? 'Get Tickets • $selectedSeatsCount Seat${selectedSeatsCount > 1 ? 's' : ''}'
                      : 'Select Seats',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeat(int row, int col) {
    return GestureDetector(
      onTap: () => _toggleSeat(row, col),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: _getSeatColor(seats[row][col]),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Color _getSeatColor(SeatStatus status) {
    switch (status) {
      case SeatStatus.available:
        return Colors.grey[700]!;
      case SeatStatus.selected:
        return Colors.red;
      case SeatStatus.reserved:
        return Colors.grey[500]!;
    }
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.grey[400],
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDateItem(String weekday, String day, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDate = '$weekday-$day';
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 12),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.grey[800],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weekday,
              style: GoogleFonts.poppins(
                color: Colors.grey[400],
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 2),
            Text(
              day,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeItem(String time, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedTimes.remove(time);
          } else {
            selectedTimes.clear();
            selectedTimes.add(time);
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 12),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.grey[800],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          time,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class CurvedScreenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          Colors.red.withOpacity(0.6),
          Colors.red,
          Colors.red.withOpacity(0.6),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();

    //  a curved path for the screen
    path.moveTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 2,
        size.height - 15, // Curve depth
        size.width,
        size.height
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

enum SeatStatus {
  available,
  selected,
  reserved,
}