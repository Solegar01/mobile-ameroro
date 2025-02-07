import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:mobile_ameroro_app/apps/config/app_config.dart';
import 'package:mobile_ameroro_app/apps/instrument/controllers/instrument_controller.dart';

class InstrumentView extends StatelessWidget {
  final InstrumentController controller = Get.find<InstrumentController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InstrumentController>(builder: (controller) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            foregroundColor: GFColors.WHITE,
            title: Text(
              'Instruments',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          body: Align(
            alignment: Alignment.topCenter,
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 20, // space between items
              runSpacing: 20, // space between rows
              children: controller.sensors.asMap().entries.map((entry) {
                int index = entry.key;
                var sensor = entry.value; // ambil nilai sensor sesuai kebutuhan

                return InkWell(
                  onTap: () {
                    Get.toNamed(sensor['route'].toString());
                  },
                  splashColor:
                      Colors.blue.withOpacity(0.5), // Warna efek saat ditekan
                  borderRadius:
                      BorderRadius.circular(8), // Membuat sudut yang melengkung
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Wrap the Image widget with a Hero
                          Hero(
                            tag: '$index', // Unique tag for each sensor
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0XFF032a43),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Image.asset(
                                "assets/images/icons/${sensor['image']}",
                                width: 50,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${sensor['sensor']}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(), // pastikan untuk mengkonversi hasil menjadi list
            ),
          ),
        ),
      );
    });
  }
}
