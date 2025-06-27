import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../BasePage.dart';
import 'SignUp.dart';
import 'package:http/http.dart' as http;

import 'authProvider.dart';


class SignInScreen extends StatefulWidget {
  final Widget? redirectToPage; // New parameter to store the page to redirect to

  const SignInScreen({Key? key, this.redirectToPage}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Controllers for text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State variables
  bool _rememberMe = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    // Validate inputs
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter both username and password'),
          backgroundColor: Colors.red[600],
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(Uri.parse('http://127.0.0.1:8000/token/'),
        body: {
          'username': _emailController.text,
          'password': _passwordController.text,
        },
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        print(response.body);
        if (mounted) {
          final data = json.decode(response.body);
          context.read<AuthProvider>().signIn(data);
          if (widget.redirectToPage != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => widget.redirectToPage!),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BasePage()),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password or username incorrect, try again'),
              backgroundColor: Colors.red[600],
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed connecting to the server, check your network and try again.'),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    }
  }

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
              SizedBox(height: 25),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BasePage())),
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
              _buildTextField('Username', 'Enter your username', false, screenWidth, _emailController),
              SizedBox(height: screenHeight * 0.02),
              _buildTextField('Password', '••••••••••', true, screenWidth, _passwordController),
              SizedBox(height: screenHeight * 0.02),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (val) {
                      setState(() {
                        _rememberMe = val ?? true;
                      });
                    },
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
                  onPressed: _isLoading ? null : login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    shadowColor: Colors.red[600]!.withOpacity(0.3),
                    disabledBackgroundColor: Colors.red[400],
                  ),
                  child: _isLoading
                      ? SizedBox(
                    width: screenWidth * 0.05,
                    height: screenWidth * 0.05,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Text('Sign In', style: GoogleFonts.nunito(fontSize: screenWidth * 0.04, color: Colors.white, fontWeight: FontWeight.bold)),
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

  Widget _buildTextField(String label, String hintText, bool isPassword, double screenWidth, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.nunito(fontSize: screenWidth * 0.035, fontWeight: FontWeight.w600, color: Colors.grey[300])),
        SizedBox(height: screenWidth * 0.02),
        TextField(
          controller: controller,
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
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red[400]!, width: 1),
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