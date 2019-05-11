import 'package:flutter/material.dart';

class ListMenu<T> {
  
  ListMenu({
    this.value,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.child,
    this.callback
  });

  final T value;
  final String title;
  final String subtitle;
  final Widget leading;
  final Widget trailing;
  final Widget child;
  final VoidCallback callback;
}