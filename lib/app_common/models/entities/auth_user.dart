import 'package:enum_to_string/enum_to_string.dart';
import 'package:transportation_mobile_app/app_driver/models/entities/session.dart';

class AuthUserModel {
  final String username;
  final String email;
  final UserRole role;
  Map<SessionStatus, List<SessionObject>> userSessions;

  AuthUserModel(
      {this.username, this.email, List<SessionObject> sessions, this.role}) {
    setUserSessions(sessions);
  }

  void setUserSessions(List<SessionObject> sessions) {
    this.userSessions = Map();
    for (SessionObject sessionObject in sessions ?? []) {
      this
          .userSessions
          .putIfAbsent(sessionObject.sessionStatus, () => [])
          .add(sessionObject);
    }
  }

  List<SessionObject> getUserSessions({SessionStatus sessionStatus}) {
    if (this.userSessions == null || this.userSessions.length == 0) {
      return [];
    }
    if (sessionStatus == null) {
      return this
          .userSessions
          .values
          .toList()
          .reduce((value, element) => value..addAll(element));
    }
    return this.userSessions.putIfAbsent(sessionStatus, () => []);
  }

  void updateSessionStatus(
      SessionObject sessionObject, SessionStatus oldStatus) {
    this.userSessions.putIfAbsent(oldStatus, () => null).remove(sessionObject);
    this
        .userSessions
        .putIfAbsent(sessionObject.sessionStatus, () => [])
        .add(sessionObject);
  }

  factory AuthUserModel.fromJson(dynamic json) {
    return AuthUserModel(
      username: json['username'],
      email: json['email'],
      role: EnumToString.fromString(UserRole.values, json['role'] ?? ""),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'role': EnumToString.convertToString(role)
    };
  }
}

enum UserRole { driver, broker, customer, operator }

extension routing on UserRole {
  String getModuleRoute() {
    switch (this) {
      // case UserRole.customer:
      //   return "/customer";
      // case UserRole.broker:
      //   return "/broker";
      case UserRole.driver:
        return "/driver";
      case UserRole.operator:
        return "/customer";
      default:
        return "";
    }
  }
}
