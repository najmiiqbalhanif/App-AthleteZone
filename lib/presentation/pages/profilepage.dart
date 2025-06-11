import 'package:flutter/material.dart';
import '../../services/UserService.dart';
import '../../models/user.dart';
import 'editprofilepage.dart';
import 'FavoriteProductsPage.dart'; // <--- Import halaman favorit

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    final fetchedUser = await UserService().fetchUserProfile();
    setState(() {
      user = fetchedUser;
      isLoading = false;
    });
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil berhasil diperbarui'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.grey,
                    backgroundImage: user!.profileImage != null && user!.profileImage!.isNotEmpty
                        ? NetworkImage(user!.profileImage!)
                        : null,
                    child: user!.profileImage == null || user!.profileImage!.isEmpty
                        ? const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    )
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user!.fullname,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@${user!.username}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: OutlinedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditProfilePage()),
                  );
                  if (result == true) {
                    await loadUserProfile();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Profil berhasil diperbarui'),
                            backgroundColor: Colors.green
                        ),
                      );
                    }
                  }
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // MODIFIED: Tombol Favorite
                  _MenuItem(
                    icon: Icons.favorite,
                    label: 'Favorite',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FavoriteProductsPage()),
                      );
                    },
                  ),
                  const _MenuItem(icon: Icons.qr_code, label: 'Access'),
                  const _MenuItem(icon: Icons.event, label: 'Event'),
                  const _MenuItem(icon: Icons.settings, label: 'Settings'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: ListTile(
                title: Text('Present from your nike member'),
                subtitle: Text('Available 2'),
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

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap; // Tambahkan properti onTap

  const _MenuItem({required this.icon, required this.label, this.onTap}); // Perbarui konstruktor

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Gunakan GestureDetector untuk menangani tap
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 28, color: Color(0xFF4A4A4A)),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}