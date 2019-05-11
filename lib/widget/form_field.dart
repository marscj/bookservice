import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

import './popup_menu.dart';

typedef String TransformValue<T>(T value);

class AnyItem<T> {
  final T value;
  final String valueText;
  final Icon icon;

  AnyItem({
    this.value,
    this.valueText,
    this.icon,
  });
}

class ListTitleField<T> extends StatefulWidget {

  ListTitleField({
    this.lableText,
    this.state,
    this.errorText,
    this.suffixIcon,
    this.valueStyle,
    this.onPressed,
    this.border,
    this.enabled = true,
  });
  
  final String lableText;
  final FormFieldState<AnyItem> state;
  final String errorText;
  final Widget suffixIcon;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final InputBorder border;
  final bool enabled;
  
  @override
  State<ListTitleField> createState() => new _ListTitleFieldState();
}

class _ListTitleFieldState<T> extends State<ListTitleField> {

  bool isFocused = false;
  FocusNode focusNode;

  @override
  void initState() {
    
    super.initState();

    focusNode = new FocusNode()..addListener(onFocusChange);
  }

  @override
  void dispose() {
    
    focusNode.removeListener(onFocusChange);
    super.dispose();
  }

  void onFocusChange() {
    setState(() {
      isFocused = focusNode.hasFocus;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: widget.enabled && widget.onPressed != null ? () {
        FocusScope.of(context).requestFocus(focusNode);
        widget.onPressed();
      } : null,
      child: new InputDecorator(
        decoration: widget.errorText != null ? new InputDecoration(
          labelText: widget.lableText ?? '',
          errorText: widget.errorText,
          enabled: widget.enabled,
          border: widget.border ?? new UnderlineInputBorder()
        ) : new InputDecoration(
          labelText: widget.lableText ?? '',
          enabled: widget.enabled,
          border: widget.border ?? new UnderlineInputBorder()
        ),
        isFocused: isFocused,
        baseStyle: widget.valueStyle,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Expanded(
              child: new Text(widget.state?.value?.valueText ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: widget.valueStyle),
            ),
            new IconTheme(
              data: new IconThemeData(color: _getActiveColor(Theme.of(context))),
              child: widget.suffixIcon,
            ),
          ],
        ),
      )
    );
  }

  Color _getActiveColor(ThemeData themeData) {
    if (widget.enabled) {
      if (isFocused) {
        switch (themeData.brightness) {
          case Brightness.dark:
            return themeData.accentColor;
          default:
            return themeData.primaryColor;
        }
      } else {
        return themeData.hintColor;
      }
    } else {
      return themeData.disabledColor;
    }
  }
}

class _FormField extends FormField<AnyItem> {

  _FormField({
    Key key,
    AnyItem initialValue,
    FormFieldSetter<AnyItem> onSaved,
    FormFieldValidator<AnyItem> validator,
    bool autovalidate = false,
    @required this.controller,
    String lableText,
    Widget suffixIcon,
    TextStyle valueStyle,
    VoidCallback onPressed,
    this.enabled = true,
  }) : 
  super(
    key: key,
    initialValue: initialValue, 
    onSaved: onSaved,
    validator: validator, 
    autovalidate: autovalidate,
    builder: (FormFieldState<AnyItem> field) {
      _FormFieldState state = field;
      return new ListTitleField(
        lableText: lableText,
        state: state,
        errorText: state.errorText,
        suffixIcon: suffixIcon,
        enabled: enabled,
        valueStyle: valueStyle,
        onPressed: onPressed,
      );
    },
  );

  final ValueNotifier<AnyItem> controller;
  final bool enabled;

  @override
  _FormFieldState createState() => new _FormFieldState();
}

class _FormFieldState extends FormFieldState<AnyItem>{

  ValueNotifier get controller => widget.controller;

  @override
  _FormField get widget => super.widget;

  @override
  void initState() {
    super.initState();

    controller.addListener(_handleControllerChanged);
  }

  void _handleControllerChanged() {
    if (controller.value != value) {
      didChange(controller.value);
    }
  }

  @override
  void dispose() {
    controller.removeListener(_handleControllerChanged);
    super.dispose();
  }
}

class AnyFormField extends StatefulWidget{

  AnyFormField.date({
    Key key,
    this.initialValue,
    this.onSaved,
    this.validator,
    this.controller,
    this.lableText,
    this.suffixIcon,
    this.enabled = true,
    this.autovalidate = false,
  }) : flag = 0,
  child = null,
  future = null,
  items = const <AnyItem>[],
  super(
    key: key,
  );

  AnyFormField.time({
    Key key,
    this.initialValue,
    this.onSaved,
    this.validator,
    this.controller,
    this.lableText,
    this.suffixIcon,
    this.enabled = true,
    this.autovalidate = false,
  }) : flag = 1,
  child = null,
  future = null,
  items = const <AnyItem>[],
  super(
    key: key,
  );

  AnyFormField.dialog({
    Key key,
    this.initialValue,
    this.onSaved,
    this.validator,
    this.controller,
    this.lableText,
    this.suffixIcon,
    this.enabled = true,
    this.autovalidate = false,
    @required this.items
  }) : flag = 2,
  child = null,
  future = null,
  super(
    key: key,
  );
  
  AnyFormField.menu({
    Key key,
    this.initialValue,
    this.onSaved,
    this.validator,
    this.controller,
    this.lableText,
    this.suffixIcon,
    this.enabled = true,
    this.autovalidate = false,
    @required this.items
  }) : flag = 3,
  child = null,
  future = null,
  super(
    key: key,
  );

  AnyFormField.bottomSheet({
    Key key,
    this.initialValue,
    this.onSaved,
    this.validator,
    this.controller,
    this.lableText,
    this.suffixIcon,
    this.enabled = true,
    this.autovalidate = false,
    @required this.items
  }) : flag = 4,
  child = null,
  future = null,
  super(
    key: key,     
  );

  AnyFormField.futureWidget({
    Key key,
    this.initialValue,
    this.onSaved,
    this.validator,
    this.controller,
    this.lableText,
    this.suffixIcon,
    this.enabled = true,
    this.autovalidate = false,
    @required this.future
  }) : flag = 5,
  child = null,
  items = const <AnyItem>[], 
  super(
    key: key,
  );

  AnyFormField.fullScreenDialog({
    Key key,
    this.initialValue,
    this.onSaved,
    this.validator,
    this.controller,
    this.lableText,
    this.suffixIcon,
    this.enabled = true,
    this.autovalidate = false,
    @required this.child
  }) : flag = 6,
  future = null,
  items = const <AnyItem>[], 
  super(
    key: key
  );

  final AnyItem initialValue;
  final FormFieldSetter<AnyItem> onSaved;
  final FormFieldValidator<AnyItem> validator;
  final ValueNotifier<AnyItem> controller;
  final String lableText;
  final Widget suffixIcon;
  final bool enabled;
  final bool autovalidate;

  final List<AnyItem> items;
  final Widget child;
  final FutureOr future;
  final int flag;

  @override
  State<AnyFormField> createState() => new AnyFormFieldState();
}

class AnyFormFieldState extends State<AnyFormField> {

  ValueNotifier<AnyItem> controller;

  @override
  void initState() {
    
    super.initState();

    controller = widget.controller ?? new ValueNotifier(widget.initialValue);
  }

  @override
  Widget build(BuildContext context) => switchWidget();

  Widget switchWidget() {
    switch (widget.flag) {
      case 0:
        return date;
      case 1:
        return time;
      case 2:
        return dialog; 
      case 3:
        return menu;
      case 4:
        return bottomSheet;
      case 5:
        return futureWidget;
      case 6:
        return fullScreenDialog;
    }
    return null;
  }

  Widget get date => new _FormField(
    initialValue: controller?.value ?? widget.initialValue,
    onSaved: widget.onSaved,
    validator: widget.validator,
    controller: controller,
    lableText: widget.lableText,
    suffixIcon: new Icon(Icons.event),
    enabled: widget.enabled,
    onPressed: () {
      showDatePicker(
        context: context,
        firstDate: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1),
        lastDate: new DateTime.now().add(new Duration(days: 30)),
        initialDate: widget.initialValue != null ? widget.initialValue.value : new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1),
      ).then((onValue){
        if (onValue != null){
          controller.value = new AnyItem(value: onValue, valueText: DateFormat.yMd("en_US").format(onValue));
        }
      });
    }
  );

  Widget get time => new _FormField(
    initialValue: controller?.value ?? widget.initialValue,
    onSaved: widget.onSaved,
    validator: widget.validator,
    controller: controller,
    lableText: widget.lableText, 
    suffixIcon: new Icon(Icons.schedule),
    enabled: widget.enabled,
    onPressed: () {
      showTimePicker(
        context: context,
        initialTime: widget.initialValue != null ? widget.initialValue.value : new TimeOfDay(hour: 0, minute: 0)
      ).then((onValue){
        if (onValue != null){
          controller.value = new AnyItem(value: onValue, valueText: onValue.format(context));
        }
      });
    }
  );

  Widget get dialog => new _FormField(
    initialValue: controller?.value ?? widget.initialValue,
    onSaved: widget.onSaved,
    validator: widget.validator,
    controller: controller,
    lableText: widget.lableText, 
    suffixIcon: widget.suffixIcon ?? new Icon(Icons.arrow_drop_down),
    enabled: widget.enabled && widget.items != null && widget.items.isNotEmpty,
    onPressed: () {
      showDialog(
        context: context,
        builder: (_){
          return SimpleDialog(
            children: ListTile.divideTiles(context: context, tiles: widget.items.map((item){
              return new ListTile(
                title: new Text(item.valueText),
                trailing:  controller?.value?.value == item.value ?  new Icon(Icons.check) : null,
                onTap: () {
                  Navigator.of(context).pop(item);
                },
              );
            })).toList()
          );
        }
      ).then((onValue){
        if (onValue != null){
          controller.value = onValue;
        }
      });
    }
  );

  Widget get menu => new _FormField(
    initialValue: controller?.value ?? widget.initialValue,
    onSaved: widget.onSaved,
    validator: widget.validator,
    controller: controller,
    lableText: widget.lableText,
    suffixIcon: widget.suffixIcon ?? new Icon(Icons.arrow_drop_down),
    enabled: widget.enabled && widget.items != null && widget.items.isNotEmpty,
    onPressed: () {
      final RenderBox button = context.findRenderObject();
      final RenderBox overlay = Overlay.of(context).context.findRenderObject();
      final RelativeRect position = new RelativeRect.fromRect(
        new Rect.fromPoints(
          button.localToGlobal(button.size.bottomLeft(new Offset(0.0, 2.0)), ancestor: overlay),
          button.localToGlobal(button.size.bottomRight(new Offset(0.0, 2.0)), ancestor: overlay),
        ),
        Offset.zero & overlay.size,
      );

      showCustomMenu(
        context: context,
        items: _dividePopupMenuItem(controller.value, context: context, tiles: widget.items),
        initialValue: widget.initialValue,
        position: position,
        alignWidth: MediaQuery.of(context).size.width - position.left - position.right > MediaQuery.of(context).size.width / 2 ? true : false
      ).then((onValue){
        if (onValue != null){
          controller.value = onValue;
        }
      });
    }
  );

  Widget get bottomSheet => new _FormField(
    initialValue: controller?.value ?? widget.initialValue,
    onSaved: widget.onSaved,
    validator: widget.validator,
    controller: controller,
    lableText: widget.lableText,
    suffixIcon: widget.suffixIcon ?? new Icon(Icons.arrow_drop_down),
    enabled: widget.enabled && widget.items != null && widget.items.isNotEmpty,
    onPressed: () {
      showModalBottomSheet(
        context: context,
        builder: (_) => new ListView(
          padding: kMaterialListPadding,
          children: ListTile.divideTiles(context: context, tiles: widget.items.map((item){
            return new ListTile(
              title: new Text(item.valueText),
              trailing:  controller?.value?.value == item.value ?  new Icon(Icons.check) : null,
              onTap: () {
                Navigator.of(context).pop(item);
              },
            );
          })).toList()
        )
      ).then((onValue){
        if (onValue != null){
          controller.value = onValue;
        }
      });
    }
  );

  Widget get futureWidget => new _FormField(
    initialValue: controller?.value ?? widget.initialValue,
    onSaved: widget.onSaved,
    validator: widget.validator,
    controller: controller,
    lableText: widget.lableText,
    suffixIcon: widget.suffixIcon ?? new Icon(Icons.arrow_drop_down),
    enabled: widget.enabled,
    onPressed: () {
      Future.sync(widget.future).then((onValue){
        if (onValue != null){
          controller.value = onValue;
        }
      });
    }
  );

  Widget get fullScreenDialog => new _FormField(
    initialValue: controller?.value ?? widget.initialValue,
    onSaved: widget.onSaved,
    validator: widget.validator,
    controller: controller,
    lableText: widget.lableText,
    suffixIcon: widget.suffixIcon ?? new Icon(Icons.arrow_drop_down),
    enabled: widget.enabled,
    onPressed: () {
      return Navigator.push<AnyItem>(context, new MaterialPageRoute(
        builder: (_) {
          return widget.child;
        },
        fullscreenDialog: true,
      )).then((onValue){
        if (onValue != null){
          controller.value = onValue;
        }
      });
    }
  );
}

List<IPopupMenuEntry> _dividePopupMenuItem(AnyItem cur, { BuildContext context, @required Iterable<AnyItem> tiles, Color color}){
  assert(tiles != null);
  assert(color != null || context != null);

  final Iterator<AnyItem> iterator = tiles.iterator;
  
  final Decoration decoration = new BoxDecoration(
    border: new Border(
      bottom: Divider.createBorderSide(context, color: color),
    ),
  );

  List<IPopupMenuEntry> res = new List<IPopupMenuEntry>();
  int index = 0;

  for (;iterator.moveNext();) {
    if (index < tiles.length - 1){
      res.add(
        new IPopupMenuItem(
          value: iterator.current,
          height: 60.0,
          child: new DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: decoration,
            child: new ListTile(
              contentPadding: EdgeInsets.zero,
              title: new Text(iterator.current.valueText, maxLines: 2, overflow: TextOverflow.ellipsis),
              dense: true,
              trailing: cur?.value == iterator.current.value ?  new Icon(Icons.check) : null,
            )
          )
        )
      );
    } else { 
      res.add(
        new IPopupMenuItem(
          value: iterator.current,
          height: 60.0,
          child: new ListTile(
            contentPadding: EdgeInsets.zero,
            title: new Text(iterator.current.valueText, maxLines: 2, overflow: TextOverflow.ellipsis),
            dense: true,
            trailing: cur?.value == iterator.current.value ?  new Icon(Icons.check) : null,
          )
        )
      );
    }
    index ++ ;
  }
  return res;
}