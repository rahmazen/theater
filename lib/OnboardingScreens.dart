
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theater/pages/BasePage.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<OnboardingItem> _pages = [
    OnboardingItem(
      title: "Theater Mobile App",
      description: "Welcome to our theater app, where modern technology makes booking your seat easy and seamless.",
      image: "assets/5.png",
      backgroundColor: Colors.white,
      textColor: Colors.blueGrey.shade700,
    ),
    OnboardingItem(
      title: "Smart Ticketing System",
      description: "Secure your tickets instantly for your favorite shows with just a few taps.",
      image: "assets/1.png",
      backgroundColor: Colors.white,
      textColor: Colors.blueGrey.shade700,
    ),
    OnboardingItem(
      title: "Easy E-Payment",
      description: "Enjoy fast and secure online payments—book from the comfort of your home.",
      image: "assets/2.png",
      backgroundColor: Colors.white,
      textColor: Colors.blueGrey.shade700,
    ),
  ];


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>  BasePage(),
          transitionDuration: Duration.zero,
        ),
      );


    }
  }

  Widget _buildNextButton() {
    return Container(
      width: double.infinity,
      height: 50,
      margin:  EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: _goToNextPage,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Next",
              style:GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ), ),
            SizedBox(width: 8),
            Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Page content
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return _buildPage(_pages[index]);
            },
          ),

          // Dots indicator
          Positioned(
            bottom: 130,
            left: 0,
            right: 0,
            child: Center(
              child: DotsIndicator(
                dotsCount: _pages.length,
                position: _currentPage.toDouble(),
                decorator: DotsDecorator(
                  color: Colors.grey.withOpacity(0.5),
                  activeColor: Colors.red[800],
                  size: Size.square(8),
                  activeSize: Size(20, 8),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
          ),

          // next button positioned at bottom
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: _buildNextButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingItem item) {
    return Container(
      color: Colors.black,
      child: Container(
        //padding: EdgeInsets.only(left: 20, bottom: 20, top: 0, right: 20),
        child: Column(
          children: [
            SizedBox(height: 60),
            Container(
              height: 400,
              width: double.infinity,
              child: Image.asset(
                item.image,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 7),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    item.description,
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 200), //  above next button
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}






class OnboardingItem {
  final String title;
  final String description;
  final String image;
  final Color backgroundColor;
  final Color textColor;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
    required this.backgroundColor,
    required this.textColor,
  });
}