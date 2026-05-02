import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pickup_dropoff_screen.dart';

class PassengerTypeScreen extends StatefulWidget {
  const PassengerTypeScreen({super.key});

  @override
  State<PassengerTypeScreen> createState() => _PassengerTypeScreenState();
}

class _PassengerTypeScreenState extends State<PassengerTypeScreen> {
  final Map<String, bool> _selectedTypes = {
    'Senior Citizens': true,
    'Student': true,
    'PWD': false,
    'Regular': false,
  };

  final Map<String, int> _quantities = {
    'Senior Citizens': 2,
    'Student': 2,
    'PWD': 1,
    'Regular': 1,
  };

  int get _totalCount {
    int total = 0;
    _selectedTypes.forEach((key, isSelected) {
      if (isSelected) {
        total += _quantities[key] ?? 0;
      }
    });
    return total;
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Text(
                    'Choose Type of Passenger',
                    style: GoogleFonts.poppins(
                      color: darkBlue,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  _buildPassengerCategory('Senior Citizens', darkBlue),
                  const SizedBox(height: 20),
                  _buildPassengerCategory('Student', darkBlue),
                  const SizedBox(height: 20),
                  _buildPassengerCategory('PWD', darkBlue),
                  const SizedBox(height: 20),
                  _buildPassengerCategory('Regular', darkBlue),
                  
                  const SizedBox(height: 40),
                  
                  // CONFIRM Button
                  SizedBox(
                    width: 240,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PickupDropoffScreen(),
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerCategory(String title, Color darkBlue) {
    bool isSelected = _selectedTypes[title] ?? false;
    int currentQty = _quantities[title] ?? 1;

    return Column(
      children: [
        // Category Selection Pill
        GestureDetector(
          onTap: () {
            if (!isSelected && _totalCount >= 4) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Maximum of 4 passengers allowed')),
              );
              return;
            }
            setState(() {
              _selectedTypes[title] = !isSelected;
              // If selecting a new category and it would exceed 4, reset it to 1
              if (!isSelected && _totalCount > 4) {
                _quantities[title] = 1;
              }
            });
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.black, width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: darkBlue,
                    shape: BoxShape.circle,
                  ),
                  child: isSelected 
                    ? const Icon(Icons.check, color: Colors.greenAccent, size: 18) 
                    : null,
                ),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: darkBlue,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 24), // Spacer to balance the leading icon
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 10),
        
        // Quantity Selectors
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [1, 2, 3, 4].map((num) {
            bool isNumSelected = isSelected && currentQty == num;
            
            // Logic to disable numbers that would exceed total count of 4
            int totalWithoutThis = _totalCount - (isSelected ? currentQty : 0);
            bool canSelect = isSelected && (totalWithoutThis + num <= 4);
            
            return GestureDetector(
              onTap: canSelect ? () {
                setState(() {
                  _quantities[title] = num;
                });
              } : null,
              child: Container(
                width: 50,
                height: 28,
                decoration: BoxDecoration(
                  color: isNumSelected 
                    ? Colors.green 
                    : (canSelect ? Colors.white : Colors.grey[300]),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: canSelect || isNumSelected ? Colors.black : Colors.grey[400]!, 
                    width: 1.5
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  num.toString(),
                  style: GoogleFonts.poppins(
                    color: canSelect || isNumSelected ? darkBlue : Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
