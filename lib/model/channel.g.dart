// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChannelAdapter extends TypeAdapter<Channel> {
  @override
  final int typeId = 0;

  @override
  Channel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Channel(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
    )..programs = (fields[5] as List).cast<Program>();
  }

  @override
  void write(BinaryWriter writer, Channel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.displayName)
      ..writeByte(2)
      ..write(obj.about)
      ..writeByte(3)
      ..write(obj.imgURL)
      ..writeByte(4)
      ..write(obj.url)
      ..writeByte(5)
      ..write(obj.programs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChannelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProgramAdapter extends TypeAdapter<Program> {
  @override
  final int typeId = 1;

  @override
  Program read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Program(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as DateTime?,
      fields[4] as DateTime?,
      fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Program obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.channel)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.lang)
      ..writeByte(3)
      ..write(obj.start)
      ..writeByte(4)
      ..write(obj.stop)
      ..writeByte(5)
      ..write(obj.about);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgramAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
