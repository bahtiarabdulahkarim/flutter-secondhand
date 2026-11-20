import 'package:flutter/material.dart';

class HomeNavbar extends StatelessWidget {
  final String activeMenu;
  final Function(String) onNavigate;
  final VoidCallback onProfile;

  const HomeNavbar({
    super.key,
    required this.activeMenu,
    required this.onNavigate,
    required this.onProfile,
  });

  static const Color gold = Color(0xFFC9A45C);
  static const Color dark = Color(0xFF0D1015);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: dark,
      padding: const EdgeInsets.symmetric(
        horizontal: 36,
        vertical: 18,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 750) {
            return _buildMobileNavbar();
          }

          return _buildDesktopNavbar();
        },
      ),
    );
  }

  // NAVBAR DESKTOP
  Widget _buildDesktopNavbar() {
    return Row(
      children: [
        _buildLogo(),
        const Spacer(),

        _buildMenuItem('Beranda', 'Beranda'),
        _buildMenuItem('Mobil', 'Mobil'),
        _buildMenuItem('Motor', 'Motor'),
        _buildMenuItem('Tentang Kami', 'Tentang Kami'),

        const Spacer(),

        IconButton(
          onPressed: onProfile,
          tooltip: 'Profil',
          icon: const Icon(
            Icons.account_circle_outlined,
            color: gold,
            size: 29,
          ),
        ),
      ],
    );
  }

  // NAVBAR MOBILE
  Widget _buildMobileNavbar() {
    return Row(
      children: [
        _buildLogo(),
        const Spacer(),

        IconButton(
          onPressed: onProfile,
          tooltip: 'Profil',
          icon: const Icon(
            Icons.account_circle_outlined,
            color: gold,
            size: 27,
          ),
        ),

        PopupMenuButton<String>(
          icon: const Icon(
            Icons.menu,
            color: gold,
          ),
          color: const Color(0xFF191D24),
          onSelected: onNavigate,
          itemBuilder: (context) => [
            _menuEntry('Beranda'),
            _menuEntry('Mobil'),
            _menuEntry('Motor'),
            _menuEntry('Tentang Kami'),
          ],
        ),
      ],
    );
  }

  // LOGO
  Widget _buildLogo() {
    return GestureDetector(
      onTap: () => onNavigate('Beranda'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'SECONDHAND',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              letterSpacing: 2.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 3),
          Text(
            'DRIVE BETTER, BUY SMARTER.',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 7,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  // MENU NAVIGASI
  Widget _buildMenuItem(String title, String destination) {
    final bool isActive = activeMenu == destination;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9),
      child: TextButton(
        onPressed: () => onNavigate(destination),
        style: TextButton.styleFrom(
          backgroundColor: isActive
              ? const Color(0xFF25282D)
              : Colors.transparent,
          foregroundColor: isActive ? gold : Colors.white70,
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  // MENU POPUP MOBILE
  PopupMenuItem<String> _menuEntry(String destination) {
    return PopupMenuItem<String>(
      value: destination,
      child: Text(
        destination,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
