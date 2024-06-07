import 'package:flutter/material.dart';
import 'package:tarea8_crudfirebase/Models/notasmodel.dart';
import 'package:tarea8_crudfirebase/Services/Service_nota.dart';
import 'package:intl/intl.dart';

class HomeScreens extends StatefulWidget {
  @override
  _HomeScreensState createState() => _HomeScreensState();
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
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          _agregarNota(context);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder<List<Nota>>(
        stream: _notaService.obtenerNotas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay notas'));
          } else {
            final notas = snapshot.data!;
            return ListView.builder(
              itemCount: notas.length,
              itemBuilder: (context, index) {
                final nota = notas[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      nota.descripcion,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fecha: ${DateFormat('yyyy-MM-dd').format(nota.fecha)}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            'Estado: ${nota.estado}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            'Importante: ${nota.importante ? 'Sí' : 'No'}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _editarNota(context, nota);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await _notaService.eliminarNota(nota.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _agregarNota(BuildContext context) {
    final TextEditingController descripcionController = TextEditingController();
    String estado = 'creado';
    bool importante = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Nota'),
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: descripcionController,
                        decoration: InputDecoration(
                          labelText: 'Descripción',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text('Estado',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      DropdownButton<String>(
                        value: estado,
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            estado = newValue!;
                          });
                        },
                        items: <String>[
                          'creado',
                          'por hacer',
                          'trabajando',
                          'finalizado'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text('Importante',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Checkbox(
                            value: importante,
                            onChanged: (bool? value) {
                              setState(() {
                                importante = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
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
                  estado: estado,
                  importante: importante,
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

  void _editarNota(BuildContext context, Nota nota) {
    final TextEditingController descripcionController =
        TextEditingController(text: nota.descripcion);
    String estado = nota.estado;
    bool importante = nota.importante;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Nota'),
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: descripcionController,
                        decoration: InputDecoration(
                          labelText: 'Descripción',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text('Estado',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      DropdownButton<String>(
                        value: estado,
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            estado = newValue!;
                          });
                        },
                        items: <String>[
                          'creado',
                          'por hacer',
                          'trabajando',
                          'finalizado'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text('Importante',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Checkbox(
                            value: importante,
                            onChanged: (bool? value) {
                              setState(() {
                                importante = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
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
                  estado: estado,
                  importante: importante,
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
