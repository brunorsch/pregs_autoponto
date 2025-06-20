import 'package:equatable/equatable.dart';
import '../models/horarios_trabalho.dart';

abstract class HorasTrabalhoEvent extends Equatable {
  const HorasTrabalhoEvent();

  @override
  List<Object?> get props => [];
}

class RegistrarHorarioEvent extends HorasTrabalhoEvent {}

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
