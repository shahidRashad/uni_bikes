import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:uni_bike/app/core/api_gateway.dart';

import '../../../core/server_client.dart';
import '../../../core/string_const.dart';
import '../../../helpers/common_widget.dart';
import '../../../utils/enums.dart';
import '../../../utils/loading_overlay.dart';
import '../../create ride/model/get_all-rides_moidel.dart';

class HomeProvider extends ChangeNotifier {
  // selecting between 2 containers start

  final List<String> destinations = [
    'Outer circle',
    'Sj',
    'Cv raman',
    'Valmiky hostel ',
    'Tiruvallur stafium',
    'Rajiv gandhi stadium',
    'Narmadha',
    'Health centre ',
    "Ponlait",
    "Gate2",
    "Reading room",
    "Gate 1"
  ];

  SelectedContainer _selectedContainer = SelectedContainer.all;

  SelectedContainer get selectedContainer => _selectedContainer;

  void updateSelectedContainer(SelectedContainer newContainer) {
    _selectedContainer = newContainer;
    notifyListeners();
  }

  bool isFilterShow = true;

  removeFilter() {
    isFilterShow = !isFilterShow;
    log("isFilterShow $isFilterShow");
    notifyListeners();
  }

  // selecting between 2 containers end

  TextEditingController nameCntrlr = TextEditingController();
  TextEditingController branchCntrlr = TextEditingController();
  TextEditingController departmnetCntrlr = TextEditingController();
  TextEditingController idCntrlr = TextEditingController();
  TextEditingController phoneCntrlr = TextEditingController();

  // Future<void> createUserFn({required BuildContext context}) async {
  //   if (nameCntrlr.text.isEmpty) {
  //     toast(context, title: "Name is empty", backgroundColor: Colors.red);
  //   } else if (branchCntrlr.text.isEmpty) {
  //     toast(context, title: "branch is empty", backgroundColor: Colors.red);
  //   } else if (departmnetCntrlr.text.isEmpty) {
  //     toast(context, title: "department is empty", backgroundColor: Colors.red);
  //   } else if (idCntrlr.text.isEmpty) {
  //     toast(context, title: "Id is empty", backgroundColor: Colors.red);
  //   } else if (phoneCntrlr.text.isEmpty) {
  //     toast(context,
  //         title: "Phone number is empty", backgroundColor: Colors.red);
  //   } else {
  //     LoadingOverlay.of(context).show();
  //     try {
  //       List response = await ServerClient.post(
  //           "http://rashadahmed36334401.pythonanywhere.com/rides/",
  //           data: {
  //             "motorcycle": nameCntrlr.text,
  //             "start_point": phoneCntrlr.text,
  //             "end_point": branchCntrlr.text,
  //             "start_time": departmnetCntrlr.text,
  //             "end_time": idCntrlr.text,
  //             "contact_number": nameCntrlr.text,
  //             "created_by": "",
  //           },
  //           post: true);

  //       log("slot1111  ::${response.last}");
  //       log("slot222  ::${response.first}");
  //       if (response.first >= 200 && response.first < 300) {
  //         StringConst.setUserId(userId: response.last['id']);
  //         getAllRides(context: context, isFrom: false);

  //         nameCntrlr.clear();
  //         phoneCntrlr.clear();
  //         departmnetCntrlr.clear();
  //         branchCntrlr.clear();
  //         nameCntrlr.clear();
  //         idCntrlr.clear();

  //         LoadingOverlay.of(context).hide();
  //         toast(context, title: "Success", backgroundColor: Colors.green);
  //         // Routes.back();

  //         notifyListeners();
  //       } else {
  //         LoadingOverlay.of(context).hide();
  //         throw Exception('Failed to fetch posts');
  //       }
  //     } catch (e) {
  //       LoadingOverlay.of(context).hide();
  //       notifyListeners();
  //       throw Exception('Failed to fetch posts');
  //     }
  //   }
  // }

  GetAllRidesModel getAllRidesModel = GetAllRidesModel();
  GetAllRidesStatus getAllRidesStatus = GetAllRidesStatus.initial;

  TextEditingController startPointCntrlr = TextEditingController();
  TextEditingController endPointCntrlr = TextEditingController();

  Future<void> getAllRides(
      {required BuildContext context, required bool isFrom}) async {
    if (isFrom) {
      getAllRidesStatus = GetAllRidesStatus.loading;
      try {
        String url = "https://unibikes.onrender.com/get-rides";
        final response = await ApiGateway.service(
          url:Uri.parse(url),
          body: {
            "startPoint": startPointCntrlr.text,
            "endPoint": endPointCntrlr.text,
          },
        );
        if (response.isNotEmpty) {
          log("hiiiiiiiiiiii");
          getAllRidesModel = GetAllRidesModel.fromJson(response);
          log("hiiiiiiiiiiii2  ${getAllRidesModel.rides?.length}");

          getAllRidesStatus = GetAllRidesStatus.loaded;
          notifyListeners();
        } else {
          // log("error in getAllRidesModel  ::     ${response.last}");
          getAllRidesStatus = GetAllRidesStatus.error;
        }
      } catch (e) {
        getAllRidesStatus = GetAllRidesStatus.error;
        debugPrint(e.toString());
      } finally {
        notifyListeners();
      }
    } else {
      if (startPointCntrlr.text.isEmpty || endPointCntrlr.text.isEmpty) {
        toast(context,
            title: "Please fill all fields", backgroundColor: Colors.red);
      } else {
        getAllRidesStatus = GetAllRidesStatus.loading;
        try {
          notifyListeners();
          String url = "https://unibikes.onrender.com/get-rides";
          final response = await ApiGateway.service(
            url: Uri.parse(url),
            body: {
              "startPoint": startPointCntrlr.text,
              "endPoint": endPointCntrlr.text,
            },
          );
          if (response.isNotEmpty) {
            getAllRidesModel = GetAllRidesModel.fromJson(response);
            log("length   :: ${getAllRidesModel.rides}");
            getAllRidesStatus = GetAllRidesStatus.loaded;
            notifyListeners();
          } else {
            getAllRidesStatus = GetAllRidesStatus.error;
          }
        } catch (e) {
          getAllRidesStatus = GetAllRidesStatus.error;
          debugPrint(e.toString());
        } finally {
          notifyListeners();
        }
      }
    }
  }

  GetAllRidesModel getMyRidesModel = GetAllRidesModel();

  MyRidesStatus myRidesStatus = MyRidesStatus.initial;

  Future<void> getMyRideFn({
    required BuildContext ctx,
  }) async {
    myRidesStatus = MyRidesStatus.loading;
    final id = await StringConst.getUserID();
    log("idddd   ::     $id");
    try {
      notifyListeners();
      String url = "https://unibikes.onrender.com/get-my-rides";
      final response = await ApiGateway.service(
        url:Uri.parse(url),
        body: {
          "id": id,
        },
      );
      if (response.isNotEmpty) {
        getMyRidesModel = GetAllRidesModel.fromJson(response);
        // log("getMyRidesModel   ::     ${getMyRidesModel.myRides?.length}");
        log("getMyRidesModel   ::     ${getMyRidesModel.rides?.length}");

        myRidesStatus = MyRidesStatus.loaded;

        notifyListeners();
      } else {
        myRidesStatus = MyRidesStatus.error;
        throw Exception('Failed to fetch posts');
      }
    } catch (e) {
      myRidesStatus = MyRidesStatus.error;
      debugPrint(e.toString());
    } finally {
      notifyListeners();
    }
  }

  dynamic profileModel;
  ProfileStatus profileStatus = ProfileStatus.initial;

  Future<void> getProfileFn({
    required BuildContext ctx,
  }) async {
    profileStatus = ProfileStatus.loading;
    final id = await StringConst.getUserID();
    log("idddd   ::     $id");
    try {
      String url = "https://unibikes.onrender.com/get-user";
      final response = await ApiGateway.service(
        url:Uri.parse(url),
        body: {
          "id": id,
        },
      );
      if (response.isNotEmpty) {
        try {
          profileModel = response["user"];
          log("phone   ::     ${response["user"]['mobileNumber']}");
          log(" depa  ::     ${response["user"]["departMent"]}");
          profileStatus = ProfileStatus.loaded;
        } catch (e) {
          log("error in profileModel  ::     $e");
          profileStatus = ProfileStatus.error;
        }

        notifyListeners();
      } else {
        profileStatus = ProfileStatus.error;
        throw Exception('Failed to fetch posts');
      }
    } catch (e) {
      profileStatus = ProfileStatus.error;
      debugPrint(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> showInterest({
    required BuildContext ctx,
    required String rideId,
  }) async {
    LoadingOverlay.of(ctx).show();
    final id = await StringConst.getUserID();
    log("idddd   ::     $id");
    try {
      notifyListeners();
      String url = "https://unibikes.onrender.com/show-intrest";
      final response = await ApiGateway.service(
        url:Uri.parse(url),
        body: {"id": id, "rideId": rideId},
      );
      if (response.isNotEmpty) {
        toast(ctx, title: "Success", backgroundColor: Colors.green);
        LoadingOverlay.of(ctx).hide();
        notifyListeners();
      } else {
        LoadingOverlay.of(ctx).hide();
        toast(ctx, title: "Failed", backgroundColor: Colors.red);
        throw Exception('Failed to fetch posts');
      }
    } catch (e) {
      LoadingOverlay.of(ctx).hide();
      debugPrint(e.toString());
    } finally {
      notifyListeners();
    }
  }
}

enum SelectedContainer { all, myRide }
