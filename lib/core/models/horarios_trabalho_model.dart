import 'package:hive/hive.dart';
import 'turno.dart';

part 'horarios_trabalho_model.g.dart';

@HiveType(typeId: 0)
class HorariosTrabalhoModel extends HiveObject {
  @HiveField(0)
  Turno manha;

  @HiveField(1)
  Turno tarde;

  HorariosTrabalhoModel({required this.manha, required this.tarde});

  factory HorariosTrabalhoModel.fromJson(Map<String, dynamic> json) {
    return HorariosTrabalhoModel(
      manha: Turno.fromJson(json['manha']),
      tarde: Turno.fromJson(json['tarde']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'manha': manha.toJson(), 'tarde': tarde.toJson()};
  }
}
