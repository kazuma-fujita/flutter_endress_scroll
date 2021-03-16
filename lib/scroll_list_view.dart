import 'package:flutter/material.dart';
import 'package:flutter_endress_scroll/main.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'item.dart';

class ScrollListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Scroll List'),
        ),
        body: _ScrollListView(),
      ),
    );
  }
}

class _ScrollListView extends HookWidget {
  static const _threshold = 0.7;

  @override
  Widget build(BuildContext context) {
    final state = useProvider(scrollListViewModelProvider.state);

    if (state.error != null) {
      _showErrorSnackBar(state.error!);
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        final scrollProportion =
            scrollInfo.metrics.pixels / scrollInfo.metrics.maxScrollExtent;
        if (!state.isLoading && scrollProportion > _threshold) {
          context.read(scrollListViewModelProvider).fetchList();
        }
        return false;
      },
      child: state.items.isNotEmpty
          ? ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (BuildContext _context, int index) {
                return _buildRow(state.items[index]);
              },
            )
          : _emptyListView(),
    );
  }

  Widget _buildRow(Item item) {
    return SizedBox(
      height: 80,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Text(
            item.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyListView() {
    return const Center(
      child: Text(
        'Item not found.',
        style: TextStyle(
          color: Colors.black54,
          fontSize: 16,
        ),
      ),
    );
  }

  void _showErrorSnackBar(String errorMessage) {
    final context = useContext();
    final snackBar = SnackBar(
      content: Text(errorMessage),
      duration: const Duration(days: 365),
      action: SnackBarAction(
        label: '再試行',
        onPressed: () {
          // 一覧取得
          context.read(scrollListViewModelProvider).fetchList();
          // snackBar非表示
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        },
      ),
    );
    // 全Widgetのbuild後にsnackBarを表示させる
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }
}
