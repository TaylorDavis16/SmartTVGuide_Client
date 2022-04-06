import 'package:hive_flutter/adapters.dart';

part 'channel.g.dart';

@HiveType(typeId: 0)
class Channel extends HiveObject {
  @HiveField(0)
  String id = 'unknown';
  @HiveField(1)
  String displayName = 'unknown';
  @HiveField(2)
  String about = 'Nothing here';
  @HiveField(3)
  String imgURL = 'unknown';
  @HiveField(4)
  String url = 'unknown';
  @HiveField(5)
  List<Program> programs = <Program>[];

  Channel(this.id, this.displayName, this.about, this.imgURL, this.url);

  Channel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['displayName'];
    about = json['about'];
    if (json['imgURL'] != null) {
      imgURL = json['imgURL'];
    }
    url = json['url'];
    if (json['programs'] != null) {
      json['programs'].forEach((v) {
        programs.add(Program.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['displayName'] = displayName;
    data['about'] = about;
    data['img'] = imgURL;
    data['url'] = url;
    if (programs.isNotEmpty) {
      data['programs'] = programs.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Channel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          displayName == other.displayName;

  @override
  int get hashCode => id.hashCode ^ displayName.hashCode;
}

@HiveType(typeId: 1)
class Program extends HiveObject {
  @HiveField(0)
  String channel = '';
  @HiveField(1)
  String title = 'Unknown';
  @HiveField(2)
  String lang = 'Unknown';
  @HiveField(3)
  DateTime? start;
  @HiveField(4)
  DateTime? stop;
  @HiveField(5)
  String about = 'Unknown';

  Program(
      this.channel, this.title, this.lang, this.start, this.stop, this.about);

  Program.fromJson(Map<String, dynamic> json) {
    channel = json['channel'];
    title = json['title'];
    lang = json['lang'];
    start = DateTime.parse(json['start']);
    stop = DateTime.parse(json['stop']);
    about = json['about'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['channel'] = channel;
    data['title'] = title;
    data['lang'] = lang;
    data['start'] = start.toString();
    data['stop'] = stop.toString();
    data['about'] = about;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Program &&
          runtimeType == other.runtimeType &&
          channel == other.channel &&
          title == other.title;

  @override
  int get hashCode => channel.hashCode ^ title.hashCode;

  @override
  String toString() {
    return 'Program{channel: $channel, title: $title, lang: $lang, start: $start, stop: $stop, about: $about}';
  }
}
