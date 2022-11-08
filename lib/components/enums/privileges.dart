
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

  String get text {
    switch (this) {
      case EPrivileges.eAdmin:
      return "Admin";
      case EPrivileges.eObserver:
      return "Observer";
      case EPrivileges.eManager:
      return "Manager";
      case EPrivileges.eAccountant:
      return "Accountant";
      default:
      return "None";
    }
  }

  String get desc {
    switch (this) {
      case EPrivileges.eAdmin:
      return "어드민 캔 두 애니띵";
      case EPrivileges.eObserver:
      return "자료 조회 및 출력 권한을 갖고 있습니다";
      case EPrivileges.eManager:
      return "자료 조회, 출력 및 입급확인 권한을 갖고 있습니다";
      case EPrivileges.eAccountant:
      return "자료에 관한 모든 권한을 갖고 있습니다 ";
      default:
      return "";
    }
  }
}

EPrivileges intToPriv(int id) {
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

EPrivileges textToPriv(String text) {
  switch (text) {
    case "Admin":
    return EPrivileges.eAdmin;
    case "Observer":
    return EPrivileges.eObserver;
    case "Manager":
    return EPrivileges.eManager;
    case "Accountant":
    return EPrivileges.eAccountant;
    default:
    return EPrivileges.eNone;
  }
}

List<String> getPrivTextList() {
  return [
    EPrivileges.eAdmin.text,
    EPrivileges.eObserver.text,
    EPrivileges.eManager.text,
    EPrivileges.eAccountant.text,
  ];
}