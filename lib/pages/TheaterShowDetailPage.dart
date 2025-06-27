import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'Account/authProvider.dart';
import 'CinemaSeatSelectionPage.dart';
import 'package:intl/intl.dart';
class TheaterShowDetailPage extends StatefulWidget {
  final String eventid;

  const TheaterShowDetailPage({
    Key? key,
    required this.eventid,
  }) : super(key: key);

  @override
  State<TheaterShowDetailPage> createState() => _TheaterShowDetailPageState();
}

class _TheaterShowDetailPageState extends State<TheaterShowDetailPage> {
  Map<String, dynamic>? eventData;
  bool isLoading = true;
  String? error;
  int? _selectedRating; // To store the selected rating
  final List<bool> _ratingStars = List.generate(5, (index) => false);
  @override
  void initState() {
    super.initState();
    fetchEventDetails();
    _commentsFuture = _fetchComments();
  }
// Helper function to parse upcoming_replays string
  List<Map<String, String>> parseUpcomingReplays(String upcomingReplays) {
    List<Map<String, String>> replays = [];

    if (upcomingReplays.isEmpty) return replays;

    // Split by comma and parse each replay
    List<String> replayParts = upcomingReplays.split(',');

    for (String part in replayParts) {
      part = part.trim();

      // Extract date, time, and id using regex
      RegExp regex = RegExp(r'(\d{2}/\d{2})\s+(\d{2}:\d{2})\s+\(id:(\d+)\)');
      Match? match = regex.firstMatch(part);

      if (match != null) {
        replays.add({
          'date': match.group(1)!,
          'time': match.group(2)!,
          'id': match.group(3)!,
        });
      }
    }

    return replays;
  }

// Helper function to format the replay datetime for display
  String formatReplayDateTime(String date, String time) {
    // You can customize this format as needed
    return '$date at $time';
  }
  Future<void> fetchEventDetails() async {
    try {
      // Replace with your actual API endpoint
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/client/event/${widget.eventid}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          eventData = json.decode(response.body);
          isLoading = false;
        });
        fetchreplays();
      } else {
        setState(() {
          error = 'Failed to load event details';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';
        isLoading = false;
      });
    }
  }
String replays = '' ;
  final TextEditingController _commentController = TextEditingController();


// In your initState


// Methods to add
  Future<List<dynamic>> _fetchComments() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/client/comment/${widget.eventid}/'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data ;
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      throw Exception('Error fetching comments: $e');
    }
  }

  Future<void> _submitComment(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (_commentController.text.isEmpty) return;

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/client/comment/${authProvider.authData?.username}/${widget.eventid}/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authProvider.authData?.accessToken}',
        },
        body: json.encode({
          'comment': _commentController.text,
          'rating': _selectedRating,
        }),
      );

      if (response.statusCode == 201) {
        _commentController.clear();
        setState(() {
          _commentsFuture = _fetchComments(); // Refresh comments
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Comment submitted!'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        throw Exception('Failed to submit comment');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting comment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }// Controllers and state

  late Future<List<dynamic>> _commentsFuture;


// Submit new comment

// Modified review item widget
  Widget _buildReviewItem(String name, String date, double rating, String comment, String? imageUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey[800],
                    backgroundImage: imageUrl != null
                        ? NetworkImage('http://127.0.0.1:8000$imageUrl')
                        : null,
                    child: imageUrl == null
                        ? Text(
                      name[0].toUpperCase(),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        date,
                        style: GoogleFonts.poppins(
                          color: Colors.grey[500],
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (rating > 0) Row(
                children: [
                  ...List.generate(5, (index) {
                    return Icon(
                      index < rating.floor() ? Icons.star :
                      (index < rating && rating % 1 != 0) ? Icons.star_half : Icons.star_border,
                      color: Colors.red,
                      size: 16,
                    );
                  }),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            comment,
            style: GoogleFonts.poppins(
              color: Colors.grey[300],
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
  Future<void> fetchreplays() async {
    try {

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/client/replays/${eventData?['content']['id']}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          replays = json.decode(response.body).toString();
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load event details';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';
        isLoading = false;
      });
    }
  }


  String formatDateTime(String dateTimeString) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeString;
    }
  }

  String formatDuration(int minutes) {
    int hours = minutes ~/ 60;
    int mins = minutes % 60;
    if (hours > 0) {
      return '${hours}h ${mins}min';
    }
    return '${mins}min';
  }

  String getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return 'https://picsum.photos/400/600?random=1';
    }
    // Replace with your actual base URL
    return 'http://127.0.0.1:8000$imagePath';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.red),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red, size: 64),
              SizedBox(height: 16),
              Text(
                error!,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    error = null;
                  });
                  fetchEventDetails();
                },
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final content = eventData!['content'];
    final artists = eventData!['artists'] as List<dynamic>;
    final startTime = eventData!['start_time'];
    final endTime = eventData!['end_time'];
    final ticketPrice = eventData!['ticket_price'];
    final isSoldOut = eventData!['is_sold_out'];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image Section with curved bottom
            Stack(
              children: [
                ClipPath(
                  clipper: CurvedBottomClipper(),
                  child: Container(
                    height: 400,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                         'http://127.0.0.1:8000${content['poster']}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[800],
                              child: Icon(
                                Icons.theater_comedy,
                                size: 100,
                                color: Colors.grey[600],
                              ),
                            );
                          },
                        ),
                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // App Bar
                Positioned(
                  top: 40,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.favorite_border, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                // Play Button (only show if trailer is available)
                if (content['trailer_url'] != null)
                  Positioned(
                    bottom: 1,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),

                  // Title
                  Text(
                    content['title'] ?? 'No Title',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Event Type
                  Text(
                    eventData!['event_type']?.toString().toUpperCase() ?? 'PERFORMANCE',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Rating (if available)
                  if (content['rating'] != null)
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          double rating = content['rating'].toDouble();
                          return Icon(
                            index < rating.floor() ? Icons.star :
                            (index < rating && rating % 1 != 0) ? Icons.star_half : Icons.star_border,
                            color: Colors.red,
                            size: 20,
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          content['rating'].toString(),
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 20),

                  // Show Details
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      if (content['release_year'] != null)
                        _buildDetailChip(content['release_year'].toString()),
                      if (content['duration_minutes'] != null)
                        _buildDetailChip(formatDuration(content['duration_minutes'])),
                      if (content['language'] != null)
                        _buildDetailChip(content['language']),
                      if (content['subtitles'] == true)
                        _buildDetailChip('Subtitles'),
                      _buildDetailChip('${ticketPrice} DA'),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Show Times
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[800]!),
                    ),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upcoming Replays',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),

                        // Parse and display upcoming replays
                        ...parseUpcomingReplays(replays).map((replay) =>
                            Padding(
                              padding: EdgeInsets.only(bottom: 4),
                              child: Text(
                                formatReplayDateTime(replay['date']!, replay['time']!),
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[300],
                                  fontSize: 14,
                                ),
                              ),
                            )
                        ).toList(),

                        // If no replays available
                        if (parseUpcomingReplays(replays).isEmpty)
                          Text(
                            'No upcoming replays',
                            style: GoogleFonts.poppins(
                              color: Colors.grey[400],
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),

                        if (eventData!['minimum_age'] != null && eventData!['minimum_age'] > 0)
                          Text(
                            'Minimum age: ${eventData!['minimum_age']} years',
                            style: GoogleFonts.poppins(
                              color: Colors.orange,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Description
                  if (content['description'] != null && content['description'].isNotEmpty)
                    Text(
                      content['description'],
                      style: GoogleFonts.poppins(
                        color: Colors.grey[300],
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),

                  const SizedBox(height: 30),

                  // Artists Section
                  if (artists.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Artists',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Artists List
                    ...artists.map((artist) => _buildArtistItem(artist)).toList(),

                    const SizedBox(height: 40),
                  ],

                  // Reviews Section

                  // Comment Input Section

                  Row(
                    children: [
                      Text(
                        'Comments',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),

                  const SizedBox(height: 30),

// Comment Input Section (only visible when authenticated)
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      if (!authProvider.isAuthenticated) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Colors.grey[700]!),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    // User profile picture
                                    Container(
                                      margin: const EdgeInsets.only(left: 12),
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: ClipOval(
                                        child: authProvider.authData?.image != null
                                            ? Image.network(
                                          authProvider.authData?.image ?? '',
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Icon(
                                              Icons.person,
                                              size: 18,
                                              color: Colors.white,
                                            );
                                          },
                                        )
                                            : Icon(
                                          Icons.person,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),

                                    // Comment text field
                                    Expanded(
                                      child: TextField(
                                        controller: _commentController,
                                        cursorColor: Colors.grey[600],
                                        style: GoogleFonts.poppins(color: Colors.white),
                                        decoration: InputDecoration(
                                          hintText: 'Share your thoughts...',
                                          hintStyle: GoogleFonts.poppins(
                                            color: Colors.grey[400],
                                            fontSize: 14,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                        ),
                                      ),
                                    ),
                                    // Inside your comment input Container, add this below the text field:
                                    const SizedBox(height: 12),

                                    // Action icons
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.emoji_emotions_outlined,
                                            color: Colors.grey[400],
                                            size: 20,
                                          ),
                                          onPressed: () {},
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          splashRadius: 20,
                                        ),
                                        const SizedBox(width: 8),

                                        Container(
                                          margin: const EdgeInsets.only(right: 12),
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.arrow_upward,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            onPressed: () => _submitComment(context),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            splashRadius: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: List.generate(5, (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedRating = index + 1;
                                          // Update star states
                                          for (int i = 0; i < _ratingStars.length; i++) {
                                            _ratingStars[i] = i <= index;
                                          }
                                        });
                                      },
                                      child: Icon(
                                        _ratingStars[index] ? Icons.star : Icons.star_border,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),

                          ),



                          const SizedBox(height: 24),
                        ],
                      );
                    },
                  ),

// Comments List
                  FutureBuilder<List<dynamic>>(
                    future: _commentsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Text('Error loading comments: ${snapshot.error}');
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text(
                          'No comments yet',
                          style: GoogleFonts.poppins(color: Colors.grey),
                        );
                      }

                      return Column(
                        children: snapshot.data!.map((comment) => _buildReviewItem(
                          comment['user']['username'],
                          DateFormat('MMMM yyyy').format(DateTime.parse(comment['created_at'])),
                          comment['rating']?.toDouble() ?? 0.0,
                          comment['comment'] ?? '',
                          comment['user']['image'],
                        )).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 80),
                  // Sample reviews (you might want to fetch these from API as well)
                  // Extra space for floating button
                ],
              ),
            ),
          ],
        ),
      ),
      // Floating Action Button for booking tickets
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isSoldOut
            ? null
            : () {
          Future.delayed(Duration(milliseconds: 500), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CinemaSeatSelectionPage(event: eventData , replays: replays),
              ),
            );
          });
        },
        backgroundColor: isSoldOut ? Colors.grey : Colors.red,
        icon: Icon(
          isSoldOut ? Icons.block : Icons.local_activity,
          color: Colors.white,
        ),
        label: Text(
          isSoldOut ? 'SOLD OUT' : 'BOOK TICKETS',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Build artist item widget
  Widget _buildArtistItem(Map<String, dynamic> artist) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'http://127.0.0.1:8000${artist['image']}',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[800],
                  child: Icon(
                    Icons.person,
                    color: Colors.grey[600],
                    size: 30,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artist['name'] ?? 'Unknown Artist',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  artist['artist_type']?.toString().toUpperCase() ?? 'ARTIST',
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build review item widget

  Widget _buildDetailChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.grey[300],
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// Custom clipper for curved bottom effect
class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 60);

    var controlPoint = Offset(size.width / 2, size.height + 20);
    var endPoint = Offset(size.width, size.height - 60);

    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy,
        endPoint.dx, endPoint.dy
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}