import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/cctv/controllers/cctv_controller.dart';

class CctvDetailView extends StatelessWidget {
  final CctvController _controller = Get.find<CctvController>();
  final String id = Get.arguments ?? "";

  CctvDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail CCTV",
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
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.delete_forever_outlined, color: Colors.white),
        //     onPressed: () {
        //       Get.defaultDialog(
        //         title: 'Hapus CCTV',
        //         middleText: 'Apakah Anda yakin ingin menghapus CCTV ini?',
        //         textConfirm: 'Ya',
        //         textCancel: 'Batal',
        //         onConfirm: () {
        //           // _controller.deleteCctv(context, id);
        //           Get.back();
        //         },
        //       );
        //     },
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nama Lokasi *',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _controller.name,
              hintText: 'Masukkan Nama Lokasi',
            ),
            const SizedBox(height: 16),
            const Text(
              'URL Gambar *',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _controller.url,
              hintText: 'Masukkan URL Gambar',
            ),
            const SizedBox(height: 16),
            const Text(
              'Latitude *',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _controller.latitude,
              hintText: 'Masukkan Latitude',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            const Text(
              'Longitude *',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _controller.longitude,
              hintText: 'Masukkan Longitude',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            const Text(
              'Catatan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _controller.note,
              hintText: 'Masukkan Catatan',
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _controller.updateCctv(id);
                },
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
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
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
}
