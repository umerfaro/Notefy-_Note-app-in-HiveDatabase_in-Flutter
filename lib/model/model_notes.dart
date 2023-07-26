
import 'package:hive/hive.dart';
part 'model_notes.g.dart';

@HiveType(typeId: 0)// use this if we make more model to differentiate it
class NotesModel extends HiveObject{

  @HiveField(0)
  String? title;

  @HiveField(1)
  String? description;
  @HiveField(2)
  String? imageUrl;

  NotesModel({required this.title, required this.description,required this.imageUrl});


}