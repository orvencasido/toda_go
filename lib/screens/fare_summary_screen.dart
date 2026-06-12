import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/booking_service.dart';
import '../services/auth_service.dart';
import '../models/booking_model.dart';
import 'searching_tricycle_screen.dart';

class FareSummaryScreen extends StatefulWidget {
  final int tripFare;
  final String pickupAddress;
  final String dropoffAddress;
  final double pickupLat;
  final double pickupLng;
  final double dropoffLat;
  final double dropoffLng;
  final double distanceKm;

  const FareSummaryScreen({
    super.key,
    required this.tripFare,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropoffLat,
    required this.dropoffLng,
    required this.distanceKm,
  });

  @override
  State<FareSummaryScreen> createState() => _FareSummaryScreenState();
}

class _FareSummaryScreenState extends State<FareSummaryScreen> {
  bool _isLoading = false;
  final BookingService _bookingService = BookingService();
  final AuthService _authService = AuthService();

  Future<void> _handleFindTricycle() async {
    final user = _authService.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    setState(() => _isLoading = true);

    double totalFare = widget.tripFare.toDouble();

    Booking newBooking = Booking(
      id: '', // Will be assigned by BookingService
      passengerId: user.uid,
      pickupAddress: widget.pickupAddress,
      dropoffAddress: widget.dropoffAddress,
      pickupLat: widget.pickupLat,
      pickupLng: widget.pickupLng,
      dropoffLat: widget.dropoffLat,
      dropoffLng: widget.dropoffLng,
      distanceKm: widget.distanceKm,
      fare: totalFare,
      status: BookingStatus.pending,
      createdAt: DateTime.now(),
    );

    String? bookingId = await _bookingService.createBooking(newBooking);

    setState(() => _isLoading = false);

    if (bookingId != null) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchingTricycleScreen(bookingId: bookingId),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create booking. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF000080);
    const Color backgroundColor = Color(0xFFF8F9FA);
    int totalFare = widget.tripFare;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // Modern Header synchronized with Dashboard
          Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  darkBlue,
                  Color(0xFF1A237E),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SafeArea(
              child: Row(
                children: [
                  // Left-aligned Logo consistent with Dashboard
                  Container(
                    height: 115,
                    width: 115,
                    padding: const EdgeInsets.all(5),
                    child: Image.asset(
                      'assets/images/toda_go_white.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.receipt_long_rounded,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  // Branding & Title
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TODA GO',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          'FARE SUMMARY',
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Back Button on Right Side
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25.0),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Route Preview Card
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Stack(
                        children: [
                          CustomPaint(
                            size: const Size(double.infinity, 180),
                            painter: MapRoutePainter(),
                          ),
                          const Center(
                            child: Icon(Icons.map_rounded, color: Colors.white24, size: 80),
                          ),
                          Positioned(
                            top: 40,
                            left: 40,
                            child: _buildMapPin(Icons.my_location_rounded, Colors.blue),
                          ),
                          Positioned(
                            bottom: 40,
                            right: 40,
                            child: _buildMapPin(Icons.location_on_rounded, Colors.redAccent),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // Fare Breakdown Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Header section with Total
                        Container(
                          padding: const EdgeInsets.all(25),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: darkBlue.withOpacity(0.02),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'TOTAL FARE',
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'PHP ${totalFare.toStringAsFixed(0)}',
                                style: GoogleFonts.poppins(
                                  color: darkBlue,
                                  fontSize: 42,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        
                        // Breakdown Rows
                        Padding(
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            children: [
                              _buildSummaryRow('Distance', '${widget.distanceKm.toStringAsFixed(1)} km'),
                              const SizedBox(height: 16),
                              _buildSummaryRow('Fare', 'PHP ${widget.tripFare}'),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Divider(height: 1, color: Color(0xFFF5F5F5)),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.payment_rounded, color: darkBlue, size: 20),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Cash Payment',
                                    style: GoogleFonts.poppins(
                                      color: darkBlue,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // FIND TRICYCLE Button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleFindTricycle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 4,
                        shadowColor: darkBlue.withOpacity(0.3),
                      ),
                      child: _isLoading 
                        ? const SizedBox(
                            height: 25, 
                            width: 25, 
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
                          )
                        : Text(
                            'FIND TRICYCLE',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPin(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4)],
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }

  Widget _buildSummaryRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.grey[600],
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          amount,
          style: GoogleFonts.poppins(
            color: const Color(0xFF000080),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class MapRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintRoad = Paint()
      ..color = Colors.grey[100]!
      ..style = PaintingStyle.fill;
    
    final paintPark = Paint()
      ..color = const Color(0xFFE8F5E9)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 60, size.width, 30), paintRoad);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.4, 0, 30, size.height), paintRoad);
    canvas.drawRRect(RRect.fromLTRBR(10, 10, 100, 50, const Radius.circular(10)), paintPark);
    canvas.drawRRect(RRect.fromLTRBR(size.width - 100, size.height - 50, size.width - 10, size.height - 10, const Radius.circular(10)), paintPark);

    final paintRoute = Paint()
      ..color = const Color(0xFF000080)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    
    final path = Path();
    path.moveTo(40, 40);
    path.quadraticBezierTo(size.width * 0.5, 40, size.width * 0.5, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.5, size.height - 40, size.width - 40, size.height - 40);

    canvas.drawPath(path, paintRoute);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
