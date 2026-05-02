import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';

  void _showLanguageDialog(Color darkBlue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Language',
            style: GoogleFonts.poppins(color: darkBlue, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('English', style: GoogleFonts.poppins()),
                leading: Radio<String>(
                  value: 'English',
                  groupValue: _selectedLanguage,
                  activeColor: darkBlue,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'English';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Tagalog', style: GoogleFonts.poppins()),
                leading: Radio<String>(
                  value: 'Tagalog',
                  groupValue: _selectedLanguage,
                  activeColor: darkBlue,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'Tagalog';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFBEEBFF);
    const Color darkBlue = Color(0xFF000080);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // Top Bar
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 20, bottom: 10),
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
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  // Title
                  Text(
                    'Settings',
                    style: GoogleFonts.poppins(
                      color: darkBlue,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Settings Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
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
                      children: [
                        // Notifications
                        ListTile(
                          leading: const Icon(Icons.notifications_none, color: darkBlue, size: 28),
                          title: Text(
                            'Notifications',
                            style: GoogleFonts.poppins(
                              color: darkBlue,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Switch(
                            value: _notificationsEnabled,
                            activeColor: darkBlue,
                            onChanged: (value) {
                              setState(() {
                                _notificationsEnabled = value;
                              });
                            },
                          ),
                        ),
                        const Divider(height: 1, indent: 60),
                        
                        // Language
                        _buildSettingsItem(
                          icon: Icons.language_outlined,
                          title: 'Language',
                          trailingText: _selectedLanguage,
                          darkBlue: darkBlue,
                          onTap: () => _showLanguageDialog(darkBlue),
                        ),
                        const Divider(height: 1, indent: 60),
                        
                        // About
                        _buildSettingsItem(
                          icon: Icons.info_outline,
                          title: 'About',
                          darkBlue: darkBlue,
                        ),
                        const Divider(height: 1, indent: 60),
                        
                        // Privacy Policy
                        _buildSettingsItem(
                          icon: Icons.shield_outlined,
                          title: 'Privacy Policy',
                          darkBlue: darkBlue,
                        ),
                        const Divider(height: 1, indent: 60),
                        
                        // Terms & Conditions
                        _buildSettingsItem(
                          icon: Icons.description_outlined,
                          title: 'Terms & Conditions',
                          darkBlue: darkBlue,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'ACCOUNT'),
        ],
        currentIndex: 2,
        selectedItemColor: darkBlue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index != 2) {
            Navigator.pop(context); // Go back to Dashboard if other tab selected
          }
        },
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required Color darkBlue,
    String? trailingText,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: darkBlue, size: 28),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: darkBlue,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: GoogleFonts.poppins(
                color: Colors.blueAccent,
                fontSize: 14,
              ),
            ),
          const SizedBox(width: 10),
          Icon(Icons.chevron_right, color: darkBlue),
        ],
      ),
      onTap: onTap ?? () {},
    );
  }
}
