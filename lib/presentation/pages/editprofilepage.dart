import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _firstNameController = TextEditingController(text: 'Najmi');
  final _lastNameController = TextEditingController(text: 'Hanif');
  final _cityController = TextEditingController();
  final _bioController = TextEditingController();
  int bioLength = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(),
        title: const Text('Edit Profil'),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                'SIMPAN',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          )
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 48,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Edit',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Nama Depan
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Nama Depan'),
            ),
            TextField(
              controller: _firstNameController,
            ),

            const SizedBox(height: 16),

            // Nama Belakang
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Nama Belakang'),
            ),
            TextField(
              controller: _lastNameController,
            ),

            const SizedBox(height: 16),

            // Kota, Provinsi
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                hintText: 'Kota, Provinsi',
              ),
            ),

            const SizedBox(height: 16),

            // Bio
            TextField(
              controller: _bioController,
              maxLines: null,
              maxLength: 150,
              onChanged: (text) {
                setState(() {
                  bioLength = text.length;
                });
              },
              decoration: InputDecoration(
                labelText: 'Bio',
                counterText: '${bioLength}/150',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
