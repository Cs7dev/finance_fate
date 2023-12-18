import 'package:finance_fate/pod/company.dart';
import 'package:flutter/material.dart';

class CompanyList extends ChangeNotifier {
  final List<Company> companyList = [];

  int length() {
    return companyList.length;
  }

  bool isEmpty() {
    return companyList.isEmpty;
  }

  bool isNotEmpty() {
    return !isEmpty();
  }

  int indexOfCompany(String ticker) {
    return companyList.indexWhere((element) => ticker == element.ticker);
  }

  bool contains(String company) {
    return indexOfCompany(company) != -1;
  }

  Company? findCompanyFromTicker(String ticker) {
    int index = indexOfCompany(ticker);
    return index == -1 ? null : companyList[index];
  }

  Company companyAtIndex(int index) {
    if (index >= companyList.length) {
      throw "Out of bounds. Index accessed: $index, length of list: ${companyList.length}";
    }

    return companyList[index];
  }

  void addUser(Company company) {
    if (contains(company.ticker)) {
      return;
    }

    companyList.add(company);
    notifyListeners();
  }

  void insertUser(int index, Company company) {
    if (contains(company.ticker)) {
      return;
    }

    companyList.insert(index, company);
    notifyListeners();
  }

  // Future<void> loadUsersFromDatabase() async {
  //   if (_isInitialized) {
  //     return;
  //   }

  //   _isInitialized = true;

  //   var isar = await UserDatabase.isar();
  //   var tempUserList = await isar!.userDatas
  //       .filter()
  //       .isarIdGreaterThan(Isar.minId)
  //       .sortByListOrder()
  //       .findAll();

  //   _companyList = tempUserList;
  //   notifyListeners();

  //   // refreshListOrder(); //todo investigate if redundant
  // }

  // Future<void> updateUser(UserData user) async {
  //   var dataMap = await DataParser(username: user.username).getAllAsJson();
  //   user.update(updatedUser: UserData.fromMap(dataMap: dataMap!));

  //   notifyListeners();
  // }

  // Future<void> updateUsersFromServer() async {
  //   List<Future> futureJsonList = [];
  //   for (var user in _companyList) {
  //     futureJsonList.add(DataParser(username: user.username).getAllAsJson());
  //   }

  //   Queue<dynamic> jsonQueue = Queue.from(await Future.wait(futureJsonList));

  //   // Take care of reordering that occurs in between refreshing
  //   // Consider using mapping from Username to userData and index

  //   while (jsonQueue.isNotEmpty) {
  //     var first = jsonQueue.first;
  //     jsonQueue.removeFirst();

  //     var updatedUser = UserData.fromMap(dataMap: first);

  //     int index = indexOfCompany(updatedUser.username);
  //     // User was removed in between refreshing
  //     if (index == -1) {
  //       continue;
  //     }

  //     updatedUser.listOrder = index;
  //     _companyList[index].update(updatedUser: updatedUser);
  //   }

  //   notifyListeners();
  // }

  // void refreshListOrder() {
  //   bool didUpdate = false;

  //   for (int i = 0; i < _companyList.length; ++i) {
  //     if (_companyList[i].listOrder != i) {
  //       didUpdate = true;
  //       _companyList[i].listOrder = i;
  //     }
  //   }

  //   if (didUpdate) {
  //     notifyListeners();
  //   }
  // }

  String exportCompanyTickerAsCSV() {
    String headerColumn = 'Username';

    String csv = headerColumn;

    for (var company in companyList) {
      csv = "$csv\n${company.ticker}";
    }

    return csv;
  }

  void deleteUser(Company company) {
    companyList.remove(company);
    notifyListeners();
  }

  Company deleteUserAt(int index) {
    if (index >= companyList.length) {
      throw "Out of bounds. Index accessed: $index, length of list: ${companyList.length}";
    }

    Company deleted = companyList.removeAt(index);
    notifyListeners();
    return deleted;
  }

  // Future<void> deleteAllDatabaseSync() async {
  //   _companyList.clear();
  //   notifyListeners();
  //   await UserDatabase.deleteAll();
  // }

  // Future<void> syncDatabase() async {
  //   await UserDatabase.putAll(_companyList);
  // }

  // void importUsersFromList(List userList) {
  //   bool userAdded = false;

  //   for (UserData? user in userList) {
  //     if (user == null) {
  //       // ToDo: tell user username no longer exists
  //       continue;
  //     }

  //     if (contains(user.username)) {
  //       continue;
  //     }

  //     user.listOrder = length();
  //     addUser(user);
  //     userAdded = true;
  //   }

  //   if (userAdded) {
  //     notifyListeners();
  //   }
  // }
}
