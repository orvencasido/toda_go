import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/booking_model.dart';
import '../services/auth_service.dart';
import '../services/booking_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF000080);
    const Color backgroundColor = Color(0xFFF8F9FA);
    final passengerId = AuthService().currentUser?.uid;

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
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                        Icons.history_rounded,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'RIDE HISTORY',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: passengerId == null
                ? const Center(child: Text('Please log in to view history.'))
                : FutureBuilder<List<Booking>>(
                    future: BookingService().getPassengerHistory(passengerId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final rides = snapshot.data ?? [];
                      if (rides.isEmpty) {
                        return Center(
                          child: Text(
                            'No completed rides yet.',
                            style: GoogleFonts.poppins(color: Colors.grey[500]),
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(20.0),
                        itemCount: rides.length,
                        itemBuilder: (context, index) => _RideCard(booking: rides[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _RideCard extends StatelessWidget {
  final Booking booking;
  const _RideCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF000080);
    final isCompleted = booking.status == BookingStatus.completed;
    final date = DateFormat('MMM d, yyyy h:mm a').format(booking.createdAt.toLocal());

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.electric_rickshaw_rounded,
            color: isCompleted ? Colors.blue[700] : Colors.orange[700],
            size: 34,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.dropoffAddress,
                  style: GoogleFonts.poppins(
                    color: darkBlue,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  booking.pickupAddress,
                  style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(date, style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 11)),
                const SizedBox(height: 4),
                Text(
                  'PHP ${booking.fare.toStringAsFixed(0)} - ${isCompleted ? 'Completed' : 'Cancelled'}',
                  style: GoogleFonts.poppins(
                    color: isCompleted ? Colors.green[700] : Colors.orange[700],
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
