

enum EPrivileges {
  eNone,
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
      return 0;
    }
  }
}

EPrivileges toPriv(int id) {
  switch (id) {
    case 1 << 0:
    return EPrivileges.eAdmin;
    case 1 << 1:
    return EPrivileges.eObserver;
    case 1 << 2:
    return EPrivileges.eManager;
    case 1 << 3:
    return EPrivileges.eAccountant;
    default:
    return EPrivileges.eNone;
  }
}