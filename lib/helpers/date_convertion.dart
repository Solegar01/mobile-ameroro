import 'package:intl/intl.dart';

class DateFormatter {
  // Method untuk format DateTime ke string dengan format lokal Indonesia
  static String formatDateToLocalLable(DateTime dateTime) {
    final DateFormat formatter = DateFormat('d MMM yyyy', 'id_ID');
    return formatter.format(dateTime);
  }

  static String formatDateToLocalValue(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd', 'id_ID');
    return formatter.format(dateTime);
  }

  static String formatDateTimeToLocal(DateTime dateTime) {
    final DateFormat formatter = DateFormat('d MMM yyyy HH:mm', 'id_ID');
    return formatter.format(dateTime);
  }

  static String formatFullDateTimeToLocal(DateTime dateTime) {
    final DateFormat formatter = DateFormat('d MMMM yyyy HH:mm', 'id_ID');
    return formatter.format(dateTime);
  }
}
