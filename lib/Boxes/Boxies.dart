
import 'package:hive/hive.dart';

import '../model/model_notes.dart';

class Boxes{
  static Box<NotesModel> getNotes()=>Hive.box<NotesModel>('notes');
}