import 'package:flutter/material.dart';
import 'package:flutter_endress_scroll/scroll_list_view.dart';
import 'package:flutter_endress_scroll/scroll_list_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final scrollListViewModelProvider = StateNotifierProvider(
  (ref) => ScrollListViewModel(),
);

void main() {
  runApp(
    ProviderScope(
      child: ScrollListView(),
    ),
  );
}
