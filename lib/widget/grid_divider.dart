// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

class _GridPaperPainter extends CustomPainter {
  const _GridPaperPainter({
    this.color,
    this.length,
    this.crossAxisCount,
    this.margin,
    this.width:0.5
  });

  final Color color;
  final int length;
  final int crossAxisCount;
  final double width;
  final EdgeInsetsGeometry margin;

  @override
  void paint(Canvas canvas, Size size) {
    
    final Paint linePaint = new Paint()
      ..color = color
      ..strokeWidth = width;

    for (int x = 1; x <= crossAxisCount - 1; x ++) {
      double fontX = size.width / crossAxisCount;
      canvas.drawLine(new Offset(x * fontX, 0.0 + margin.vertical), new Offset(x * fontX, size.height - margin.vertical), linePaint);
    }
    for (int y = 1; y <= (length / crossAxisCount - 1); y ++) {
      double fontY = size.height / (length / crossAxisCount);
      canvas.drawLine(new Offset(margin.horizontal, y * fontY), new Offset(size.width - margin.horizontal, y * fontY), linePaint);
    } 
  }

  @override
  bool shouldRepaint(_GridPaperPainter oldPainter) {
    return oldPainter.color != color
        || oldPainter.length != length
        || oldPainter.crossAxisCount != crossAxisCount
        || oldPainter.margin != margin;
  }

  @override
  bool hitTest(Offset position) => false;
}

class GridDivider extends StatelessWidget {

  const GridDivider({
    Key key,
    this.color: const Color(0x7FC3E8F3),
    this.length,
    this.crossAxisCount,
    this.margin,
    this.child,
  }) : super(key: key);

  final Color color;

  final int length;

  final int crossAxisCount;

  final EdgeInsetsGeometry margin;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      foregroundPainter: new _GridPaperPainter(
        color: color,
        length: length,
        crossAxisCount: crossAxisCount,
        margin: margin,
      ),
      child: child,
    );
  }
}
