import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BotaoSugestaoHorario extends StatelessWidget {
  final DateTime horarioSugerido;
  final VoidCallback onPressed;

  const BotaoSugestaoHorario({
    super.key,
    required this.horarioSugerido,
    required this.onPressed,
  });

  String _formatarHorario(DateTime horario) {
    return DateFormat('HH:mm').format(horario);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 18,
              color: Colors.orange.shade800,
            ),
            const SizedBox(width: 8),
            Text(
              'Sugerido: ${_formatarHorario(horarioSugerido)}',
              style: TextStyle(color: Colors.orange.shade800),
            ),
          ],
        ),
      ),
    );
  }
}
