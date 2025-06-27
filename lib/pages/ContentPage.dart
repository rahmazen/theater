import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  bool isLoading = false;
  String? errorMessage;
  Map<String, dynamic> paginationInfo = {};

  final List<String> categories = ['All', 'Cinema', 'Concert', 'Play', 'Musical', 'Competition'];
  final List<String> dateFilters = ['All Dates', 'Today', 'Tomorrow', 'This Week', 'Choose Date'];
  String selectedDateFilter = 'All Dates';

  // Your API base URL - Replace with your actual server URL
  static const String baseUrl = 'http://127.0.0.1:8000/client/event_page/'; // Change this!

  // Dynamic lists for each category
  final List<dynamic> cinema = [];
  final List<dynamic> concert = [];
  final List<dynamic> competition = [];
  final List<dynamic> play = [];
  final List<dynamic> musical = [];
  String extractDateTimeFormatted(String startTime) {
    List<String> parts = startTime.split('T');
    String datePart = parts[0]; // "2025-06-26"
    String timePart = parts[1].split('+')[0]; // "10:00:00"

    // Extract date components
    List<String> dateParts = datePart.split('-');
    String month = dateParts[1]; // "06"
    String day = dateParts[2];   // "26"

    // Extract time without seconds
    String time = timePart.split(':').take(2).join(':'); // "10:00"


    return '$month/$day $time';
  }
  @override
  void initState() {
    super.initState();
    loadInitialData();
  }


  // Load initial data for all categories
  Future<void> loadInitialData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Load all categories
      await Future.wait([
        fetchEventsByGenre(genre: 'cinema', page: 1, eventsList: cinema),
        fetchEventsByGenre(genre: 'concert', page: 1, eventsList: concert),
        fetchEventsByGenre(genre: 'play', page: 1, eventsList: play),
        fetchEventsByGenre(genre: 'musical', page: 1, eventsList: musical),
        fetchEventsByGenre(genre: 'competition', page: 1, eventsList: competition),
      ]);
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load events: ${e.toString()}';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  // Load specific category when filter changes
  Future<void> loadCategoryData(String category) async {
    if (category == 'All') {
      await loadInitialData();
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final genre = category.toLowerCase();
      final eventsList = getEventsListForCategory(category);

      await fetchEventsByGenre(
        genre: genre,
        page: 1,
        eventsList: eventsList,
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load $category events: ${e.toString()}';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  // Get the appropriate list for a category
  List<dynamic> getEventsListForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'cinema':
        return cinema;
      case 'concert':
        return concert;
      case 'play':
        return play;
      case 'musical':
        return musical;
      case 'competition':
        return competition;
      default:
        return [];
    }
  }

  // API method to fetch events by genre
  Future<void> fetchEventsByGenre({
    required String genre,
    required int page,
    required List<dynamic> eventsList,
    Function(Map<String, dynamic>)? onPaginationUpdate,
    Function(String)? onError,
  }) async {
    try {
      final url = Uri.parse('$baseUrl?genre=$genre&page=$page');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Clear the list if it's the first page, otherwise append
        if (page == 1) {
          eventsList.clear();
        }

        // Add new events to the list
        final List<dynamic> newEvents = responseData['events'] ?? [];
        eventsList.addAll(newEvents);

        // Call pagination callback if provided
        if (onPaginationUpdate != null) {
          onPaginationUpdate(responseData['pagination'] ?? {});
        } else {
          setState(() {
            paginationInfo = responseData['pagination'] ?? {};
          });
        }

        print('Successfully loaded ${newEvents.length} events for $genre (page $page)');

      } else if (response.statusCode == 400) {
        final Map<String, dynamic> errorData = json.decode(response.body);
        final errorMessage = errorData['error'] ?? 'Bad request';
        if (onError != null) {
          onError(errorMessage);
        } else {
          setState(() {
            this.errorMessage = errorMessage;
          });
        }
      } else if (response.statusCode == 404) {
        final Map<String, dynamic> errorData = json.decode(response.body);
        final errorMessage = errorData['error'] ?? 'Page not found';
        if (onError != null) {
          onError(errorMessage);
        } else {
          setState(() {
            this.errorMessage = errorMessage;
          });
        }
      } else {
        final errorMessage = 'Failed to load events. Status: ${response.statusCode}';
        if (onError != null) {
          onError(errorMessage);
        } else {
          setState(() {
            this.errorMessage = errorMessage;
          });
        }
      }
    } catch (e) {
      final errorMessage = 'Network error: ${e.toString()}';
      if (onError != null) {
        onError(errorMessage);
      } else {
        setState(() {
          this.errorMessage = errorMessage;
        });
      }
      print('Error fetching events: $e');
    }
  }

  // Load more events for pagination
  Future<void> loadMoreEvents(String category) async {
    if (paginationInfo['has_next'] != true || isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final genre = category.toLowerCase();
      final eventsList = getEventsListForCategory(category);
      final currentPage = paginationInfo['current_page'] ?? 1;

      await fetchEventsByGenre(
        genre: genre,
        page: currentPage + 1,
        eventsList: eventsList,
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load more events: ${e.toString()}';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  // Get filtered items based on current selection
  // Get filtered items based on current selection
  // In your _ContentPageState class, update the filteredItems getter:
  List<dynamic> get filteredItems {
    List<dynamic> items = [];

    // Get all items for the selected category
    if (selectedCategory == 'All') {
      items.addAll(cinema);
      items.addAll(concert);
      items.addAll(play);
      items.addAll(musical);
      items.addAll(competition);
    } else {
      items = getEventsListForCategory(selectedCategory);
    }

    // Debug print to verify items before filtering
    debugPrint('Total items before search: ${items.length}');

    // Apply search filter if there's a query
    if (searchQuery.trim().isNotEmpty) {
      final query = searchQuery.toLowerCase().trim();
      items = items.where((item) {
        final content = item['content'];
        if (content != null) {
          final title = content['title']?.toString().toLowerCase() ?? '';
          // Debug print to see what's being compared
          debugPrint('Comparing: "$title" with "$query"');
          return title.contains(query);
        }
        return false;
      }).toList();

      // Debug print after filtering
      debugPrint('Items after search: ${items.length}');
    }

    return items;
  }
  Timer? _searchDebounce;
  @override
  void dispose() {
    _searchDebounce?.cancel();
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
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
                        child:TextField(
                          controller: searchController,
                          focusNode: searchFocusNode,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search events...',
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
                                  debugPrint('Search cleared'); // Debug print
                                });
                              },
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                              debugPrint('Search query updated: "$value"'); // Debug print
                            });
                          },
                          onSubmitted: (value) {
                            setState(() {
                              searchQuery = value;
                              debugPrint('Search submitted: "$value"'); // Debug print
                            });
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
                        onTap: () async {
                          setState(() {
                            selectedCategory = category;
                          });
                          // Load data for the selected category
                          await loadCategoryData(category);
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

            // Date Filter (keeping your existing implementation)
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
                          child: Text(
                            dateFilter == 'Choose Date' && selectedDate != null
                                ? '${selectedDate!.day}/${selectedDate!.month}'
                                : dateFilter,
                            style: GoogleFonts.poppins(
                              color: isSelected ? Color(0xFFDC143C) : Colors.grey[400],
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              fontSize: 12,
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

            // Error message
            if (errorMessage != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          errorMessage!,
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red, size: 16),
                        onPressed: () {
                          setState(() {
                            errorMessage = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

            if (errorMessage != null) SizedBox(height: 10),

            // Content
            Expanded(
              child: isLoading && (cinema.isEmpty && concert.isEmpty && play.isEmpty && musical.isEmpty && competition.isEmpty)
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDC143C)),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading events...',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
                  : selectedCategory == 'All'
                  ? _buildAllCategoriesView()
                  : _buildFilteredGrid(),
            ),

            SizedBox(height: 70),
          ],
        ),
      ),
    );
  }

  Widget _buildAllCategoriesView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (cinema.isNotEmpty) ...[
            _buildSection('Cinema', cinema),
            SizedBox(height: 25),
          ],
          if (concert.isNotEmpty) ...[
            _buildSection('Concerts', concert),
            SizedBox(height: 25),
          ],
          if (play.isNotEmpty) ...[
            _buildSection('Plays', play),
            SizedBox(height: 25),
          ],
          if (musical.isNotEmpty) ...[
            _buildSection('Musicals', musical),
            SizedBox(height: 25),
          ],
          if (competition.isNotEmpty) ...[
            _buildSection('Competitions', competition),
            SizedBox(height: 25),
          ],
          // Load more button for All view
          if (paginationInfo['has_next'] == true && !isLoading)
            Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () => loadInitialData(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFDC143C),
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Load More Events'),
                ),
              ),
            ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFilteredGrid() {
    final items = filteredItems;

    if (items.isEmpty && !isLoading) {
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
              searchQuery.isNotEmpty ? 'No results found' : 'No events found',
              style: GoogleFonts.poppins(
                color: Colors.grey[400],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              searchQuery.isNotEmpty
                  ? 'Try searching for a different title'
                  : 'Try selecting a different category or refresh',
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => loadCategoryData(selectedCategory),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFDC143C),
                foregroundColor: Colors.white,
              ),
              child: Text('Refresh'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: Padding(
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
                return EventCard(
                  event: items[index],
                  onTap: () {
                    final content = items[index]['content'];
                    print('Tapped on event: ${content?['title'] ?? 'No title'}');
                  },
                  isGridView: true,
                );
              },
            ),
          ),
        ),

        // Load more button for filtered view
        if (selectedCategory != 'All' && paginationInfo['has_next'] == true && !isLoading)
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => loadMoreEvents(selectedCategory),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFDC143C),
                foregroundColor: Colors.white,
              ),
              child: Text('Load More'),
            ),
          ),

        if (isLoading)
          Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDC143C)),
            ),
          ),
      ],
    );
  }

  Widget _buildSection(String title, List<dynamic> items) {
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
                child: EventCard(
                  event: items[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TheaterShowDetailPage(
                          eventid: items[index]['id'].toString(),
                        ),
                      ),
                    );
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

// New EventCard widget to display event data
class EventCard extends StatelessWidget {
  final Map<String, dynamic> event;
  final VoidCallback onTap;
  final bool isGridView;

  const EventCard({
    Key? key,
    required this.event,
    required this.onTap,
    required this.isGridView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = event['content'];
    final title = content?['title'] ?? 'No Title';
    final description = content?['description'] ?? '';
    final eventType = event['event_type'] ?? '';
    final price = event['ticket_price'] ?? '0';
    final isSoldOut = event['is_sold_out'] ?? false;
    final posterUrl = content?['poster'];
    final startTime = event['start_time'];
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isGridView ? null : 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black.withOpacity(0.3),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Expanded(
              flex: isGridView ? 3 : 2,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  color: Colors.grey[800],
                ),
                child: posterUrl != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    'http://127.0.0.1:8000${posterUrl}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholder();
                    },
                  ),
                )
                    : _buildPlaceholder(),
              ),
            ),

            // Content
            Expanded(
              flex: isGridView ? 2 : 1,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: isGridView ? 14 : 12,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          (() {
                            var parts = startTime.split('T');
                            var dateParts = parts[0].split('-');
                            var time = parts[1].split('+')[0].split(':').take(2).join(':');
                            return '${dateParts[1]}/${dateParts[2]} $time';
                          })(), // "06/26 10:00"
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: isGridView ? 14 : 12,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (isSoldOut)
                          Text(
                            'SOLD OUT',
                            style: GoogleFonts.poppins(
                              color: Colors.red,
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
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

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        color: Colors.grey[800],
      ),
      child: Icon(
        Icons.movie_outlined,
        color: Colors.grey[600],
        size: 40,
      ),
    );
  }
}