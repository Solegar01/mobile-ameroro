import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ameroro_app/apps/login/controllers/login_controller.dart';
import 'package:mobile_ameroro_app/apps/login/models/login_response_model.dart';
import 'package:mobile_ameroro_app/apps/widgets/custom_toast.dart';
import 'package:mobile_ameroro_app/routes/app_routes.dart';
import 'package:mobile_ameroro_app/apps/profile/repository/profile_repository.dart';
import 'package:mobile_ameroro_app/apps/profile/models/profile_model.dart';
import 'package:mobile_ameroro_app/services/local/session_service.dart';

class ProfileController extends GetxController with StateMixin {
  final ProfileRepository repository;
  final SessionService session = SessionService();
  final loginController = Get.find<LoginController>();
  ProfileController(this.repository);

  var user = ProfileModel.empty().obs;
  RxBool isLoading = true.obs;

  TextEditingController username = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();

  RxBool isUsernameValid = true.obs;
  RxBool isNameValid = true.obs;
  RxBool isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _setupFormListener();
    change(null, status: RxStatus.success());
  }

  void _setupFormListener() {
    username.addListener(_validateForm);
    name.addListener(_validateForm);
  }

  void toProfiledetail(BuildContext context) async {
    _setTextControllers(user.value);
    Get.toNamed(AppRoutes.PROFILE_DETAIL);
  }

  Future<void> _loadUserData() async {
    try {
      await loginController.repository.getLogin().then((model) {
        var tempProf = ProfileModel(
          id: model.id,
          username: model.username,
          name: model.name,
          phone: model.phone,
          email: model.email,
        );
        user.value = tempProf;
        _setTextControllers(tempProf);
      });
    } catch (e) {
      msgToast(e.toString());
      await Future.delayed(const Duration(milliseconds: 1500));
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }

  void _setTextControllers(ProfileModel userData) {
    username.text = userData.username ?? "";
    name.text = userData.name ?? "";
    phone.text = userData.phone ?? "";
    email.text = userData.email ?? "";
  }

  Future<void> updateProfile(String id) async {
    try {
      isLoading.value = true;
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

      // Get.back();
      Get.snackbar(
        '',
        '',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        titleText: Text(
          'Update Profile Berhasil',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        messageText: SizedBox.shrink(),
        margin: EdgeInsets.all(10),
      );
    } catch (e) {
      print('Error in updateProfile: $e');
      Get.snackbar(
        '',
        '',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        titleText: Text(
          'Update Profile Gagal',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        messageText: SizedBox.shrink(),
        margin: EdgeInsets.all(10),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword(
      String id, String oldPassword, String newPassword) async {
    try {
      isLoading.value = true;

      // Update password dengan mempertahankan data lain
      final success = await repository.updatePassword(id, newPassword);

      Get.back();
      Get.snackbar(
        '',
        '',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        titleText: Text(
          'Update Kata Sandi Berhasil',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        messageText: SizedBox.shrink(),
        margin: EdgeInsets.all(10),
      );
    } catch (e) {
      print('Error in updateKataSandi: $e');
      Get.snackbar(
        '',
        '',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        titleText: Text(
          'Update Kata Sandi Gagal',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        messageText: SizedBox.shrink(),
        margin: EdgeInsets.all(10),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _validateForm() {
    isUsernameValid.value = username.text.isNotEmpty;
    isNameValid.value = name.text.isNotEmpty;
    isFormValid.value = isUsernameValid.value && isNameValid.value;
  }

  Future<void> logout() async {
    await session.removeSession('id');
    await session.removeSession('name');
    await session.removeSession('username');
    await session.removeSession('phone');
    await session.removeSession('email');
    await session.removeSession('remeeberMe');

    Get.offAllNamed(AppRoutes.LOGIN);
  }

  void clearTextEditingController() {
    username.clear();
    name.clear();
    email.clear();
    phone.clear();
  }
}
