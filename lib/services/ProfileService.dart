import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class ProfileService {
  final String baseUrl = "http://10.0.2.2:8080/api/profilepage"; //masih emulator

  Future<User?> fetchUserProfile() async {
    try {


      final response = await http.get(Uri.parse("$baseUrl/3")); //kalau mau testing coba masukkan id nya '3'

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