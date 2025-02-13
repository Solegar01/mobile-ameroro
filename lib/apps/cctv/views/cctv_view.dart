import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:mobile_ameroro_app/apps/cctv/controllers/cctv_controller.dart';
import 'package:mobile_ameroro_app/apps/widgets/loader_animation.dart';

class CctvView extends StatelessWidget {
  final CctvController controller = Get.find<CctvController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CctvController>(builder: (controller) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            foregroundColor: GFColors.WHITE,
            title: const Text(
              'Monitoring CCTV',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          body: controller.obx(
            (state) => _detail(context, controller),
            onLoading: const Center(
              child: LoaderAnimation(),
            ),
            onEmpty: const Text('Tidak ada data yang tersedia'),
            onError: (error) => Padding(
              padding: const EdgeInsets.all(8),
              child:
                  Center(child: Text(error ?? "Error while loading data...!")),
            ),
          ),
        ),
      );
    });
  }

  _detail(BuildContext context, CctvController controller) {
    return RefreshIndicator(
      backgroundColor: GFColors.LIGHT,
      onRefresh: () async {
        await controller.fetchAllCctv();
      },
      child: LayoutBuilder(builder: (context, constraints) {
        return (controller.cctvs.isEmpty)
            ? const Center(
                child: Text("Tidak ada data CCTV tersedia"),
              )
            : ListView.separated(
                itemCount: controller.cctvs.length,
                itemBuilder: (context, index) {
                  final cctv = controller.cctvs[index];
                  final imageUrl = cctv.url;

                  return Container(
                    color: GFColors.WHITE,
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      onTap: () async {
                        await controller.toDetail(cctv);
                      },
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        child: SizedBox(
                          width: constraints.maxWidth *
                              0.25, // adjust based on screen size
                          height: constraints.maxHeight * 0.15,
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return const Center(
                                child: LoaderAnimation(),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 54);
                            },
                          ),
                        ),
                      ),
                      title: Text(
                        cctv.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      titleTextStyle: const TextStyle(
                        color: GFColors.DARK,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 5,
                ),
              );
      }),
    );
  }
}
