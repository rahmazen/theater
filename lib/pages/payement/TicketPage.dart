import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:open_file/open_file.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
class TicketPage extends StatefulWidget {
  final Map<String, dynamic> ticketData;

  const TicketPage({
    Key? key,
    required this.ticketData,
  }) : super(key: key);

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  final GlobalKey _ticketKey = GlobalKey();

  String formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      DateTime date = DateTime.parse(dateString);
      return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
    } catch (e) {
      return 'N/A';
    }
  }

  String formatTime(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      DateTime date = DateTime.parse(dateString);
      String hour = date.hour.toString().padLeft(2, '0');
      String minute = date.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } catch (e) {
      return 'N/A';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  // Generate PDF of the ticket
  Future<Uint8List> _generateTicketPDF() async {
    final pdf = pw.Document();

    // Extract ticket data
    final ticketCode = widget.ticketData['ticket_code'] ?? 'N/A';
    final pricePaid = widget.ticketData['price_paid'] ?? '0.00';
    final eventName = widget.ticketData['event']['content']['title'] ?? 'Event';
    final eventDate = widget.ticketData['event']['start_time'];
    final eventTime = widget.ticketData['event']['start_time'];
    final seatNumber = widget.ticketData['seat']?.toString() ?? 'N/A';
    final duration = widget.ticketData['event']['content']['duration_minutes']?.toString() ?? '0';

    // Generate QR code for PDF
    final qrValidationResult = QrValidator.validate(
      data: ticketCode,
      version: QrVersions.auto,
    );

    final qrCode = qrValidationResult.status == QrValidationStatus.valid
        ? qrValidationResult.qrCode
        : null;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(20),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.red,
                    borderRadius: const pw.BorderRadius.only(
                      topLeft: pw.Radius.circular(15),
                      topRight: pw.Radius.circular(15),
                    ),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'EVENT TICKET',
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        eventName,
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Ticket details section
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(20),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: const pw.BorderRadius.only(
                      bottomLeft: pw.Radius.circular(15),
                      bottomRight: pw.Radius.circular(15),
                    ),
                  ),
                  child: pw.Column(
                    children: [
                      // Event details
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('Date', style: pw.TextStyle(color: PdfColors.grey600, fontSize: 12)),
                              pw.SizedBox(height: 5),
                              pw.Text(formatDate(eventDate), style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                            ],
                          ),
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('Time', style: pw.TextStyle(color: PdfColors.grey600, fontSize: 12)),
                              pw.SizedBox(height: 5),
                              pw.Text(formatTime(eventTime), style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),

                      pw.SizedBox(height: 20),

                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('Seat', style: pw.TextStyle(color: PdfColors.grey600, fontSize: 12)),
                              pw.SizedBox(height: 5),
                              pw.Text(seatNumber, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                            ],
                          ),
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('Price', style: pw.TextStyle(color: PdfColors.grey600, fontSize: 12)),
                              pw.SizedBox(height: 5),
                              pw.Text('$pricePaid DZD', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),

                      pw.SizedBox(height: 20),

                      pw.Row(
                        children: [
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('Duration', style: pw.TextStyle(color: PdfColors.grey600, fontSize: 12)),
                              pw.SizedBox(height: 5),
                              pw.Text('$duration minutes', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),

                      pw.SizedBox(height: 30),

                      // QR Code section
                      pw.Center(
                        child: pw.Column(
                          children: [
                            pw.Text(
                              'Scan QR Code for Entry',
                              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                            ),
                            pw.SizedBox(height: 15),
                            pw.Container(
                              width: 150,
                              height: 150,
                              child: qrCode != null
                                  ? pw.BarcodeWidget(
                                barcode: pw.Barcode.qrCode(),
                                data: ticketCode,
                              )
                                  : pw.Container(
                                decoration: pw.BoxDecoration(
                                  border: pw.Border.all(),
                                ),
                                child: pw.Center(
                                  child: pw.Text('QR Code'),
                                ),
                              ),
                            ),
                            pw.SizedBox(height: 10),
                            pw.Text(
                              'Ticket Code: $ticketCode',
                              style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                pw.Spacer(),

                // Footer
                pw.Center(
                  child: pw.Text(
                    'Please present this ticket at the venue entrance',
                    style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  // Send email with PDF attachment

  Future<void> _sendTicketByEmail() async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      // 1. Generate PDF
      final pdfBytes = await _generateTicketPDF();

      // 2. Prepare API request
      final url = Uri.parse('http://127.0.0.1:8000/client/send_email/');
      final request = http.MultipartRequest('POST', url);

      // 3. Attach PDF file
      request.files.add(
        http.MultipartFile.fromBytes(
          'pdf',
          pdfBytes,
          filename: 'ticket_${widget.ticketData['ticket_code']}.pdf',
          contentType: MediaType('application', 'pdf'),
        ),
      );

      // 4. Add email and ticket data
      request.fields['email'] = 'recipient@example.com'; // Replace with user's email
      request.fields['event_name'] = widget.ticketData['event']['content']['title'];
      request.fields['date'] = formatDate(widget.ticketData['event']['start_time']);
      request.fields['seat'] = widget.ticketData['seat']?.toString() ?? 'N/A';

      // 5. Send request
      final response = await request.send();

      // 6. Check if successful
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ticket sent to email!')),
        );
      } else {
        throw Exception('Failed to send email');
      }

      // Close loading
      Navigator.of(context).pop();
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send: $e')),
      );
    }
  }
  Future<void> _sharePDF() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      // Generate PDF
      final pdfBytes = await _generateTicketPDF();

      // Get directory for saving the file
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/ticket_${widget.ticketData['ticket_code']}.pdf');
      await file.writeAsBytes(pdfBytes);

      // Open the file which will allow sharing through native options
      final result = await OpenFile.open(file.path);

      // If opening fails, show error
      if (result.type != ResultType.done) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open file. You can find it at: ${file.path}'),
            backgroundColor: Colors.orange,
          ),
        );
      }

      // Close loading dialog
      Navigator.of(context).pop();
    } catch (e) {
      // Close loading dialog if open
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to share PDF: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
 @override
  Widget build(BuildContext context) {
    // Extract data with fallbacks
    final ticketCode = widget.ticketData['ticket_code'] ?? 'N/A';
    final pricePaid = widget.ticketData['price_paid'] ?? '0.00';
    final purchasedAt = widget.ticketData['purchased_at'];
    final seatId = widget.ticketData['seat']?.toString() ?? 'N/A';
    final eventId = widget.ticketData['event']?.toString() ?? 'N/A';

    // Event and seat data
    final eventName = widget.ticketData['event']['content']['title'] ?? 'Event';
    final eventDate = widget.ticketData['event']['start_time'];
    final eventTime = widget.ticketData['event']['start_time'];
    final seatNumber = seatId;

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
                child: RepaintBoundary(
                  key: _ticketKey,
                  child: Stack(
                    children: [
                      // Main ticket container
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage('http://127.0.0.1:8000${widget.ticketData['event']['content']['poster']}' ?? ''),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.7),
                              BlendMode.darken,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            // Top section
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      eventName,
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
                                                    formatDate(eventDate),
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
                                                    formatTime(eventTime),
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
                                                    seatNumber,
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
                                                    '${pricePaid} DZD',
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
                                                    'Duration',
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white70,
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  SizedBox(height: 2),
                                                  Text(
                                                    '${widget.ticketData['event']['content']['duration_minutes'] ?? '0'}',
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
                                        width: 180,
                                        height: 180,
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: QrImageView(
                                          data: ticketCode,
                                          version: QrVersions.auto,
                                          size: 160.0,
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.black,
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

            // Action buttons
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  // Send by email button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _sendTicketByEmail,
                      icon: Icon(Icons.email, color: Colors.white),
                      label: Text(
                        'Send by Email',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  // Share PDF button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _sharePDF,
                      icon: Icon(Icons.share, color: Colors.red),
                      label: Text(
                        'Share PDF',
                        style: GoogleFonts.poppins(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
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