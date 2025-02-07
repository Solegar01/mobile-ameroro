import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ameroro_app/apps/widgets/custom_toast.dart';
import 'package:mobile_ameroro_app/routes/app_routes.dart';
import 'package:mobile_ameroro_app/apps/profile/repository/profile_repository.dart';
import 'package:mobile_ameroro_app/apps/profile/models/profile_model.dart';
import 'package:mobile_ameroro_app/services/local/session_service.dart';

class ProfileController extends GetxController with StateMixin {
  final ProfileRepository repository;
  final SessionService session = SessionService();
  ProfileController(this.repository);

  var user = ProfileModel.empty().obs;

  TextEditingController username = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();

  // RxBool isUsernameValid = true.obs;
  // RxBool isNameValid = true.obs;
  // RxBool isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    formInit();
  }

  void formInit() async {
    await _loadUserData();
    // _setupFormListener();
  }

  // void _setupFormListener() {
  //   username.addListener(_validateForm);
  //   name.addListener(_validateForm);
  // }

  void toProfiledetail(BuildContext context) async {
    _setTextControllers(user.value);
    Get.toNamed(AppRoutes.PROFILE_DETAIL);
  }

  Future<void> _loadUserData() async {
    change(null, status: RxStatus.loading());
    try {
      String? userId = await session.getSession('id');
      if (userId != null) {
        await getUserById(userId);
        change(null, status: RxStatus.success());
      } else {
        msgToast("No user ID found in session. Redirecting to login.");
        change(null, status: RxStatus.error());
        Get.offAllNamed(AppRoutes.LOGIN);
      }
    } catch (e) {
      msgToast(e.toString());
      change(null, status: RxStatus.error());
    }
  }

  Future getUserById(String id) async {
    change(null, status: RxStatus.loading());
    try {
      final userData = await repository.fetchDataById(id);
      user.value = userData;
      _setTextControllers(userData);
      print('User data after setting: ${user.value.toJson()}');
      change(null, status: RxStatus.success());
    } catch (e) {
      msgToast('Error in getUserById: $e');
      change(null, status: RxStatus.error());
    }
  }

  void _setTextControllers(ProfileModel userData) {
    username.text = userData.username ?? "";
    name.text = userData.name ?? "";
    phone.text = userData.phone ?? "";
    email.text = userData.email ?? "";
  }

  Future<void> updateProfile(String id) async {
    change(null, status: RxStatus.loading());
    try {
      final updatedProfile = ProfileModel(
        id: id,
        username: username.text,
        name: name.text,
        phone: phone.text,
        email: email.text,
      );

      final result = await repository.update(id, updatedProfile);
      user.value = result;
      _setTextControllers(result);

      msgToast('Update Profile Berhasil');
      change(null, status: RxStatus.success());
    } catch (e) {
      print('Error in updateProfile: $e');
      msgToast('Update Profile Gagal');
      change(null, status: RxStatus.error());
    }
  }

  Future<void> changePassword(
      String id, String oldPassword, String newPassword) async {
    change(null, status: RxStatus.loading());
    try {
      // Update password dengan mempertahankan data lain
      await repository.updatePassword(id, newPassword);
      Get.back();
      msgToast('Update Kata Sandi Berhasil');
      change(null, status: RxStatus.success());
    } catch (e) {
      print('Error in updateKataSandi: $e');
      msgToast('Update Kata Sandi Gagal');
      change(null, status: RxStatus.error());
    }
  }

  // void _validateForm() {
  //   isUsernameValid.value = username.text.isNotEmpty;
  //   isNameValid.value = name.text.isNotEmpty;
  //   isFormValid.value = isUsernameValid.value && isNameValid.value;
  // }

  Future<void> logout() async {
    await session.removeSession('id');
    await session.removeSession('name');
    await session.removeSession('username');
    await session.removeSession('phone');
    await session.removeSession('email');
    await session.removeSession('isLogin');

    Get.offAllNamed(AppRoutes.LOGIN);
  }

  void clearTextEditingController() {
    username.clear();
    name.clear();
    email.clear();
    phone.clear();
  }
}
