import 'package:flutter_endress_scroll/item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ScrollListViewModel extends StateNotifier<Items> {
  ScrollListViewModel() : super(const Items(items: [])) {
    fetchList();
  }

  static const _addCount = 20;

  Future<void> fetchList() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final newList = await fetchNextListByDummyRepository();
      state = state.copyWith(items: newList, isLoading: false, error: null);
    } on Exception catch (error) {
      state = state.copyWith(error: error.toString(), isLoading: false);
    }
  }

  Future<List<Item>> fetchNextListByDummyRepository() async =>
      Future.delayed(const Duration(seconds: 2), () {
        final items = <Item>[];
        for (var i = 0; i < _addCount; i++) {
          final id = state.items.length + i + 1;
          items.add(Item(id: id, title: 'Item no. $id'));
        }
        return [...state.items, ...items];
      });
}
