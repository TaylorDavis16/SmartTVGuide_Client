// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CollectionModelAdapter extends TypeAdapter<CollectionModel> {
  @override
  final int typeId = 3;

  @override
  CollectionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CollectionModel(
      (fields[0] as Map).cast<dynamic, dynamic>(),
      (fields[1] as Map).cast<dynamic, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, CollectionModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.channelCollection)
      ..writeByte(1)
      ..write(obj.programCollection);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CollectionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
