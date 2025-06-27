import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:theater/pages/payement/TicketPage.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Account/authProvider.dart';
// Import your actual files here:
// import 'package:theater/pages/payement/TicketPage.dart';
// import 'Account/authProvider.dart';

class PaymentVerificationPage extends StatefulWidget {
  final String orderId;
  final dynamic selectedReplay;
  final dynamic selectedSeat;
  final String url ;

  const PaymentVerificationPage({
    Key? key,
    required this.orderId,
    required this.selectedReplay,
    required this.selectedSeat,
    required this.url,
  }) : super(key: key);

  @override
  State<PaymentVerificationPage> createState() => _PaymentVerificationPageState();
}

class _PaymentVerificationPageState extends State<PaymentVerificationPage> {
  bool isLoading = true;
  String currentStatus = 'checking';
  Timer? _timer;
  int _retryCount = 0;
  final int _maxRetries = 60; // Maximum number of retries (5 minutes if checking every 5 seconds)

  @override
  void initState() {
    super.initState();
    _startPaymentVerification();
    _launchPaymentUrl();
  }

  Future<void> _launchPaymentUrl() async {
    try {
      if (await canLaunchUrl(Uri.parse(widget.url))) {
        await launchUrl(Uri.parse(widget.url), mode: LaunchMode.externalApplication);
      } else {
        print('Could not launch url');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open payment page'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPaymentVerification() {
    getTrans(widget.orderId);
    // Start periodic checking every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_retryCount < _maxRetries) {
        getTrans(widget.orderId);
        _retryCount++;
      } else {
        // Stop checking after max retries
        timer.cancel();
        setState(() {
          currentStatus = 'timeout';
          isLoading = false;
        });
      }
    });
  }

  Future<void> getTrans(String orderId) async {
    try {

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/client/payment2/${orderId}'),
        headers: {'Content-Type': 'application/json'},

      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data['data']['attributes']['status'];

        setState(() {
          currentStatus = status;
        });

        if (status == 'processing') {

        } else if (status == 'general_faiture') {
          // Stop checking on failure
          _timer?.cancel();
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Payment failed'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (status == 'paid') {
          // Stop checking on success
          _timer?.cancel();

          await createTicket();
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting transaction: $e');
    }
  }

  Future<void> createTicket() async {
    setState(() {
      isLoading = true;
    });

    print(widget.selectedSeat?.seatNumber);
    print(widget.selectedReplay);

    final authData = Provider.of<AuthProvider>(context, listen: false).authData;

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/client/book/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'seat_id': widget.selectedSeat?.seatNumber,
          'event_id': widget.selectedReplay,
          'user_id': authData?.username
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          isLoading = false;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TicketPage(ticketData: data),
          ),
        );
      } else {
        setState(() {
          isLoading = false;
        });

      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error creating ticket: $e');

    }
  }

  void _retryPayment() {
    setState(() {
      isLoading = true;
      currentStatus = 'checking';
      _retryCount = 0;
    });
    _startPaymentVerification();
  }

  Widget _buildStatusIcon() {
    switch (currentStatus) {
      case 'processing':
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          strokeWidth: 3,
        );
      case 'paid':
        return Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 60,
        );
      case 'general_failure':
        return Icon(
          Icons.error,
          color: Colors.red,
          size: 60,
        );
      case 'timeout':
        return Icon(
          Icons.access_time,
          color: Colors.red[300],
          size: 60,
        );
      default:
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          strokeWidth: 3,
        );
    }
  }

  String _getStatusMessage() {
    switch (currentStatus) {
      case 'processing':
        return 'Payment is being processed...\nPlease wait while we verify your payment.';
      case 'paid':
        return 'Payment successful!\nCreating your ticket...';
      case 'general_failure':
        return 'Payment failed.\nPlease try again or contact support.';
      case 'timeout':
        return 'Payment verification timed out.\nPlease check your payment status or try again.';
      default:
        return 'Checking payment status...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Payment Verification',
          style: TextStyle(color: Colors.red),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.red),
        automaticallyImplyLeading: false, // Prevent back navigation during payment
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatusIcon(),
            SizedBox(height: 30),
            Text(
              _getStatusMessage(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            if (currentStatus == 'processing')
              Text(
                'Attempt ${_retryCount + 1} of $_maxRetries',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
            SizedBox(height: 40),
            if (currentStatus == 'general_failure' || currentStatus == 'timeout')
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _retryPayment,
                    child: Text(
                      'Retry Payment Verification',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Text(
                      'Back to Home',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            if (currentStatus == 'processing')
              TextButton(
                onPressed: () {
                  _timer?.cancel();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Text(
                  'Cancel and Go Back',
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}