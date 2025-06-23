import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContentPage extends StatefulWidget {
  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  String selectedCategory = 'All';
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  final List<String> categories = ['All', 'Movies', 'Theater', 'Performances', 'Upcoming'];

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  final List<ContentItem> movies = [
    ContentItem(
      title: 'Dune: Part Two',
      imageUrl: 'https://picsum.photos/300/450?random=1',
      duration: '2h 46m',
      genre: 'Sci-Fi, Adventure',
    ),
    ContentItem(
      title: 'The Batman',
      imageUrl: 'https://picsum.photos/300/450?random=2',
      duration: '2h 56m',
      genre: 'Action, Crime',
    ),
    ContentItem(
      title: 'Spider-Man: No Way Home',
      imageUrl: 'https://picsum.photos/300/450?random=3',
      duration: '2h 28m',
      genre: 'Action, Adventure',
    ),
    ContentItem(
      title: 'Avatar: The Way of Water',
      imageUrl: 'https://picsum.photos/300/450?random=4',
      duration: '3h 12m',
      genre: 'Sci-Fi, Adventure',
    ),
    ContentItem(
      title: 'Top Gun: Maverick',
      imageUrl: 'https://picsum.photos/300/450?random=5',
      duration: '2h 11m',
      genre: 'Action, Drama',
    ),
  ];

  final List<ContentItem> theater = [
    ContentItem(
      title: 'Romeo & Juliet',
      imageUrl: 'https://picsum.photos/300/450?random=6',
      duration: '2h 30m',
      genre: 'Drama, Romance',
    ),
    ContentItem(
      title: 'Hamilton',
      imageUrl: 'https://picsum.photos/300/450?random=7',
      duration: '2h 40m',
      genre: 'Musical, Biography',
    ),
    ContentItem(
      title: 'The Lion King',
      imageUrl: 'https://picsum.photos/300/450?random=8',
      duration: '2h 30m',
      genre: 'Musical, Family',
    ),
    ContentItem(
      title: 'Phantom of the Opera',
      imageUrl: 'https://picsum.photos/300/450?random=9',
      duration: '2h 20m',
      genre: 'Musical, Drama',
    ),
  ];

  final List<ContentItem> performances = [
    ContentItem(
      title: 'Swan Lake',
      imageUrl: 'https://picsum.photos/300/450?random=10',
      duration: '2h 15m',
      genre: 'Ballet, Classical',
    ),
    ContentItem(
      title: 'The Nutcracker',
      imageUrl: 'https://picsum.photos/300/450?random=11',
      duration: '2h 00m',
      genre: 'Ballet, Classical',
    ),
    ContentItem(
      title: 'Carmen',
      imageUrl: 'https://picsum.photos/300/450?random=12',
      duration: '2h 45m',
      genre: 'Opera, Drama',
    ),
  ];

  final List<ContentItem> upcoming = [
    ContentItem(
      title: 'Fast X',
      imageUrl: 'https://picsum.photos/300/450?random=13',
      duration: '2h 21m',
      genre: 'Action, Thriller',
    ),
    ContentItem(
      title: 'Guardians of the Galaxy Vol. 3',
      imageUrl: 'https://picsum.photos/300/450?random=14',
      duration: '2h 30m',
      genre: 'Action, Adventure',
    ),
    ContentItem(
      title: 'John Wick: Chapter 4',
      imageUrl: 'https://picsum.photos/300/450?random=15',
      duration: '2h 49m',
      genre: 'Action, Thriller',
    ),
  ];

  List<ContentItem> get allItems => [...movies, ...theater, ...performances, ...upcoming];

  List<ContentItem> get filteredItems {
    switch (selectedCategory) {
      case 'Movies':
        return movies;
      case 'Theater':
        return theater;
      case 'Performances':
        return performances;
      case 'Upcoming':
        return upcoming;
      default:
        return allItems;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.5,
            colors: [
              Color(0xFF6B0909).withOpacity(0.3),
              Color(0xFF2A2A2A),
              Color(0xFF000000),
            ],
          ),
        ),
        child: Expanded(
          child: Column(
            children: [
              SizedBox(height: 40),

              // Header
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    if (isSearching) ...[
                      Expanded(
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.grey[600]!,
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: searchController,
                            focusNode: searchFocusNode,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search movies, shows...',
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.grey[400],
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.clear, color: Colors.grey[400]),
                                onPressed: () {
                                  setState(() {
                                    isSearching = false;
                                    searchController.clear();
                                  });
                                },
                              ),
                            ),
                            onSubmitted: (value) {
                              // Handle search
                              print('Searching for: $value');
                            },
                          ),
                        ),
                      ),
                    ] else ...[
                      Expanded(
                        child: Text(
                          'What would you like to watch?',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.search, color: Colors.white, size: 24),
                        onPressed: () {
                          setState(() {
                            isSearching = true;
                          });
                          // Focus the search field after the widget rebuilds
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            searchFocusNode.requestFocus();
                          });
                        },
                      ),
                    ],
                  ],
                ),
              ),

              // Category Filter
              Container(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = selectedCategory == category;

                    return Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? Color(0xFFDC143C) : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? Color(0xFFDC143C) : Colors.grey[600]!,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              category,
                              style: GoogleFonts.poppins(
                                color: isSelected ? Colors.white : Colors.grey[400],
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 20),

              // Content
              Expanded(
                child: selectedCategory == 'All'
                    ? _buildAllCategoriesView()
                    : _buildFilteredGrid(),
              ),
              SizedBox(height: 70),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllCategoriesView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection('Movies', movies),
          SizedBox(height: 25),
          _buildSection('Theater', theater),
          SizedBox(height: 25),
          _buildSection('Performances', performances),
          SizedBox(height: 25),
          _buildSection('Upcoming', upcoming),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFilteredGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          return ContentCard(
            item: filteredItems[index],
            onTap: () {
              print('Tapped on ${filteredItems[index].title}');
            },
            isGridView: true,
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<ContentItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 15),
        Container(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 20),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 15),
                child: ContentCard(
                  item: items[index],
                  onTap: () {
                    print('Tapped on ${items[index].title}');
                  },
                  isGridView: false,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ContentCard extends StatelessWidget {
  final ContentItem item;
  final VoidCallback onTap;
  final bool isGridView;

  const ContentCard({
    Key? key,
    required this.item,
    required this.onTap,
    this.isGridView = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isGridView ? null : 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            Expanded(
              flex: isGridView ? 4 : 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(item.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: [0.6, 1.0],
                    ),
                  ),
                ),
              ),
            ),

            // Content Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: isGridView ? 12 : 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      item.genre,
                      style: GoogleFonts.poppins(
                        color: Colors.grey[400],
                        fontSize: isGridView ? 10 : 11,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      item.duration,
                      style: GoogleFonts.poppins(
                        color: Color(0xFFDC143C),
                        fontSize: isGridView ? 10 : 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContentItem {
  final String title;
  final String imageUrl;
  final String duration;
  final String genre;

  ContentItem({
    required this.title,
    required this.imageUrl,
    required this.duration,
    required this.genre,
  });
}