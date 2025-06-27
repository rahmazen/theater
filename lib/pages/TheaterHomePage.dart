import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http ;
import 'dart:convert' ;
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';

import 'TheaterShowDetailPage.dart';

class TheaterHomePage extends StatefulWidget {
  @override
  _TheaterHomePageState createState() => _TheaterHomePageState();
}

class _TheaterHomePageState extends State<TheaterHomePage> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;
  double _scrollOffset = 0.0;
  bool isLoadingTodays = false ;
  bool isLoadingWeeks = false ;
  bool isLoadingFavorites = false ;
  bool isLoadingUpcoming = false ;
List<dynamic> todaysEvents =[
  {
    "id": 3,
    "content": {
      "id": 2,
      "title": "loading...",
      "description": "loading...",
      "genre": "live performance",
      "duration_minutes": 0,
      "release_year": null,
      "poster": "/media/catalogue/posters/ballet2.jpg",
      "trailer_url": null,
      "rating": null,
      "language": null,
      "subtitles": false
    },

    "start_time": "2025-06-25T22:00:00Z",
    "event_type": "play",
    "end_time": "2025-06-25T23:40:00Z",
    "ticket_price": "1000.00",
    "minimum_age": 0,
    "is_sold_out": false
  },
];
List<dynamic> thisWeeksEvents =[  {
  "id": 3,
  "content": {
    "id": 2,
    "title": "loading...",
    "description": "loading...",
    "genre": "live performance",
    "duration_minutes": 0,
    "release_year": null,
    "poster": "/media/catalogue/posters/ballet2.jpg",
    "trailer_url": null,
    "rating": null,
    "language": null,
    "subtitles": false
  },

  "start_time": "2025-06-25T22:00:00Z",
  "event_type": "play",
  "end_time": "2025-06-25T23:40:00Z",
  "ticket_price": "1000.00",
  "minimum_age": 0,
  "is_sold_out": false
},];
List<dynamic> upcomingEvents =[
  {
  "id": 3,
  "title": "loading...",
  "description": "loading...",
  "genre": "musical",
  "duration_minutes": 0,
  "release_year": 0000,
  "poster": null,
  "trailer_url": null,
  "rating": null,
  "language": null,
  "subtitles": false
  },
  ];
List<dynamic> audienceFavorites =[  {
  "id": 3,
  "content": {
    "id": 2,
    "title": "loading...",
    "description": "loading...",
    "genre": "live performance",
    "duration_minutes": 0,
    "release_year": null,
    "poster": "/media/catalogue/posters/ballet2.jpg",
    "trailer_url": null,
    "rating": null,
    "language": null,
    "subtitles": false
  },

  "start_time": "2025-06-25T22:00:00Z",
  "event_type": "play",
  "end_time": "2025-06-25T23:40:00Z",
  "ticket_price": "1000.00",
  "minimum_age": 0,
  "is_sold_out": false
},];



  Future<void> _loadTodaysEvents() async {
    try {
      setState(() => isLoadingTodays = true);
      print('loading today events .....................');

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/client/todays_events/'),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          todaysEvents = data is List ? data : [data];
          isLoadingTodays = false;
          // Reset current index if needed
          if (todaysEvents.isNotEmpty && _currentIndex >= todaysEvents.length) {
            _currentIndex = 0;
          }
        });
      } else {
        throw Exception('Failed to load today\'s events');
      }
    } catch (e) {
      print('Error loading today\'s events: $e');
      setState(() => isLoadingTodays = false);
    }
  }

  Future<void> _loadThisWeeksEvents() async {
    try {
      setState(() => isLoadingWeeks = true);
      print('loading weeks evennts .....................');
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/client/weeks_events/'),
        headers: {'Content-Type': 'application/json'},
      );
        print (response.body) ;
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          thisWeeksEvents = data is List ? data : [data];
          isLoadingWeeks = false;
        });
      } else {
        throw Exception('Failed to load this week\'s events');
      }
    } catch (e) {
      print('Error loading this week\'s events: $e');
      setState(() => isLoadingWeeks = false);
    }
  }

  Future<void> _loadAudienceFavorites() async {
    try {
      setState(() => isLoadingFavorites = true);

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/client/upcoming/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          audienceFavorites = data is List ? data : [data];
          isLoadingFavorites = false;
        });
      } else {
        throw Exception('Failed to load audience favorites');
      }
    } catch (e) {
      print('Error loading audience favorites: $e');
      setState(() => isLoadingFavorites = false);
    }
  }

  Future<void> _loadUpcomingEvents() async {
    try {
      setState(() => isLoadingUpcoming = true);

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/client/upcoming/'),
        headers: {'Content-Type': 'application/json'},
      );
            print(response.body) ;
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          upcomingEvents = data is List ? data : [data];
          isLoadingUpcoming = false;
        });
      } else {
        throw Exception('Failed to load upcoming events');
      }
    } catch (e) {
      print('Error loading upcoming events: $e');
      setState(() => isLoadingUpcoming = false);
    }
  }



  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
    _loadTodaysEvents();
    _loadThisWeeksEvents();
    _loadUpcomingEvents();

  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Dynamic Background with parallax effect and background image
          AnimatedContainer(
            duration:  Duration(milliseconds: 100),
            transform: Matrix4.identity()..translate(0, -_scrollOffset * 0.3),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('http://127.0.0.1:8000${todaysEvents[_currentIndex]['content']['poster']}'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.6),
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          // Additional gradient overlay for better text readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                Colors.grey[900]!.withOpacity(0.7),
                Colors.grey[700]!.withOpacity(0.5),
                  Colors.black.withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Background texture/pattern
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Scrollable Content
          CustomScrollView(
            controller: _scrollController,
            slivers: [

              SliverToBoxAdapter(
                child: Container(
                  height: 400,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child:  Text(
                          'today\'s schedule',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Movie Title
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          todaysEvents[_currentIndex]['content']['title'] ,
                          key: ValueKey(todaysEvents[_currentIndex]['content']['title']),
                          style:  GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Popularity and Rating
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.1),
                                    ),
                                  ),
                                  child:  Text(
                                    'POPULAR WITH FRIENDS',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Movie Details
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          todaysEvents[_currentIndex]['content']['description'],
                          key: ValueKey(todaysEvents[_currentIndex]['content']['description']),
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Buy Ticket Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TheaterShowDetailPage(
                                  eventid: todaysEvents[_currentIndex]['id'].toString(),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child:  Text(
                            'BUY TICKET',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Movie Carousel Section
              SliverToBoxAdapter(
                child: Container(
                  height: 250,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemCount: todaysEvents.length,
                    itemBuilder: (context, index) {
                      final scale = _currentIndex == index ? 1.0 : 0.85;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        transform: Matrix4.identity()..scale(scale),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage('http://127.0.0.1:8000${todaysEvents[_currentIndex]['content']['poster']}'),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.4),
                                BlendMode.darken,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Glassy overlay
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.3),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                              // Movie info
                              Positioned(
                                bottom: 20,
                                left: 20,
                                right: 20,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      todaysEvents[_currentIndex]['content']['title'],
                                      style:  GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      todaysEvents[_currentIndex]['event_type'] ?? '',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Fixed: Remove nested SliverToBoxAdapter and flatten the structure
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title
                      Text(
                        ' ADDS',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Featured Performance Card
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.red[800]!,
                              Colors.red[600]!,
                              Colors.grey[600]!,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Glassy overlay
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.1),
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.4),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                            // Content
                            Positioned(
                              left: 30,
                              bottom: 30,
                              right: 30,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.yellow[600],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'TONIGHT',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'The Phantom of the Opera',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Main Theater • 8:00 PM • 45-85',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 60), // Combined spacing

                      // This Week Section Title
                      Text(
                        'This Week',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Performance List - Using dynamic data
                      ...thisWeeksEvents.map((event) {
                        DateTime startTime = DateTime.parse(event['start_time']);
                        String formattedDate = DateFormat('EEE, MMM d').format(startTime);
                        String formattedTime = DateFormat('h:mm a').format(startTime);

                        return GestureDetector(
                           onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TheaterShowDetailPage(
                                eventid: event['id'].toString(),
                              ),
                            ),
                          );
                         },
                          child:
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 4,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.blue[700],
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                event['content']['title'] ?? 'No Title',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${event['event_type'] ?? 'Unknown Genre'} • $formattedTime',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white.withOpacity(0.8),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                formattedDate,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white.withOpacity(0.6),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            // Event type badge
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.blue[700]?.withOpacity(0.3),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                event['event_type']?.toString().toUpperCase() ?? 'EVENT',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),

                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                        );
                      }).toList(),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              // Movies Section
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.only(left:5 , right: 5),
                          child: Row(

                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               Text(
                                'Audience favorites',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                            ],
                          ),
                        ),

                        // Featured Movies Grid
                        SizedBox(
                          height: 200,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: _buildLargeMovieCard(
                                  'Ant-Man',
                                  'Action, Adventure',
                                  4.5,
                                  Colors.white.withOpacity(0.2),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: _buildSmallMovieCard(
                                        'The Irishman',
                                        4.2,
                                        Colors.grey[600]!,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Expanded(
                                      child: _buildSmallMovieCard(
                                        'Parasite',
                                        4.8,
                                        Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Additional Content Section
                         Text(
                          'Coming Soon',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Coming Soon Movies List
                        // Coming Soon Events List
                        ...upcomingEvents.map((event) {
                          // Format duration from minutes to hours and minutes
                          String formatDuration(int? minutes) {
                            if (minutes == null) return 'Duration unknown';
                            int hours = minutes ~/ 60;
                            int remainingMinutes = minutes % 60;
                            if (hours > 0) {
                              return '${hours}h ${remainingMinutes}m';
                            } else {
                              return '${minutes}m';
                            }
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: event['poster'] != null
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
    'http://127.0.0.1:8000${event['poster']}',
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(Icons.movie, color: Colors.grey[600]);
                                      },
                                    ),
                                  )
                                      : Icon(Icons.movie, color: Colors.grey[600]),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        event['title'] ?? 'No Title',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        event['genre'] ?? 'Unknown Genre',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            event['release_year']?.toString() ?? 'Year unknown',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.deepOrange[200],
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            formatDuration(event['duration_minutes']),
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              color: Colors.grey[500],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (event['description'] != null && event['description'].isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Text(
                                            event['description'],
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              color: Colors.grey[400],
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    if (event['rating'] != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.amber.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          event['rating'].toString(),
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            color: Colors.amber,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 8),
                                    Icon(Icons.notifications_outlined, color: Colors.grey[600]),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),

                        const SizedBox(height: 50), // Bottom padding

                        const SizedBox(height: 50), // Bottom padding
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLargeMovieCard(
      String title, String genre, double rating, Color bgColor) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:  GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  genre,
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(5, (index) => Icon(
                    index < rating.floor() ? Icons.star : Icons.star_outline,
                    color: Colors.orange,
                    size: 16,
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallMovieCard(String title, double rating, Color bgColor) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:  GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(5, (index) => Icon(
                    index < rating.floor() ? Icons.star : Icons.star_outline,
                    color: Colors.orange,
                    size: 12,
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingCard(String title, double rating, Color bgColor) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:  GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(5, (index) => Icon(
                    index < rating.floor() ? Icons.star : Icons.star_outline,
                    color: Colors.orange,
                    size: 10,
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(String title, String subtitle, String time, IconData icon, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 24,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      time,
                      style:  GoogleFonts.poppins(
                        color: Colors.orange,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:  GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}