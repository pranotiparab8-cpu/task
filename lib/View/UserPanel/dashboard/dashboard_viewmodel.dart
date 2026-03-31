import 'package:stacked/stacked.dart';

import '../../../Core/database/db_service.dart';
import '../../../Core/models/user_model.dart';
import '../../../Core/service/json_service.dart';

class DashboardViewModel extends BaseViewModel {
  bool isUserPanelExpanded = true;
  final _jsonService = JsonService();
  final _dbService = DbService();
  UserModel? userModel;

  String selectedMenu = "Dashboard";

  void toggleUserPanel() {
    isUserPanelExpanded = !isUserPanelExpanded;
    notifyListeners();
  }

  void selectMenu(String menu) {
    selectedMenu = menu;
    notifyListeners();
  }

  Future<void> init() async {
    final data = await _jsonService.loadData();
    //userModel = UserModel.fromJson(data);

    // 2. Save to DB
    await _dbService.insertUser(data['user']);

    // 3. Load from DB
    final userFromDb = await _dbService.getUser(data['user']['empId']);
    if (userFromDb != null) {
      userModel = UserModel.fromJson(userFromDb);
    }

    notifyListeners();
  }

}