import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

class TheaterHomePage extends StatefulWidget {
  @override
  _TheaterHomePageState createState() => _TheaterHomePageState();
}

class _TheaterHomePageState extends State<TheaterHomePage> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;
  double _scrollOffset = 0.0;

  final List<Map<String, dynamic>> _movies = [
    {
      'title': 'BATMAN',
      'subtitle': '2022 • Action, Crime, Drama',
      'rating': '8.2',
      'color': Colors.grey[800]!,
      'gradient': [Colors.grey[900]!, Colors.grey[700]!],
      'backgroundImage': 'https://images.unsplash.com/photo-1635805737707-575885ab0820?w=800&h=1200&fit=crop&crop=faces',
    },
    {
      'title': 'JOKER',
      'subtitle': '2019 • Crime, Drama, Thriller',
      'rating': '8.7',
      'color': Colors.grey[800]!,
      'gradient': [Colors.grey[900]!, Colors.grey[700]!],
      'backgroundImage': 'https://images.unsplash.com/photo-1594736797933-d0501ba2fe65?w=800&h=1200&fit=crop&crop=faces',
    },
    {
      'title': 'BALLET ',
      'subtitle': '21st january • Watch the eurapean ballet',
      'rating': '',
      'color': Colors.grey[800]!,
      'gradient': [Colors.grey[900]!, Colors.grey[700]!],
      'backgroundImage': 'assets/ballet2.jpg',
    },
    {
      'title': 'DUNE',
      'subtitle': '2021 • Adventure, Drama, Sci-Fi',
      'rating': '8.0',
      'color': Colors.grey[800]!,
      'gradient': [Colors.grey[900]!, Colors.grey[700]!],
      'backgroundImage': 'https://images.unsplash.com/photo-1446776653964-20c1d3a81b06?w=800&h=1200&fit=crop&crop=faces',
    },{
      'title': 'MALOUF',
      'subtitle': '25th May • Mouhamed Benwahab',
      'rating': '',
      'color': Colors.grey[800]!,
      'gradient': [Colors.grey[900]!, Colors.grey[700]!],
      'backgroundImage': 'assets/malouf.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
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
                image: NetworkImage(_movies[_currentIndex]['backgroundImage']),
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
                  _movies[_currentIndex]['gradient'][0].withOpacity(0.7),
                  _movies[_currentIndex]['gradient'][1].withOpacity(0.5),
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
              // App Bar Section
              // App Bar Section
              // App Bar Section
              // App Bar Section
              // App Bar Section
              // App Bar Section
              // App Bar Section
              // App Bar Section
              // App Bar Section


              // Hero Content Section
              SliverToBoxAdapter(
                child: Container(
                  height: 400,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // New Show Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child:  Text(
                          'NEW SHOW',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Movie Title
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          _movies[_currentIndex]['title'],
                          key: ValueKey(_movies[_currentIndex]['title']),
                          style:  GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 48,
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

                      const SizedBox(height: 16),

                      // Movie Details
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          _movies[_currentIndex]['subtitle'],
                          key: ValueKey(_movies[_currentIndex]['subtitle']),
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
                          onPressed: () {},
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
                    itemCount: _movies.length,
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
                              image: NetworkImage(_movies[index]['backgroundImage']),
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
                                      _movies[index]['title'],
                                      style:  GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _movies[index]['subtitle'].split('•')[0],
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

              // Performances and Theater Activities Section
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title
                       Text(
                        'Live Performances',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 28,
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
                                    child:  Text(
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

                      const SizedBox(height: 30),

                      // Theater Activities Grid



                      const SizedBox(height: 30),

                      // Upcoming Performances
                       Text(
                        'This Week',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Performance List
                      ...List.generate(3, (index) {
                        final performances = [
                          {
                            'title': 'Romeo and Juliet',
                            'date': 'Wed, Jun 21',
                            'time': '7:30 PM',
                            'venue': 'Main Stage',
                            'price': '',
                            'color': Colors.red[700],
                          },
                          {
                            'title': 'Chicago',
                            'date': 'Fri, Jun 23',
                            'time': '8:00 PM',
                            'venue': 'Broadway Hall',
                            'price': '',
                            'color': Colors.blue[700],
                          },
                          {
                            'title': 'Les Misérables',
                            'date': 'Sat, Jun 24',
                            'time': '2:00 PM',
                            'venue': 'Grand Theater',
                            'price': '',
                            'color': Colors.amber[700],
                          },
                        ];

                        return Container(
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
                                        color: performances[index]['color'] as Color,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            performances[index]['title']!.toString() ?? '',
                                            style:  GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${performances[index]['venue']} • ${performances[index]['time']}',
                                            style: GoogleFonts.poppins(
                                              color: Colors.white.withOpacity(0.8),
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            performances[index]['date']!.toString() ?? '',
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
                                        Text(
                                          performances[index]['price']!.toString() ?? '',
                                          style:  GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child:  Text(
                                            'Book',
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),

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
                                'Movies',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                               Text(
                                'View All',
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 15,
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

                         Text(
                          'Trending',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: _buildTrendingCard(
                                  'JOKER', 4.7, Colors.grey.withOpacity(0.2)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTrendingCard(
                                  'Frozen 2', 4.3, Colors.grey.withOpacity(0.2)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTrendingCard(
                                  'Ford v Ferrari', 4.5, Colors.grey.withOpacity(0.2)),
                            ),
                          ],
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
                        ...List.generate(3, (index) {
                          final comingSoonMovies = [
                            {'title': 'Avatar: The Way of Water', 'date': 'Dec 16, 2024', 'genre': 'Sci-Fi, Adventure'},
                            {'title': 'Black Panther: Wakanda Forever', 'date': 'Nov 11, 2024', 'genre': 'Action, Drama'},
                            {'title': 'The Flash', 'date': 'Jun 16, 2024', 'genre': 'Action, Adventure'},
                          ];

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
                                  child: Icon(Icons.movie, color: Colors.grey[600]),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comingSoonMovies[index]['title']!,
                                        style:  GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        comingSoonMovies[index]['genre']!,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        comingSoonMovies[index]['date']!,
                                        style:  GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.deepOrange[200],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.notifications_outlined, color: Colors.grey[600]),
                              ],
                            ),
                          );
                        }),

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