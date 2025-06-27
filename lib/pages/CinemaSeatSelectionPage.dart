import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:url_launcher/url_launcher.dart';
import 'package:theater/pages/payement/TicketPage.dart';

import 'Account/authProvider.dart';

class Seat {
  final int seatNumber;
  final int row;
  final int column;
  final String type;
  final double price;
  String status;

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
      price: double.parse(json['price']),

      status: json['status'] ?? 'available',
    );
  }
}

class CinemaSeatSelectionPage extends StatefulWidget {
  final Map<String, dynamic>? event;
  final String? replays;

  const CinemaSeatSelectionPage({
    Key? key,
    this.event,
    this.replays
  }) : super(key: key);

  @override
  _CinemaSeatSelectionPageState createState() => _CinemaSeatSelectionPageState();
}

class _CinemaSeatSelectionPageState extends State<CinemaSeatSelectionPage> {
  List<Seat> seats = [];
  Seat? selectedSeat;
  String selectedDate = '';
  String selectedTime = '';
  String? selectedReplayId;
  bool isLoading = true;

  // WebSocket related variables
  WebSocketChannel? _webSocketChannel;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _loadSeats(widget.event!['id'].toString());
  }

  @override
  void dispose() {
    _disconnectWebSocket();
    super.dispose();
  }

  // WebSocket connection methods
  Future<void> _connectWebSocket(String eventId) async {
    try {
      _webSocketChannel = WebSocketChannel.connect(
        Uri.parse('ws://127.0.0.1:8000/ws/seats/$eventId/'),
      );
      _isConnected = true;

      print('WebSocket connected for event: $eventId');

      _webSocketChannel!.stream.listen(
            (data) {
          _handleWebSocketMessage(data);
        },
        onError: (error) {
          print('WebSocket error: $error');
          setState(() {
            _isConnected = false;
          });
        },
        onDone: () {
          print('WebSocket connection closed');
          setState(() {
            _isConnected = false;
          });
        },
      );
    } catch (e) {
      print('Failed to connect WebSocket: $e');
      setState(() {
        _isConnected = false;
      });
    }
  }

  void _handleWebSocketMessage(dynamic data) {
    try {
      final message = json.decode(data);

      if (message['type'] == 'seat_booked') {
        final bookedSeatId = message['seat_id'].toString();
        _updateSeatStatus(bookedSeatId, 'reserved');
      }
      // Handle other message types as needed
    } catch (e) {
      print('Error parsing WebSocket message: $e');
    }
  }

  void _updateSeatStatus(String seatId, String newStatus) {
    setState(() {
      final seatIndex = seats.indexWhere((seat) => seat.seatNumber.toString() == seatId);
      if (seatIndex != -1) {
        seats[seatIndex].status = newStatus;

        // If the booked seat was our selected seat, deselect it
        if (selectedSeat?.seatNumber.toString() == seatId) {
          selectedSeat = null;
        }
      }
    });
  }

  void _disconnectWebSocket() {
    if (_webSocketChannel != null) {
      _webSocketChannel!.sink.close(status.goingAway);
      _webSocketChannel = null;
      setState(() {
        _isConnected = false;
      });
    }
  }

  Future<void> _loadSeats(String id) async {
    setState(() {
      isLoading = true;
    });

    // Disconnect existing WebSocket connection
    _disconnectWebSocket();

    print('Loading seats for event id: $id');

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/client/seats/$id'),
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

        // Connect WebSocket after successfully loading seats
        await _connectWebSocket(id);
      } else {
        _loadSampleData();
      }
    } catch (e) {
      print('Error loading seats: $e');
      _loadSampleData();
    }
  }


  Future<void> createTicket() async {
    setState(() {
      isLoading = true;
    });
    print(selectedSeat?.seatNumber);
    print(selectedReplayId );
    final authData = Provider.of<AuthProvider>(context, listen: false).authData;
    try {
      final response = await http.post(  // Changed to POST
      Uri.parse('http://127.0.0.1:8000/client/book/'),
          headers: {'Content-Type': 'application/json'},
    body: jsonEncode({  // JSON encode the body
    'seat_id': selectedSeat?.seatNumber,  // Assuming you want the seat ID
    'event_id': selectedReplayId,
      'user_id' : authData?.username // Make sure this is the correct ID
    }),
    );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TicketPage(ticketData: data,),
            ),
          );
        });


      } else {
        print('yikes');
      }
    } catch (e) {
      print('Error creating ticket: $e');

    }
  }




  Future<void> processPayment() async {
    double amount2 = calculatePrice() ;
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/client/payment/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': amount2,
        }),
      );

      if (response.statusCode == 201) {

        final data = json.decode(response.body);
        final String url = data['data']['attributes']['form_url'];
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        } else {
          print('Could not launch $url');
          throw 'Could not launch $url';

        }
      } else {
        print('Payment failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during payment: $e');
    }
  }



  void _loadSampleData() {
    List<Seat> sampleSeats = [
      Seat(seatNumber: 1, row: 1, column: 1, type: "vip", price: 500.00, status: "available"),
      Seat(seatNumber: 27, row: 4, column: 3, type: "regular", price: 200.00, status: "available"),
      Seat(seatNumber: 28, row: 4, column: 4, type: "regular", price: 200.00, status: "reserved"),
    ];

    setState(() {
      seats = sampleSeats;
      isLoading = false;
    });
  }

  List<Map<String, String>> parseUpcomingReplays(String upcomingReplays) {
    List<Map<String, String>> replays = [];

    if (upcomingReplays.isEmpty) return replays;

    List<String> replayParts = upcomingReplays.split(',');

    for (String part in replayParts) {
      part = part.trim();

      RegExp regex = RegExp(r'(\d{2}/\d{2})\s+(\d{2}:\d{2})\s+\(id:(\d+)\)');
      Match? match = regex.firstMatch(part);

      if (match != null) {
        String date = match.group(1)!;
        String time = match.group(2)!;
        String id = match.group(3)!;

        String weekday = _getWeekdayFromDate(date);
        String day = date.split('/')[0];

        replays.add({
          'date': date,
          'weekday': weekday,
          'day': day,
          'time': time,
          'id': id,
          'dateKey': '$weekday-$day',
        });
      }
    }

    return replays;
  }

  String _getWeekdayFromDate(String date) {
    List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    int day = int.parse(date.split('/')[0]);
    return weekdays[(day - 1) % 7];
  }

  List<Map<String, String>> getUniqueDates() {
    List<Map<String, String>> replays = parseUpcomingReplays(widget.replays ?? '');
    Map<String, Map<String, String>> uniqueDates = {};
    for (var replay in replays) {
      String dateKey = replay['dateKey']!;
      if (!uniqueDates.containsKey(dateKey)) {
        uniqueDates[dateKey] = {
          'weekday': replay['weekday']!,
          'day': replay['day']!,
          'dateKey': dateKey,
        };
      }
    }

    return uniqueDates.values.toList();
  }

  List<Map<String, String>> getTimesForDate(String selectedDateKey) {
    List<Map<String, String>> replays = parseUpcomingReplays(widget.replays ?? '');
    return replays.where((replay) => replay['dateKey'] == selectedDateKey).toList();
  }

  String formatTimeForDisplay(String time24) {
    List<String> parts = time24.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    String period = hour >= 12 ? 'PM' : 'AM';
    int displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '${displayHour}:${minute.toString().padLeft(2, '0')} $period';
  }

  void _toggleSeat(Seat seat) {
    if (seat.status == 'reserved') {
      // Show a message that the seat is already taken
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('This seat is already taken'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      if (selectedSeat?.seatNumber == seat.seatNumber) {
        selectedSeat!.status = 'available';
        selectedSeat = null;
      } else {
        if (selectedSeat != null) {
          selectedSeat!.status = 'available';
        }
        seat.status = 'selected';
        selectedSeat = seat;
      }
    });
  }

  List<List<Seat>> _buildSeatGrid() {
    Map<int, List<Seat>> seatsByRow = {};
    for (var seat in seats) {
      seatsByRow.putIfAbsent(seat.row, () => []).add(seat);
    }

    List<int> sortedRows = seatsByRow.keys.toList()..sort();
    List<List<Seat>> grid = [];

    for (int row in sortedRows) {
      List<Seat> rowSeats = seatsByRow[row]!;
      rowSeats.sort((a, b) => a.column.compareTo(b.column));
      grid.add(rowSeats);
    }

    return grid;
  }
  double discountAmount = 0;
  double get discountedPrice => calculatePrice() - discountAmount;
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
  double calculatePrice() {
    // Print selectedSeat price value and type
    var seatPrice = selectedSeat?.price;
    print('selectedSeat price value: $seatPrice');
    print('selectedSeat price type: ${seatPrice.runtimeType}');

    // Print widget.event ticket_price value and type
    var ticketPrice = widget.event?['ticket_price'];
    print('ticket_price value: $ticketPrice');
    print('ticket_price type: ${ticketPrice.runtimeType}');

    // Convert to double and calculate
    double seatPriceDouble = (seatPrice as int?)?.toDouble() ?? 0.0;
    double ticketPriceDouble = double.tryParse(ticketPrice as String? ?? '0') ?? 0.0;

    double totalPrice = seatPriceDouble + ticketPriceDouble;

    print('Total calculated price: $totalPrice');

    return totalPrice;

  }
  @override
  Widget build(BuildContext context) {
    final seatGrid = _buildSeatGrid();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header with connection status
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
                      child: Column(
                        children: [
                          Text(
                            widget.event?['content']['title'],
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _isConnected ? Colors.green : Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 6),
                              Text(
                                _isConnected ? 'Live' : 'Offline',
                                style: GoogleFonts.poppins(
                                  color: _isConnected ? Colors.green : Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
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
                children: getUniqueDates().map((dateInfo) =>
                    _buildDateItem(
                        dateInfo['weekday']!,
                        dateInfo['day']!,
                        isSelected: selectedDate == dateInfo['dateKey']
                    )
                ).toList(),
              ),
            ),

            SizedBox(height: 20),

            // Time selection
            Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: selectedDate.isNotEmpty
                  ? ListView(
                scrollDirection: Axis.horizontal,
                children: getTimesForDate(selectedDate).map((timeInfo) {
                  String displayTime = formatTimeForDisplay(timeInfo['time']!);
                  return _buildTimeItem(
                      displayTime,
                      replayId: timeInfo['id']!,
                      isSelected: selectedTime == displayTime
                  );
                }).toList(),
              )
                  : Center(
                child: Text(
                  'Select a date to view available times',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
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

            // Price display
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
                     "${calculatePrice()} DZD",
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
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
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
                  processPayment();

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
          selectedTime = '';
        });
        _loadSeats(selectedReplayId!);
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

  Widget _buildTimeItem(String time, {bool isSelected = false, String? replayId}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTime = time;
          selectedReplayId = replayId.toString();
        });
        _loadSeats(selectedReplayId!);
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