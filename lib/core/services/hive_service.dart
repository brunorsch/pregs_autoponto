import 'package:hive_flutter/hive_flutter.dart';
import '../models/horarios_trabalho_model.dart';
import '../models/turno.dart';

class HiveService {
  static const String _boxName = 'horarios_trabalho';
  static const String _key = 'horarios';

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(HorariosTrabalhoModelAdapter());
    Hive.registerAdapter(TurnoAdapter());

    await Hive.openBox<HorariosTrabalhoModel>(_boxName);
  }

  static Future<void> save(HorariosTrabalhoModel horarios) async {
    final box = Hive.box<HorariosTrabalhoModel>(_boxName);
    await box.put(_key, horarios);
  }

  static HorariosTrabalhoModel? get() {
    final box = Hive.box<HorariosTrabalhoModel>(_boxName);
    return box.get(_key);
  }
}
