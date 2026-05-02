import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'map_picker_screen.dart';
import 'fare_summary_screen.dart';

class PickupDropoffScreen extends StatefulWidget {
  const PickupDropoffScreen({super.key});

  @override
  State<PickupDropoffScreen> createState() => _PickupDropoffScreenState();
}

class _PickupDropoffScreenState extends State<PickupDropoffScreen> {
  String _pickupAddress = 'Select Pick-up Location';
  String _pickupSub = 'Tap to choose on map';
  String _dropoffAddress = 'Select Drop-off Location';
  String _dropoffSub = 'Tap to choose on map';
  
  double _distance = 0.0;
  int _tripFare = 0;
  int _doorToDoorFare = 100;

  void _calculateFare() {
    if (_pickupAddress != 'Select Pick-up Location' && _dropoffAddress != 'Select Drop-off Location') {
      // Simulate distance between 1 and 15 km if both selected
      // In a real app, this would use Geolocator.distanceBetween
      _distance = 6.5; 
      
      // Logic: 15 PHP for first 5km, +2 PHP per additional 1km
      if (_distance <= 5) {
        _tripFare = 15;
      } else {
        _tripFare = 15 + ((_distance - 5).ceil() * 2);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF000080);
    const Color backgroundColor = Color(0xFFBEEBFF);
    const Color confirmGreen = Color(0xFF00C853);

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
                  'Pick-up & Drop-off',
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Pick-up Card
                  _buildLocationCard(
                    label: 'Pick up',
                    title: _pickupAddress,
                    subtitle: _pickupSub,
                    icon: Icons.location_on,
                    darkBlue: darkBlue,
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MapPickerScreen(title: 'Pick-up'),
                        ),
                      );
                      if (result != null && result is Map<String, String>) {
                        setState(() {
                          _pickupAddress = result['address']!;
                          _pickupSub = result['sub']!;
                          _calculateFare();
                        });
                      }
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Drop-off Card
                  _buildLocationCard(
                    label: 'Drop off',
                    title: _dropoffAddress,
                    subtitle: _dropoffSub,
                    icon: Icons.location_on,
                    darkBlue: darkBlue,
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MapPickerScreen(title: 'Drop-off'),
                        ),
                      );
                      if (result != null && result is Map<String, String>) {
                        setState(() {
                          _dropoffAddress = result['address']!;
                          _dropoffSub = result['sub']!;
                          _calculateFare();
                        });
                      }
                    },
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Fare Section
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
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
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          child: Text(
                            'Estimated Fare',
                            style: GoogleFonts.poppins(
                              color: darkBlue,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Divider(height: 1, thickness: 1.5),
                        
                        _buildFareRow('Trip Fare:', 'PHP $_tripFare', darkBlue),
                        const Divider(height: 1, thickness: 1.5),
                        
                        _buildFareRow('Door-to-Door:', 'PHP $_doorToDoorFare', darkBlue),
                        
                        if (_distance > 0)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Text(
                              'Estimated Distance: ${_distance.toStringAsFixed(1)} km',
                              style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 13),
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 50),
                  
                  // Confirm Button
                  SizedBox(
                    width: 240,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: (_tripFare > 0) ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FareSummaryScreen(
                              tripFare: _tripFare,
                              doorToDoorFare: _doorToDoorFare,
                            ),
                          ),
                        );
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: confirmGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                        disabledBackgroundColor: Colors.grey[300],
                      ),
                      child: Text(
                        'Confirm',
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

  Widget _buildLocationCard({
    required String label,
    required String title,
    required String subtitle,
    required Color darkBlue,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.blue[700], size: 40),
              const SizedBox(width: 15),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      color: darkBlue.withOpacity(0.6),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: darkBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: darkBlue,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF000080)),
          ],
        ),
      ),
    );
  }

  Widget _buildFareRow(String label, String amount, Color darkBlue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
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
            amount,
            style: GoogleFonts.poppins(
              color: darkBlue,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
