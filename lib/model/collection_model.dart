import 'package:smart_tv_guide/model/channel.dart';

///解放生产力：在线json转dart https://www.devio.org/io/tools/json-to-dart/
class CollectionChannelModel {
  String? name;
  Map<String, List<String>> collection = {};

  CollectionChannelModel(this.name, this.collection);

  CollectionChannelModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['data'] != null) {
      json['data'].forEach((key, values) =>
          collection[key] = values);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    final Map<String, dynamic> data1 = <String, dynamic>{};
    data['name'] = name;
    for (var entry in collection.entries) {
      data1[entry.key] = entry.value;
    }
    data['collection'] = data1;
    return data;
  }

  @override
  String toString() {
    return 'HomeModel{name: $name, collection: ${collection.length}}';
  }
}

class CollectionProgramModel {
  String? name;
  Map<String, List<Program>> collection = {};

  CollectionProgramModel(this.name, this.collection);

  CollectionProgramModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['data'] != null) {
      json['data'].forEach((key, values) =>
      collection[key] = values.map((e) => Program.fromJson(e)).toList());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    final Map<String, dynamic> data1 = <String, dynamic>{};
    data['name'] = name;
    for (var entry in collection.entries) {
      data1[entry.key] = entry.value.map((e) => e.toJson()).toList();
    }
    data['collection'] = data1;
    return data;
  }

  @override
  String toString() {
    return 'HomeModel{name: $name, collection: ${collection.length}}';
  }
}
