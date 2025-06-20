import 'package:pregs_autoponto/core/models/turno.dart';
import 'package:equatable/equatable.dart';
import '../models/horarios_trabalho.dart';

class HorasTrabalhoState extends Equatable {
  final HorariosTrabalho horariosTrabalho;
  final bool canUndo;
  final bool canRedo;
  final HorariosTrabalho? horariosSugeridos;

  const HorasTrabalhoState({
    required this.horariosTrabalho,
    this.canUndo = false,
    this.canRedo = false,
    this.horariosSugeridos,
  });

  HorasTrabalhoState copyWith({
    HorariosTrabalho? horariosTrabalho,
    bool? canUndo,
    bool? canRedo,
    HorariosTrabalho? horariosSugeridos,
  }) {
    return HorasTrabalhoState(
      horariosTrabalho: horariosTrabalho ?? this.horariosTrabalho,
      canUndo: canUndo ?? this.canUndo,
      canRedo: canRedo ?? this.canRedo,
      horariosSugeridos: horariosSugeridos ?? this.horariosSugeridos,
    );
  }

  HorasTrabalhoState withManha(Turno manha) {
    return copyWith(horariosTrabalho: horariosTrabalho.withManha(manha));
  }

  HorasTrabalhoState withTarde(Turno tarde) {
    return copyWith(horariosTrabalho: horariosTrabalho.withTarde(tarde));
  }

  @override
  List<Object?> get props => [
    horariosTrabalho,
    canUndo,
    canRedo,
    horariosSugeridos,
  ];
}
