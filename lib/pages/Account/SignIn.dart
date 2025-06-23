import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'SignUp.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25,),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: [
                    Icon(Icons.arrow_back_ios_rounded, color: Colors.red[300], size: screenWidth * 0.05),
                    SizedBox(width: screenWidth * 0.02),
                    Text('Back', style: GoogleFonts.nunito(color: Colors.red[300], fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Text('Welcome to the Show', style: GoogleFonts.nunito(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: screenHeight * 0.01),
              Text('Sign in to continue', style: GoogleFonts.nunito(fontSize: screenWidth * 0.04, color: Colors.grey[400])),
              SizedBox(height: screenHeight * 0.03),
              _buildTextField('Email', 'Enter your email', false, screenWidth),
              SizedBox(height: screenHeight * 0.02),
              _buildTextField('Password', '••••••••••', true, screenWidth),
              SizedBox(height: screenHeight * 0.02),
              Row(
                children: [
                  Checkbox(
                    value: true,
                    onChanged: (val) {},
                    activeColor: Colors.red[600],
                    checkColor: Colors.white,
                    side: BorderSide(color: Colors.red[300]!),
                  ),
                  Text('Remember me', style: GoogleFonts.nunito(fontSize: screenWidth * 0.03, color: Colors.grey[300])),
                  Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text('Forgot password?', style: GoogleFonts.nunito(fontSize: screenWidth * 0.03, color: Colors.red[400], fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.06,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    shadowColor: Colors.red[600]!.withOpacity(0.3),
                  ),
                  child: Text('Sign In', style: GoogleFonts.nunito(fontSize: screenWidth * 0.04, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[700], thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    child: Text('or continue with', style: GoogleFonts.nunito(fontSize: screenWidth * 0.03, color: Colors.grey[500])),
                  ),
                  Expanded(child: Divider(color: Colors.grey[700], thickness: 1)),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton(Icons.facebook, Colors.blue[700]!, screenWidth),
                  SizedBox(width: screenWidth * 0.04),
                  _buildSocialButton(Icons.g_mobiledata, Colors.red[500]!, screenWidth),
                  SizedBox(width: screenWidth * 0.04),
                  _buildSocialButton(Icons.apple, Colors.white, screenWidth),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ", style: GoogleFonts.nunito(color: Colors.grey[400], fontSize: screenWidth * 0.03)),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(context, PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const SignUpScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
                      transitionDuration: const Duration(milliseconds: 300),
                    )),
                    child: Text('Sign up', style: GoogleFonts.nunito(color: Colors.red[400], fontWeight: FontWeight.bold, fontSize: screenWidth * 0.03)),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.theaters, size: screenWidth * 0.04, color: Colors.red[600]),
                  SizedBox(width: screenWidth * 0.02),
                  Text('Theater App', style: GoogleFonts.nunito(fontSize: screenWidth * 0.035, color: Colors.red[400], fontWeight: FontWeight.w600)),
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.copyright_rounded, size: screenWidth * 0.03, color: Colors.grey[600]),
                  SizedBox(width: screenWidth * 0.01),
                  Text('2025 Theater App. All rights reserved.', style: GoogleFonts.nunito(fontSize: screenWidth * 0.03, color: Colors.grey[600])),
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
              Container(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline_rounded, size: screenWidth * 0.03, color: Colors.grey[600]),
                    SizedBox(width: screenWidth * 0.01),
                    Text('Version 1.0.0', style: GoogleFonts.nunito(fontSize: screenWidth * 0.03, color: Colors.grey[600])),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hintText, bool isPassword, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.nunito(fontSize: screenWidth * 0.035, fontWeight: FontWeight.w600, color: Colors.grey[300])),
        SizedBox(height: screenWidth * 0.02),
        TextField(
          cursorColor: Colors.red[400],
          style: GoogleFonts.nunito(color: Colors.white),
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.nunito(color: Colors.grey[500], fontSize: screenWidth * 0.035),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),

            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),

            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),

            ),
            contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenWidth * 0.04),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, Color color, double screenWidth) {
    return Container(
      width: screenWidth * 0.12,
      height: screenWidth * 0.12,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[700]!, width: 1),
      ),
      child: Icon(icon, color: color, size: screenWidth * 0.06),
    );
  }
}