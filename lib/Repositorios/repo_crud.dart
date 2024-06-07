import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tarea8_crudfirebase/Models/notasmodel.dart';

class NotaRepositorio {
  final FirebaseFirestore _basedatos = FirebaseFirestore.instance;

  Future<void> agregarNota(Nota nota) async {
    await _basedatos.collection('Notas').add(nota.toFirestore());
  }

  Stream<List<Nota>> obtenerNotas() {
    return _basedatos.collection('Notas').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Nota.fromFirestore(doc)).toList());
  }

  Future<Nota?> obtenerNotaPorId(String id) async {
    final doc = await _basedatos.collection('Notas').doc(id).get();
    if (doc.exists) {
      return Nota.fromFirestore(doc);
    }
    return null;
  }

  Future<void> actualizarNota(Nota nota) async {
    await _basedatos
        .collection('Notas')
        .doc(nota.id)
        .update(nota.toFirestore());
  }

  Future<void> eliminarNota(String id) async {
    await _basedatos.collection('Notas').doc(id).delete();
  }
}
