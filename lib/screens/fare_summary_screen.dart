import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'searching_tricycle_screen.dart';

class FareSummaryScreen extends StatelessWidget {
  final int tripFare;
  final int doorToDoorFare;

  const FareSummaryScreen({
    super.key,
    required this.tripFare,
    required this.doorToDoorFare,
  });

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF000080);
    const Color backgroundColor = Color(0xFFBEEBFF);
    const Color confirmGreen = Color(0xFF00C853);
    int totalFare = tripFare + doorToDoorFare;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // Top bar
          Container(
            height: 120,
            width: double.infinity,
            color: darkBlue,
            padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF81D4FA), // Cyan/Light Blue circle
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  'Estimated Fare',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  // Map Route Preview Card
                  Container(
                    width: double.infinity,
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          // Simulated Map Background with Route
                          CustomPaint(
                            size: const Size(double.infinity, 220),
                            painter: MapRoutePainter(),
                          ),
                          // Pick-up Pin
                          const Positioned(
                            top: 100,
                            left: 40,
                            child: Icon(Icons.location_on, color: Colors.blue, size: 40),
                          ),
                          // Drop-off Pin
                          const Positioned(
                            bottom: 60,
                            right: 50,
                            child: Icon(Icons.location_on, color: Colors.purple, size: 40),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Fare Details Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          child: Text(
                            'Estimated Fare',
                            style: GoogleFonts.poppins(
                              color: darkBlue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Divider(height: 1, thickness: 1.5, color: Color(0xFFE1F5FE)),
                        
                        // Main Total Display
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                          child: Text(
                            'PHP $totalFare',
                            style: GoogleFonts.poppins(
                              color: darkBlue,
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Divider(height: 1, thickness: 1.5, color: Color(0xFFE1F5FE)),
                        
                        // Breakdown
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              _buildFareRow('Round Trip Fare :', 'PHP $tripFare', darkBlue),
                              const SizedBox(height: 15),
                              _buildFareRow('Door-to-Door:', 'PHP $doorToDoorFare', darkBlue),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 50),
                  
                  // Find Tricycle Button
                  SizedBox(
                    width: 260,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchingTricycleScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: confirmGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        'Find Tricycle',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildFareRow(String label, String value, Color darkBlue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: darkBlue,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: darkBlue,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Simple painter to simulate a map with roads and a route
class MapRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintRoad = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.fill;
    
    final paintPark = Paint()
      ..color = Colors.green[200]!
      ..style = PaintingStyle.fill;

    // Draw some roads
    canvas.drawRect(Rect.fromLTWH(0, 40, size.width, 25), paintRoad);
    canvas.drawRect(Rect.fromLTWH(60, 0, 30, size.height), paintRoad);
    canvas.drawRect(Rect.fromLTWH(180, 0, 25, size.height), paintRoad);
    canvas.drawRect(Rect.fromLTWH(0, 150, size.width, 20), paintRoad);

    // Draw some parks
    canvas.drawRRect(RRect.fromLTRBR(200, 10, size.width - 20, 90, const Radius.circular(15)), paintPark);
    canvas.drawRRect(RRect.fromLTRBR(120, 110, 160, 190, const Radius.circular(15)), paintPark);

    // Draw Route (dotted line)
    final paintRoute = Paint()
      ..color = Colors.blue[800]!
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    
    final path = Path();
    path.moveTo(60, 120);
    path.lineTo(120, 120);
    path.lineTo(150, 80);
    path.lineTo(200, 130);
    path.lineTo(260, 130);

    // Simulated dotted path
    for (double i = 0; i < 1.0; i += 0.05) {
      canvas.drawCircle(Offset(60 + (200 * i), 120 - (20 * (i * 3))), 3, paintRoute);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
