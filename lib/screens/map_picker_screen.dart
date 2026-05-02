import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MapPickerScreen extends StatelessWidget {
  final String title;
  const MapPickerScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF000080);
    const Color backgroundColor = Color(0xFFBEEBFF);

    // Simulated locations in Tayabas City
    final List<Map<String, String>> tayabasLocations = [
      {'address': 'Tayabas City Hall', 'sub': 'City Center, Tayabas'},
      {'address': 'Minor Basilica of St. Michael', 'sub': 'San Roque St, Tayabas'},
      {'address': 'Brgy. Baguio', 'sub': 'Ilaya-Tayabas, Quezon'},
      {'address': 'Sa lumang court', 'sub': 'CTS De Tayabas, P. Norte'},
      {'address': 'Tayabas Community Hospital', 'sub': 'Brgy. Wakas, Tayabas'},
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: darkBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Select $title Location',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Simulated Map View Area
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              color: Colors.grey[300],
              child: Stack(
                children: [
                  // Placeholder for Map Image
                  const Center(
                    child: Icon(Icons.map, size: 100, color: Colors.grey),
                  ),
                  const Center(
                    child: Text(
                      'Tayabas City Map View',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ),
                  // Center Marker
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on, color: Colors.red, size: 40),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Select this point',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Location List
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nearby in Tayabas City',
                    style: GoogleFonts.poppins(
                      color: darkBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView.separated(
                      itemCount: tayabasLocations.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final loc = tayabasLocations[index];
                        return ListTile(
                          leading: const Icon(Icons.location_on_outlined, color: darkBlue),
                          title: Text(loc['address']!, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                          subtitle: Text(loc['sub']!, style: GoogleFonts.poppins(fontSize: 12)),
                          onTap: () {
                            Navigator.pop(context, loc);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
