import 'package:flutter/material.dart';

class Category {
  const Category(this. value, { this.name, this.icon});
  @required final String name;
  @required final Widget icon;
  final int value;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other))
      return true;
    if (runtimeType != other.runtimeType)
      return false;
    final Category typedOther = other;
    return typedOther.name == name && typedOther.icon == icon;
  }

  @override
  int get hashCode => hashValues(name, icon);

  @override
  String toString() {
    return '$runtimeType($name)';
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    Key key,
    this.category,
    this.onTap,
  }) : super (key: key);

  final Category category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return new RepaintBoundary(
      child: new Container(
        alignment: Alignment.center,
        // margin: new EdgeInsets.all(16.0),
        // decoration: new BoxDecoration(
        //   color: Theme.of(context).indicatorColor,
        //   borderRadius: new BorderRadius.circular(8.0)
        // ),
        child: new RawMaterialButton(
          padding: EdgeInsets.zero,
          splashColor: theme.primaryColor.withOpacity(0.12),
          highlightColor: Colors.transparent,
          onPressed: onTap,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.zero,
                child: category.icon,
              ),
              const SizedBox(height: 5.0),
              new Container(
                // height: 48.0,
                alignment: Alignment.center,
                child: new Text(
                  category.name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.subhead.copyWith(
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({
    Key key,
    this.categories,
    this.onCategoryTap,
  }) : super(key: key);

  final Iterable<Category> categories;
  final ValueChanged<Category> onCategoryTap;

  @override
  Widget build(BuildContext context) => new GridView.count(
    crossAxisCount: 2,
    shrinkWrap: true,
    primary: false,
    childAspectRatio: 1.2,
    children: categories.map((item){
      return new SizedBox(
        child: new _CategoryItem(
          category: item,
          onTap: () { 
            onCategoryTap(item);
          },
        ),
      ); 
    }).toList(),
  );

  // @override
  // Widget build(BuildContext context) {
  //   const double aspectRatio = 160.0 / 180.0;
  //   final List<Category> categoriesList = categories.toList();
  //   final int columnCount = (MediaQuery.of(context).orientation == Orientation.portrait) ? 2 : 3;

  //   return new Semantics(
  //     scopesRoute: true,
  //     namesRoute: true,
  //     label: 'categories',
  //     explicitChildNodes: true,
  //     child: new SingleChildScrollView(
  //       key: const PageStorageKey<String>('categories'),
  //       child: new LayoutBuilder(
  //         builder: (BuildContext context, BoxConstraints constraints) {
  //           final double columnWidth = constraints.biggest.width / columnCount.toDouble();
  //           final double rowHeight = math.min(225.0, columnWidth * aspectRatio);
  //           final int rowCount = (categories.length + columnCount - 1) ~/ columnCount;

  //           return new RepaintBoundary(
  //             child: new Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.stretch,
  //               children: new List<Widget>.generate(rowCount, (int rowIndex) {
  //                 final int columnCountForRow = rowIndex == rowCount - 1
  //                   ? categories.length - columnCount * math.max(0, rowCount - 1)
  //                   : columnCount;

  //                 return new Row(
  //                   children: new List<Widget>.generate(columnCountForRow, (int columnIndex) {
  //                     final int index = rowIndex * columnCount + columnIndex;
  //                     final Category category = categoriesList[index];

  //                     return new SizedBox(
  //                       width: columnWidth,
  //                       height: rowHeight,
  //                       child: new _CategoryItem(
  //                         category: category,
  //                         onTap: () {
  //                           onCategoryTap(category);
  //                         },
  //                       ),
  //                     );
  //                   }),
  //                 );
  //               }),
  //             ),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }
}