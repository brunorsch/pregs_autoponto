import 'package:pregs_autoponto/core/constants/app_strings.dart';
import 'package:pregs_autoponto/core/models/turno.dart';
import 'package:pregs_autoponto/core/models/horarios_trabalho.dart';
import 'package:pregs_autoponto/core/utils/date_utils.dart';
import 'package:pregs_autoponto/widget/botao_sugestao_horario.dart';
import 'package:flutter/material.dart';

class HorarioCard extends StatelessWidget {
  final String rotuloTurno;
  final Turno turno;
  final TurnoTipo turnoTipo;
  final Function(Turno) onEdit;
  final HorariosTrabalho? horariosSugeridos;

  Future<void> _registrarHorarioComTimePicker({
    required BuildContext context,
    TimeOfDay? horarioInicial,
    required Function(DateTime) onEdit,
  }) async {
    final TimeOfDay? novoHorario = await showTimePicker(
      context: context,
      initialTime: horarioInicial ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.inputOnly,
      helpText: AppStrings.selecionarHorario,
      cancelText: AppStrings.cancelar,
      confirmText: AppStrings.confirmar,
      hourLabelText: AppStrings.hora,
      minuteLabelText: AppStrings.minuto,
      builder:
          (BuildContext context, Widget? child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          ),
    );

    if (novoHorario != null) {
      final DateTime agora = DateTime.now();
      final DateTime novoDateTime = DateTime(
        agora.year,
        agora.month,
        agora.day,
        novoHorario.hour,
        novoHorario.minute,
      );
      onEdit(novoDateTime);
    }
  }

  const HorarioCard({
    super.key,
    required this.rotuloTurno,
    required this.turno,
    required this.turnoTipo,
    required this.onEdit,
    this.horariosSugeridos,
  });

  Widget _buildCampoHorario({
    required BuildContext context,
    required String rotulo,
    required TurnoTipo turnoTipo,
    required bool isEntrada,
    required DateTime? horario,
    required Function(DateTime) onEdit,
    required Function() onRemove,
  }) {
    final turnoSugerido = horariosSugeridos?.getByTurnoTipo(turnoTipo);
    final horarioSugerido =
        isEntrada ? turnoSugerido?.entrada : turnoSugerido?.saida;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(rotulo),
        Row(
          children: [
            if (horariosSugeridos != null && horarioSugerido != null) ...[
              BotaoSugestaoHorario(
                horarioSugerido: horarioSugerido,
                onPressed: () => onEdit(horarioSugerido),
              ),
              const SizedBox(width: 8),
            ],
            if (horario == null) ...[
              InkWell(
                onTap:
                    () => _registrarHorarioComTimePicker(
                      context: context,
                      onEdit: onEdit,
                    ),
                child: Tooltip(
                  message: AppStrings.registrar,
                  child: Text(
                    AppStrings.naoRegistrado,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ] else
              Text(HorarioUtils.formatarHorario(horario)),
            if (horario != null) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed:
                    () => _registrarHorarioComTimePicker(
                      context: context,
                      onEdit: onEdit,
                      horarioInicial: TimeOfDay.fromDateTime(horario),
                    ),
                tooltip: AppStrings.editarHorario,
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20),
                onPressed: onRemove,
                tooltip: AppStrings.removerHorario,
              ),
            ],
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(rotuloTurno, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            _buildCampoHorario(
              context: context,
              rotulo: AppStrings.entrada,
              turnoTipo: turnoTipo,
              isEntrada: true,
              horario: turno.entrada,
              onEdit: (horario) => onEdit(turno.withEntrada(horario)),
              onRemove: () => onEdit(turno.withEntrada(null)),
            ),
            const SizedBox(height: 4),
            _buildCampoHorario(
              context: context,
              rotulo: AppStrings.saida,
              turnoTipo: turnoTipo,
              isEntrada: false,
              horario: turno.saida,
              onEdit: (horario) => onEdit(turno.withSaida(horario)),
              onRemove: () => onEdit(turno.withSaida(null)),
            ),
          ],
        ),
      ),
    );
  }
}
