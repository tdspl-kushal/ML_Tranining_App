import 'package:intl/intl.dart';

class DateTimeUtils {
  static bool stringDataCompare(String endDate, String startDate) {
    // endDate is before startDate : condition
    return getDateTimeFromString(endDate)!.compareTo(getDateTimeFromString(startDate)!) < 0;
  }

  static bool stringDataCompare_T(String endDate, String startDate) {
    return getDateTimeFromString_T(endDate)!.compareTo(getDateTimeFromString_T(startDate)!) < 0;
  }

  static bool dataCompare_T(DateTime? endDate, DateTime? startDate) {
    return endDate!.compareTo(startDate!) < 0;
  }

  static bool dataCompare(DateTime? endDate, DateTime? startDate) {
    return endDate!.compareTo(startDate!) < 0;
  }

  static DateTime? getDateTimeFromString(String? date, {String format = "yyyy-MM-dd HH:mm:ss.SSS'Z"}) {
    if (date == null || date.isEmpty) return null;

    return DateFormat(format).parseUTC(date);
  }

  static DateTime? getDateTimeString(String? date, {String format = "dd-mm-yyyy"}) {
    if (date == null || date.isEmpty) return null;

    return DateFormat(format).parseUTC(date);
  }


  static DateTime getDateTimeFromString_T(String? date, {String format = "yyyy-MM-ddTHH:mm:ss.SSS'Z'"}) {
    if (date == null || date.isEmpty) {
      // Return a default DateTime
      return DateTime(0000);
    }

    return DateFormat(format).parseUTC(date);
  }

  static String? getDateFromString(String? date, {String format = "yyyy-MM-dd"}) {
    if (date == null || date.isEmpty) return null;

    return DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z").format(DateFormat(format).parseUTC(date));
  }

  static String? getParsedDateTime(String? date, {String format = "yyyy-MM-dd"}) {
    if (date == null || date.isEmpty) return null;

    return DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z").format(DateFormat(format).parseUTC(date));
  }

  static getToIso8601String(DateTime? dateTime) {
    if (dateTime == null) {
      return null;
    }

    return dateTime.toIso8601String();
  }

  static getToIso8601StringOrString(DateTime? dateTime) {
    if (dateTime == null) {
      return "";
    }

    return dateTime.toIso8601String();
  }

  static getToString(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }

    return dateTime.toString();
  }


  static getyMdFormat(DateTime? datetime) {
    if (datetime == null) return "";

    return DateFormat('yyyy-MM-dd').format(datetime);
  }

  static getyMdhmFormat(DateTime? dateTime) {
    if (dateTime == null) return "";

    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }
}
