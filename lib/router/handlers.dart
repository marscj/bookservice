import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../auth/profile_view.dart';
import '../router/routes.dart';
import '../screens.dart';
import '../store/store.dart';
import '../firebase_user.dart';

Handler adHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params, [dynamic object]) {
    return new AdPage(callback);
  });

Handler homeHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params, [dynamic object]) {
    return new Home();
  });

Handler categoryHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params, [dynamic object]) {
    return new CategoryPage(callback);
  });

Handler languageHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params, [dynamic object]) {
    return new LanguagePage(callback: object['callback'], canBack: object['canBack']);
  });

Handler signinHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params, [dynamic object]) {
    return new SignInPage(callback);
  });

Handler profileHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params, [dynamic object]) {
    return new ProfileView(callback: object, sigout: () async {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
    }, storage: Store.instance.userRef);
  });

Handler addrHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params, [dynamic object]) {
    return new AddrPage(object);
  });

Handler addAddressCustomerHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params, [dynamic object]) {
    return new CustomerAddressPage(object['addrType'], object['data']);
  }); 

Handler addAddressCompanyHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params, [dynamic object]) {
    return new CompanyAddressPage(object['addrType'], object['data']);
  }); 

Handler freelancerProfileHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params, [dynamic object]) {
    return new FreelancerProfile(object);
  }); 

Handler bookingCreateHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params, [dynamic object]) {
    return new BookingCreatePage(object['category'], object['userData']);
  }); 

Handler bookingDetailHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params, [dynamic object]) {
    return new BookingDetail(object['data'], object['userData']);
  }); 

Handler bookingListHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params, [dynamic object]) {
    return new BookingList(viewData: object['viewData'], userData: object['userData'], isShowAppBar: true);
  }); 

Handler bookingPageHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params, [dynamic object]) {
    return new BookingPage(object);
  });

Handler whiteListHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params, [dynamic object]) {
    return new WhiteListPage(object);
  }); 

Handler addWhiteListHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params, [dynamic object]) {
    return new AddWhiteList();
  }); 

Handler usersHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params, [dynamic object]) {
    return new UserPage(object);
  }); 

Handler userDetailHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params, [dynamic object]) {
    return new UserDetail(userId: object['userId'], userData: object['userData']);
  }); 

Handler userPageStaffHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params, [dynamic object]) {
    return new UserPageStaff();
  }); 

Handler completeHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params, [dynamic object]) {
    return new Complete(object);
  });

Handler mapHandler = new Handler(
  handlerFunc: (_, params, [object]){
    return new MyMap(object);
  }
);

Handler contractHandler = new Handler(
  handlerFunc: (_, params, [object]){
    return new ContractPage(object['viewData'], object['userData']);
  }
);

Handler jobHandler = new Handler(
  handlerFunc: (_, params, [object]){
    return new JobPage(object);
  }
);

Handler uploadHandler = new Handler(
  handlerFunc: (_, params, [object]){
    return new UploadPage();
  } 
);

Future callback(context) async {
  FirebaseUser user = UserWithFirebase.instance.firebaseUser;

  if (UserWithFirebase.instance.firebaseUser == null) {
    return Routes.instance.navigateTo(context, Routes.instance.signin, replace: true, transition: TransitionType.inFromRight);
  } else if (user.displayName == null || user.email == null) {
    return Routes.instance.navigateTo(context, Routes.instance.profile, replace: true, transition: TransitionType.inFromRight, object: callback);
  } else {
    return Routes.instance.navigateTo(context, Routes.instance.home, replace: true, transition: TransitionType.inFromRight);
  }
}