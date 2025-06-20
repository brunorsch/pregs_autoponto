import 'package:pregs_autoponto/core/models/turno.dart';
import 'package:equatable/equatable.dart';

class HorariosTrabalho extends Equatable {
  final Turno manha;
  final Turno tarde;

  const HorariosTrabalho({
    this.manha = const Turno(),
    this.tarde = const Turno(),
  });

  HorariosTrabalho copyWith({Turno? manha, Turno? tarde}) {
    return HorariosTrabalho(
      manha: manha ?? this.manha,
      tarde: tarde ?? this.tarde,
    );
  }

  HorariosTrabalho copy() {
    return HorariosTrabalho(manha: manha.copy(), tarde: tarde.copy());
  }

  HorariosTrabalho withTarde(Turno tarde) {
    return copyWith(tarde: tarde);
  }

  HorariosTrabalho withManha(Turno manha) {
    return copyWith(manha: manha);
  }

  Turno getByTurnoTipo(TurnoTipo turnoTipo) {
    return turnoTipo == TurnoTipo.manha ? manha : tarde;
  }

  @override
  String toString() {
    return manha.isVazio && tarde.isVazio
        ? 'HorariosTrabalho{vazio}'
        : 'HorariosTrabalho{manha: $manha, tarde: $tarde}';
  }

  @override
  List<Object?> get props => [manha, tarde];
}
