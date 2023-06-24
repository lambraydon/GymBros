import 'package:flutter/widgets.dart';
import 'package:gymbros/models/gbprofile.dart';
import 'package:gymbros/services/authservice.dart';
import 'package:gymbros/services/databaseservice.dart';

class UserProvider with ChangeNotifier {
  GbProfile? _gbProfile;
  final AuthService _auth = AuthService();
  final DatabaseService _db = DatabaseService(uid: AuthService().getUid());

  GbProfile get getUser => _gbProfile!;

  Future<void> refreshUser() async {
    GbProfile gbProfile = await _db.getUserDetails();
    _gbProfile = gbProfile;
    notifyListeners();
  }
}