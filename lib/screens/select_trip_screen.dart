import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'passenger_type_screen.dart';

class SelectTripScreen extends StatefulWidget {
  const SelectTripScreen({super.key});

  @override
  State<SelectTripScreen> createState() => _SelectTripScreenState();
}

class _SelectTripScreenState extends State<SelectTripScreen> {
  int _selectedTrip = 0; // 0 for One Way, 1 for Round Trip

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFBEEBFF);
    const Color darkBlue = Color(0xFF000080);
    const Color confirmGreen = Color(0xFF00C853);
    const Color selectedBorderColor = Colors.blueAccent;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // Top bar
          Container(
            height: 120,
            width: double.infinity,
            color: darkBlue,
            padding: const EdgeInsets.only(top: 40, left: 20),
            alignment: Alignment.centerLeft,
            child: GestureDetector(
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
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Title
                  Text(
                    'Select Trip',
                    style: GoogleFonts.poppins(
                      color: darkBlue,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Trip Options Card Container
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // One Way Trip
                        _buildTripOption(
                          index: 0,
                          title: 'One Way Trip',
                          subtitle: '(Pick-Up to Drop-Off)',
                          isSelected: _selectedTrip == 0,
                          darkBlue: darkBlue,
                          selectedBorderColor: selectedBorderColor,
                        ),
                        const SizedBox(height: 15),
                        // Round Trip
                        _buildTripOption(
                          index: 1,
                          title: 'Round Trip',
                          subtitle: '(Door-to-Door)',
                          isSelected: _selectedTrip == 1,
                          darkBlue: darkBlue,
                          selectedBorderColor: selectedBorderColor,
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // CONFIRM Button
                  SizedBox(
                    width: 240,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PassengerTypeScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: confirmGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        'CONFIRM',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripOption({
    required int index,
    required String title,
    required String subtitle,
    required bool isSelected,
    required Color darkBlue,
    required Color selectedBorderColor,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTrip = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? selectedBorderColor : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.electric_rickshaw, size: 60, color: Colors.black87),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: darkBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 14,
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
}
