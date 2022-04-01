import 'package:smart_tv_guide/model/channel.dart';

///解放生产力：在线json转dart https://www.devio.org/io/tools/json-to-dart/
class HotProgramModel {
  List<Program> programs = [];
  int maxSize = 0;


  HotProgramModel(this.programs, this.maxSize);

  HotProgramModel.fromJson(Map<String, dynamic> json) {
    maxSize = json['maxSize'];
    if (json['programs'] != null) {
      json['programs'].forEach((v) => programs.add(Program.fromJson(v)));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maxSize'] = maxSize;
    data['programs'] = programs.map((v) => v.toJson()).toList();
    return data;
  }

  @override
  String toString() {
    return 'HomeModel{programs: ${programs.length}, maxSize: $maxSize}';
  }
}
