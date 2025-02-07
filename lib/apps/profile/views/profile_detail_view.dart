import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:mobile_ameroro_app/apps/config/app_config.dart';
import 'package:mobile_ameroro_app/apps/profile/controllers/profile_controller.dart';

class ProfileDetailView extends StatelessWidget {
  final ProfileController _controller = Get.find<ProfileController>();
  final _formKey = GlobalKey<FormState>();
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
        // backgroundColor: const Color(0XFF3A57E8),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: _controller.obx(
        (state) => _buildForm(),
        onLoading: const Center(
          child: GFLoader(
            type: GFLoaderType.circle,
          ),
        ),
        onEmpty: const Text('Empty Data'),
        onError: (error) => Padding(
          padding: const EdgeInsets.all(8),
          child: Center(child: Text(error!)),
        ),
      ),
    );
  }

  // Membuat TextField yang lebih proporsional
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    final String? Function(String?)? validator,
  }) {
    return TextFormField(
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
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

  _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Username *',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildTextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Username tidak boleh kosong";
                }
                return null;
              },
              controller: _controller.username,
              hintText: "Masukkan Username",
            ),
            const SizedBox(height: 16),
            const Text(
              'Nama Lengkap *',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildTextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Nama tidak boleh kosong";
                }
                return null;
              },
              controller: _controller.name,
              hintText: "Masukkan Nama Lengkap",
            ),
            const SizedBox(height: 16),
            const Text(
              'Nomor HP *',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildTextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Nomor HP tidak boleh kosong";
                }
                return null;
              },
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
            _buildTextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Email tidak boleh kosong";
                }
                return null;
              },
              controller: _controller.email,
              hintText: "Masukkan Email",
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _controller.updateProfile(_controller.user.value.id!);
                  }
                },
                // onPressed: _controller.isFormValid()
                //     ? () async {
                //         await _controller
                //             .updateProfile(_controller.user.value.id!);
                //       }
                //     : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConfig.focusTextField,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Simpan Perubahan',
                  style: TextStyle(fontSize: 16, color: AppConfig.primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
