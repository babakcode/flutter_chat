import 'package:chat_babakcode/models/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

abstract class AppCollections {
  Future<Map<String, dynamic>> toSaveFormat();
}

// class SaveFormatType {
//   dynamic value;
//
//   String? get type => _type;
//   String? _type;
//
//   SaveFormatType.id(dynamic a) {
//     _type = 'id';
//     if (a.runtimeType != String && a.runtimeType != int) {
//       throw ErrorWidget('the id must be int or string');
//     }
//     value = a;
//   }
//
//   SaveFormatType.int(int? a) {
//     _type = 'int';
//     value = a;
//   }
//
//   SaveFormatType.double(double? d) {
//     _type = 'double';
//     value = d;
//   }
//
//   SaveFormatType.string(String? d) {
//     _type = 'string';
//     value = d;
//   }
//
//   SaveFormatType.bool(bool? d) {
//     _type = 'bool';
//     value = d;
//   }
//
//   SaveFormatType.map(Map<String, SaveFormatType>? map) {
//     _type = 'map';
//     value = map;
//   }
//
//   SaveFormatType.backLinks(BackLinks d) {
//     _type = 'backLinks';
//     value = d;
//   }
//
//   SaveFormatType.list(List<GlobalCollections>? list) {
//     _type = 'list';
//     value = list;
//   }
// }
//

// class ObjectStringId{
//   String? id;
//   ObjectStringId(String id, {String? ref});
// }


// class SavableObject<E extends AppCollections>{
//
//   late Box<Map> _hiveBox;
//
//   String _idKeyName = '_id';
//   SavableObject({required String collection, String? idKeyName}) {
//     _hiveBox = Hive.box<Map>(collection);
//     if(idKeyName != null){
//       _idKeyName = idKeyName;
//     }
//   }
//   dynamic objectId;
//   E? object;
//
//   String unPopulate(){
//     return object?.toSaveFormat()[_idKeyName];
//   }
//   E populate(){
//     _hiveBox.get(objectId);
//   }
// }

class SavableList<E extends AppCollections> {

  late Box<Map> _hiveBox;

  SavableList({required String collection}) {
    _hiveBox = Hive.box<Map>(collection);
  }

  List<E> _list = [];

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;

  int get length => _list.length;

  void addAll(List<E> addAll) async {
    /// for chats
    _list = addAll;
    // saveList();
    // if(await _validateList(addAll)){
    // }
  }

  void saveList() async {
    for (var item in _list) {
      final _saveMap = item.toSaveFormat();
      final _docId = (await _saveMap).values.where((element) => element.type == 'id');
      if (_docId.length != 1) {
        throw HiveError(
            'the document must have an id that is int or string type');
      }

      _hiveBox.put(_docId.elementAt(0).value,
          (await _saveMap).map((key, value) => MapEntry(key,value.value)));
    }
  }

  void getAllData() {
    // print(_hiveBox.values);
  }

  // Future<bool> _validateList(List<E> addAll) async {
  //   for(var item in addAll){
  //     if((await item.toSaveFormat()).values.where((element) => element != 'wadjkawdawd').isNotEmpty){
  //       throw ErrorHint('errrrrrrrrrrrrrrroooooooooooooooooorrrrrrrrrrrrrrrrr');
  //     }
  //   }
  //   return true;
  // }

  void add(E e) async{
    _list.add(e);
  }

  Iterable<E> where(bool Function(E element) test){
    return _list.where(test);
  }

  E firstWhere(bool Function(E element) test) {
    return _list.firstWhere(test);
  }

  void sort([int Function(E a, E b)? compare]) {
    _list.sort(compare);
  }

  int indexWhere(bool Function(E element) test) {
    return _list.indexWhere(test);
  }

  int indexOf(E e) {
    return _list.indexOf(e);
  }

  E get(int i) {
    return _list[i];
  }

  Iterable<E> map(E Function(E e) test) {
    return _list.map(test);
  }

// remove(){}
// find(){}
}
