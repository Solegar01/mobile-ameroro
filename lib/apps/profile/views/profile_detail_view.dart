import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/profile/controllers/profile_controller.dart';

class ProfileDetailView extends StatelessWidget {
  final ProfileController _controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Informasi Personal",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 7, 23, 94),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Username *',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(() => _buildTextField(
                  controller: _controller.username,
                  hintText: "Masukkan Username",
                  errorText: _controller.isUsernameValid.value
                      ? null
                      : "Username tidak boleh kosong",
                )),
            const SizedBox(height: 16),
            const Text(
              'Nama Lengkap *',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(() => _buildTextField(
                  controller: _controller.name,
                  hintText: "Masukkan Nama Lengkap",
                  errorText: _controller.isNameValid.value
                      ? null
                      : "Nama tidak boleh kosong",
                )),
            const SizedBox(height: 16),
            const Text(
              'Nomor HP *',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _controller.phone,
              hintText: "Contoh: 082123456789",
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            const Text(
              'Email *',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _controller.email,
              hintText: "Masukkan Email",
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _controller.isFormValid()
                    ? () async {
                        await _controller
                            .updateProfile(_controller.user.value.id!);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 7, 23, 94),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Simpan Perubahan',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Membuat TextField yang lebih proporsional
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
