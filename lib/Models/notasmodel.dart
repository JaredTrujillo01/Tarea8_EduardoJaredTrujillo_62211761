import 'package:cloud_firestore/cloud_firestore.dart';

class Nota {
  String id;
  String descripcion;
  DateTime fecha;
  String estado;
  bool importante;

  Nota({
    required this.id,
    required this.descripcion,
    required this.fecha,
    required this.estado,
    required this.importante,
  });

  factory Nota.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Nota(
      id: doc.id,
      descripcion: data['Descripcion'] ?? '',
      fecha: (data['Fecha'] as Timestamp).toDate(),
      estado: data['Estado'] ?? 'Creado',
      importante: data['Importante'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'Descripcion': descripcion,
      'Fecha': fecha,
      'Estado': estado,
      'Importante': importante,
    };
  }
}
