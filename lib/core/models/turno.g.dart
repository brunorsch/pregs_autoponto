// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'turno.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TurnoAdapter extends TypeAdapter<Turno> {
  @override
  final int typeId = 2;

  @override
  Turno read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Turno(
      entrada: fields[0] as DateTime?,
      saida: fields[1] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Turno obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.entrada)
      ..writeByte(1)
      ..write(obj.saida);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TurnoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
