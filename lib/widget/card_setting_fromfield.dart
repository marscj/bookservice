import 'package:flutter/material.dart';

class _CardSettingsField extends StatelessWidget {
  _CardSettingsField({
    this.label: 'Label',
    this.content,
    this.pickerIcon,
    this.errorText,
    this.labelWidth = 120.0,
    this.visible: true,
    this.contentOnNewLine = true,
    this.style = false
  });

  final String label;
  final Widget content;
  final Widget pickerIcon;
  final String errorText;
  final bool visible;
  final bool contentOnNewLine;
  final double labelWidth;
  final bool style;

  @override
  Widget build(BuildContext context) {
    return new Visibility(
      visible: visible,
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.white,
          border: Border(bottom: BorderSide(width: 1.0, color: Theme.of(context).dividerColor)),
        ),
        padding: style ? const EdgeInsets.symmetric(vertical: 14) : const EdgeInsets.all(14),
        child: contentOnNewLine ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildLabel(context),
                _buildRightDecoration()
              ],
            ),
            _buildRowContent(context)
          ],
        ) : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: <Widget>[
            _buildLabel(context),
            new Expanded(
              child: _buildRowContent(context),
            ),
            _buildRightDecoration()
          ],
        ),
      )
    );
  }

  Widget _buildRowContent(context) {
    var decoratedContent = content;

    if (content is TextField || content is TextFormField) {
      // do nothing, these already have built in InputDecorations
    } else {
      final InputDecoration decoration = const InputDecoration()
          .applyDefaults(Theme.of(context).inputDecorationTheme)
          .copyWith(
              errorText: errorText,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none);

      decoratedContent = InputDecorator(decoration: decoration, child: content);
    }

    return Container(
      child: decoratedContent,
    );
  }

  Widget _buildLabel(BuildContext context) {
    return new Container(
      width: labelWidth,
      child:  Text(
        label,
        style: _buildLabelStyle(context),
      )
    );
  }

  TextStyle _buildLabelStyle(BuildContext context) {
    TextStyle labelStyle = style ? Theme.of(context).textTheme.body2: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
    );

    return labelStyle.merge(Theme.of(context).inputDecorationTheme.labelStyle);
  }

  Widget _buildRightDecoration() {
    return pickerIcon != null ? Container(
        alignment: Alignment.centerRight,
        child: pickerIcon
      )
    : Container();
  }
}

class CardSettingsFieldState<T> extends FormField {

  CardSettingsFieldState({
    String label = 'Lable',
    Widget content,
    Widget pickerIcon,
    String errorText,
    bool style = false,
    bool visible = true,
    bool contentOnNewLine = true,
    double labelWidth = 120.0,
    FormFieldValidator validator,
    FormFieldSetter onSaved,
    T initialValue,
    this.controller,
    VoidCallback onPressed
  }) : super(
    initialValue: initialValue,
    validator: validator,
    onSaved: onSaved,
    builder: (FormFieldState field) {
      return new InkWell(
        onTap: onPressed,
        child: new _CardSettingsField(
          label: label,
          content: content,
          style: style,
          pickerIcon: pickerIcon,
          errorText: field.errorText,
          visible: visible,
          labelWidth: labelWidth,
          contentOnNewLine: contentOnNewLine
        )
      );
    }
  );

  final ValueNotifier<T> controller;

  @override
  _CardSettingsFieldStateState createState() => new _CardSettingsFieldStateState();
}

class _CardSettingsFieldStateState extends FormFieldState {}

class CardSettingsHeaderEx extends StatelessWidget {
  CardSettingsHeaderEx({
    this.label,
    this.height: 44.0,
    this.color,
    this.icon,
  });

  final Widget label;
  final double height;
  final Color color;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(color: color ?? Theme.of(context).accentColor),
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          label is Text ? new Padding(
            padding: new EdgeInsets.symmetric(horizontal: 12.0),
            child: new DefaultTextStyle(
              style: Theme.of(context).primaryTextTheme.title,
              child: label,
            )
          ) : label,
          icon ?? new Container()
        ],
      ),
    );
  }
}