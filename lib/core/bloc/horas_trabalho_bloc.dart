import 'package:pregs_autoponto/core/models/turno.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/horarios_trabalho.dart';
import '../models/horarios_trabalho_model.dart';
import '../services/hive_service.dart';
import '../utils/stack.dart';
import 'horas_trabalho_event.dart';
import 'horas_trabalho_state.dart';

// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class HorariosTrabalhoBloc
    extends Bloc<HorasTrabalhoEvent, HorasTrabalhoState> {
  final UniqueStack<HorariosTrabalho> _undoStack =
      UniqueStack<HorariosTrabalho>();
  final UniqueStack<HorariosTrabalho> _redoStack =
      UniqueStack<HorariosTrabalho>();
  HorariosTrabalho horariosInicial = HorariosTrabalho();

  HorariosTrabalhoBloc()
    : super(HorasTrabalhoState(horariosTrabalho: HorariosTrabalho())) {
    on<RegistrarHorarioAtualEvent>(_onRegistrarHorarioAtual);
    on<RegistrarHorarioSugeridoEvent>(_onRegistrarHorarioSugerido);
    on<AtualizarHorasEvent>(_onAtualizarHoras);
    on<UndoEvent>(_onUndo);
    on<RedoEvent>(_onRedo);
    on<LimparEvent>(_onLimpar);
    on<CarregarHorariosEvent>(_onCarregarHorarios);

    add(CarregarHorariosEvent());
  }

  void _atualizarHoras(
    HorariosTrabalho horariosTrabalho,
    Emitter<HorasTrabalhoState> emit,
  ) {
    _undoStack.push(horariosTrabalho);

    final horarioSugerido = _calcularSugestaoHorario(horariosTrabalho);

    emit(
      state.copyWith(
        horariosTrabalho: horariosTrabalho,
        canUndo: _undoStack.isNotEmpty,
        canRedo: _redoStack.isNotEmpty,
        horariosSugeridos: horarioSugerido,
      ),
    );

    // Salvar no Hive
    final model = HorariosTrabalhoModel(
      manha: horariosTrabalho.manha,
      tarde: horariosTrabalho.tarde,
    );
    HiveService.save(model);
  }

  void _undo(Emitter<HorasTrabalhoState> emit) {
    if (_undoStack.isNotEmpty) {
      _redoStack.push(_undoStack.pop()!);
    }

    final estadoAnterior =
        _undoStack.isNotEmpty ? _undoStack.top : horariosInicial.copy();

    final horarioSugerido = _calcularSugestaoHorario(estadoAnterior);

    emit(
      state.copyWith(
        horariosTrabalho: estadoAnterior,
        canUndo: _undoStack.isNotEmpty,
        canRedo: _redoStack.isNotEmpty,
        horariosSugeridos: horarioSugerido,
      ),
    );
  }

  void _redo(Emitter<HorasTrabalhoState> emit) {
    if (_redoStack.isEmpty) return;

    var top = _redoStack.pop()!;

    _undoStack.push(top);

    final nextState = top;
    final horariosSugeridos = _calcularSugestaoHorario(nextState);

    emit(
      state.copyWith(
        horariosTrabalho: nextState,
        canUndo: _undoStack.isNotEmpty,
        canRedo: _redoStack.isNotEmpty,
        horariosSugeridos: horariosSugeridos,
      ),
    );
  }

  TurnoSemRegistro? _determinarPrimeiroTurnoSemRegistro() {
    final Map<TurnoTipo, Turno> turnos = {
      TurnoTipo.manha: state.horariosTrabalho.manha,
      TurnoTipo.tarde: state.horariosTrabalho.tarde,
    };

    return turnos.entries
        .map((entry) => TurnoSemRegistro(tipo: entry.key, turno: entry.value))
        .firstWhereOrNull(
          (tested) =>
              tested.turno.entrada == null || tested.turno.saida == null,
        );
  }

  HorariosTrabalho? _calcularSugestaoHorario(
    HorariosTrabalho? horariosTrabalho,
  ) {
    final horarios = horariosTrabalho ?? state.horariosTrabalho;
    final horariosSugeridos = HorariosTrabalho();

    if (horarios.manha.entrada == null) {
      if (horarios.manha.saida != null) {
        return horariosSugeridos.withManha(
          horarios.manha.copyWithNull(
            entrada: horarios.manha.saida!.subtract(const Duration(hours: 4)),
            saida: null,
          ),
        );
      }

      final agora = DateTime.now();
      return horariosSugeridos.withManha(
        horarios.manha.copyWithNull(
          entrada: DateTime(agora.year, agora.month, agora.day, 8, 0),
          saida: null,
        ),
      );
    } else if (horarios.manha.saida == null && horarios.manha.entrada != null) {
      return horariosSugeridos.withManha(
        horarios.manha.copyWithNull(
          entrada: null,
          saida: horarios.manha.entrada!.add(const Duration(hours: 4)),
        ),
      );
    } else if (horarios.tarde.entrada == null && horarios.manha.saida != null) {
      return horariosSugeridos.withTarde(
        horarios.tarde.copyWithNull(
          entrada: horarios.manha.saida!.add(const Duration(hours: 1)),
          saida: null,
        ),
      );
    } else if (horarios.tarde.saida == null && horarios.tarde.entrada != null) {
      return horariosSugeridos.withTarde(
        horarios.tarde.copyWithNull(
          entrada: null,
          saida: horarios.tarde.entrada!.add(const Duration(hours: 4)),
        ),
      );
    } else {
      return HorariosTrabalho();
    }
  }

  void _onRegistrarHorario(DateTime horario, Emitter<HorasTrabalhoState> emit) {
    TurnoSemRegistro? turnoSemRegistro = _determinarPrimeiroTurnoSemRegistro();

    if (turnoSemRegistro == null) {
      return;
    }

    final Turno turnoARegistrar = turnoSemRegistro.turno;
    final bool isManha = turnoSemRegistro.tipo == TurnoTipo.manha;

    final Turno turnoRegistrado =
        turnoARegistrar.entrada == null
            ? turnoARegistrar.copyWith(entrada: horario)
            : turnoARegistrar.copyWith(saida: horario);

    _atualizarHoras(
      isManha
          ? state.horariosTrabalho.withManha(turnoRegistrado)
          : state.horariosTrabalho.withTarde(turnoRegistrado),
      emit,
    );
  }

  void _onRegistrarHorarioAtual(
    RegistrarHorarioAtualEvent event,
    Emitter<HorasTrabalhoState> emit,
  ) {
    final agora = DateTime.now();
    _onRegistrarHorario(agora, emit);
  }

  void _onRegistrarHorarioSugerido(
    RegistrarHorarioSugeridoEvent event,
    Emitter<HorasTrabalhoState> emit,
  ) {
    final horarioSugerido = event.horarioSugerido;
    _onRegistrarHorario(horarioSugerido, emit);
  }

  void _onAtualizarHoras(
    AtualizarHorasEvent event,
    Emitter<HorasTrabalhoState> emit,
  ) {
    _atualizarHoras(event.horasTrabalho, emit);
  }

  void _onUndo(UndoEvent event, Emitter<HorasTrabalhoState> emit) {
    _undo(emit);
  }

  void _onRedo(RedoEvent event, Emitter<HorasTrabalhoState> emit) {
    _redo(emit);
  }

  void _onLimpar(LimparEvent event, Emitter<HorasTrabalhoState> emit) {
    final horasLimpas = HorariosTrabalho();

    if (horasLimpas == state.horariosTrabalho) {
      return;
    }

    _atualizarHoras(horasLimpas, emit);
  }

  void _onCarregarHorarios(
    CarregarHorariosEvent event,
    Emitter<HorasTrabalhoState> emit,
  ) {
    final horariosSalvos = HiveService.get();
    if (horariosSalvos != null) {
      final horariosTrabalho = HorariosTrabalho(
        manha: horariosSalvos.manha,
        tarde: horariosSalvos.tarde,
      );

      horariosInicial = horariosTrabalho.copy();
      final horariosSugeridos = _calcularSugestaoHorario(horariosTrabalho);

      emit(
        state.copyWith(
          horariosTrabalho: horariosTrabalho,
          horariosSugeridos: horariosSugeridos,
        ),
      );
    }
  }
}
