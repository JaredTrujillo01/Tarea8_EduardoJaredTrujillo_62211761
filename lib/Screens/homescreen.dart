import 'package:flutter/material.dart';
import 'package:tarea8_crudfirebase/Models/notasmodel.dart';
import 'package:tarea8_crudfirebase/Services/Service_nota.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  final NotaService _notaService = NotaService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "CRUD",
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          _mostrarDialogoAgregarNota(context);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder<List<Nota>>(
        stream: _notaService.obtenerNotas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No hay notas');
          } else {
            final notas = snapshot.data!;
            return ListView.builder(
              itemCount: notas.length,
              itemBuilder: (context, index) {
                final nota = notas[index];
                return ListTile(
                  title: Text(nota.descripcion),
                  subtitle: Text(nota.fecha.toString()),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _mostrarDialogoEditarNota(context, nota);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await _notaService.eliminarNota(nota.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _mostrarDialogoAgregarNota(BuildContext context) {
    final TextEditingController descripcionController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Nota'),
          content: TextField(
            controller: descripcionController,
            decoration: InputDecoration(labelText: 'Descripción'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () async {
                final nuevaNota = Nota(
                  id: '',
                  descripcion: descripcionController.text,
                  fecha: DateTime.now(),
                  estado: 'creado',
                  importante: false,
                );
                await _notaService.agregarNota(nuevaNota);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoEditarNota(BuildContext context, Nota nota) {
    final TextEditingController descripcionController =
        TextEditingController(text: nota.descripcion);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Nota'),
          content: TextField(
            controller: descripcionController,
            decoration: InputDecoration(labelText: 'Descripción'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () async {
                final notaActualizada = Nota(
                  id: nota.id,
                  descripcion: descripcionController.text,
                  fecha: nota.fecha,
                  estado: nota.estado,
                  importante: nota.importante,
                );
                await _notaService.actualizarNota(notaActualizada);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
