
import 'package:intl/intl.dart';

class FormatManager {
  static final _integerFormatter = NumberFormat("###,###,###,##0");

  static String thousandSeperator(int number) {
    return _integerFormatter.format(number);
  }

  static String dateTimeToString(DateTime date) {
    return DateFormat("yyyy-MM-dd").format(date);
  }
}