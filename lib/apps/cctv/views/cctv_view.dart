import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/cctv/controllers/cctv_controller.dart';

class CctvView extends StatelessWidget {
  final CctvController controller = Get.find<CctvController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Monitoring CCTV",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 7, 23, 94),
      ),
      body: Center(child: Text('CCTV')),
      // RefreshIndicator(
      //   onRefresh: () async => await controller.fetchAllCctv(),
      //   child: LayoutBuilder(
      //     builder: (context, constraints) {
      //       return Obx(() {
      //         if (controller.isLoading.value) {
      //           return const Center(
      //             child: CircularProgressIndicator(),
      //           );
      //         }

      //         if (controller.cctvs.isEmpty) {
      //           return const Center(
      //             child: Text("Tidak ada data CCTV tersedia"),
      //           );
      //         }

      //         return ListView.separated(
      //           itemCount: controller.cctvs.length,
      //           itemBuilder: (context, index) {
      //             final cctv = controller.cctvs[index];
      //             final imageUrl = cctv.url;

      //             return ListTile(
      //               onTap: () async {
      //                 await controller.toDetail(index);
      //               },
      //               leading: ClipRRect(
      //                 borderRadius: BorderRadius.circular(6.0),
      //                 child: (imageUrl?.isNotEmpty ?? false)
      //                     ? Image.network(
      //                         imageUrl!,
      //                         width: constraints.maxWidth *
      //                             0.25, // adjust based on screen size
      //                         height: constraints.maxHeight * 0.15,
      //                         fit: BoxFit.cover,
      //                         errorBuilder: (context, error, stackTrace) {
      //                           return const Icon(Icons.broken_image, size: 54);
      //                         },
      //                       )
      //                     : const Icon(Icons.image,
      //                         size: 54), // Placeholder icon
      //               ),
      //               title: Text(cctv.name),
      //               trailing: const Icon(Icons.arrow_forward_ios),
      //             );
      //           },
      //           separatorBuilder: (context, index) => const Divider(
      //             height: 1,
      //             color: Colors.grey,
      //             indent: 16,
      //             endIndent: 16,
      //           ),
      //         );
      //       });
      //     },
      //   ),
      // ),
    );
  }
}
