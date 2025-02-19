import 'package:bingr/controllers/tmdb_controller.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class ArtistDetail extends StatefulWidget {
  final int artistId;

  const ArtistDetail({super.key, required this.artistId});

  @override
  _ArtistDetailState createState() => _ArtistDetailState();
}

class _ArtistDetailState extends State<ArtistDetail> {
  final TMDBController _tmdbController = TMDBController();
  Map<String, dynamic>? artistDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchArtistDetails();
  }

  void _fetchArtistDetails() async {
    try {
      final details = await _tmdbController.getArtistDetails(widget.artistId);
      setState(() {
        artistDetails = details;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error fetching artist details: $e");
    }
  }

  // Function to calculate age from date of birth
  String? _calculateAge(String? birthDate) {
    if (birthDate == null || birthDate.isEmpty) return null;
    try {
      DateTime dob = DateFormat("yyyy-MM-dd").parse(birthDate);
      DateTime today = DateTime.now();
      int age = today.year - dob.year;
      if (today.month < dob.month ||
          (today.month == dob.month && today.day < dob.day)) {
        age--;
      }
      return "$birthDate  ($age years old)";
    } catch (e) {
      return birthDate; // Return only DOB if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(artistDetails?['name'] ?? "Artist Details"),
        leading: IconButton(
          icon: Icon(
            Iconsax.arrow_left_2,
            color: const Color.fromARGB(255, 245, 71, 32),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        iconTheme: IconThemeData(
          color: const Color.fromARGB(255, 245, 71, 32),
          size: 30,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : artistDetails == null
              ? const Center(
                  child: Text(
                    "No data available",
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Artist Image
                      Image.network(
                        "https://image.tmdb.org/t/p/original${artistDetails!['profile_path'] ?? ''}",
                        fit: BoxFit.cover,
                        height: 400,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                          child: Icon(Icons.error, color: Colors.red, size: 50),
                        ),
                      ),

                      // Details Section
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name
                            Text(
                              artistDetails!['name'] ?? "Unknown",
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Known For
                            _infoRow(Iconsax.user,
                                artistDetails!['known_for_department']),

                            // Birthday + Age
                            _infoRow(Iconsax.calendar,
                                _calculateAge(artistDetails!['birthday'])),

                            // Place of Birth
                            _infoRow(Iconsax.location,
                                artistDetails!['place_of_birth']),

                            const SizedBox(height: 16),

                            // Biography
                            Text(
                              "Biography",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              artistDetails!['biography'] ??
                                  "No biography available.",
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  // Widget for simple row with an icon & text
  Widget _infoRow(IconData icon, String? text) {
    return text != null && text.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Icon(icon, size: 24),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
