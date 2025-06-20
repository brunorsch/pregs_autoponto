import 'package:pregs_autoponto/core/bloc/horas_trabalho_bloc.dart';
import 'package:pregs_autoponto/core/bloc/horas_trabalho_event.dart';
import 'package:pregs_autoponto/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FabRegistrarHorario extends StatelessWidget {
  const FabRegistrarHorario({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        context.read<HorariosTrabalhoBloc>().add(RegistrarHorarioAtualEvent());
      },
      label: const Text(AppStrings.registrarHorario),
      icon: const Icon(Icons.access_time),
    );
  }
}
