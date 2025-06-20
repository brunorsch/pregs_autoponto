import 'package:equatable/equatable.dart';
import '../models/horarios_trabalho.dart';

abstract class HorasTrabalhoEvent extends Equatable {
  const HorasTrabalhoEvent();

  @override
  List<Object?> get props => [];
}

class RegistrarHorarioAtualEvent extends HorasTrabalhoEvent {}

class RegistrarHorarioSugeridoEvent extends HorasTrabalhoEvent {
  final DateTime horarioSugerido;

  const RegistrarHorarioSugeridoEvent(this.horarioSugerido);

  @override
  List<Object?> get props => [horarioSugerido];
}

class AtualizarHorasEvent extends HorasTrabalhoEvent {
  final HorariosTrabalho horasTrabalho;

  const AtualizarHorasEvent(this.horasTrabalho);

  @override
  List<Object?> get props => [horasTrabalho];
}

class UndoEvent extends HorasTrabalhoEvent {}

class RedoEvent extends HorasTrabalhoEvent {}

class LimparEvent extends HorasTrabalhoEvent {}

class CarregarHorariosEvent extends HorasTrabalhoEvent {}
