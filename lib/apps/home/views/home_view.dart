import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ameroro_app/apps/config/app_config.dart';
import 'package:mobile_ameroro_app/apps/home/controllers/home_controller.dart';
import 'package:mobile_ameroro_app/apps/home/models/graphic_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/helpers/app_enum.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConfig.bgLogin,
        foregroundColor: GFColors.WHITE,
        title: GetBuilder<HomeController>(
          builder: (controller) => Row(
            children: [
              Image.asset(
                'assets/images/logo-pu.png',
                width: 20,
                height: 20,
              ),
              SizedBox(width: 5),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'BENDUNGAN ', style: TextStyle(fontSize: 12)),
                    TextSpan(
                        text: 'AMERORO',
                        style: TextStyle(
                            color: AppConfig.focusTextField, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(FluentIcons.settings_16_filled))
        ],
      ),
      body: controller.obx(
        (state) => _detail(context, controller),
        onLoading: _loader(context, controller),
        onEmpty: Center(
          child: Padding(
            padding: EdgeInsets.all(5),
            child: const Text('Empty Data'),
          ),
        ),
        onError: (error) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(error!)),
        ),
      ),
    );
  }

  _loader(BuildContext context, HomeController controller) {
    return ListView(
      children: [
        SizedBox(
          width: double.infinity,
          height: 320,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    color: AppConfig.bgLogin, // Top color
                    height: 150, // Half of the total height
                  ),
                  Container(
                    color: GFColors.WHITE, // Bottom color
                    height: 150, // Half of the total height
                  ),
                ],
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Text(
                  'EARLY WARNING SYSTEM',
                  style: TextStyle(
                    color: GFColors.WHITE,
                    fontSize: 12,
                  ),
                ),
              ),
              Positioned(
                top: 30,
                left: 0,
                right: 0,
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: GFColors.LIGHT,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 5,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: GFShimmer(
                      mainColor: GFColors.LIGHT,
                      secondaryColor: Colors.grey,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 100,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: GFColors.LIGHT,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 20,
                                                width: 100,
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: GFColors.LIGHT,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Divider(
                              height: 1,
                              color: Colors.white,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Container(
                                    height: 20,
                                    width: 60,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: GFColors.LIGHT,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Container(
                                    height: 20,
                                    width: 60,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: GFColors.LIGHT,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              height: 1,
                              color: Colors.white,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Container(
                                    height: 20,
                                    width: 60,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: GFColors.LIGHT,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Container(
                                    height: 20,
                                    width: 60,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: GFColors.LIGHT,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              height: 1,
                              color: Colors.white,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Container(
                                    height: 20,
                                    width: 60,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: GFColors.LIGHT,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Container(
                                    height: 20,
                                    width: 60,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: GFColors.LIGHT,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              height: 1,
                              color: Colors.white,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Container(
                                    height: 20,
                                    width: 60,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: GFColors.LIGHT,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Container(
                                    height: 20,
                                    width: 60,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: GFColors.LIGHT,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        GFShimmer(
          mainColor: GFColors.LIGHT,
          secondaryColor: Colors.grey,
          child: Column(
            children: [
              ExpansionTile(
                  title: Container(
                height: 20,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                // color: Colors.grey[200],
              )),
              ExpansionTile(
                  title: Container(
                height: 20,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                // color: Colors.grey[200],
              )),
              ExpansionTile(
                  title: Container(
                height: 20,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                // color: Colors.grey[200],
              )),
              ExpansionTile(
                  title: Container(
                height: 20,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                // color: Colors.grey[200],
              )),
              ExpansionTile(
                  title: Container(
                height: 20,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                // color: Colors.grey[200],
              )),
            ],
          ),
        ),
      ],
    );
  }

  _detail(BuildContext context, HomeController controller) {
    return RefreshIndicator(
      backgroundColor: GFColors.LIGHT,
      onRefresh: () async => await controller.formInit(),
      child: ListView(
        children: [
          _ewsCard(context, controller),
          _graphList(context,
              controller), // Directly place your graph list here without using Expanded
        ],
      ),
    );
  }

  _errorEws(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 320,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                color: AppConfig.bgLogin, // Top color
                height: 150, // Half of the total height
              ),
              Container(
                color: Colors.grey[50], // Bottom color
                height: 150, // Half of the total height
              ),
            ],
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Text(
              'EARLY WARNING SYSTEM',
              style: TextStyle(
                color: GFColors.WHITE,
                fontSize: 12,
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppConfig.bgLogin.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                height: 40,
                                width: 100,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: GFColors.INFO.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: Text(
                                    ' - ',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: GFColors.WHITE),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Status Speaker: - ',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: GFColors.WHITE),
                                        ),
                                        const IconButton(
                                          icon: Icon(
                                              FluentIcons.speaker_off_16_filled,
                                              color: GFColors.WHITE),
                                          onPressed: null,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        height: 1,
                        color: Colors.white,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Center(
                              child: Text(
                                'BSH 01',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: GFColors.WHITE),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Center(
                              child: Text(
                                ' - m ( - )',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: GFColors.WHITE),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        height: 1,
                        color: Colors.white,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Center(
                              child: Text(
                                'BSH 02',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: GFColors.WHITE),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Center(
                              child: Text(
                                ' - m ( - )',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: GFColors.WHITE),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        height: 1,
                        color: Colors.white,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Center(
                              child: Text(
                                'BSH 03',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: GFColors.WHITE),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Center(
                              child: Text(
                                ' - m ( - )',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: GFColors.WHITE),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        height: 1,
                        color: Colors.white,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Center(
                              child: Text(
                                'BSH-INTAKE',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: GFColors.WHITE),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Center(
                              child: Text(
                                ' - m ( - )',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: GFColors.WHITE),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _ewsCard(BuildContext context, HomeController controller) {
    return FutureBuilder(
        future: controller.getConnection(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              width: double.infinity,
              height: 320,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        color: AppConfig.bgLogin, // Top color
                        height: 150, // Half of the total height
                      ),
                      Container(
                        color: Colors.grey[50], // Bottom color
                        height: 150, // Half of the total height
                      ),
                    ],
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Text(
                      'EARLY WARNING SYSTEM',
                      style: TextStyle(
                        color: GFColors.WHITE,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: 0,
                    right: 0,
                    child: SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: GFColors.LIGHT,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: GFShimmer(
                          mainColor: GFColors.LIGHT,
                          secondaryColor: Colors.grey,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 100,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: GFColors.LIGHT,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    height: 20,
                                                    width: 100,
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      color: GFColors.LIGHT,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(
                                  height: 1,
                                  color: Colors.white,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Container(
                                        height: 20,
                                        width: 60,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: GFColors.LIGHT,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Container(
                                        height: 20,
                                        width: 60,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: GFColors.LIGHT,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  height: 1,
                                  color: Colors.white,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Container(
                                        height: 20,
                                        width: 60,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: GFColors.LIGHT,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Container(
                                        height: 20,
                                        width: 60,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: GFColors.LIGHT,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  height: 1,
                                  color: Colors.white,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Container(
                                        height: 20,
                                        width: 60,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: GFColors.LIGHT,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Container(
                                        height: 20,
                                        width: 60,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: GFColors.LIGHT,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  height: 1,
                                  color: Colors.white,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Container(
                                        height: 20,
                                        width: 60,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: GFColors.LIGHT,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Container(
                                        height: 20,
                                        width: 60,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: GFColors.LIGHT,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return _errorEws(context);
          } else if (snapshot.hasData) {
            if (snapshot.data == true) {
              return SizedBox(
                width: double.infinity,
                height: 320,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          color: AppConfig.bgLogin, // Top color
                          height: 150, // Half of the total height
                        ),
                        Container(
                          color: Colors.grey[50], // Bottom color
                          height: 150, // Half of the total height
                        ),
                      ],
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Text(
                        'EARLY WARNING SYSTEM',
                        style: TextStyle(
                          color: GFColors.WHITE,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 30,
                      left: 0,
                      right: 0,
                      child: SingleChildScrollView(
                        child: Obx(
                          () => Container(
                            width: double.infinity,
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: switch (controller.alarmVal.value) {
                                0 => StatusLevel.normal.color.withOpacity(0.5),
                                1 => StatusLevel.siaga1.color.withOpacity(0.5),
                                2 => StatusLevel.siaga2.color.withOpacity(0.5),
                                3 => StatusLevel.siaga3.color.withOpacity(0.5),
                                int() => AppConfig.bgLogin.withOpacity(0.5),
                                null => AppConfig.bgLogin.withOpacity(0.5),
                              },
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            height: 40,
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: switch (
                                                    controller.alarmVal.value) {
                                                  0 => StatusLevel.normal.color,
                                                  1 => StatusLevel.siaga1.color,
                                                  2 => StatusLevel.siaga2.color,
                                                  3 => StatusLevel.siaga3.color,
                                                  int() => GFColors.LIGHT
                                                      .withOpacity(0.5),
                                                  null => GFColors.LIGHT
                                                      .withOpacity(0.5),
                                                },
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Center(
                                              child: Text(
                                                switch (
                                                    controller.alarmVal.value) {
                                                  0 => StatusLevel.normal.name
                                                      .toUpperCase(),
                                                  1 => StatusLevel.siaga1.name
                                                      .toUpperCase(),
                                                  2 => StatusLevel.siaga2.name
                                                      .toUpperCase(),
                                                  3 => StatusLevel.siaga3.name
                                                      .toUpperCase(),
                                                  int() => ' - ',
                                                  null => ' - ',
                                                },
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: GFColors.WHITE),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Status Speaker : ${(controller.muteVal.value == 0) ? 'UNMUTE' : 'MUTE'}',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              GFColors.WHITE),
                                                    ),
                                                    IconButton(
                                                      icon: (controller.muteVal
                                                                  .value ==
                                                              0)
                                                          ? const Icon(
                                                              FluentIcons
                                                                  .speaker_2_16_filled,
                                                              color: GFColors
                                                                  .WHITE,
                                                            )
                                                          : const Icon(
                                                              FluentIcons
                                                                  .speaker_off_16_filled,
                                                              color: GFColors
                                                                  .DARK),
                                                      onPressed: () async {
                                                        String val = (controller
                                                                        .muteVal
                                                                        .value ??
                                                                    0) ==
                                                                0
                                                            ? '1'
                                                            : '0';
                                                        await controller
                                                            .setSpeakerStatus(
                                                                val);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    height: 1,
                                    color: Colors.white,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Center(
                                          child: Text(
                                            'BSH 01',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: GFColors.WHITE),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Center(
                                          child: Text(
                                            '${controller.bsh1Data['water_level'] ?? ' - '} m (${switch (controller.bsh1Status.value) {
                                              0 => StatusLevel.normal.name,
                                              1 => StatusLevel.siaga1.name,
                                              2 => StatusLevel.siaga2.name,
                                              3 => StatusLevel.siaga3.name,
                                              int() => ' - ',
                                              null => ' - ',
                                            }})',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: GFColors.WHITE),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    height: 1,
                                    color: Colors.white,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Center(
                                          child: Text(
                                            'BSH 02',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: GFColors.WHITE),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Center(
                                          child: Text(
                                            '${controller.bsh2Data['water_level'] ?? ' - '} m (${switch (controller.bsh2Status.value) {
                                              0 => StatusLevel.normal.name,
                                              1 => StatusLevel.siaga1.name,
                                              2 => StatusLevel.siaga2.name,
                                              3 => StatusLevel.siaga3.name,
                                              int() => ' - ',
                                              null => ' - ',
                                            }})',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: GFColors.WHITE),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    height: 1,
                                    color: Colors.white,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Center(
                                          child: Text(
                                            'BSH 03',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: GFColors.WHITE),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Center(
                                          child: Text(
                                            '${controller.bsh3Data['water_level'] ?? ' - '} m (${switch (controller.bsh3Status.value) {
                                              0 => StatusLevel.normal.name,
                                              1 => StatusLevel.siaga1.name,
                                              2 => StatusLevel.siaga2.name,
                                              3 => StatusLevel.siaga3.name,
                                              int() => ' - ',
                                              null => ' - ',
                                            }})',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: GFColors.WHITE),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    height: 1,
                                    color: Colors.white,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Center(
                                          child: Text(
                                            'BSH-INTAKE',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: GFColors.WHITE),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Center(
                                          child: Text(
                                            '${controller.intakeData['water_level'] ?? ' - '} m (${switch (controller.intakeStatus.value) {
                                              0 => StatusLevel.normal.name,
                                              1 => StatusLevel.siaga1.name,
                                              2 => StatusLevel.siaga2.name,
                                              3 => StatusLevel.siaga3.name,
                                              int() => ' - ',
                                              null => ' - ',
                                            }})',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: GFColors.WHITE),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return _errorEws(context);
            }
          } else {
            return _errorEws(context);
          }
        });
  }

  _weatherSlider(BuildContext context, HomeController controller) {
    return FutureBuilder(
      future: controller.getCuacaList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          List<String> loadStr = ['loading...', 'loading...', 'loading...'];
          return GFCarousel(
            items: loadStr.map((load) {
              return GFShimmer(
                mainColor: GFColors.LIGHT,
                secondaryColor: Colors.grey,
                child: Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            autoPlay: false,
            enlargeMainPage: false,
            hasPagination: false,
            passiveIndicator: Colors.grey,
            activeIndicator: Colors.blue,
            autoPlayInterval: const Duration(seconds: 5), // Adjust as needed
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            height: 180,
          );
        } else if (snapshot.hasError) {
          List<String> errorStr = [
            'Error loading weather data',
            'Error loading weather data',
            'Error loading weather data'
          ];
          return GFCarousel(
            items: errorStr.map((error) {
              return GFCard(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.zero,
                boxFit: BoxFit.cover,
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                elevation: 5,
                content: Center(
                  child: Text(
                    error,
                  ),
                ),
              );
            }).toList(),
            autoPlay: false,
            enlargeMainPage: false,
            hasPagination: false,
            passiveIndicator: Colors.grey,
            activeIndicator: Colors.blue,
            autoPlayInterval: const Duration(seconds: 5), // Adjust as needed
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            height: 180,
          );
        } else if (snapshot.hasData) {
          return GFCarousel(
            items: snapshot.data!.map((cuaca) {
              return GFCard(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.zero,
                boxFit: BoxFit.cover,
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                elevation: 5,
                content: Column(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(right: 10, left: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  _getSvgPic(cuaca.image),
                                  Text(
                                    cuaca.weatherDesc,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Text(
                                    AppConstants()
                                        .dateFullDayFormatID
                                        .format(cuaca.localDatetime),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                  Text(
                                    '${AppConstants().hourMinuteFormat.format(cuaca.localDatetime)} WIB',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildWeatherInfoRow(cuaca),
                        Divider(
                          height: 1,
                          color: Colors.grey[400],
                        ),
                        _buildAdditionalInfoRow(cuaca),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
            autoPlay: true,
            enlargeMainPage: false,
            hasPagination: false,
            passiveIndicator: Colors.grey,
            activeIndicator: Colors.blue,
            autoPlayInterval: const Duration(seconds: 5), // Adjust as needed
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            height: 180,
          );
        } else {
          List<String> errorStr = [
            'Error loading weather data',
            'Error loading weather data',
            'Error loading weather data'
          ];
          return GFCarousel(
            items: errorStr.map((error) {
              return GFCard(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.zero,
                boxFit: BoxFit.cover,
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                elevation: 5,
                content: Center(
                  child: Text(
                    error,
                  ),
                ),
              );
            }).toList(),
            autoPlay: false,
            enlargeMainPage: false,
            hasPagination: false,
            passiveIndicator: Colors.grey,
            activeIndicator: Colors.blue,
            autoPlayInterval: const Duration(seconds: 5), // Adjust as needed
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            height: 180,
          );
        }
      },
    );
  }

  _buildWeatherInfoRow(cuaca) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildWeatherInfoItem(
                Icons.thermostat, '${cuaca.t} \u00B0C', 'Suhu'),
            _buildWeatherInfoItem(
                Icons.water_drop_outlined, '${cuaca.hu} %', 'Kelembaban'),
            _buildWeatherInfoItem(
                FluentIcons.compass_northwest_28_regular,
                '${cuaca.wdDeg} \u00B0C (${cuaca.wd} → ${cuaca.wdTo})',
                'Arah mata angin'),
          ],
        ),
      ),
    );
  }

  _buildAdditionalInfoRow(cuaca) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildWeatherInfoItem(FluentIcons.weather_squalls_48_filled,
                '${cuaca.ws} m/s', 'Kec. angin'),
            _buildWeatherInfoItem(
                Icons.cloud, '${cuaca.tcc} %', 'Tutupan awan'),
            _buildWeatherInfoItem(
                Icons.remove_red_eye_outlined, cuaca.vsText, 'Jarak pandang'),
          ],
        ),
      ),
    );
  }

  _buildWeatherInfoItem(IconData icon, String data, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20),
        SizedBox(width: 5),
        Column(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: data,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  _getSvgPic(String svgUrl) {
    return FutureBuilder<String>(
      future: controller.getSvgPic(svgUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              height: 20,
              width: 20,
              child: const CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return SizedBox(
            width: 30,
            height: 30,
            child: Icon(
              Icons.image_not_supported_rounded,
              size: 30,
              color: Colors.grey,
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return SvgPicture.string(
            snapshot.data!,
            width: 30,
            height: 30,
            fit: BoxFit.contain,
          );
        } else {
          // Optional fallback if no data is returned but no error
          return SizedBox(
            width: 30,
            height: 30,
            child: Icon(
              Icons.image_not_supported_rounded,
              size: 30,
              color: Colors.grey,
            ),
          );
        }
      },
    );
  }

  _graphList(BuildContext context, HomeController controller) {
    return FutureBuilder<GraphicModel?>(
      future: controller.getGraphic(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GFShimmer(
            mainColor: GFColors.LIGHT,
            secondaryColor: Colors.grey,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: GFColors.WHITE,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ExpansionTile(
                      shape: const Border(
                        bottom: BorderSide(width: 0),
                      ),
                      title: Container(
                        height: 20,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        // color: Colors.grey[200],
                      )),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: GFColors.WHITE,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ExpansionTile(
                      shape: const Border(
                        bottom: BorderSide(width: 0),
                      ),
                      title: Container(
                        height: 20,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        // color: Colors.grey[200],
                      )),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: GFColors.WHITE,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ExpansionTile(
                      shape: const Border(
                        bottom: BorderSide(width: 0),
                      ),
                      title: Container(
                        height: 20,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        // color: Colors.grey[200],
                      )),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: GFColors.WHITE,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ExpansionTile(
                      shape: const Border(
                        bottom: BorderSide(width: 0),
                      ),
                      title: Container(
                        height: 20,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        // color: Colors.grey[200],
                      )),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: GFColors.WHITE,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ExpansionTile(
                      shape: const Border(
                        bottom: BorderSide(width: 0),
                      ),
                      title: Container(
                        height: 20,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        // color: Colors.grey[200],
                      )),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Column(
            children: [
              Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: GFColors.WHITE,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ExpansionTile(
                  shape: const Border(
                    bottom: BorderSide(width: 0),
                  ),
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Prakiraan Cuaca ',
                            style:
                                TextStyle(fontSize: 12, color: GFColors.DARK)),
                      ],
                    ),
                  ),
                  children: const [
                    Center(
                      child: Text('Error while loading data'),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: GFColors.WHITE,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ExpansionTile(
                  shape: const Border(
                    bottom: BorderSide(width: 0),
                  ),
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Grafik TMA Intake ',
                            style:
                                TextStyle(fontSize: 12, color: GFColors.DARK)),
                        TextSpan(
                            text: '(12 jam terakhir)',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            )),
                      ],
                    ),
                  ),
                  children: const [
                    Center(
                      child: Text('Error while loading data'),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: GFColors.WHITE,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ExpansionTile(
                  shape: const Border(
                    bottom: BorderSide(width: 0),
                  ),
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Grafik Debit V-Notch ',
                            style:
                                TextStyle(fontSize: 12, color: GFColors.DARK)),
                        TextSpan(
                            text: '(12 jam terakhir)',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            )),
                      ],
                    ),
                  ),
                  children: const [
                    Center(
                      child: Text('Error while loading data'),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: GFColors.WHITE,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ExpansionTile(
                  shape: const Border(
                    bottom: BorderSide(width: 0),
                  ),
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Grafik TMA AWLR ',
                            style:
                                TextStyle(fontSize: 12, color: GFColors.DARK)),
                        TextSpan(
                            text: '(12 jam terakhir)',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            )),
                      ],
                    ),
                  ),
                  children: const [
                    Center(
                      child: Text('Error while loading data'),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: GFColors.WHITE,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ExpansionTile(
                  shape: const Border(
                    bottom: BorderSide(width: 0),
                  ),
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Grafik Curah Hujan ',
                            style:
                                TextStyle(fontSize: 12, color: GFColors.DARK)),
                        TextSpan(
                            text: '(12 jam terakhir)',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            )),
                      ],
                    ),
                  ),
                  children: const [
                    Center(
                      child: Text('Error while loading data'),
                    )
                  ],
                ),
              ),
            ],
          );
        } else if (snapshot.hasData) {
          var listIntake = snapshot.data?.listIntake ?? [];
          var listVnotch = snapshot.data?.listVnotch ?? [];
          var listAwlr = snapshot.data?.listAwlr ?? [];
          var listRainFall = snapshot.data?.listRainFall ?? [];
          if (listIntake.isNotEmpty) {
            listIntake.sort((a, b) => b.readingAt.compareTo(a.readingAt));
          }
          if (listVnotch.isNotEmpty) {
            listVnotch.sort((a, b) => b.readingAt.compareTo(a.readingAt));
          }
          if (listAwlr.isNotEmpty) {
            listAwlr.sort((a, b) => b.readingAt.compareTo(a.readingAt));
          }
          if (listRainFall.isNotEmpty) {
            listRainFall.sort((a, b) => b.readingAt!.compareTo(a.readingAt!));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: GFColors.WHITE,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ExpansionTile(
                    shape: const Border(
                      bottom: BorderSide(width: 0),
                    ),
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: 'Prakiraan Cuaca ',
                              style: TextStyle(
                                  fontSize: 12, color: GFColors.DARK)),
                        ],
                      ),
                    ),
                    children: [_weatherSlider(context, controller)],
                  ),
                ),
                _intakeGraph(context, listIntake),
                _vnotchGraph(context, listVnotch),
                _awlrList(context, listAwlr),
                _rainFallGraph(context, listRainFall),
              ],
            ),
          );
        } else {
          return Column(
            children: [
              Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: GFColors.WHITE,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ExpansionTile(
                  shape: const Border(
                    bottom: BorderSide(width: 0),
                  ),
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Prakiraan Cuaca ',
                            style:
                                TextStyle(fontSize: 12, color: GFColors.DARK)),
                      ],
                    ),
                  ),
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: const Text('Empty Data'),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: GFColors.WHITE,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ExpansionTile(
                  shape: const Border(
                    bottom: BorderSide(width: 0),
                  ),
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Grafik TMA Intake ',
                            style:
                                TextStyle(fontSize: 12, color: GFColors.DARK)),
                        TextSpan(
                            text: '(12 jam terakhir)',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            )),
                      ],
                    ),
                  ),
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: const Text('Empty Data'),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: GFColors.WHITE,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ExpansionTile(
                  shape: const Border(
                    bottom: BorderSide(width: 0),
                  ),
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Grafik Debit V-Notch ',
                            style:
                                TextStyle(fontSize: 12, color: GFColors.DARK)),
                        TextSpan(
                            text: '(12 jam terakhir)',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            )),
                      ],
                    ),
                  ),
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: const Text('Empty Data'),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: GFColors.WHITE,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ExpansionTile(
                  shape: const Border(
                    bottom: BorderSide(width: 0),
                  ),
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Grafik TMA AWLR ',
                            style:
                                TextStyle(fontSize: 12, color: GFColors.DARK)),
                        TextSpan(
                            text: '(12 jam terakhir)',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            )),
                      ],
                    ),
                  ),
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: const Text('Empty Data'),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: GFColors.WHITE,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ExpansionTile(
                  shape: const Border(
                    bottom: BorderSide(width: 0),
                  ),
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Grafik Curah Hujan ',
                            style:
                                TextStyle(fontSize: 12, color: GFColors.DARK)),
                        TextSpan(
                            text: '(12 jam terakhir)',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            )),
                      ],
                    ),
                  ),
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: const Text('Empty Data'),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }

  _intakeGraph(BuildContext context, List<Intake> listIntake) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: GFColors.WHITE,
        borderRadius: BorderRadius.circular(5),
      ),
      child: ExpansionTile(
        shape: const Border(
          bottom: BorderSide(width: 0),
        ),
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'Grafik TMA Intake ',
                  style: TextStyle(fontSize: 12, color: GFColors.DARK)),
              TextSpan(
                  text: '(12 jam terakhir)',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  )),
            ],
          ),
        ),
        children: [
          (listIntake.isEmpty)
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: const Text('Empty Data'),
                  ),
                )
              : SfCartesianChart(
                  primaryXAxis: DateTimeAxis(
                    dateFormat: DateFormat.MMMd('id_ID'),
                    autoScrollingDeltaType: DateTimeIntervalType.auto,
                    labelFormat: '{value}',
                    title: const AxisTitle(
                        text: "Waktu", alignment: ChartAlignment.center),
                  ),
                  primaryYAxis: const NumericAxis(
                    labelFormat: '{value}',
                    title: AxisTitle(text: 'TMA (mdpl)'),
                  ),
                  title: ChartTitle(
                    textStyle: TextStyle(
                        height: 2, fontSize: 14, fontWeight: FontWeight.bold),
                    alignment: ChartAlignment.center,
                    text: 'Grafik Tinggi Muka Air BSH-INTAKE',
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  trackballBehavior: TrackballBehavior(
                    markerSettings: const TrackballMarkerSettings(
                      markerVisibility:
                          TrackballVisibilityMode.visible, // Show markers
                      color: Colors.white, // Color of the trackball marker
                    ),
                    tooltipSettings: const InteractiveTooltip(
                      enable: true,
                      color: Color(0xFF2CAFFE), // Tooltip background color
                      textStyle:
                          TextStyle(color: Colors.white), // Tooltip text color
                    ),
                    activationMode: ActivationMode.singleTap,
                    enable: true,
                    builder: (BuildContext context,
                        TrackballDetails trackballDetails) {
                      final DateTime date = trackballDetails.point?.x;
                      final String formattedDate =
                          AppConstants().dateTimeFormatID.format(date);
                      return SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.75),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  formattedDate,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                  color: Colors.blue,
                                ))),
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "TMA : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mdpl)",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  zoomPanBehavior: ZoomPanBehavior(
                    enablePinching: true, // Enable pinch zoom
                    enablePanning: true, // Enable panning
                    zoomMode: ZoomMode
                        .x, // Allow zooming only on the x-axis (can be both x, y or both)
                    enableDoubleTapZooming: true, // Enable double-tap zoom
                  ),
                  series: <CartesianSeries<Intake, DateTime>>[
                      AreaSeries<Intake, DateTime>(
                        borderColor: const Color(0xFF2CAFFE),
                        borderDrawMode: BorderDrawMode.top,
                        markerSettings: const MarkerSettings(
                            color: Colors.white,
                            // isVisible: true,
                            // Marker shape is set to diamond
                            shape: DataMarkerType.circle),
                        dataSource: listIntake,
                        xValueMapper: (Intake data, _) => data.readingAt,
                        yValueMapper: (Intake data, _) => data.waterLevel,
                        name: 'TMA',
                        borderWidth: 2,
                        color: const Color(0xFF2CAFFE),
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF2CAFFE).withOpacity(0.5),
                            Colors.white,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ]),
        ],
      ),
    );
  }

  _vnotchGraph(BuildContext context, List<Vnotch> listVnotch) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: GFColors.WHITE,
        borderRadius: BorderRadius.circular(5),
      ),
      child: ExpansionTile(
        shape: const Border(
          bottom: BorderSide(width: 0),
        ),
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'Grafik Debit V-Notch ',
                  style: TextStyle(fontSize: 12, color: GFColors.DARK)),
              TextSpan(
                  text: '(12 jam terakhir)',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  )),
            ],
          ),
        ),
        children: [
          (listVnotch.isEmpty)
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: const Text('Empty Data'),
                  ),
                )
              : SfCartesianChart(
                  primaryXAxis: DateTimeAxis(
                    dateFormat: DateFormat.MMMd('id_ID'),
                    autoScrollingDeltaType: DateTimeIntervalType.auto,
                    labelFormat: '{value}',
                    title: const AxisTitle(
                        text: "Waktu", alignment: ChartAlignment.center),
                  ),
                  primaryYAxis: const NumericAxis(
                    labelFormat: '{value}',
                    title: AxisTitle(text: 'Debit (lt/d)'),
                  ),
                  title: ChartTitle(
                    textStyle: TextStyle(
                        height: 2, fontSize: 14, fontWeight: FontWeight.bold),
                    alignment: ChartAlignment.center,
                    text: 'Grafik Debit',
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  trackballBehavior: TrackballBehavior(
                    markerSettings: const TrackballMarkerSettings(
                      markerVisibility:
                          TrackballVisibilityMode.visible, // Show markers
                      color: Colors.white, // Color of the trackball marker
                    ),
                    tooltipSettings: const InteractiveTooltip(
                      enable: true,
                      color: Color(0xFF2CAFFE), // Tooltip background color
                      textStyle:
                          TextStyle(color: Colors.white), // Tooltip text color
                    ),
                    activationMode: ActivationMode.singleTap,
                    enable: true,
                    builder: (BuildContext context,
                        TrackballDetails trackballDetails) {
                      final DateTime date = trackballDetails.point?.x;
                      final String formattedDate =
                          AppConstants().dateTimeFormatID.format(date);
                      return SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.75),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  formattedDate,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                  color: Colors.blue,
                                ))),
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Debit : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (lt/d)",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  zoomPanBehavior: ZoomPanBehavior(
                    enablePinching: true, // Enable pinch zoom
                    enablePanning: true, // Enable panning
                    zoomMode: ZoomMode
                        .x, // Allow zooming only on the x-axis (can be both x, y or both)
                    enableDoubleTapZooming: true, // Enable double-tap zoom
                  ),
                  series: <CartesianSeries<Vnotch, DateTime>>[
                      AreaSeries<Vnotch, DateTime>(
                        borderDrawMode: BorderDrawMode.top,
                        markerSettings: const MarkerSettings(
                            color: Colors.white,
                            // isVisible: true,
                            // Marker shape is set to diamond
                            shape: DataMarkerType.circle),
                        dataSource: listVnotch,
                        xValueMapper: (Vnotch data, _) => data.readingAt,
                        yValueMapper: (Vnotch data, _) => data.debit,
                        name: 'Debit',
                        borderColor: const Color(0xFF2CAFFE),
                        borderWidth: 2,
                        color: const Color(0xFF2CAFFE),
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF2CAFFE).withOpacity(0.5),
                            Colors.white,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ]),
        ],
      ),
    );
  }

  _rainFallGraph(BuildContext context, List<RainFall> listRainFall) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: GFColors.WHITE,
        borderRadius: BorderRadius.circular(5),
      ),
      child: ExpansionTile(
        shape: const Border(
          bottom: BorderSide(width: 0),
        ),
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'Grafik Curah Hujan ',
                  style: TextStyle(fontSize: 12, color: GFColors.DARK)),
              TextSpan(
                  text: '(12 jam terakhir)',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  )),
            ],
          ),
        ),
        children: [
          (listRainFall.isEmpty)
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: const Text('Empty Data'),
                  ),
                )
              : SfCartesianChart(
                  primaryXAxis: DateTimeAxis(
                    dateFormat: DateFormat.MMMd('id_ID'),
                    autoScrollingDeltaType: DateTimeIntervalType.auto,
                    labelFormat: '{value}',
                    title: const AxisTitle(
                        text: "Waktu", alignment: ChartAlignment.center),
                  ),
                  primaryYAxis: const NumericAxis(
                    labelFormat: '{value}',
                    title: AxisTitle(text: 'Curah Hujan (mm)'),
                  ),
                  title: ChartTitle(
                    textStyle: TextStyle(
                        height: 2, fontSize: 14, fontWeight: FontWeight.bold),
                    alignment: ChartAlignment.center,
                    text: 'Grafik Curah Hujan',
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  trackballBehavior: TrackballBehavior(
                    markerSettings: const TrackballMarkerSettings(
                      markerVisibility:
                          TrackballVisibilityMode.visible, // Show markers
                      color: Colors.white, // Color of the trackball marker
                    ),
                    tooltipSettings: const InteractiveTooltip(
                      enable: true,
                      color: Colors.green, // Tooltip background color
                      textStyle:
                          TextStyle(color: Colors.white), // Tooltip text color
                    ),
                    activationMode: ActivationMode.singleTap,
                    enable: true,
                    builder: (BuildContext context,
                        TrackballDetails trackballDetails) {
                      final DateTime date = trackballDetails.point?.x;
                      final String formattedDate =
                          AppConstants().dateTimeFormatID.format(date);
                      return SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.75),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  formattedDate,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                  color: Colors.blue,
                                ))),
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Curah Hujan : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mm)",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  zoomPanBehavior: ZoomPanBehavior(
                    enablePinching: true, // Enable pinch zoom
                    enablePanning: true, // Enable panning
                    zoomMode: ZoomMode
                        .x, // Allow zooming only on the x-axis (can be both x, y or both)
                    enableDoubleTapZooming: true, // Enable double-tap zoom
                  ),
                  series: <CartesianSeries<RainFall, DateTime>>[
                      ColumnSeries<RainFall, DateTime>(
                        color: Colors.blue[500],
                        markerSettings: MarkerSettings(
                            color: Colors.blue[900]!,
                            // isVisible: true,
                            // Marker shape is set to diamond
                            shape: DataMarkerType.circle),
                        dataSource: listRainFall,
                        xValueMapper: (RainFall data, _) => data.readingAt,
                        yValueMapper: (RainFall data, _) => data.rainFall ?? 0,
                        name: 'Curah Hujan',
                        borderRadius: BorderRadius.circular(5),
                        width: 0.9,
                      ),
                    ]),
        ],
      ),
    );
  }

  _awlrList(BuildContext context, List<Awlr> listAwlrDetail) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: GFColors.WHITE,
        borderRadius: BorderRadius.circular(5),
      ),
      child: ExpansionTile(
        shape: const Border(
          bottom: BorderSide(width: 0),
        ),
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'Grafik TMA AWLR ',
                  style: TextStyle(fontSize: 12, color: GFColors.DARK)),
              TextSpan(
                  text: '(12 jam terakhir)',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  )),
            ],
          ),
        ),
        children: (listAwlrDetail.isEmpty)
            ? Center(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: const Text('Empty Data'),
                ),
              )
            : _awlrGraph(context, listAwlrDetail),
      ),
    );
  }

  _awlrGraph(BuildContext context, List<Awlr> listAwlrDetail) {
    List<Widget> listGraph = List.empty(growable: true);
    for (var i = 0; i < controller.listAwlr.length; i++) {
      var name = controller.listAwlr[i].stationName ?? '';
      var listTemp = listAwlrDetail.where((x) => x.name == name).toList();
      var graph = listTemp.isEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: const Text('Empty Data'),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpansionTile(
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: 'Grafik TMA $name ',
                          style: TextStyle(fontSize: 12, color: GFColors.DARK)),
                    ],
                  ),
                ),
                children: [
                  SfCartesianChart(
                      primaryXAxis: DateTimeAxis(
                        dateFormat: DateFormat.MMMd('id_ID'),
                        autoScrollingDeltaType: DateTimeIntervalType.auto,
                        labelFormat: '{value}',
                        title: const AxisTitle(
                            text: "Waktu", alignment: ChartAlignment.center),
                      ),
                      primaryYAxis: const NumericAxis(
                        labelFormat: '{value}',
                        title: AxisTitle(text: 'TMA (mdpl)'),
                      ),
                      title: ChartTitle(
                        textStyle: TextStyle(
                            height: 2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        alignment: ChartAlignment.center,
                        text: 'Grafik TMA AWLR $name',
                      ),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      trackballBehavior: TrackballBehavior(
                        markerSettings: const TrackballMarkerSettings(
                          markerVisibility:
                              TrackballVisibilityMode.visible, // Show markers
                          color: Colors.white, // Color of the trackball marker
                        ),
                        tooltipSettings: const InteractiveTooltip(
                          enable: true,
                          color: Color(0xFF2CAFFE), // Tooltip background color
                          textStyle: TextStyle(
                              color: Colors.white), // Tooltip text color
                        ),
                        activationMode: ActivationMode.singleTap,
                        enable: true,
                        builder: (BuildContext context,
                            TrackballDetails trackballDetails) {
                          final DateTime date = trackballDetails.point?.x;
                          final String formattedDate =
                              AppConstants().dateTimeFormatID.format(date);
                          return SingleChildScrollView(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.75),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      formattedDate,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                      color: Colors.blue,
                                    ))),
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "TMA : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mdpl)",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePinching: true, // Enable pinch zoom
                        enablePanning: true, // Enable panning
                        zoomMode: ZoomMode
                            .x, // Allow zooming only on the x-axis (can be both x, y or both)
                        enableDoubleTapZooming: true, // Enable double-tap zoom
                      ),
                      series: <CartesianSeries<Awlr, DateTime>>[
                        AreaSeries<Awlr, DateTime>(
                          borderColor: const Color(0xFF2CAFFE),
                          borderDrawMode: BorderDrawMode.top,
                          markerSettings: const MarkerSettings(
                              color: Colors.white,
                              // isVisible: true,
                              // Marker shape is set to diamond
                              shape: DataMarkerType.circle),
                          dataSource: listTemp,
                          xValueMapper: (Awlr data, _) => data.readingAt,
                          yValueMapper: (Awlr data, _) => data.waterLevel,
                          name: 'TMA',
                          borderWidth: 2,
                          color: const Color(0xFF2CAFFE),
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF2CAFFE).withOpacity(0.5),
                              Colors.white,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ]),
                ],
              ),
            );
      listGraph.add(graph);
    }
    return listGraph;
  }
}
