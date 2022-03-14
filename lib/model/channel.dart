class Channel {
  String id = 'unknown';
  String displayName = 'unknown';
  String about = 'Nothing here';
  String imgURL = 'unknown';
  String url = 'unknown';
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
}

class Program {
  String channel = '';
  String title = 'Unknown';
  String lang = 'Unknown';
  DateTime? start;
  DateTime? stop;
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
    data['name'] = title;
    data['lang'] = lang;
    data['start'] = start.toString();
    data['stop'] = stop.toString();
    data['about'] = about;
    return data;
  }
}
