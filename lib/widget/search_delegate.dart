import 'package:flutter/material.dart';

typedef SuggestionBuilder = Widget Function(BuildContext context, String query, ValueChanged onResult);
typedef ResultBuilder<T> = Widget Function(BuildContext context, T query);

class SearchListDelegate<T> extends SearchDelegate {
  
  SearchListDelegate({
    @required this.suggestionBuilder,
    this.resultBuilder
  });


  final SuggestionBuilder suggestionBuilder;
  final ResultBuilder<T> resultBuilder;
  T result;

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return suggestionBuilder(context, query, (value) {
      result = value;
      showResults(context);
    });
  }

  @override
  Widget buildResults(BuildContext context) {
    return resultBuilder(context, result);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      new Visibility(
        visible:  query.isNotEmpty,
        child: IconButton(
          tooltip: 'Clear',
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        )
      )
    ];
  }
}