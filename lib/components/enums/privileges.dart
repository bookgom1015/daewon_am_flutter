
import 'package:flutter/scheduler.dart';

enum EPrivileges {
  eAdmin,
  eObserver,
  eManager,
  eAccountant,
}

extension EPrivilegesExt on EPrivileges {
  int get id {
    switch (this) {
      case EPrivileges.eAdmin:
      return 1 << 0;
      case EPrivileges.eObserver:
      return 1 << 1;
      case EPrivileges.eManager:
      return 1 << 2;
      case EPrivileges.eAccountant:
      return 1 << 3;
      default:
      return -1;
    }
  }
}