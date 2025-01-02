import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:getwidget/colors/gf_color.dart';

enum StatusLevel {
  normal,
  siaga1,
  siaga2,
  siaga3,
  siagakekeringan;

  String get name {
    switch (this) {
      case StatusLevel.normal:
        return 'Normal';
      case StatusLevel.siaga1:
        return 'Siaga 1';
      case StatusLevel.siaga2:
        return 'Siaga 2';
      case StatusLevel.siaga3:
        return 'Siaga 3';
      case StatusLevel.siagakekeringan:
        return 'Siaga Kekeringan';
      default:
        return '';
    }
  }

  int? get value {
    switch (this) {
      case StatusLevel.normal:
        return 0;
      case StatusLevel.siaga1:
        return 1;
      case StatusLevel.siaga2:
        return 2;
      case StatusLevel.siaga3:
        return 3;
      case StatusLevel.siagakekeringan:
        return 4;
      default:
        return null;
    }
  }

  Color get color {
    switch (this) {
      case StatusLevel.normal:
        return GFColors.SUCCESS;
      case StatusLevel.siaga1:
        return GFColors.DANGER;
      case StatusLevel.siaga2:
        return Colors.orange;
      case StatusLevel.siaga3:
        return GFColors.WARNING;
      case StatusLevel.siagakekeringan:
        return Colors.brown;
      default:
        return GFColors.LIGHT;
    }
  }
}

enum WarningStatus {
  normal,
  awas,
  waspada,
  siaga;

  String get name {
    switch (this) {
      case WarningStatus.normal:
        return 'Normal';
      case WarningStatus.awas:
        return 'Awas';
      case WarningStatus.waspada:
        return 'Waspada';
      case WarningStatus.siaga:
        return 'Siaga';
      default:
        return '';
    }
  }

  Color get color {
    switch (this) {
      case WarningStatus.normal:
        return GFColors.SUCCESS;
      case WarningStatus.awas:
        return GFColors.DANGER;
      case WarningStatus.waspada:
        return Colors.orange;
      case WarningStatus.siaga:
        return GFColors.WARNING;
      default:
        return GFColors.LIGHT;
    }
  }

  IconData get icon {
    switch (this) {
      case WarningStatus.normal:
        return Icons.check_circle_outline_rounded;
      case WarningStatus.awas:
        return Icons.warning_amber_rounded;
      case WarningStatus.waspada:
        return Icons.warning_amber_rounded;
      case WarningStatus.siaga:
        return Icons.warning_amber_rounded;
      default:
        return Icons.circle_outlined;
    }
  }
}
