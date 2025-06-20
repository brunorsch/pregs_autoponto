class HorarioUtils {
  static String formatarHorario(DateTime? horario) {
    if (horario == null) return 'Não registrado';
    return '${horario.hour.toString().padLeft(2, '0')}:${horario.minute.toString().padLeft(2, '0')}';
  }
}
