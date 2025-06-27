import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theater/pages/Account/authProvider.dart';
import 'package:google_fonts/google_fonts.dart';

class PointsBalance extends StatelessWidget {
  const PointsBalance({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[900]!.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Theater-themed icon
          Icon(
            Icons.local_play_rounded, // Theater ticket icon
            color: Colors.red[400],
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            '${authProvider.authData?.points ?? 0}',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}