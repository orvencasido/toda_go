import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/booking_model.dart';
import '../services/booking_service.dart';
import 'dashboard_screen.dart';
import 'rating_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String bookingId;
  final double fare;

  const PaymentScreen({
    super.key,
    required this.bookingId,
    required this.fare,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final BookingService _bookingService = BookingService();
  bool _isSaving = false;

  Future<void> _markPaymentSent() async {
    setState(() => _isSaving = true);
    await _bookingService.updateTripStatus(widget.bookingId, BookingStatus.completed);
    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment marked as sent.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF000080);
    const Color backgroundColor = Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [darkBlue, Color(0xFF1A237E)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SafeArea(
              child: Row(
                children: [
                  Container(
                    height: 115,
                    width: 115,
                    padding: const EdgeInsets.all(5),
                    child: Image.asset(
                      'assets/images/toda_go_white.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.payments_rounded,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'PAYMENT',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.payments_rounded, color: Colors.green, size: 80),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Cash Payment',
                    style: GoogleFonts.poppins(
                      color: darkBlue,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Pay the driver in cash, then mark the payment as sent.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
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
                        Text(
                          'TOTAL FARE',
                          style: GoogleFonts.poppins(
                            color: Colors.grey[500],
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'PHP ${widget.fare.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                            color: darkBlue,
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _markPaymentSent,
                      child: _isSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'PAYMENT SENT',
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RatingScreen()),
                        );
                      },
                      child: Text('RATE RIDER', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const DashboardScreen()),
                          (route) => false,
                        );
                      },
                      child: Text('BOOK AGAIN', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
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
