import 'package:equatable/equatable.dart';

class UniqueStack<T extends Equatable> {
  final List<T> itens = [];

  bool get isEmpty => itens.isEmpty;
  bool get isNotEmpty => itens.isNotEmpty;
  bool get isNotSingle => isNotEmpty && itens.length > 1;
  T get top => itens.last;

  void push(T item) {
    if (isNotEmpty && top == item) return;

    itens.add(item);
  }

  T? pop() {
    if (isEmpty) return null;
    return itens.removeLast();
  }

  void clear() {
    itens.clear();
  }
}
