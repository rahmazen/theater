import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatelessWidget {
  // App colors for dark mode
  static const Color primaryBlack = Color(0xFF000000);
  static const Color cardBlack = Color(0xFF1A1A1A);
  static const Color primaryRed = Color(0xFFDC2626);
  static const Color primaryGrey = Color(0xFF9CA3AF);
  static const Color lightGrey = Color(0xFFD1D5DB);
  static const Color darkGrey = Color(0xFF374151);

  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Header
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          // color: cardBlack,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Profile',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                     SizedBox(width: 42),
                  ],
                ),

                const SizedBox(height: 20),

                // Main Profile Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: cardBlack,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      // Profile Header Section
                      Container(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            // Profile Avatar
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [primaryRed, primaryRed.withOpacity(0.8)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: const Icon(
                                Icons.theater_comedy,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Name
                            Text(
                              'Rahma Zen',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Email
                            Text(
                              'rahma@gmail.com',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: primaryGrey,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Divider
                      Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        color: darkGrey,
                      ),

                      // Menu Items
                      _buildMenuItem(
                        icon: Icons.person_outline,
                        title: 'My Profile',
                        onTap: () {
                          // Navigate to edit profile
                        },
                      ),

                      _buildMenuItem(
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        onTap: () {
                          // Navigate to settings
                        },
                      ),

                      _buildMenuItem(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        onTap: () {
                          // Navigate to notifications
                        },
                      ),

                      _buildMenuItem(
                        icon: Icons.history_outlined,
                        title: 'Transaction History',
                        onTap: () {
                          // Navigate to transaction history
                        },
                      ),

                      _buildMenuItem(
                        icon: Icons.help_outline,
                        title: 'FAQ',
                        onTap: () {
                          // Navigate to FAQ
                        },
                      ),

                      _buildMenuItem(
                        icon: Icons.info_outline,
                        title: 'About App',
                        onTap: () {
                          // Navigate to about app
                        },
                      ),

                      // Divider before logout
                      Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        color: darkGrey,
                      ),

                      _buildMenuItem(
                        icon: Icons.logout_outlined,
                        title: 'Logout',
                        isLogout: true,
                        onTap: () {
                          _showLogoutDialog(context);
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                // color: isLogout ? primaryRed.withOpacity(0.1) : darkGrey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isLogout ? primaryRed : lightGrey,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: isLogout ? primaryRed : Colors.white,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: cardBlack,
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          actionsPadding: const EdgeInsets.fromLTRB(0, 24, 0, 0), // Increased top padding

          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: primaryRed.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: primaryRed,
                  size: 28,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Sign Out',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Are you sure you want to sign out of your account?',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: primaryGrey,
                  height: 1.4,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 32), // Add spacing to push buttons down
            ],
          ),

          actions: [
            Container(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Divider
                  Container(
                    height: 0.3,
                    width: double.infinity,
                    color: primaryGrey.withOpacity(0.3),
                  ),

                  // Buttons Row
                  SizedBox(
                    height: 56,
                    child: Row(
                      children: [
                        // Cancel Button
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: primaryGrey,
                              padding: EdgeInsets.zero,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: primaryGrey,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                        ),

                        // Vertical Divider
                        Container(
                          width: 0.5,
                          height: double.infinity,
                          color: primaryGrey.withOpacity(0.3),
                        ),

                        // Sign Out Button
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();

                              // Handle logout logic here
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Signed out successfully',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: primaryRed,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  margin: const EdgeInsets.all(16),
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: primaryRed,
                              padding: EdgeInsets.zero,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                            ),
                            child: Text(
                              'Sign Out',
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: primaryRed,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }}