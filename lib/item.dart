import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';

@freezed
abstract class Item with _$Item {
  const factory Item({
    required final int id,
    required final String title,
  }) = _Item;
}

@freezed
abstract class Items with _$Items {
  const factory Items({
    required final List<Item> items,
  }) = _Items;
}
