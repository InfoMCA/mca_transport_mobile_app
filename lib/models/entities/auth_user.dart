import 'package:transportation_mobile_app/models/entities/session.dart';

class AuthUserModel {
  final String username;
  final String email;
  Map<SessionStatus, List<SessionObject>> userSessions;

  AuthUserModel({this.username, this.email, List<SessionObject> sessions}) {
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
    };
  }
}
