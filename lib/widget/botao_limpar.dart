import 'package:pregs_autoponto/core/bloc/horas_trabalho_bloc.dart';
import 'package:pregs_autoponto/core/bloc/horas_trabalho_event.dart';
import 'package:pregs_autoponto/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BotaoLimpar extends StatelessWidget {
  const BotaoLimpar({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => context.read<HorariosTrabalhoBloc>().add(LimparEvent()),
      icon: const Icon(Icons.delete_sweep),
      label: const Text(AppStrings.limparTodos),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.error,
        foregroundColor: Theme.of(context).colorScheme.onError,
        minimumSize: const Size(double.infinity, 48),
      ),
    );
  }
}
