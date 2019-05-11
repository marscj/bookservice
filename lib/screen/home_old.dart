// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import '../auth/l10n/authlocalization.dart';
// import '../router/routes.dart';
// import '../theme.dart';
// import '../widgets.dart';
// import '../caches.dart';
// import './config_home.dart';

// const Duration _kFrontLayerSwitchDuration = Duration(milliseconds: 300);

// class HomePage extends StatefulWidget {

//   State<HomePage> createState() => new _HomePage();
// }

// class _HomePage extends State<HomePage> {
  
//   String _category;

//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//   @override 
//   void initState() {
//     
//     super.initState();

//     _getCategory();
//   }

//   _getCategory() async {
//     setState(() {});
//   }

//   Widget _topHomeLayout(Widget currentChild, List<Widget> previousChildren) {
//     List<Widget> children = previousChildren;
//     if (currentChild != null)
//       children = children.toList()..add(currentChild);
//     return new Stack(
//       children: children,
//       alignment: Alignment.topCenter,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {

//     final ThemeData theme = Theme.of(context);
//     final bool isDark = theme.brightness == Brightness.dark;
//     const Curve switchOutCurve = Interval(0.4, 1.0, curve: Curves.fastOutSlowIn);
//     const Curve switchInCurve = Interval(0.4, 1.0, curve: Curves.fastOutSlowIn);
    
//     Widget home = new Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: isDark ? kFlutterBlue : theme.primaryColor,
//       body: new SafeArea(
//         bottom: false,
//         //optionsPage,
//         child: new Backdrop(
//           backTitle: const Text('Options'),
//           backLayer: new IButtonBar(
//             axis: Axis.vertical,
//             alignment: MainAxisAlignment.start,
//             children: <Widget>[
//               new FlatButton(
//                 child: new Text(AuthLocalizations.of(context).userProfileTitle, style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
//                 onPressed: () {
//                   Routes.instance.navigateTo(context, Routes.instance.profile, transition: TransitionType.fadeIn);
//                 },
//               ),
//               new Visibility(
//                 visible: _category != null,
//                 child: _category != 'freelancer' ? 
//                   new FlatButton(
//                     child: new Text('Address', style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
//                     onPressed: () {
//                       Routes.instance.navigateTo(context, Routes.instance.addr, transition: TransitionType.fadeIn);
//                     }
//                 ) : 
//                   new FlatButton(
//                     child: new Text('Freelancer', style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
//                     onPressed: () {
//                       Routes.instance.navigateTo(context, Routes.instance.freelancer, transition: TransitionType.fadeIn);
//                     },
//                   )
//               ),
//               new FlatButton(
//                 child: new Text('Language', style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
//                 onPressed: () {
//                   Routes.instance.navigateTo(context, Routes.instance.language, transition: TransitionType.fadeIn);
//                 },
//               ),
//               new FlatButton(
//                 child: new Text('Bookings', style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
//                 onPressed: () {
//                   Routes.instance.navigateTo(context, Routes.instance.bookingList, transition: TransitionType.fadeIn);
//                 },
//               ),
//             ],
//           ),
//           frontAction: new AnimatedSwitcher(
//             duration: _kFrontLayerSwitchDuration,
//             switchOutCurve: switchOutCurve,
//             switchInCurve: switchInCurve,
//             child: AppLogo(size: 20.0)
//           ),
//           frontTitle: new AnimatedSwitcher(
//             duration: _kFrontLayerSwitchDuration,
//             child: new Text('BookService')
//           ),
//           frontLayer: new AnimatedSwitcher(
//             duration: _kFrontLayerSwitchDuration,
//             switchOutCurve: switchOutCurve,
//             switchInCurve: switchInCurve,
//             layoutBuilder: _topHomeLayout,
//             child:  new CategoriesPage(
//               categories: ConfigHome.of(context).categories,
//               onCategoryTap: (Category category) {
//                 Routes.instance.navigateTo(context, Routes.instance.bookingCreate, transition: TransitionType.nativeModal, object: category);
//               },
//             ),
//           ),
//         ),
//       ),
//     );

//     home = new AnnotatedRegion<SystemUiOverlayStyle>(
//       child: home,
//       value: SystemUiOverlayStyle.light
//     );

//     return home;
//   }
// }