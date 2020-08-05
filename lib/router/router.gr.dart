// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../apis/client.dart';
import '../pages/pages.dart';

class Routes {
  static const String authentication = '/';
  static const String _userPage = '/users/:id';
  static String userPage({@required dynamic id}) => '/users/$id';
  static const String faqPage = '/faqs';
  static const String contractPage = '/contract';
  static const String addressPage = '/address';
  static const String orderPage = '/order';
  static const String orderPost = '/order/post';
  static const String orderPut = '/order/put';
  static const all = <String>{
    authentication,
    _userPage,
    faqPage,
    contractPage,
    addressPage,
    orderPage,
    orderPost,
    orderPut,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.authentication, page: Authentication),
    RouteDef(
      Routes._userPage,
      page: UserPage,
      generator: UserPageRouter(),
    ),
    RouteDef(Routes.faqPage, page: FaqPage),
    RouteDef(
      Routes.contractPage,
      page: ContractPage,
      generator: ContractPageRouter(),
    ),
    RouteDef(
      Routes.addressPage,
      page: AddressPage,
      generator: AddressPageRouter(),
    ),
    RouteDef(Routes.orderPage, page: OrderPage),
    RouteDef(Routes.orderPost, page: OrderPostPage),
    RouteDef(Routes.orderPut, page: OrderPostPage),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    Authentication: (data) {
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => Authentication(),
        settings: data,
      );
    },
    UserPage: (data) {
      return buildAdaptivePageRoute<Widget>(
        builder: (context) => UserPage(),
        settings: data,
      );
    },
    FaqPage: (data) {
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => FaqPage(),
        settings: data,
      );
    },
    ContractPage: (data) {
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => ContractPage(),
        settings: data,
      );
    },
    AddressPage: (data) {
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => AddressPage(),
        settings: data,
      );
    },
    OrderPage: (data) {
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => OrderPage(),
        settings: data,
      );
    },
    OrderPostPage: (data) {
      final args = data.getArgs<OrderPostPageArguments>(
        orElse: () => OrderPostPageArguments(),
      );
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => OrderPostPage(
          key: args.key,
          data: args.data,
        ),
        settings: data,
      );
    },
  };
}

class UserPageRoutes {
  static const String userProfilePage = '/';
  static const String userPhotoPage = '/photo';
  static const String _userPostPage = '/post/:field?';
  static String userPostPage({dynamic field = ''}) => '/post/$field';
  static const String _emailValidatePage = '/emailvalidate/:email?';
  static String emailValidatePage({dynamic email = ''}) =>
      '/emailvalidate/$email';
  static const String joinPage = '/join';
  static const all = <String>{
    userProfilePage,
    userPhotoPage,
    _userPostPage,
    _emailValidatePage,
    joinPage,
  };
}

class UserPageRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(UserPageRoutes.userProfilePage, page: UserProfilePage),
    RouteDef(UserPageRoutes.userPhotoPage, page: UserPhotoPage),
    RouteDef(UserPageRoutes._userPostPage, page: UserPostPage),
    RouteDef(UserPageRoutes._emailValidatePage, page: EmailValidatePage),
    RouteDef(UserPageRoutes.joinPage, page: JoinPage),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    UserProfilePage: (data) {
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => UserProfilePage(),
        settings: data,
      );
    },
    UserPhotoPage: (data) {
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => UserPhotoPage(),
        settings: data,
      );
    },
    UserPostPage: (data) {
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => UserPostPage(),
        settings: data,
      );
    },
    EmailValidatePage: (data) {
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => EmailValidatePage(),
        settings: data,
      );
    },
    JoinPage: (data) {
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => JoinPage(),
        settings: data,
      );
    },
  };
}

class ContractPageRoutes {
  static const String contractListPage = '/';
  static const String _contractPost = '/:id/post';
  static String contractPost({@required dynamic id}) => '/$id/post';
  static const all = <String>{
    contractListPage,
    _contractPost,
  };
}

class ContractPageRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(ContractPageRoutes.contractListPage, page: ContractListPage),
    RouteDef(ContractPageRoutes._contractPost, page: ContractPost),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    ContractListPage: (data) {
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => ContractListPage(),
        settings: data,
      );
    },
    ContractPost: (data) {
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => ContractPost(),
        settings: data,
      );
    },
  };
}

class AddressPageRoutes {
  static const String list = '/';
  static const String post = '/post';
  static const String put = '/put';
  static const all = <String>{
    list,
    post,
    put,
  };
}

class AddressPageRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(AddressPageRoutes.list, page: AddressListPage),
    RouteDef(AddressPageRoutes.post, page: AddressPostPage),
    RouteDef(AddressPageRoutes.put, page: AddressPostPage),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    AddressListPage: (data) {
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => AddressListPage(),
        settings: data,
      );
    },
    AddressPostPage: (data) {
      final args = data.getArgs<AddressPostPageArguments>(
        orElse: () => AddressPostPageArguments(),
      );
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => AddressPostPage(
          key: args.key,
          data: args.data,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// OrderPostPage arguments holder class
class OrderPostPageArguments {
  final Key key;
  final Order data;
  OrderPostPageArguments({this.key, this.data});
}

/// AddressPostPage arguments holder class
class AddressPostPageArguments {
  final Key key;
  final Address data;
  AddressPostPageArguments({this.key, this.data});
}
