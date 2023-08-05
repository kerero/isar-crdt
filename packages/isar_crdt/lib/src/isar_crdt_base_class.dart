import '../isar_crdt.dart';

abstract class IsarCrdtBase<T> {
  Hlc updateHLCs(T? oldObj);
  void merge(T other);
}
