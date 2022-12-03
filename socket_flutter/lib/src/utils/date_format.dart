import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateFormatter {
  static String getVerBoseDateString(DateTime dateTime, [bool isOmit = false]) {
    final locale = Intl.defaultLocale;
    initializeDateFormatting(locale);

    DateTime now = DateTime.now();
    DateTime justNow = now.subtract(const Duration(minutes: 1));
    DateTime localDateTime = dateTime.toLocal();
    if (!localDateTime.difference(justNow).isNegative) {
      return "Just Now";
    }

    String roughTimeString = DateFormat(
      'jm',
      locale,
    ).format(dateTime);
    if (localDateTime.day == now.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return roughTimeString;
    }
    DateTime yesterday = now.subtract(const Duration(days: 1));
    if (localDateTime.day == yesterday.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return "Yesterday";
    }
    if (now.difference(localDateTime).inDays < 4) {
      String weekday = DateFormat('EEEE').format(localDateTime);
      return weekday;
    }

    if (isOmit) {
      return DateFormat('yMd', locale).format(dateTime);
    } else {
      return '${DateFormat('yMd', locale).format(dateTime)}, $roughTimeString';
    }
  }
}
