import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  // Data anggota kelompok
  final List<Map<String, String>> members = const [
    {
      'name': 'Andhika Annas Satria',
      'nim': '25051204429',
      'photo': 'assets/team/Andhika.jpeg',
      'github': 'https://github.com/satriamahatir357',
    },
    {
      'name': 'Eka Fajar Deny Iswantoro',
      'nim': '25051204391',
      'photo': 'assets/team/deny.jpeg',
      'github': 'https://github.com/denzy-id',
    },
    {
      'name': 'Bahtiar Abdulah Karim',
      'nim': '25051204396',
      'photo': 'assets/team/bahtiar.jpeg',
      'github': 'https://github.com/bahtiarabdulahkarim',
    },
    {
      'name': 'Yesica Candra Carlota',
      'nim': '25051204423',
      'photo': 'assets/team/yesica.jpeg',
      'github': 'https://github.com/YesicaCandra',
    },
    {
      'name': 'Revaliza Aura Nabila',
      'nim': '25051204409',
      'photo': 'assets/team/revaliza.jpeg',
      'github': 'https://github.com/revalizaaura',
    },
    {
      'name': 'Mutiara Nur Hidayah',
      'nim': '25051204412',
      'photo': 'assets/team/mutiara.jpeg',
      'github': 'https://github.com/Her4nesss',
    },
    {
      'name': 'Dhea Sarrah Azzahra',
      'nim': '25051204432',
      'photo': 'assets/team/dhea.jpeg',
      'github': 'https://github.com/dheasarrah',
    },
  ];

  // Fungsi membuka GitHub
  Future<void> bukaGitHub(
    BuildContext context,
    String url,
  ) async {
    final Uri uri = Uri.parse(url);

    try {
      final berhasil = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!berhasil && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak dapat membuka GitHub'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terjadi kesalahan saat membuka GitHub'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF789449),
        foregroundColor: Colors.white,
        title: const Text(
          'About Us',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 35,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 600) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            flex: 3,
                            child: Text(
                              'Meet the team\nbehind SECONDHAND MOTORS',
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                                height: 1.15,
                              ),
                            ),
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Kami adalah tim pengembang aplikasi '
                              'SECONDHAND MOTORS yang berkomitmen '
                              'menghadirkan informasi kendaraan bekas '
                              'dengan tampilan yang mudah digunakan.',
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.6,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Meet the team\nbehind SECONDHAND MOTORS',
                          style: TextStyle(
                            fontSize: 29,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Kami adalah tim pengembang aplikasi '
                          'SECONDHAND MOTORS yang berkomitmen '
                          'menghadirkan informasi kendaraan bekas '
                          'dengan tampilan yang mudah digunakan.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 35),

                // GRID ANGGOTA
                LayoutBuilder(
                  builder: (context, constraints) {
                    int columns;

                    if (constraints.maxWidth > 750) {
                      columns = 3;
                    } else if (constraints.maxWidth > 450) {
                      columns = 2;
                    } else {
                      columns = 1;
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: members.length,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 18,
                        mainAxisSpacing: 25,
                        childAspectRatio: 0.72,
                      ),
                      itemBuilder: (context, index) {
                        final member = members[index];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // FOTO ANGGOTA
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2F3F1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    member['photo']!,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(
                                          Icons.person,
                                          size: 85,
                                          color: Color(0xFF789449),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // NAMA
                            Text(
                              member['name']!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            // NIM
                            Text(
                              'NIM: ${member['nim']}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // LINK GITHUB
                            InkWell(
                              onTap: () {
                                bukaGitHub(
                                  context,
                                  member['github']!,
                                );
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.code,
                                    size: 19,
                                    color: Color(0xFF789449),
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      member['github']!
                                          .replaceFirst(
                                        'https://',
                                        '',
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF789449),
                                        fontWeight: FontWeight.w600,
                                        decoration:
                                            TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
