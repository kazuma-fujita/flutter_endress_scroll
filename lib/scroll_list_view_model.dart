import 'package:flutter_endress_scroll/item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ScrollListViewModel extends StateNotifier<AsyncValue<Items>> {
  ScrollListViewModel() : super(const AsyncValue.data(Items(items: []))) {
    fetchList();
  }

  static const _addCount = 20;

  Future<void> fetchList() async {
    // if (state is AsyncLoading) {
    //   return;
    // }
    state = const AsyncValue.loading();
    try {
      final newList = await fetchNextListByDummyRepository();
      print('length:${newList.length}');
      state = AsyncValue.data(state.data == null
          ? Items(items: newList)
          : state.data!.value.copyWith(items: newList));
    } on Exception catch (error) {
      state = AsyncValue.error(error);
    }
  }

  Future<List<Item>> fetchNextListByDummyRepository() async =>
      Future.delayed(const Duration(seconds: 2), () {
        final items = <Item>[];
        for (var i = 0; i < _addCount; i++) {
          final id = state.data == null
              ? i + 1
              : state.data!.value.items.length + i + 1;
          items.add(Item(id: id, title: 'Item no. $id'));
        }
        return state.data == null
            ? items
            : [...state.data!.value.items, ...items];
      });
}
