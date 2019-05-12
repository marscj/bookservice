import 'package:flutter/widgets.dart';
import 'package:fluro/fluro.dart';

export 'package:fluro/fluro.dart';
import '../router/handlers.dart';

class Routes extends Router{
  String root = '/';
  String category = '/category';
  String home = '/home';
  String language = '/language';
  String signin = '/signin';
  String profile = '/profile';
  String addr = '/addrs';
  String addAddressCustomer = '/addAddressCustomer';
  String addAddressCompany = '/addAddressCompany';
  String freelancerProfile = '/freelancerProfile';
  String bookingCreate = '/bookingCreate';
  String bookingDetail = '/bookingDetail';
  String bookingList = '/bookingList';
  String bookingPage = '/bookingPage';
  String whiteList = '/whiteList';
  String addWhiteList = '/addWhiteList';
  String users = '/users';
  String userDetail = '/userDetail';
  String userPageStaff = '/userPageStaff';
  String complete = '/complete';
  String map = '/map';
  String contract = '/contract';
  String job = '/job';
  String upload = '/upload';

  static Routes _instance = new Routes._();

  static Routes get instance => _instance;

  Routes._() {
    notFoundHandler = new Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params, [object]) {
        print("ROUTE WAS NOT FOUND !!!");
    });

    define(root, handler: adHandler);
    define(category, handler: categoryHandler);
    define(home, handler: homeHandler);
    define(language, handler: languageHandler);
    define(signin, handler: signinHandler);
    define(profile, handler: profileHandler);
    define(addr, handler: addrHandler);
    define(addAddressCustomer, handler: addAddressCustomerHandler);
    define(addAddressCompany, handler: addAddressCompanyHandler);
    define(freelancerProfile, handler: freelancerProfileHandler);
    define(bookingCreate, handler: bookingCreateHandler);
    define(bookingDetail, handler: bookingDetailHandler);
    define(bookingList, handler: bookingListHandler);
    define(bookingPage, handler: bookingPageHandler);
    define(whiteList, handler: whiteListHandler);
    define(addWhiteList, handler: addWhiteListHandler);
    define(users, handler: usersHandler);
    define(userDetail, handler: userDetailHandler);
    define(userPageStaff, handler: userPageStaffHandler);
    define(complete, handler: completeHandler);
    define(map, handler: mapHandler);
    define(contract, handler: contractHandler);
    define(job, handler: jobHandler);
    define(upload, handler: uploadHandler);
  }
}