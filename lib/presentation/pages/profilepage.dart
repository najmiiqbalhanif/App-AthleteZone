import 'package:flutter/material.dart';
import 'editprofilepage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian atas: ikon navigasi atau teks (bisa dikembangkan)

            const SizedBox(height: 25),

            // Avatar dan nama
            Center(
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Najmi Hanif',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tombol Edit Profil
            Center(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditProfilePage()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  side: const BorderSide(color: Colors.grey),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  'Edit Profil',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 42),

            // Menu bar (Pesanan, Akses, Acara, Pengaturan)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _MenuItem(icon: Icons.shopping_bag_outlined, label: 'Pesanan'),
                  _MenuItem(icon: Icons.qr_code, label: 'Akses'),
                  _MenuItem(icon: Icons.event, label: 'Acara'),
                  _MenuItem(icon: Icons.settings, label: 'Pengaturan'),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Hadiah Anggota
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: ListTile(
                title: Text('Hadiah Anggota Nike Anda'),
                subtitle: Text('Tersedia 2'),
                trailing: Icon(Icons.chevron_right),
              ),
            ),

            const Divider(),


          ],
        ),
      ),
    );
  }
}

// Komponen untuk menu atas
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MenuItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Color(0xFF4A4A4A)),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

