import 'package:auto_route/auto_route_annotations.dart';
import 'package:bookservice/apis/client.dart';
import 'package:bookservice/pages/pages.dart';
import 'package:flutter/material.dart';

@MaterialAutoRouter(
  // generateNavigationHelperExtension: true,
  routes: <AutoRoute>[
    AdaptiveRoute(page: Authentication, initial: true),
    AdaptiveRoute<Widget>(
      path: '/users/:id',
      page: UserPage,
      children: [
        AdaptiveRoute(path: '/', page: UserProfilePage),
        AdaptiveRoute(path: '/photo', page: UserPhotoPage),
        AdaptiveRoute(
          path: '/post/:field?',
          page: UserPostPage,
        ),
        AdaptiveRoute(path: '/emailvalidate/:email?', page: EmailValidatePage),
        AdaptiveRoute(path: '/join', page: JoinPage)
      ],
    ),
    AdaptiveRoute(
      path: '/faqs',
      page: FaqPage,
    ),
    AdaptiveRoute(path: '/contract', page: ContractPage, children: [
      AdaptiveRoute(path: '/', page: ContractListPage),
      AdaptiveRoute(path: '/:id/post', page: ContractPost),
    ]),
    AdaptiveRoute(path: '/address', page: AddressPage, children: [
      AdaptiveRoute(name: 'list', path: '/', page: AddressListPage),
      AdaptiveRoute(name: 'post', path: '/post', page: AddressPostPage),
      AdaptiveRoute(name: 'put', path: '/put', page: AddressPostPage)
    ]),
    AdaptiveRoute<Address>(
        name: 'pickaddr',
        path: '/pickaddr',
        page: AddressListPage,
        fullscreenDialog: true),
    AdaptiveRoute(path: '/order', page: OrderPage, children: [
      AdaptiveRoute(name: 'list', path: '/', page: OrderListPage),
      AdaptiveRoute(name: 'post', path: '/:id/post', page: OrderPostPage),
    ]),
  ],
)
class $Router {}
