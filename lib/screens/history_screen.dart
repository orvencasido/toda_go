import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFBEEBFF);
    const Color darkBlue = Color(0xFF000080);
    const Color rebookGreen = Color(0xFF81C784);

    final List<Map<String, dynamic>> rides = [
      {
        'destination': 'Tayabas Public Market',
        'pickup': 'Dap-dap',
        'date': 'February 12, 2026 1:07 PM',
        'price': '50',
        'status': 'Completed',
      },
      {
        'destination': 'Tayabas Primark',
        'pickup': 'Malagonlong Bridge',
        'date': 'February 12, 2026 2:48 PM',
        'price': '50',
        'status': 'Cancelled',
      },
      {
        'destination': 'Tayabas City Hall',
        'pickup': 'Alandy Compound',
        'date': 'February 04, 2026 7:15 AM',
        'price': '50',
        'status': 'Completed',
      },
      {
        'destination': 'Ibabang Wakas',
        'pickup': 'Ilaya Lalo',
        'date': 'February 02, 2026 4:36 PM',
        'price': '40',
        'status': 'Completed',
      },
    ];

    return Column(
      children: [
        // Top Bar
        Container(
          height: 120,
          width: double.infinity,
          color: darkBlue,
          padding: const EdgeInsets.only(top: 40, left: 25),
          alignment: Alignment.centerLeft,
          child: null,
        ),
        
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Title
                Text(
                  'Ride History',
                  style: GoogleFonts.poppins(
                    color: darkBlue,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Ride Cards
                ...rides.map((ride) => _buildRideCard(ride, darkBlue, rebookGreen)),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRideCard(Map<String, dynamic> ride, Color darkBlue, Color rebookGreen) {
    bool isCompleted = ride['status'] == 'Completed';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
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
      child: Row(
        children: [
          // Icon Avatar
          CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFF4FC3F7), // Light Blue
            child: const Icon(Icons.electric_rickshaw, color: Colors.black87, size: 30),
          ),
          const SizedBox(width: 12),
          
          // Info Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ride['destination'],
                  style: GoogleFonts.poppins(
                    color: darkBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.circle, size: 8, color: darkBlue),
                    const SizedBox(width: 5),
                    Text(
                      ride['pickup'],
                      style: GoogleFonts.poppins(
                        color: Colors.blue[800],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Text(
                  ride['date'],
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 10,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(fontSize: 12),
                    children: [
                      TextSpan(
                        text: 'Php. ${ride['price']} ',
                        style: const TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ride['status'],
                        style: TextStyle(
                          color: isCompleted ? const Color(0xFF4CAF50) : const Color(0xFFFFA726),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // REBOOK Button
          SizedBox(
            height: 40,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.sync, color: Colors.white, size: 20),
              label: const Text(
                'REBOOK',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: rebookGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
