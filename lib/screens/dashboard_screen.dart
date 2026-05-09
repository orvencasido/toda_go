import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'select_trip_screen.dart';
import 'history_screen.dart';
import 'account_screen.dart';

// Optimization: Using constant theme data to avoid recreation in build methods
class DashboardTheme {
  static const Color darkBlue = Color(0xFF000080);
  static const Color primaryBlue = Color(0xFF1A237E);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color white = Colors.white;
  
  static final TextStyle headerStyle = GoogleFonts.poppins(
    color: white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  
  static final TextStyle subHeaderStyle = GoogleFonts.poppins(
    color: Colors.white70,
    fontSize: 14,
  );
}

class DashboardScreen extends StatefulWidget {
  final int initialIndex;
  const DashboardScreen({super.key, this.initialIndex = 0});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Optimization: Pre-defining views as const to prevent rebuilds
    final List<Widget> _views = const [
      _DashboardHomeView(),
      HistoryScreen(),
      AccountScreen(),
    ];

    return Scaffold(
      backgroundColor: DashboardTheme.backgroundColor,
      body: _views[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10, // Optimized: reduced blur
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              activeIcon: Icon(Icons.home_rounded, size: 28),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              activeIcon: Icon(Icons.history_rounded, size: 28),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              activeIcon: Icon(Icons.person_rounded, size: 28),
              label: 'Account',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: DashboardTheme.darkBlue,
          unselectedItemColor: Colors.grey.withOpacity(0.5),
          backgroundColor: DashboardTheme.white,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        ),
      ),
    );
  }
}

class _DashboardHomeView extends StatelessWidget {
  const _DashboardHomeView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Optimization: Physics to make scrolling feel better
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _DashboardHeader(),
          SizedBox(height: 55),
          _BookNowButton(),
          SizedBox(height: 35),
          _SectionTitle(title: 'Safety & Tips'),
          SizedBox(height: 15),
          _InfoCardsSection(),
          SizedBox(height: 30),
          _SectionTitle(title: 'Recent Trips'),
          SizedBox(height: 10),
          _RecentTripItem(
            title: 'Tayabas Public Market',
            subtitle: 'San Diego St, Tayabas City',
          ),
          _RecentTripItem(
            title: 'SM City Lucena',
            subtitle: 'Dalahican Rd, Lucena City',
          ),
          SizedBox(height: 25),
        ],
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: DashboardTheme.darkBlue,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hello, Joross!', style: DashboardTheme.headerStyle),
                  Text('Ready for a ride?', style: DashboardTheme.subHeaderStyle),
                ],
              ),
              const CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, color: Colors.white, size: 30),
              ),
            ],
          ),
        ),
        const Positioned(
          bottom: -25,
          left: 25,
          right: 25,
          child: _SearchCard(),
        ),
      ],
    );
  }
}

class _SearchCard extends StatelessWidget {
  const _SearchCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SelectTripScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: DashboardTheme.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: DashboardTheme.darkBlue, size: 28),
            const SizedBox(width: 15),
            Text(
              'Where to?',
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookNowButton extends StatelessWidget {
  const _BookNowButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SelectTripScreen()),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: DashboardTheme.darkBlue,
          foregroundColor: DashboardTheme.white,
          minimumSize: const Size(double.infinity, 65),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 4, // Optimized: reduced elevation
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.electric_rickshaw_rounded, size: 32),
            SizedBox(width: 15),
            Text(
              'BOOK A TRICYCLE',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: DashboardTheme.primaryBlue,
        ),
      ),
    );
  }
}

class _InfoCardsSection extends StatelessWidget {
  const _InfoCardsSection();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 25),
        children: const [
          _InfoCard(
            title: 'Ride Safely',
            description: 'Always wear your helmet and hold on tight during the ride.',
            color: Color(0xFFE3F2FD),
            icon: Icons.security_rounded,
            iconColor: Colors.blue,
          ),
          _InfoCard(
            title: 'Fair Rates',
            description: 'Check our fare guide to know the standard rates in Tayabas.',
            color: Color(0xFFFFF3E0),
            icon: Icons.payments_rounded,
            iconColor: Colors.orange,
          ),
          _InfoCard(
            title: 'Be Kind',
            description: 'Treat our drivers with respect and courtesy at all times.',
            color: Color(0xFFE8F5E9),
            icon: Icons.favorite_rounded,
            iconColor: Colors.green,
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String description;
  final Color color;
  final IconData icon;
  final Color iconColor;

  const _InfoCard({
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  maxLines: 2,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Icon(icon, color: iconColor.withOpacity(0.3), size: 45),
        ],
      ),
    );
  }
}

class _RecentTripItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const _RecentTripItem({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Color(0xFFEEEEEE), shape: BoxShape.circle),
            child: const Icon(Icons.history_rounded, color: Colors.grey, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
