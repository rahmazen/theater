import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Account/authProvider.dart';

class OfferDiscountWidget extends StatefulWidget {
  final double originalPrice;
  final String eventId;
  final Function(double) onDiscountApplied;

  const OfferDiscountWidget({
    Key? key,
    required this.originalPrice,
    required this.eventId,
    required this.onDiscountApplied,
  }) : super(key: key);

  @override
  _OfferDiscountWidgetState createState() => _OfferDiscountWidgetState();
}

class _OfferDiscountWidgetState extends State<OfferDiscountWidget> {
  List<dynamic> availableOffers = [];
  int? selectedOfferId;
  int userPoints = 0;
  bool isLoading = true;
  bool isApplyingDiscount = false;

  @override
  void initState() {
    super.initState();
    _loadUserPointsAndOffers();
  }

  Future<void> _loadUserPointsAndOffers() async {
    setState(() {
      isLoading = true;
    });

    try {
      // 1. Get user points
      final authData = Provider.of<AuthProvider>(context, listen: false).authData;
      if (authData != null) {
        setState(() {
          userPoints = authData.points ?? 0;
        });
      }

      // 2. Get available offers for this event
      final offersResponse = await http.get(
        Uri.parse('http://127.0.0.1:8000/client/offer/${widget.eventId}/'),
      );

      if (offersResponse.statusCode == 200) {
        final decodedResponse = json.decode(offersResponse.body);
        if (decodedResponse is List) {
          setState(() {
            availableOffers = decodedResponse;
          });
        }
      }
    } catch (e) {
      print('Error loading offers: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading offers'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _applyDiscount() async {
    if (selectedOfferId == null) return;

    setState(() {
      isApplyingDiscount = true;
    });

    try {
      final authData = Provider.of<AuthProvider>(context, listen: false).authData;
      if (authData?.username == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/client/redeem/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': authData!.username,
          'offer_id': selectedOfferId,
          'event_id': widget.eventId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final discountPercentage = data['discount_percentage']?.toDouble() ?? 0.0;
        final discountAmount = widget.originalPrice * (discountPercentage / 100);
        widget.onDiscountApplied(discountAmount);

        // Update user points
        setState(() {
          userPoints = data['remaining_points']?.toInt() ?? userPoints;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Discount applied successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final errorMessage = json.decode(response.body)['message'] ?? 'Failed to apply discount';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error applying discount: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error applying discount: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isApplyingDiscount = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Points display
        Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 20),
              SizedBox(width: 8),
              Text(
                'Your Points: $userPoints',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Offers section
        if (!isLoading && availableOffers.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Available Offers',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              ...availableOffers.map<Widget>((offer) {  // Explicitly specify Widget return type
                final offerMap = offer as Map<String, dynamic>? ?? {};
                return _buildOfferCard(offerMap.cast<String, dynamic>());
              }).toList(),
            ],
          ),

        if (isLoading)
          Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(color: Colors.red),
            ),
          ),

        if (!isLoading && availableOffers.isEmpty)
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'No offers available for this event',
              style: GoogleFonts.poppins(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildOfferCard(Map<String, dynamic> offer) {
    final isDiscount = offer['offer_type'] == 'discount';
    final pointsRequired = offer['points_required']?.toInt() ?? 0;
    final canAfford = userPoints >= pointsRequired;
    final isSelected = selectedOfferId == offer['id'];
    final discountPercentage = offer['discount_percentage']?.toDouble() ?? 0.0;
    final discountAmount = widget.originalPrice * (discountPercentage / 100);

    return Card(
      color: Colors.grey[850],
      margin: EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isSelected
            ? BorderSide(color: Colors.red, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  offer['name'] ?? 'Unnamed Offer',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '$pointsRequired pts',
                      style: GoogleFonts.poppins(
                        color: Colors.amber,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            if (offer['description'] != null)
              Text(
                offer['description']!,
                style: GoogleFonts.poppins(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
            if (isDiscount) SizedBox(height: 8),
            if (isDiscount)
              Text(
                '${discountPercentage.toStringAsFixed(0)}% discount (${discountAmount.toStringAsFixed(2)} DZD)',
                style: GoogleFonts.poppins(
                  color: Colors.green[400],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: canAfford
                  ? () {
                if (isSelected) {
                  setState(() => selectedOfferId = null);
                  widget.onDiscountApplied(0); // Reset discount
                } else {
                  setState(() => selectedOfferId = offer['id']);
                  _applyDiscount();
                }
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? Colors.grey[700] : Colors.red,
                minimumSize: Size(double.infinity, 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isApplyingDiscount && selectedOfferId == offer['id']
                  ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : Text(
                isSelected ? 'Applied' : canAfford ? 'Apply' : 'Not enough points',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}