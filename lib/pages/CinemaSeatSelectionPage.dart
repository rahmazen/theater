import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Seat {
  final int seatNumber;
  final int row;
  final int column;
  final String type;
  final double price;
  String status; // available, selected, reserved

  Seat({
    required this.seatNumber,
    required this.row,
    required this.column,
    required this.type,
    required this.price,
    this.status = 'available',
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      seatNumber: json['seat_number'],
      row: json['row'],
      column: json['column'],
      type: json['type'],
      price: double.parse(json['price'].toString()),
      status: json['status'] ?? 'available',
    );
  }
}
class CinemaSeatSelectionPage extends StatefulWidget {
  final Map<String, dynamic>? event;

  const CinemaSeatSelectionPage({
    Key? key,
    this.event,
  }) : super(key: key);

  @override
  _CinemaSeatSelectionPageState createState() => _CinemaSeatSelectionPageState();
}

class _CinemaSeatSelectionPageState extends State<CinemaSeatSelectionPage> {
  List<Seat> seats = [];
  Seat? selectedSeat;
  String selectedDate = '';
  String selectedTime = '8:30 PM';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSeats();
  }

  Future<void> _loadSeats() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Replace with your actual API endpoint
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/client/seats/${widget.event?['id']}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          seats = (data as List)
              .map((seatJson) => Seat.fromJson(seatJson))
              .toList();
          isLoading = false;
        });
      } else {
        // Handle error - for demo, load sample data
        _loadSampleData();
      }
    } catch (e) {
      // Handle network error - for demo, load sample data
      _loadSampleData();
    }
  }

  void _loadSampleData() {
    // Sample data matching your JSON structure
    List<Seat> sampleSeats = [
      // Row 1
      Seat(seatNumber: 1, row: 1, column: 1, type: "vip", price: 500.00, status: "available"),
      Seat(seatNumber: 2, row: 1, column: 2, type: "regular", price: 200.00, status: "available"),
      Seat(seatNumber: 3, row: 1, column: 3, type: "regular", price: 200.00, status: "reserved"),
      Seat(seatNumber: 4, row: 1, column: 4, type: "vip", price: 500.00, status: "available"),
      Seat(seatNumber: 5, row: 1, column: 5, type: "vip", price: 500.00, status: "available"),
      Seat(seatNumber: 6, row: 1, column: 6, type: "vip", price: 500.00, status: "reserved"),
      Seat(seatNumber: 7, row: 1, column: 7, type: "regular", price: 200.00, status: "available"),
      Seat(seatNumber: 8, row: 1, column: 8, type: "regular", price: 200.00, status: "available"),


      // Row 4
      Seat(seatNumber: 27, row: 4, column: 3, type: "regular", price: 200.00, status: "available"),
      Seat(seatNumber: 28, row: 4, column: 4, type: "regular", price: 200.00, status: "reserved"),
      Seat(seatNumber: 29, row: 4, column: 5, type: "regular", price: 200.00, status: "available"),
      Seat(seatNumber: 30, row: 4, column: 6, type: "regular", price: 200.00, status: "available"),
    ];

    setState(() {
      seats = sampleSeats;
      isLoading = false;
    });
  }

  void _toggleSeat(Seat seat) {
    if (seat.status == 'reserved') return;

    setState(() {
      // If clicking the same selected seat, deselect it
      if (selectedSeat?.seatNumber == seat.seatNumber) {
        selectedSeat!.status = 'available';
        selectedSeat = null;
      } else {
        // Deselect previously selected seat if any
        if (selectedSeat != null) {
          selectedSeat!.status = 'available';
        }
        // Select new seat (only one seat can be selected)
        seat.status = 'selected';
        selectedSeat = seat;
      }
    });
  }

  List<List<Seat>> _buildSeatGrid() {
    // Group seats by row
    Map<int, List<Seat>> seatsByRow = {};
    for (var seat in seats) {
      seatsByRow.putIfAbsent(seat.row, () => []).add(seat);
    }

    // Sort rows and columns
    List<int> sortedRows = seatsByRow.keys.toList()..sort();
    List<List<Seat>> grid = [];

    for (int row in sortedRows) {
      List<Seat> rowSeats = seatsByRow[row]!;
      rowSeats.sort((a, b) => a.column.compareTo(b.column));
      grid.add(rowSeats);
    }

    return grid;
  }

  Color _getSeatColor(Seat seat) {
    switch (seat.status) {
      case 'selected':
        return Colors.red;
      case 'reserved':
        return Colors.grey[500]!;
      case 'available':
        switch (seat.type) {
          case 'vip':
            return Colors.amber[600]!;
          case 'regular':
          default:
            return Colors.grey[700]!;
        }
      default:
        return Colors.grey[500]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final seatGrid = _buildSeatGrid();

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
                        widget.event?['content']['title'],
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
                  _buildTimeItem('8:30 PM', isSelected: selectedTime == '8:30 PM'),
                ],
              ),
            ),

            SizedBox(height: 30),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: CustomPaint(
                size: Size(double.infinity, 30),
                painter: CurvedScreenPainter(),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Stage',
              style: GoogleFonts.poppins(
                color: Colors.grey[500],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: 30),

            // Seats grid
            Expanded(
              child: isLoading
                  ? Center(
                child: CircularProgressIndicator(color: Colors.red),
              )
                  : SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int rowIndex = 0; rowIndex < seatGrid.length; rowIndex++)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int colIndex = 0; colIndex < seatGrid[rowIndex].length; colIndex++)
                                _buildSeat(seatGrid[rowIndex][colIndex]),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Price display (only show if a seat is selected)
            if (selectedSeat != null)
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Seat ${selectedSeat!.seatNumber}',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${selectedSeat!.type.toUpperCase()} • Row ${selectedSeat!.row}',
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '\$${selectedSeat!.price.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

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
                onPressed: selectedSeat != null ? () {
                  _showCheckoutModal();
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
                  selectedSeat != null
                      ? 'Get Tickets • 1 Seat'
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

  Widget _buildSeat(Seat seat) {
    bool isVIP = seat.type == 'vip';
    bool isClickable = seat.status != 'reserved';

    return GestureDetector(
      onTap: isClickable ? () => _toggleSeat(seat) : null,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: _getSeatColor(seat),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
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
        _loadSeats();
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
          selectedTime = time;
        });
        _loadSeats();
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

  void _showCheckoutModal() {
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
              Text(
                'All done!',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'You have successfully booked seat ${selectedSeat!.seatNumber} for \$${selectedSeat!.price.toStringAsFixed(2)}.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 30),
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
    path.moveTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 2,
        size.height - 15,
        size.width,
        size.height
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}