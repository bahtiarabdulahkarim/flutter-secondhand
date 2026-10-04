import 'package:flutter/material.dart';

import 'detail_page.dart';
import 'login_page.dart';
import 'model/kendaraan_model.dart';

class ProfilePage extends StatelessWidget {
  final List<Kendaraan> favoriteVehicles;
  final Function(Kendaraan) onFavoritePressed;

  const ProfilePage({
    super.key,
    required this.favoriteVehicles,
    required this.onFavoritePressed,
  });

  void logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Sign out?',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: const Text('Kamu akan keluar dari akun AutoMarket.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF171717),
                foregroundColor: Colors.white,
              ),
              child: const Text('Sign out'),
            ),
          ],
        );
      },
    );
  }

  void showPersonalInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Personal Information',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nama', style: TextStyle(color: Colors.grey, fontSize: 12)),
              SizedBox(height: 4),
              Text(
                'Bahtiar Abdullah Karim',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 15),
              Text(
                'Program Studi',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              SizedBox(height: 4),
              Text(
                'Teknik Informatika',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        );
      },
    );
  }

  void showEducation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Education',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: const Text(
            'Program Studi Teknik Informatika\n'
            'Flutter Student Project',
          ),
        );
      },
    );
  }

  void showStudentId(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Student ID',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: const Text(
            'NIM: 25051204396\n\n'
            '25051204396.',
          ),
        );
      },
    );
  }

  void showMyVehicles(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Vehicles',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
              ),

              const SizedBox(height: 8),

              Text(
                'Kendaraan yang kamu jual.',
                style: TextStyle(color: Colors.grey.shade600),
              ),

              const SizedBox(height: 25),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F2),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.directions_car_outlined,
                      size: 45,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Belum ada kendaraan',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Fitur menjual kendaraan akan '
                      'dikembangkan pada tahap berikutnya.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void showFavorites(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * .65,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Favorites',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${favoriteVehicles.length}',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                if (favoriteVehicles.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 50,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Belum ada favorit',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: favoriteVehicles.length,
                      itemBuilder: (context, index) {
                        final kendaraan = favoriteVehicles[index];

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 5,
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              kendaraan.gambar,
                              width: 65,
                              height: 55,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            kendaraan.getNamaKendaraan(),
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          subtitle: Text(kendaraan.getHarga()),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                          onTap: () {
                            Navigator.pop(context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(
                                  kendaraan: kendaraan,
                                  isFavorite: true,
                                  onFavoritePressed: () {
                                    onFavoritePressed(kendaraan);
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget menuItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: const Color(0xFFE8E8E5)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2EF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 25, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -.8,
                ),
              ),

              const SizedBox(height: 25),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF171717),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/profile.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bahtiar Abdullah Karim',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Teknik Informatika',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'AutoMarket member',
                            style: TextStyle(
                              color: Color(0xFFD8FF3E),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Account',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),

              const SizedBox(height: 12),

              menuItem(
                context,
                Icons.person_outline,
                'Personal information',
                'Bahtiar Abdullah Karim',
                () => showPersonalInfo(context),
              ),

              menuItem(
                context,
                Icons.school_outlined,
                'Education',
                'Teknik Informatika',
                () => showEducation(context),
              ),

              menuItem(
                context,
                Icons.badge_outlined,
                'Student ID',
                '25051204396',
                () => showStudentId(context),
              ),

              const SizedBox(height: 15),

              const Text(
                'Application',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),

              const SizedBox(height: 12),

              menuItem(
                context,
                Icons.directions_car_outlined,
                'My vehicles',
                'Vehicles that you listed',
                () => showMyVehicles(context),
              ),

              menuItem(
                context,
                Icons.favorite_border,
                'Favorites',
                '${favoriteVehicles.length} saved vehicles',
                () => showFavorites(context),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 53,
                child: OutlinedButton.icon(
                  onPressed: () {
                    logout(context);
                  },
                  icon: const Icon(Icons.logout, size: 19),
                  label: const Text(
                    'Sign out',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF171717),
                    side: const BorderSide(color: Color(0xFFD9D9D5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Center(
                child: Text(
                  'AUTOMARKET v1.0',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
