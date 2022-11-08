
class ChartData {
  int date;
  bool dataType;
  int value;  
  ChartData(this.date, this.dataType, this.value);

  ChartData.fromJson(dynamic json) :
    date = json["date"],
    dataType = json["data_type"],
    value = json["sum"];
}

class SfChartData {
  String date;
  int? income;
  int? outcome;
  SfChartData(this.date, this.income, this.outcome);
}