import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:theater/pages/Account/SignIn.dart';
import 'package:theater/pages/Account/authProvider.dart';
import 'package:theater/pages/BasePage.dart';
import 'package:theater/pages/CinemaSeatSelectionPage.dart';
import 'package:theater/pages/ContentPage.dart';
import 'package:theater/pages/TheaterHomePage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theater/pages/TicketHistoryPage.dart';
import 'package:theater/pages/payement/TicketPage.dart';
import 'package:theater/pages/profile_page.dart';
import  'package:provider/provider.dart' ;
void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => ChangeNotifierProvider(
        create: (_) => AuthProvider(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Theater App',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: BasePage(),
    );
  }
}
