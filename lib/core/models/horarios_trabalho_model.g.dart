// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'horarios_trabalho_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HorariosTrabalhoModelAdapter extends TypeAdapter<HorariosTrabalhoModel> {
  @override
  final int typeId = 0;

  @override
  HorariosTrabalhoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HorariosTrabalhoModel(
      manha: fields[0] as Turno,
      tarde: fields[1] as Turno,
    );
  }

  @override
  void write(BinaryWriter writer, HorariosTrabalhoModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.manha)
      ..writeByte(1)
      ..write(obj.tarde);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HorariosTrabalhoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
