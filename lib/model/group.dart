import 'package:hive_flutter/adapters.dart';
part 'group.g.dart';
@HiveType(typeId: 4)
class Group {
  @HiveField(0)
  late int gid;
  @HiveField(1)
  late int owner;
  @HiveField(2)
  late String name;
  @HiveField(3)
  late DateTime begin;
  @HiveField(4)
  late Map members;

  Group(this.gid, this.owner, this.name, this.begin, this.members);

  Group.fromJson(Map<String, dynamic> json) {
    gid = json['gid'];
    owner = json['owner'];
    name = json['name'];
    begin = DateTime.fromMillisecondsSinceEpoch(json['begin']);
    members = json['members'];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'gid': gid,
        'owner': owner,
        'name': name,
        'begin': begin.millisecondsSinceEpoch,
        'members': members,
      };
}


