import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:mobile_ameroro_app/apps/instrument/controllers/instrument_controller.dart';

class InstrumentView extends StatelessWidget {
  InstrumentView({super.key});
  final InstrumentController controller = Get.find<InstrumentController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
                top: 40.r,
                left: 0,
                right: 0,
                child: SizedBox(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.r,
                      vertical: 30.r,
                    ),
                    child: Center(
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 20.r, // space between items
                        runSpacing: 20.r, // space between rows
                        children:
                            controller.sensors.asMap().entries.map((entry) {
                          int index = entry.key;
                          var sensor = entry
                              .value; // ambil nilai sensor sesuai kebutuhan

                          return InkWell(
                            onTap: () {
                              Get.toNamed(sensor['route'].toString());
                            },
                            splashColor: Colors.blue
                                .withOpacity(0.5), // Warna efek saat ditekan
                            borderRadius: BorderRadius.circular(
                                8.r), // Membuat sudut yang melengkung
                            child: SizedBox(
                              width: 100.r,
                              height: 100.r,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Wrap the Image widget with a Hero
                                    Hero(
                                      tag:
                                          '$index', // Unique tag for each sensor
                                      child: Image.asset(
                                        "assets/images/${sensor['image']}",
                                        width: 50.r,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.r,
                                    ),
                                    Text(
                                      '${sensor['sensor']}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12.r),
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
                )),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                color: const Color.fromARGB(255, 7, 23, 94),
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 10.r,
                            top: 10.r,
                            bottom: 10.r,
                          ),
                          child: Text(
                            'Instruments',
                            style: TextStyle(
                              fontSize: 20.r,
                              color: GFColors.WHITE,
                            ),
                          ),
                        ),
                        // IconButton(
                        //   icon: Icon(
                        //     Icons.close,
                        //     size: 25.r,
                        //     color: GFColors.WHITE,
                        //   ),
                        //   onPressed: () {
                        //     Get.back(); // Menutup dialog
                        //   },
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*



*/
