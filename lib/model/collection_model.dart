import 'package:hive_flutter/adapters.dart';
import 'package:smart_tv_guide/model/channel.dart';

///解放生产力：在线json转dart https://www.devio.org/io/tools/json-to-dart/
part 'collection_model.g.dart';

@HiveType(typeId: 3)
class CollectionModel extends HiveObject {
  @HiveField(0)
  Map channelCollection = {};
  @HiveField(1)
  Map programCollection = {};

  CollectionModel(this.channelCollection, this.programCollection);

  CollectionModel.fromJson(Map<String, dynamic> json) {
    if (json['channel_collection'] != null) {
      channelCollection = json['channel_collection'];
    }
    if (json['program_collection'] != null) {
      programCollection = json['program_collection'].map((key, list) =>
          MapEntry(key, list.map((value) => Program.fromJson(value)).toList()));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['channel_collection'] = channelCollection;
    data['program_collection'] = programCollection.map((key, list) =>
        MapEntry(key, list.map((program) => program.toJson()).toList()));
    return data;
  }

  @override
  String toString() {
    return 'CollectionChannelModel{channelCollection: $channelCollection, programCollection: $programCollection}';
  }
}
