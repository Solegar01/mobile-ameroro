import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_ameroro_app/apps/config/app_config.dart';
import 'package:mobile_ameroro_app/apps/profile/controllers/profile_controller.dart';

class ProfileView extends StatelessWidget {
  final ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: controller.obx(
        (state) => RefreshIndicator(
          backgroundColor: GFColors.LIGHT,
          onRefresh: () async => controller.formInit(),
          child: ListView(
            children: [
              Column(
                children: [
                  // Profile Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    color: const Color(0XFF3A57E8),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.purple,
                          child: Text(
                            controller.user.value.name?.isNotEmpty == true
                                ? controller.user.value.name![0].toUpperCase()
                                : '',
                            style: const TextStyle(
                                fontSize: 24, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() => Text(
                                  controller.user.value.name ?? "",
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white),
                                )),
                            const SizedBox(height: 4),
                            const Text(
                              "BENDUNGAN AMERORO",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Informasi Personal Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person,
                                color: Color.fromARGB(255, 173, 173, 175)),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Informasi Personal',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                controller.toProfiledetail(context);
                              },
                              child: const Row(
                                children: [
                                  Text(
                                    'Ubah',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 75, 104, 255)),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.edit,
                                    size: 18,
                                    color: Color.fromARGB(255, 75, 104, 255),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Obx(() => _buildInfoItem(
                            'Username', controller.user.value.username ?? '')),
                        Obx(() => _buildInfoItem(
                            'Nama Lengkap', controller.user.value.name ?? '')),
                        Obx(() => _buildInfoItem(
                            'Nomor HP', controller.user.value.phone ?? '')),
                        Obx(() => _buildInfoItem(
                            'Email', controller.user.value.email ?? '')),
                      ],
                    ),
                  ),

                  // Pengaturan Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.settings,
                                color: Color.fromARGB(255, 173, 173, 175)),
                            SizedBox(width: 8),
                            Text(
                              'Pengaturan',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildSettingItem('Ubah Kata Sandi', onTap: () {
                          String userId =
                              '37f75b0c-400b-4f15-b349-b8a0b6a546c3';
                          showChangePasswordPopup(context, userId, controller);
                        }),
                        _buildSettingItem('Versi Aplikasi', trailing: '1.0.0'),
                      ],
                    ),
                  ),

                  // Logout Button
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: GFButton(
                      onPressed: () async {
                        // Menampilkan popup konfirmasi sebelum logout
                        bool? confirmLogout = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              title: const Center(
                                child: Text(
                                  'Konfirmasi Logout',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              content: const Text(
                                'Apakah Anda yakin ingin menutup aplikasi?',
                                style: TextStyle(color: Colors.black),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text(
                                    'No',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(color: GFColors.DANGER),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        if (confirmLogout == true) {
                          await controller.logout();
                        }
                      },
                      text: 'Logout',
                      color: GFColors.DANGER,
                      size: GFSize.LARGE,
                      fullWidthButton: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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

  Widget _buildInfoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 14)),
          Text(value.isNotEmpty ? value : '-',
              style: const TextStyle(fontSize: 14, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildSettingItem(String title,
      {Function()? onTap, String? trailing}) {
    return ListTile(
      title: Text(title),
      trailing: trailing != null
          ? Text(trailing,
              style: const TextStyle(fontSize: 14, color: Colors.black54))
          : const Icon(Icons.arrow_forward_ios, size: 16),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }

  void showChangePasswordPopup(
      BuildContext context, String userId, ProfileController controller) {
    TextEditingController oldPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          title: Text(
            'Ubah Kata Sandi',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.indigo[700]),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: oldPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi Lama',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukkan kata sandi lama';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi Baru',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukkan kata sandi baru';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Kata Sandi Baru',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukkan konfirmasi kata sandi baru';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                foregroundColor: Colors.black,
                backgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                foregroundColor: Colors.white,
                backgroundColor: const Color(0XFF3A57E8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Simpan'),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  // Validasi kata sandi baru
                  if (newPasswordController.text ==
                      confirmPasswordController.text) {
                    // Panggil fungsi ubah kata sandi di controller
                    controller.changePassword(
                      userId, // Menggunakan userId dari parameter
                      oldPasswordController.text,
                      newPasswordController.text,
                    );
                    Navigator.of(context)
                        .pop(); // Hanya menutup dialog setelah fungsi dipanggil
                  } else {
                    Get.snackbar(
                        'Error', 'Konfirmasi kata sandi tidak sesuai.');
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
