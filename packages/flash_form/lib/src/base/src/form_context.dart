import 'dart:async';

import 'package:flash_form/flash_form.dart';

class FormContext {
  FormContext();

  final StreamController<FormEvent> _eventController =
      StreamController<FormEvent>.broadcast();

  // 親と子の関係を管理するためのマップ
  final Map<int, List<int>> _idMap = {};

  // 自身のFieldSchemaのタイプを管理するためのマップ
  final Map<int, FieldSchema> _schemaMap = {};

  Stream<FormEvent> get eventStream => _eventController.stream;

  var maxId = 0;

  int generateId() {
    final newId = (maxId + 1);
    maxId = newId;
    return newId;
  }

  void registerId({
    required int id,
    required int? parentId,
    required FieldSchema schema,
  }) {
    _idMap[id] = [];
    _schemaMap[id] = schema;

    /// 親のキーを取得
    if (parentId != null) {
      if (!_idMap.containsKey(parentId)) {
        _idMap[parentId] = [];
      }
      _idMap[parentId]!.add(id);
    }
  }

  int? getParentId(int id) {
    final parentIds = _idMap.entries
        .where((entry) => entry.value.contains(id))
        .map((entry) => entry.key);

    if (parentIds.isEmpty) {
      return null;
    }

    if (parentIds.length > 1) {
      throw Exception('Multiple parents found for id: $id');
    }

    return parentIds.first;
  }

  bool isParentChild({
    required int childId,
    required int parentId,
  }) =>
      _idMap[parentId]?.contains(childId) ?? false;

  bool isListItem(int id) {
    final parentId = getParentId(id);
    final parentSchema = parentId != null ? _schemaMap[parentId] : null;
    return parentSchema?.fieldType == SchemaType.list;
  }

  void removeId(int id) {
    _removeId(id);

    // idを持っているリストから削除する
    for (var entry in _idMap.entries) {
      final children = entry.value;
      if (children.contains(id)) {
        children.remove(id);
      }
    }
  }

  void _removeId(int id) {
    // idに子供がいる場合は遡って削除する
    final children = _idMap[id];
    if (children != null) {
      for (var childId in children) {
        _removeId(childId);
      }
    }

    _idMap.remove(id);
    _schemaMap.remove(id);
  }

  void sendEvent(FormEvent event) {
    _eventController.add(event);
  }

  int indexOf(int id) {
    final parentId = getParentId(id);
    if (parentId == null) {
      return -1;
    }

    final parentChildren = _idMap[parentId];
    if (parentChildren == null) {
      return -1;
    }

    return parentChildren.indexOf(id);
  }

  /// 木構造のネストの深さを取得する
  int depthOf(int id) {
    final parentId = getParentId(id);
    if (parentId == null) {
      return 0;
    }

    return depthOf(parentId) + 1;
  }

  /// 木構造でルートまでに何回[SchemaType]が出現するかを取得する
  int countTypeOf(int id, SchemaType type) {
    final parentId = getParentId(id);
    if (parentId == null) {
      return 0;
    }

    if (_schemaMap[parentId] == type) {
      return countTypeOf(parentId, type) + 1;
    }

    return countTypeOf(parentId, type);
  }

  FieldSchema<TValue, TView>? getSchemaById<TValue, TView>(int id) {
    final schema = _schemaMap[id];

    if (schema is FieldSchema<TValue, TView>) {
      return schema;
    }

    return null;
  }
}
