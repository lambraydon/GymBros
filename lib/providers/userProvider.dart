import 'package:flutter/widgets.dart';
import 'package:gymbros/models/gbprofile.dart';
import 'package:gymbros/services/database_service.dart';
import 'package:gymbros/services/auth_service.dart';

class UserProvider with ChangeNotifier {
  GbProfile? _gbProfile;
  final _db = DatabaseService(uid: AuthService().getUid());

  GbProfile get getUser => _gbProfile!;

  Future<void> refreshUser() async {
    GbProfile user = await _db.getUserDetails();
    _gbProfile = user;
    notifyListeners();
  }
}