
class AccountingData {
  int? uid;
  String clientName;
  DateTime date;
  double steelWeight;
  int supplyPrice;
  int taxAmount;
  int unitPrice;
  bool dataType;
  bool depositConfirmed;
  DateTime? depositDate;
  bool deleted;

  AccountingData({
    this.uid,
    required this.clientName, 
    required this.date,
    required this.steelWeight,
    required this.supplyPrice,
    required this.taxAmount,
    required this.unitPrice,
    this.dataType = false,
    this.depositConfirmed = false,
    this.depositDate,
    this.deleted = false});

  AccountingData.fromJson(dynamic json) :
    uid = json["uid"],
    clientName = json["client_name"],
    date = DateTime.parse(json["date"]),
    steelWeight = json["steel_weight"],
    supplyPrice = json["supply_price"],
    taxAmount = json["tax_amount"],
    unitPrice = json["unit_price"],
    dataType = json["data_type"],
    depositConfirmed = json["deposit_confirmed"],
    depositDate = json["deposit_date"] == null ? null : DateTime.parse(json["deposit_date"]),
    deleted = json["deleted"];

  @override
  String toString() {
    final sb = StringBuffer();
    sb.write("{ \"uid\" : ");               sb.write(uid);
    sb.write(", \"client_name\" : ");       sb.write("\"$clientName\"");
    sb.write(", \"date\" : ");              sb.write("\"$date\"");
    sb.write(", \"steel_weight\" : ");      sb.write(steelWeight);
    sb.write(", \"supply_price\" : ");      sb.write(supplyPrice);
    sb.write(", \"tax_amount\" : ");        sb.write(taxAmount);
    sb.write(", \"unit_price\" : ");        sb.write(unitPrice);
    sb.write(", \"data_type\" : ");         sb.write(dataType);
    sb.write(", \"deposit_confirmed\" : "); sb.write(depositConfirmed);
    sb.write(", \"deposit_date\" : ");      (!depositConfirmed || depositDate == null) ? sb.write("null") : sb.write("\"$depositDate\"");
    sb.write(", \"deleted\" : ");           sb.write(deleted);
    sb.write(" }");
    return sb.toString();
  }

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "client_name": clientName,
    "date": date.toString(),
    "steel_weight": steelWeight,
    "supply_price": supplyPrice,
    "tax_amount": taxAmount,
    "unit_price": unitPrice,
    "data_type": dataType,
    "deposit_confirmed": depositConfirmed,
    "deposit_date": (!depositConfirmed || depositDate == null) ? null : depositDate.toString(),
    "deleted": deleted
  };
}