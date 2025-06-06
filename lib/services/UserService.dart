import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserService {
  final String profileUrl = "http://10.0.2.2:8080/api/profilepage";
  final String editProfileUrl = "http://10.0.2.2:8080/api/editprofilepage";//masih emulator

  Future<User?> fetchUserProfile() async {
    try {
      // Ambil userId dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      if (userId == null) {
        print("User ID not found in SharedPreferences.");
        return null;
      }

      final response = await http.get(Uri.parse("$profileUrl/$userId"));

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

  Future<bool> updateUserProfile({
    required String username,
    required String email,
    required String fullName,
    String? profileImage,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      if (userId == null) {
        print("User ID not found in SharedPreferences.");
        return false;
      }

      var uri = Uri.parse("$editProfileUrl/$userId");
      var request = http.MultipartRequest("PUT", uri);
      request.fields['username'] = username;
      request.fields['email'] = email;
      request.fields['fullName'] = fullName;

      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath('profileImage', profileImage));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        print("Profile updated successfully");
        return true;
      } else {
        print("Failed to update profile. Status code: \${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error updating profile: $e");
      return false;
    }
  }
}