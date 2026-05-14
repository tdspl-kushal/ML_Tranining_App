import 'package:intl/intl.dart';

extension StringExtension on String {
  DateTime? get date {
    if (isEmpty) return null;
    String format = 'yyyy-MM-ddTHH:mm:ssZ';

    return DateFormat(format).parseUTC(this);
  }

  DateTime? get date_time {
    if (isEmpty) return null;
    String format = 'yyyy-MM-ddTHH:mm:ss';

    return DateFormat(format).parseUTC(this);
  }

  DateTime? get dateTime {
    if (isEmpty) return null;

    return DateTime.parse(this);
  }
}
