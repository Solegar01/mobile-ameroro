import 'dart:convert';

import 'package:mobile_ameroro_app/apps/profile/models/profile_model.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';

class ProfileRepository {
  final ApiService apiService;
  ProfileRepository(this.apiService);

  Future<ProfileModel> fetchDataById(String id) async {
    try {
      final response = await apiService.get('profile/$id');
      print('API Response status: ${response.statusCode}');
      print('API Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['data'] != null) {
          final profileData = ProfileModel.fromJson(jsonResponse['data']);
          print('Parsed ProfileModel: ${profileData.toJson()}');
          return profileData;
        } else {
          throw Exception('Data not found in the response');
        }
      } else {
        throw Exception('Error fetching profile data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchDataById: $e');
      rethrow;
    }
  }

  Future<ProfileModel> update(String id, ProfileModel update) async {
    try {
      final body = update.toJson();
      final response = await apiService.put('profile/$id', body);

      print('Update Response status: ${response.statusCode}');
      print('Update Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['data'] != null) {
          return ProfileModel.fromJson(jsonResponse['data']);
        } else {
          return update; // Return the update model if no data in response
        }
      } else {
        throw Exception('Failed to update Profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating Profile: $e');
      rethrow;
    }
  }

  Future<bool> updatePassword(String id, String newPassword) async {
    try {
      final currentProfileResponse = await apiService.get('profile/$id');
      if (currentProfileResponse.statusCode != 200) {
        throw Exception('Failed to get current profile data');
      }

      final currentProfile = json.decode(currentProfileResponse.body)['data'];

      // Membuat body dengan mempertahankan data yang ada
      final body = {
        'username': currentProfile['username'] ?? '',
        'name': currentProfile['name'] ?? '',
        'email': currentProfile['email'] ?? '',
        'phone': currentProfile['phone'] ?? '',
        'password': newPassword,
      };

      final response = await apiService.put('profile/$id', body);
      print('Update Password Response status: ${response.statusCode}');
      print('Update Password Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['code'] == 200;
      }
      return false;
    } catch (e) {
      print('Error updating password: $e');
      return false;
    }
  }
}
