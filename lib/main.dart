import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicialización compatible con Web y Android
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyByOFBtlL8aCJ0MnZ2OyRMkAgnPId-FJgc",
      authDomain: "cinefilospruebadb.firebaseapp.com",
      projectId: "cinefilospruebadb",
      storageBucket: "cinefilospruebadb.firebasestorage.app",
      messagingSenderId: "36509841084",
      appId: "1:36509841084:web:9f482e9ac7f1ed475f02b9",
    ),
  );

  runApp(const CinefilosCRUDApp());
}



class CinefilosCRUDApp extends StatelessWidget {
  const CinefilosCRUDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cinéfilos - CRUD Firebase',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const PeliculasScreen(),
    );
  }
}

class PeliculasScreen extends StatefulWidget {
  const PeliculasScreen({super.key});

  @override
  State<PeliculasScreen> createState() => _PeliculasScreenState();
}

class _PeliculasScreenState extends State<PeliculasScreen> {
  final CollectionReference _peliculas = FirebaseFirestore.instance.collection('peliculas');

  // Función para precargar 10 películas aleatorias en Firestore
  Future<void> _cargar10PeliculasAleatorias() async {
    final List<Map<String, dynamic>> peliculasAleatorias = [
      {'id_pelicula': 'MOV-001', 'nombre': 'El Padrino', 'anio': 1972, 'director': 'Francis Ford Coppola', 'sinopsis': 'La historia de la familia mafiosa Corleone.', 'valoracion': 5},
      {'id_pelicula': 'MOV-002', 'nombre': 'Interestelar', 'anio': 2014, 'director': 'Christopher Nolan', 'sinopsis': 'Un viaje a través de agujeros de gusano en el espacio.', 'valoracion': 5},
      {'id_pelicula': 'MOV-003', 'nombre': 'Pulp Fiction', 'anio': 1994, 'director': 'Quentin Tarantino', 'sinopsis': 'Historias entrelazadas de violencia y crimen en Los Ángeles.', 'valoracion': 4},
      {'id_pelicula': 'MOV-004', 'nombre': 'El Rey León', 'anio': 1994, 'director': 'Roger Allers, Rob Minkoff', 'sinopsis': 'El joven Simba busca reclamar su trono como rey.', 'valoracion': 5},
      {'id_pelicula': 'MOV-005', 'nombre': 'Matrix', 'anio': 1999, 'director': 'Lana Wachowski, Lilly Wachowski', 'sinopsis': 'Un hacker descubre la verdadera naturaleza de su realidad.', 'valoracion': 4},
      {'id_pelicula': 'MOV-006', 'nombre': 'Forrest Gump', 'anio': 1994, 'director': 'Robert Zemeckis', 'sinopsis': 'La vida extraordinaria de un hombre sencillo.', 'valoracion': 5},
      {'id_pelicula': 'MOV-007', 'nombre': 'Gladiador', 'anio': 2000, 'director': 'Ridley Scott', 'sinopsis': 'Un general romano traicionado busca venganza en la arena.', 'valoracion': 4},
      {'id_pelicula': 'MOV-008', 'nombre': 'Titanic', 'anio': 1997, 'director': 'James Cameron', 'sinopsis': 'Romance a bordo del transatlántico más famoso.', 'valoracion': 4},
      {'id_pelicula': 'MOV-009', 'nombre': 'Jurassic Park', 'anio': 1993, 'director': 'Steven Spielberg', 'sinopsis': 'Un parque temático con dinosaurios clonados sale mal.', 'valoracion': 4},
      {'id_pelicula': 'MOV-010', 'nombre': 'Whiplash', 'anio': 2014, 'director': 'Damien Chazelle', 'sinopsis': 'Un joven baterista es llevado al límite por su profesor.', 'valoracion': 5},
    ];

    for (var pelicula in peliculasAleatorias) {
      await _peliculas.add(pelicula);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡10 películas aleatorias cargadas con éxito!')),
    );
  }

  // Función para Crear o Actualizar Película usando TextFormField
  void _mostrarFormulario([DocumentSnapshot? documentSnapshot]) async {
    String idPel = '';
    String nombre = '';
    int anio = 2023;
    String director = '';
    String sinopsis = '';
    int valoracion = 3;

    if (documentSnapshot != null) {
      final data = documentSnapshot.data() as Map<String, dynamic>;
      idPel = data['id_pelicula'] ?? '';
      nombre = data['nombre'] ?? '';
      anio = data['anio'] ?? 2023;
      director = data['director'] ?? '';
      sinopsis = data['sinopsis'] ?? '';
      valoracion = data['valoracion'] ?? 3;
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  documentSnapshot == null ? 'Crear Nueva Película' : 'Actualizar Película',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  initialValue: idPel,
                  decoration: const InputDecoration(labelText: 'ID de la película (ej. MOV-011)'),
                  onChanged: (value) => idPel = value,
                ),
                TextFormField(
                  initialValue: nombre,
                  decoration: const InputDecoration(labelText: 'Nombre de la película'),
                  onChanged: (value) => nombre = value,
                ),
                TextFormField(
                  initialValue: anio.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Año de lanzamiento'),
                  onChanged: (value) => anio = int.tryParse(value) ?? 2023,
                ),
                TextFormField(
                  initialValue: director,
                  decoration: const InputDecoration(labelText: 'Director'),
                  onChanged: (value) => director = value,
                ),
                TextFormField(
                  initialValue: sinopsis,
                  decoration: const InputDecoration(labelText: 'Sinopsis'),
                  onChanged: (value) => sinopsis = value,
                ),
                TextFormField(
                  initialValue: valoracion.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Valoración (1 a 5 estrellas)'),
                  onChanged: (value) => valoracion = int.tryParse(value) ?? 3,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text(documentSnapshot == null ? 'Crear' : 'Actualizar'),
                    onPressed: () async {
                      if (documentSnapshot == null) {
                        // CREATE: Crear registro en Firestore
                        await _peliculas.add({
                          'id_pelicula': idPel,
                          'nombre': nombre,
                          'anio': anio,
                          'director': director,
                          'sinopsis': sinopsis,
                          'valoracion': valoracion,
                        });
                      } else {
                        // UPDATE: Actualizar registro existente
                        await _peliculas.doc(documentSnapshot.id).update({
                          'id_pelicula': idPel,
                          'nombre': nombre,
                          'anio': anio,
                          'director': director,
                          'sinopsis': sinopsis,
                          'valoracion': valoracion,
                        });
                      }
                      if (!ctx.mounted) return;
                      Navigator.of(ctx).pop();
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // DELETE: Eliminar película por ID de documento
  Future<void> _eliminarPelicula(String productId) async {
    await _peliculas.doc(productId).delete();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Película eliminada correctamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cinéfilos - Catálogo Firebase CRUD'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.playlist_add),
            tooltip: 'Precargar 10 películas aleatorias',
            onPressed: _cargar10PeliculasAleatorias,
          )
        ],
      ),
      // READ: Consultar datos en tiempo real con StreamBuilder
      body: StreamBuilder(
        stream: _peliculas.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            final List<DocumentSnapshot> documents = streamSnapshot.data!.docs;
            if (documents.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'No hay películas registradas. Presiona el botón superior (➕) para precargar 10 películas aleatorias.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot document = documents[index];
                final data = document.data() as Map<String, dynamic>;

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('${data['nombre']} (${data['anio']})', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Director: ${data['director']}'),
                        Text('Sinopsis: ${data['sinopsis']}'),
                        Text('Valoración: ${'⭐' * (data['valoracion'] ?? 1)}'),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _mostrarFormulario(document),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _eliminarPelicula(document.id),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormulario(),
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}