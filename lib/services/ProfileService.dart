import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class ProfileService {
  final String baseUrl = "http://10.0.2.2:8080/api/profilepage"; //masih emulator

  Future<User?> fetchUserProfile() async {
    try {
      // Ambil userId dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      if (userId == null) {
        print("User ID not found in SharedPreferences.");
        return null;
      }

      final response = await http.get(Uri.parse("$baseUrl/$userId"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data);
      } else {
        print("Failed to load profile. Status code: \${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching profile: $e");
      return null;
    }
  }
}