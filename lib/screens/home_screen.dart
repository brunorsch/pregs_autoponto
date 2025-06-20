import 'package:pregs_autoponto/core/models/turno.dart';
import 'package:pregs_autoponto/widget/botao_limpar.dart';
import 'package:pregs_autoponto/widget/fab_registrar_horario.dart';
import 'package:pregs_autoponto/widget/horario_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/bloc/horas_trabalho_bloc.dart';
import '../core/bloc/horas_trabalho_event.dart';
import '../core/bloc/horas_trabalho_state.dart';
import '../core/constants/app_strings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _buildHorarioCard({
    required BuildContext context,
    required HorasTrabalhoState state,
    required TurnoTipo turnoTipo,
  }) {
    final bool isManha = turnoTipo == TurnoTipo.manha;

    return HorarioCard(
      rotuloTurno: isManha ? AppStrings.turnoManha : AppStrings.turnoTarde,
      turno:
          isManha ? state.horariosTrabalho.manha : state.horariosTrabalho.tarde,
      turnoTipo: turnoTipo,
      horariosSugeridos: state.horariosSugeridos,
      onEdit: (turno) {
        context.read<HorariosTrabalhoBloc>().add(
          AtualizarHorasEvent(
            isManha
                ? state.horariosTrabalho.copyWith(manha: turno)
                : state.horariosTrabalho.copyWith(tarde: turno),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HorariosTrabalhoBloc(),
      child: BlocBuilder<HorariosTrabalhoBloc, HorasTrabalhoState>(
        builder: (context, state) {
          return KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) {
              final isControlPressed =
                  HardwareKeyboard.instance.isControlPressed;
              final isMetaPressed = HardwareKeyboard.instance.isMetaPressed;
              final isModifierPressed = isControlPressed || isMetaPressed;

              if (event.logicalKey == LogicalKeyboardKey.keyZ &&
                  isModifierPressed) {
                context.read<HorariosTrabalhoBloc>().add(UndoEvent());
              } else if (event.logicalKey == LogicalKeyboardKey.keyY &&
                  isModifierPressed) {
                context.read<HorariosTrabalhoBloc>().add(RedoEvent());
              }
            },
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: const Text(AppStrings.appName),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.undo),
                    onPressed:
                        state.canUndo
                            ? () => context.read<HorariosTrabalhoBloc>().add(
                              UndoEvent(),
                            )
                            : null,
                    tooltip: 'Desfazer (Ctrl+Z)',
                  ),
                  IconButton(
                    icon: const Icon(Icons.redo),
                    onPressed:
                        state.canRedo
                            ? () => context.read<HorariosTrabalhoBloc>().add(
                              RedoEvent(),
                            )
                            : null,
                    tooltip: 'Refazer (Ctrl+Y)',
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHorarioCard(
                      context: context,
                      state: state,
                      turnoTipo: TurnoTipo.manha,
                    ),
                    const SizedBox(height: 16),
                    _buildHorarioCard(
                      context: context,
                      state: state,
                      turnoTipo: TurnoTipo.tarde,
                    ),
                    const SizedBox(height: 16),
                    BotaoLimpar(),
                  ],
                ),
              ),
              floatingActionButton: FabRegistrarHorario(),
            ),
          );
        },
      ),
    );
  }
}
