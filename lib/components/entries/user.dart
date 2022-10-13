
import 'package:daewon_am/components/enums/privileges.dart';

class User {
  int? uid;
  String userId;
  String userPwd;
  EPrivileges priv;

  User(this.userId, this.userPwd, this.priv);

  User.fromJson(dynamic json) : 
    uid = json["uid"],
    userId = json["user_id"],
    userPwd = json["user_pwd"] ?? "",
    priv = intToPriv(json["privileges"] as int);

  @override
  String toString() {
    final sb = StringBuffer();
    sb.write("{ \"uid\" : ");         sb.write(uid);
    sb.write(", \"user_id\" : ");     sb.write("\"$userId\"");
    sb.write(", \"user_pwd\" : ");     sb.write("\"$userPwd\"");
    sb.write(", \"privileges\" : ");  sb.write(priv.id);
    sb.write(" }");
    return sb.toString();
  }

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "user_id": userId,
    "user_pwd": userPwd,
    "privileges": priv.id,
  };
}