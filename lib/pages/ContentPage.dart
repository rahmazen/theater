import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'TheaterShowDetailPage.dart';

class ContentPage extends StatefulWidget {
  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  String selectedCategory = 'All';
  DateTime? selectedDate;
  bool isSearching = false;
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  final List<String> categories = ['All', 'Movies', 'Theater', 'Performances', 'Upcoming'];

  // Date filter options
  final List<String> dateFilters = ['All Dates', 'Today', 'Tomorrow', 'This Week', 'Choose Date'];
  String selectedDateFilter = 'All Dates';

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
      showDate: DateTime.now(),
    ),
    ContentItem(
      title: 'The Batman',
      imageUrl: 'https://picsum.photos/300/450?random=2',
      duration: '2h 56m',
      genre: 'Action, Crime',
      showDate: DateTime.now().add(Duration(days: 1)),
    ),
    ContentItem(
      title: 'Spider-Man: No Way Home',
      imageUrl: 'https://picsum.photos/300/450?random=3',
      duration: '2h 28m',
      genre: 'Action, Adventure',
      showDate: DateTime.now().add(Duration(days: 2)),
    ),
    ContentItem(
      title: 'Avatar: The Way of Water',
      imageUrl: 'https://picsum.photos/300/450?random=4',
      duration: '3h 12m',
      genre: 'Sci-Fi, Adventure',
      showDate: DateTime.now().add(Duration(days: 3)),
    ),
    ContentItem(
      title: 'Top Gun: Maverick',
      imageUrl: 'https://picsum.photos/300/450?random=5',
      duration: '2h 11m',
      genre: 'Action, Drama',
      showDate: DateTime.now().add(Duration(days: 5)),
    ),
  ];

  final List<ContentItem> theater = [
    ContentItem(
      title: 'Romeo & Juliet',
      imageUrl: 'https://picsum.photos/300/450?random=6',
      duration: '2h 30m',
      genre: 'Drama, Romance',
      showDate: DateTime.now().add(Duration(days: 1)),
    ),
    ContentItem(
      title: 'Hamilton',
      imageUrl: 'https://picsum.photos/300/450?random=7',
      duration: '2h 40m',
      genre: 'Musical, Biography',
      showDate: DateTime.now().add(Duration(days: 4)),
    ),
    ContentItem(
      title: 'The Lion King',
      imageUrl: 'https://picsum.photos/300/450?random=8',
      duration: '2h 30m',
      genre: 'Musical, Family',
      showDate: DateTime.now().add(Duration(days: 6)),
    ),
    ContentItem(
      title: 'Phantom of the Opera',
      imageUrl: 'https://picsum.photos/300/450?random=9',
      duration: '2h 20m',
      genre: 'Musical, Drama',
      showDate: DateTime.now().add(Duration(days: 7)),
    ),
  ];

  final List<ContentItem> performances = [
    ContentItem(
      title: 'Swan Lake',
      imageUrl: 'https://picsum.photos/300/450?random=10',
      duration: '2h 15m',
      genre: 'Ballet, Classical',
      showDate: DateTime.now().add(Duration(days: 2)),
    ),
    ContentItem(
      title: 'The Nutcracker',
      imageUrl: 'https://picsum.photos/300/450?random=11',
      duration: '2h 00m',
      genre: 'Ballet, Classical',
      showDate: DateTime.now().add(Duration(days: 8)),
    ),
    ContentItem(
      title: 'Carmen',
      imageUrl: 'https://picsum.photos/300/450?random=12',
      duration: '2h 45m',
      genre: 'Opera, Drama',
      showDate: DateTime.now().add(Duration(days: 10)),
    ),
  ];

  final List<ContentItem> upcoming = [
    ContentItem(
      title: 'Fast X',
      imageUrl: 'https://picsum.photos/300/450?random=13',
      duration: '2h 21m',
      genre: 'Action, Thriller',
      showDate: DateTime.now().add(Duration(days: 14)),
    ),
    ContentItem(
      title: 'Guardians of the Galaxy Vol. 3',
      imageUrl: 'https://picsum.photos/300/450?random=14',
      duration: '2h 30m',
      genre: 'Action, Adventure',
      showDate: DateTime.now().add(Duration(days: 21)),
    ),
    ContentItem(
      title: 'John Wick: Chapter 4',
      imageUrl: 'https://picsum.photos/300/450?random=15',
      duration: '2h 49m',
      genre: 'Action, Thriller',
      showDate: DateTime.now().add(Duration(days: 28)),
    ),
  ];

  List<ContentItem> get allItems => [...movies, ...theater, ...performances, ...upcoming];

  List<ContentItem> get filteredItems {
    List<ContentItem> categoryFiltered;

    switch (selectedCategory) {
      case 'Movies':
        categoryFiltered = movies;
        break;
      case 'Theater':
        categoryFiltered = theater;
        break;
      case 'Performances':
        categoryFiltered = performances;
        break;
      case 'Upcoming':
        categoryFiltered = upcoming;
        break;
      default:
        categoryFiltered = allItems;
    }

    // Apply date filter
    List<ContentItem> dateFiltered = _applyDateFilter(categoryFiltered);

    // Apply search filter
    return _applySearchFilter(dateFiltered);
  }

  List<ContentItem> _applySearchFilter(List<ContentItem> items) {
    if (searchQuery.isEmpty) return items;

    String query = searchQuery.toLowerCase();
    return items.where((item) {
      return item.title.toLowerCase().contains(query) ||
          item.genre.toLowerCase().contains(query);
    }).toList();
  }

  List<ContentItem> _applyDateFilter(List<ContentItem> items) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = today.add(Duration(days: 1));
    DateTime endOfWeek = today.add(Duration(days: 7 - today.weekday));

    switch (selectedDateFilter) {
      case 'Today':
        return items.where((item) {
          DateTime itemDate = DateTime(item.showDate.year, item.showDate.month, item.showDate.day);
          return itemDate.isAtSameMomentAs(today);
        }).toList();

      case 'Tomorrow':
        return items.where((item) {
          DateTime itemDate = DateTime(item.showDate.year, item.showDate.month, item.showDate.day);
          return itemDate.isAtSameMomentAs(tomorrow);
        }).toList();

      case 'This Week':
        return items.where((item) {
          DateTime itemDate = DateTime(item.showDate.year, item.showDate.month, item.showDate.day);
          return itemDate.isAfter(today.subtract(Duration(days: 1))) &&
              itemDate.isBefore(endOfWeek.add(Duration(days: 1)));
        }).toList();

      case 'Choose Date':
        if (selectedDate != null) {
          DateTime targetDate = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day);
          return items.where((item) {
            DateTime itemDate = DateTime(item.showDate.year, item.showDate.month, item.showDate.day);
            return itemDate.isAtSameMomentAs(targetDate);
          }).toList();
        }
        return items;

      default:
        return items;
    }
  }

  List<ContentItem> _applyDateFilterToSection(List<ContentItem> items) {
    List<ContentItem> dateFiltered = _applyDateFilter(items);
    return _applySearchFilter(dateFiltered);
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
                                    searchQuery = '';
                                  });
                                },
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                            onSubmitted: (value) {
                              setState(() {
                                searchQuery = value;
                              });
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

              SizedBox(height: 15),

              // Date Filter
              Container(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemCount: dateFilters.length,
                  itemBuilder: (context, index) {
                    final dateFilter = dateFilters[index];
                    final isSelected = selectedDateFilter == dateFilter;

                    return Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Center(
                        child: GestureDetector(
                          onTap: () async {
                            if (dateFilter == 'Choose Date') {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate ?? DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(Duration(days: 365)),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.dark(
                                        primary: Color(0xFFDC143C),
                                        onPrimary: Colors.white,
                                        surface: Color(0xFF1C1C1C),
                                        onSurface: Colors.white,
                                        background: Color(0xFF121212),
                                        onBackground: Colors.white,
                                      ),
                                      textTheme: GoogleFonts.poppinsTextTheme().apply(
                                        bodyColor: Colors.white,
                                        displayColor: Colors.white,
                                      ),
                                      datePickerTheme: DatePickerThemeData(
                                        backgroundColor: Color(0xFF1C1C1C),
                                        headerBackgroundColor: Color(0xFF1C1C1C),
                                        headerForegroundColor: Colors.white,
                                        dividerColor: Colors.transparent,
                                        dayStyle: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        weekdayStyle: GoogleFonts.poppins(
                                          color: Colors.grey[400],
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        yearStyle: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        headerHeadlineStyle: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        headerHelpStyle: GoogleFonts.poppins(
                                          color: Colors.grey[400],
                                          fontSize: 12,
                                        ),
                                        dayForegroundColor: MaterialStateProperty.resolveWith((states) {
                                          if (states.contains(MaterialState.selected)) {
                                            return Colors.white;
                                          }
                                          if (states.contains(MaterialState.disabled)) {
                                            return Colors.grey[600];
                                          }
                                          return Colors.white;
                                        }),
                                        dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
                                          if (states.contains(MaterialState.selected)) {
                                            return Color(0xFFDC143C);
                                          }
                                          return Colors.transparent;
                                        }),
                                        todayForegroundColor: MaterialStateProperty.all(Color(0xFFDC143C)),
                                        todayBackgroundColor: MaterialStateProperty.all(Colors.transparent),
                                        todayBorder: BorderSide(color: Color(0xFFDC143C), width: 1),
                                        cancelButtonStyle: TextButton.styleFrom(
                                          foregroundColor: Colors.grey[400],
                                          textStyle: GoogleFonts.poppins(fontSize: 14),
                                        ),
                                        confirmButtonStyle: TextButton.styleFrom(
                                          foregroundColor: Color(0xFFDC143C),
                                          textStyle: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                setState(() {
                                  selectedDate = picked;
                                  selectedDateFilter = dateFilter;
                                });
                              }
                            } else {
                              setState(() {
                                selectedDateFilter = dateFilter;
                                if (dateFilter != 'Choose Date') {
                                  selectedDate = null;
                                }
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? Color(0xFFDC143C).withOpacity(0.2) : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? Color(0xFFDC143C) : Colors.grey[600]!,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                Text(
                                  dateFilter == 'Choose Date' && selectedDate != null
                                      ? '${selectedDate!.day}/${selectedDate!.month}'
                                      : dateFilter,
                                  style: GoogleFonts.poppins(
                                    color: isSelected ? Color(0xFFDC143C) : Colors.grey[400],
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
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
          _buildSection('Movies', _applyDateFilterToSection(movies)),
          SizedBox(height: 25),
          _buildSection('Theater', _applyDateFilterToSection(theater)),
          SizedBox(height: 25),
          _buildSection('Performances', _applyDateFilterToSection(performances)),
          SizedBox(height: 25),
          _buildSection('Upcoming', _applyDateFilterToSection(upcoming)),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFilteredGrid() {
    final items = filteredItems;

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              searchQuery.isNotEmpty ? Icons.search_off : Icons.movie_outlined,
              size: 64,
              color: Colors.grey[600],
            ),
            SizedBox(height: 16),
            Text(
              searchQuery.isNotEmpty ? 'No results found' : 'No shows found',
              style: GoogleFonts.poppins(
                color: Colors.grey[400],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              searchQuery.isNotEmpty
                  ? 'Try searching for a different title or genre'
                  : 'Try selecting a different date or category',
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ContentCard(
            item: items[index],
            onTap: () {
              print('Tapped on ${items[index].title}');
            },
            isGridView: true,
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<ContentItem> items) {
    if (items.isEmpty) return SizedBox.shrink();

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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    final itemDate = DateTime(date.year, date.month, date.day);

    if (itemDate.isAtSameMomentAs(today)) {
      return 'Today';
    } else if (itemDate.isAtSameMomentAs(tomorrow)) {
      return 'Tomorrow';
    } else {
      return '${date.day}/${date.month}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TheaterShowDetailPage(),
          ),
        );
      },
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
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFFDC143C),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _formatDate(item.showDate),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
  final DateTime showDate;

  ContentItem({
    required this.title,
    required this.imageUrl,
    required this.duration,
    required this.genre,
    required this.showDate,
  });
}