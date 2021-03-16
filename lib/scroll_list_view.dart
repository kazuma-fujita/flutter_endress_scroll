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
  // late final ScrollController _scrollController;
  final _scrollController = ScrollController();
  static const _threshold = 0.8;

  @override
  Widget build(BuildContext context) {
    final state = useProvider(scrollListViewModelProvider.state);
    useEffect(() {
      // _scrollController = ScrollController();
      _addScrollListener(context, state);
      return null;
      // return _scrollController.dispose;
    });

    final data = useProvider(scrollListViewModelProvider.state).data;
    // final items = useProvider(scrollListViewModelProvider.state).data?.value;
    final items = data != null ? data.value.items : const <Item>[];

    // return useProvider(scrollListViewModelProvider.state).when(
    //     data: (data) => ListView.builder(
    //           itemCount: data.items.length,
    //           controller: _scrollController,
    //           itemBuilder: (BuildContext _context, int index) {
    //             print('index: $index');
    //             return _buildRow(data.items[index]);
    //           },
    //         ),
    //     loading: () => const Center(child: CircularProgressIndicator()),
    //     error: (error, _) => Center(
    //           child: Text(error.toString()),
    //         ));

    return ListView.builder(
      itemCount: items.length,
      controller: _scrollController,
      itemBuilder: (BuildContext _context, int index) {
        print('index: $index');
        return _buildRow(items[index]);
      },
    );
  }

  void _addScrollListener(BuildContext context, AsyncValue<Items> state) {
    _scrollController.addListener(() {
      final scrollValue =
          _scrollController.offset / _scrollController.position.maxScrollExtent;
      print(scrollValue);
      if (state is AsyncData &&
          scrollValue != double.infinity &&
          scrollValue > _threshold) {
        print('loadNext');
        context.read(scrollListViewModelProvider).fetchList();
      }
    });
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
}
