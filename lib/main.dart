import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'HomeScreen.dart';
import 'model/model_notes.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var directery = await getApplicationDocumentsDirectory();
  Hive.init(directery.path);

  Hive.registerAdapter(NotesModelAdapter());

await Hive.openBox<NotesModel>('notes');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(

      ),
    );
  }
}


