import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get stringAmPm {
    return DateFormat('hh:mm a').format(this);
  }

  String get stringDateOnly {
    return DateFormat('dd-MMM-yyyy').format(this);
  }

  String get stringDateOnly_dd_mm {
    return DateFormat('dd-MM-yyyy').format(this);
  }

  String get stringDateMMMM_D_YYYY {
    return DateFormat('MMMM d, yyyy').format(this);
  }

  String get stringDateMMMM_D_AM_PM {
    return DateFormat('MMMM d, hh:mm a').format(this);
  }

  String get stringDateMMMM_D_yyyy_AM_PM_ {
    return DateFormat('EEE, MMM dd yyyy hh:mm a').format(this);
  }

  String get stringDateMMMM_D_AM_PM_ {
    return DateFormat('MMM dd, hh:mm a').format(this);
  }

  String get stringDateEEEE {
    return DateFormat('EEE, dd MMM').format(this);
  }

  String get stringDateDDD_D_YYYY {
    return DateFormat('E, MMM dd, yyyy').format(this);
  }

  String get stringDate_yyyy_MM_ddTHH_mm_ssZ {
    return DateFormat('yyyy-MM-ddTHH:mm:ssZ').format(this);
  }

  String get stringDate_yyyy_MM_dd_HH_mm_ss {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(this);
  }
}
