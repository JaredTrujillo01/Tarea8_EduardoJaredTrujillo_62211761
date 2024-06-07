import 'package:tarea8_crudfirebase/Models/notasmodel.dart';
import 'package:tarea8_crudfirebase/Repositorios/repo_crud.dart';

class NotaService {
  final NotaRepositorio _norepo = NotaRepositorio();

  Future<void> agregarNota(Nota nota) async {
    await _norepo.agregarNota(nota);
  }

  Stream<List<Nota>> obtenerNotas() {
    return _norepo.obtenerNotas();
  }

  Future<Nota?> obtenerNotaPorId(String id) async {
    return await _norepo.obtenerNotaPorId(id);
  }

  Future<void> actualizarNota(Nota nota) async {
    await _norepo.actualizarNota(nota);
  }

  Future<void> eliminarNota(String id) async {
    await _norepo.eliminarNota(id);
  }
}
