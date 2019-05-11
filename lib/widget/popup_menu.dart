import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const Duration _kMenuDuration = Duration(milliseconds: 300);
const double _kBaselineOffsetFromBottom = 20.0;
const double _kMenuCloseIntervalEnd = 2.0 / 3.0;
const double _kMenuHorizontalPadding = 16.0;
const double _kMenuItemHeight = 48.0;
const double _kMenuDividerHeight = 16.0;
// const double _kMenuMaxWidth = 5.0 * _kMenuWidthStep;
const double _kMenuMinWidth = 2.0 * _kMenuWidthStep;
const double _kMenuVerticalPadding = 8.0;
const double _kMenuWidthStep = 56.0;
const double _kMenuScreenPadding = 8.0;


abstract class IPopupMenuEntry<T> extends StatefulWidget {
  const IPopupMenuEntry({ Key key }) : super(key: key);
  double get height;
  bool represents(T value);
}

class IPopupMenuDivider extends IPopupMenuEntry<Null> {
  
  const IPopupMenuDivider({ Key key, this.height = _kMenuDividerHeight }) : super(key: key);
  @override
  final double height;

  @override
  bool represents(dynamic value) => false;

  @override
  _IPopupMenuDividerState createState() => new _IPopupMenuDividerState();
}

class _IPopupMenuDividerState extends State<IPopupMenuDivider> {
  @override
  Widget build(BuildContext context) => new Divider(height: widget.height);
}

class IPopupMenuItem<T> extends IPopupMenuEntry<T> {
  
  const IPopupMenuItem({
    Key key,
    this.value,
    this.enabled = true,
    this.height = _kMenuItemHeight,
    @required this.child,
  }) : assert(enabled != null),
       assert(height != null),
       super(key: key);

  final T value;

  final bool enabled;

  @override
  final double height;

  final Widget child;

  @override
  bool represents(T value) => value == this.value;

  @override
  IPopupMenuItemState<T, IPopupMenuItem<T>> createState() => new IPopupMenuItemState<T, IPopupMenuItem<T>>();
}

class IPopupMenuItemState<T, W extends IPopupMenuItem<T>> extends State<W> {

  @protected
  Widget buildChild() => widget.child;

  @protected
  void handleTap() {
    Navigator.pop<T>(context, widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    TextStyle style = theme.textTheme.subhead;
    if (!widget.enabled)
      style = style.copyWith(color: theme.disabledColor);

    Widget item = new AnimatedDefaultTextStyle(
      style: style,
      duration: kThemeChangeDuration,
      child: new Baseline(
        baseline: widget.height - _kBaselineOffsetFromBottom,
        baselineType: style.textBaseline,
        child: buildChild(),
      )
    );
    if (!widget.enabled) {
      final bool isDark = theme.brightness == Brightness.dark;
      item = IconTheme.merge(
        data: new IconThemeData(opacity: isDark ? 0.5 : 0.38),
        child: item,
      );
    }

    return new InkWell(
      onTap: widget.enabled ? handleTap : null,
      child: new Container(
        height: widget.height,
        padding: const EdgeInsets.symmetric(horizontal: _kMenuHorizontalPadding),
        child: item,
      ),
    );
  }
}

class ICheckedPopupMenuItem<T> extends IPopupMenuItem<T> {

  const ICheckedPopupMenuItem({
    Key key,
    T value,
    this.checked = false,
    bool enabled = true,
    Widget child,
  }) : assert(checked != null),
       super(
    key: key,
    value: value,
    enabled: enabled,
    child: child,
  );

  final bool checked;

  @override
  Widget get child => super.child;

  @override
  _CheckedPopupMenuItemState<T> createState() => new _CheckedPopupMenuItemState<T>();
}

class _CheckedPopupMenuItemState<T> extends IPopupMenuItemState<T, ICheckedPopupMenuItem<T>> with SingleTickerProviderStateMixin {
  static const Duration _fadeDuration = Duration(milliseconds: 150);
  AnimationController _controller;
  Animation<double> get _opacity => _controller.view;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(duration: _fadeDuration, vsync: this)
      ..value = widget.checked ? 1.0 : 0.0
      ..addListener(() => setState(() { }));
  }

  @override
  void handleTap() {
    if (widget.checked)
      _controller.reverse();
    else
      _controller.forward();
    super.handleTap();
  }

  @override
  Widget buildChild() {
    return new ListTile(
      enabled: widget.enabled,
      leading: new FadeTransition(
        opacity: _opacity,
        child: new Icon(_controller.isDismissed ? null : Icons.done)
      ),
      title: widget.child,
    );
  }
}

class _PopupMenu<T> extends StatelessWidget {
  const _PopupMenu({
    Key key,
    this.route,
    this.semanticLabel,
    this.position,
    this.alignWidth
  }) : super(key: key);

  final _PopupMenuRoute<T> route;
  final String semanticLabel;
  final RelativeRect position;
  final bool alignWidth;

  @override
  Widget build(BuildContext context) {
    final double unit = 1.0 / (route.items.length + 1.5);
    final List<Widget> children = <Widget>[];

    for (int i = 0; i < route.items.length; i += 1) {
      final double start = (i + 1) * unit;
      final double end = (start + 1.5 * unit).clamp(0.0, 1.0);
      final CurvedAnimation opacity = new CurvedAnimation(
        parent: route.animation,
        curve: new Interval(start, end)
      );
      Widget item = route.items[i];
      if (route.initialValue != null && route.items[i].represents(route.initialValue)) {
        item = new Container(
          color: Theme.of(context).highlightColor,
          child: item,
        );
      }
      children.add(new FadeTransition(
        opacity: opacity,
        child: item,
      ));
    }

    final CurveTween opacity = new CurveTween(curve: const Interval(0.0, 1.0 / 3.0));
    final CurveTween width = new CurveTween(curve: new Interval(0.0, unit));
    final CurveTween height = new CurveTween(curve: new Interval(0.0, unit * route.items.length));

    final Widget child = new ConstrainedBox(
      constraints: new BoxConstraints(
        minWidth: alignWidth ? MediaQuery.of(context).size.width - position.left - position.right : _kMenuMinWidth, 
        maxWidth: alignWidth ? MediaQuery.of(context).size.width - position.left - position.right : double.infinity
      ),
      child: new IntrinsicWidth(
        stepWidth: _kMenuWidthStep,
        child: new Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          label: semanticLabel,
          child: new SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: _kMenuVerticalPadding
            ),
            child: new ListBody(children: children),
          ),
        ),
      ),
    );

    return new AnimatedBuilder(
      animation: route.animation,
      builder: (BuildContext context, Widget child) {
        return new Opacity(
          opacity: opacity.evaluate(route.animation),
          child: new Material(
            type: MaterialType.card,
            elevation: route.elevation,
            child: new Align(
              alignment: AlignmentDirectional.topEnd,
              widthFactor: width.evaluate(route.animation),
              heightFactor: height.evaluate(route.animation),
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}

class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  _PopupMenuRouteLayout(this.position, this.selectedItemOffset, this.textDirection);

  final RelativeRect position;

  final double selectedItemOffset;

  final TextDirection textDirection;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return new BoxConstraints.loose(constraints.biggest - const Offset(_kMenuScreenPadding * 2.0, _kMenuScreenPadding * 2.0));
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {

    double y;
    if (selectedItemOffset == null) {
      y = position.top;
    } else {
      y = position.top + (size.height - position.top - position.bottom) / 2.0 - selectedItemOffset;
    }

    double x;
    if (position.left > position.right) {
      x = size.width - position.right - childSize.width;
    } else if (position.left < position.right) {
      x = position.left;
    } else {
      assert(textDirection != null);
      switch (textDirection) {
        case TextDirection.rtl:
          x = size.width - position.right - childSize.width;
          break;
        case TextDirection.ltr:
          x = position.left;
          break;
      }
    }

    if (x < _kMenuScreenPadding)
      x = _kMenuScreenPadding;
    else if (x + childSize.width > size.width - _kMenuScreenPadding)
      x = size.width - childSize.width - _kMenuScreenPadding;
    if (y < _kMenuScreenPadding)
      y = _kMenuScreenPadding;
    else if (y + childSize.height > size.height - _kMenuScreenPadding)
      y = size.height - childSize.height - _kMenuScreenPadding;
    return new Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) {
    return position != oldDelegate.position;
  }
}

class _PopupMenuRoute<T> extends PopupRoute<T> {
  _PopupMenuRoute({
    this.position,
    this.items,
    this.initialValue,
    this.elevation,
    this.theme,
    this.barrierLabel,
    this.semanticLabel,
    this.alignWidth
  });

  final RelativeRect position;
  final List<IPopupMenuEntry<T>> items;
  final dynamic initialValue;
  final double elevation;
  final ThemeData theme;
  final String semanticLabel;
  final bool alignWidth;

  @override
  Animation<double> createAnimation() {
    return new CurvedAnimation(
      parent: super.createAnimation(),
      curve: Curves.linear,
      reverseCurve: const Interval(0.0, _kMenuCloseIntervalEnd)
    );
  }

  @override
  Duration get transitionDuration => _kMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => null;

  @override
  final String barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    double selectedItemOffset;
    if (initialValue != null) {
      double y = _kMenuVerticalPadding;
      for (IPopupMenuEntry<T> entry in items) {
        if (entry.represents(initialValue)) {
          selectedItemOffset = y + entry.height / 2.0;
          break;
        }
        y += entry.height;
      }
    }

    Widget menu = new _PopupMenu<T>(route: this, semanticLabel: semanticLabel, position: position, alignWidth: alignWidth);
    if (theme != null)
      menu = new Theme(data: theme, child: menu);

    return new MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: new Builder(
        builder: (BuildContext context) {
          return new CustomSingleChildLayout(
            delegate: new _PopupMenuRouteLayout(
              position,
              selectedItemOffset,
              Directionality.of(context),
            ),
            child: menu,
          );
        },
      ),
    );
  }
}

Future<T> showCustomMenu<T>({
  @required BuildContext context,
  RelativeRect position,
  @required List<IPopupMenuEntry<T>> items,
  T initialValue,
  double elevation = 8.0,
  String semanticLabel,
  bool alignWidth = false
}) {
  assert(context != null);
  assert(items != null && items.isNotEmpty);
  String label = semanticLabel;
  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS:
      label = semanticLabel;
      break;
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
      label = semanticLabel ?? MaterialLocalizations.of(context)?.popupMenuLabel;
  }

  return Navigator.push(context, new _PopupMenuRoute<T>(
    alignWidth: alignWidth,
    position: position,
    items: items,
    initialValue: initialValue,
    elevation: elevation,
    semanticLabel: label,
    theme: Theme.of(context, shadowThemeOnly: true),
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
  ));
}

typedef void IPopupMenuItemSelected<T>(T value);

typedef void IPopupMenuCanceled();

typedef List<IPopupMenuEntry<T>> IPopupMenuItemBuilder<T>(BuildContext context);

class IPopupMenuButton<T> extends StatefulWidget {
  
  const IPopupMenuButton({
    Key key,
    @required this.itemBuilder,
    this.initialValue,
    this.onSelected,
    this.onCanceled,
    this.tooltip,
    this.elevation = 8.0,
    this.padding = const EdgeInsets.all(8.0),
    this.child,
    this.icon,
  }) : assert(itemBuilder != null),
       assert(!(child != null && icon != null)), // fails if passed both parameters
       super(key: key);

  final IPopupMenuItemBuilder<T> itemBuilder;

  final T initialValue;
  final IPopupMenuItemSelected<T> onSelected;
  final IPopupMenuCanceled onCanceled;
  final String tooltip;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final Widget child;
  final Icon icon;

  @override
  _IPopupMenuButtonState<T> createState() => new _IPopupMenuButtonState<T>();
}

class _IPopupMenuButtonState<T> extends State<IPopupMenuButton<T>> {
  
  void showButtonMenu() {
    final RenderBox button = context.findRenderObject();
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    final RelativeRect position = new RelativeRect.fromRect(
      new Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showCustomMenu<T>(
      context: context,
      elevation: widget.elevation,
      items: widget.itemBuilder(context),
      initialValue: widget.initialValue,
      position: position,
    ).then<void>((T newValue) {
      if (!mounted)
        return null;
      if (newValue == null) {
        if (widget.onCanceled != null)
          widget.onCanceled();
        return null;
      }
      if (widget.onSelected != null)
        widget.onSelected(newValue);
    });
  }

  Icon _getIcon(TargetPlatform platform) {
    assert(platform != null);
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return const Icon(Icons.more_vert);
      case TargetPlatform.iOS:
        return const Icon(Icons.more_horiz);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child != null
      ? new InkWell(
          onTap: showButtonMenu,
          child: widget.child,
        )
      : new IconButton(
          icon: widget.icon ?? _getIcon(Theme.of(context).platform),
          padding: widget.padding,
          tooltip: widget.tooltip ?? MaterialLocalizations.of(context).showMenuTooltip,
          onPressed: showButtonMenu,
        );
  }
}
