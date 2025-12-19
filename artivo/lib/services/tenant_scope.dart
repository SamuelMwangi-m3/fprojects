import 'package:flutter/foundation.dart';

class TenantScope extends ChangeNotifier {
  String? _tenantId;
  String? get tenantId => _tenantId;

  void setTenant(String? id) {
    _tenantId = id;
    notifyListeners();
  }
}


