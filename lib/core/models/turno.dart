import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'turno.g.dart';

enum TurnoTipo { manha, tarde }

class TurnoSemRegistro {
  final TurnoTipo tipo;
  final Turno turno;

  const TurnoSemRegistro({required this.tipo, required this.turno});
}

@HiveType(typeId: 2)
class Turno extends Equatable {
  @HiveField(0)
  final DateTime? entrada;

  @HiveField(1)
  final DateTime? saida;

  const Turno({this.entrada, this.saida});

  factory Turno.fromJson(Map<String, dynamic> json) {
    return Turno(
      entrada: json['entrada'] != null ? DateTime.parse(json['entrada']) : null,
      saida: json['saida'] != null ? DateTime.parse(json['saida']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entrada': entrada?.toIso8601String(),
      'saida': saida?.toIso8601String(),
    };
  }

  Turno _copyWithNull({DateTime? entrada, DateTime? saida}) {
    return Turno(entrada: entrada, saida: saida);
  }

  Turno copyWith({DateTime? entrada, DateTime? saida}) {
    return _copyWithNull(
      entrada: entrada ?? this.entrada,
      saida: saida ?? this.saida,
    );
  }

  Turno copyWithNull({DateTime? entrada, DateTime? saida}) {
    return _copyWithNull(entrada: entrada, saida: saida);
  }

  Turno withEntrada(DateTime? entrada) {
    return _copyWithNull(entrada: entrada, saida: saida);
  }

  Turno withSaida(DateTime? saida) {
    return _copyWithNull(entrada: entrada, saida: saida);
  }

  Turno copy() {
    return Turno(entrada: entrada, saida: saida);
  }

  int get duracao =>
      saida?.difference(entrada ?? DateTime.now()).inMinutes ?? 0;

  double get duracaoEmHoras => duracao / 60.0;

  bool get isVazio => entrada == null && saida == null;

  @override
  List<Object?> get props => [entrada, saida];
}
