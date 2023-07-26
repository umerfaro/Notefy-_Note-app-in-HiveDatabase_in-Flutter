
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';//this is for showing the data in real time that modify
import 'package:hivedatabase/model/model_notes.dart';
import 'package:hivedatabase/utils/utlis.dart';
import 'package:image_picker/image_picker.dart';
import 'Boxes/Boxies.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController _titlecontroller = TextEditingController();
  TextEditingController _edittitlecontroller = TextEditingController();
  TextEditingController _descritioncontroller = TextEditingController();
  TextEditingController _editdescritioncontroller = TextEditingController();

  File? pickedImage;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();





  SumbitData() async {

    final isValid =_formKey.currentState!.validate();
    if(isValid){
      final data = NotesModel(
        title: _titlecontroller.text.toString(),
        description: _descritioncontroller.text.toString(),
        imageUrl: pickedImage!.path,
      );
      final box = Boxes.getNotes();
      box.add(data);
      data.save();

    }
    Navigator.pop(context);

  }

  // Future getGalleryImage() async {
  //   final pickFile = await picker.pickImage(
  //     source: ImageSource.gallery,
  //     imageQuality: 80,
  //
  //
  //   );
  //
  //   setState(() {
  //     if (pickFile != null) {
  //       pickedImage = File(pickFile.path);
  //     } else {
  //       print('No Image Selected');
  //     }
  //   });
  // }
  @override
  void dispose()
  {
    super.dispose();

    _titlecontroller.dispose();
    _descritioncontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("built");
    return  SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[700],
        appBar: AppBar(
          title:  Text("N O T E L Y",style: TextStyle(color: Colors.grey[700]),),
          backgroundColor: Colors.black,
        ),

        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                  future: Hive.openBox('myBox'),
                  builder: (context,snapshot){
                return ValueListenableBuilder<Box<NotesModel>>(
                  valueListenable: Boxes.getNotes().listenable(),
                  builder: (context,box,_){
                    var data =box.values.toList().cast<NotesModel>();// this is for changes the data into list
                    return ListView.builder(

                      reverse: false,
                        shrinkWrap: true,
                        itemCount: box.length,
                        itemBuilder: (context,index){
                      return Card(
                        color: Colors.grey[400],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              Row(
                                children: [

                                  FullScreenWidget(
                                    disposeLevel: DisposeLevel.Medium,
                                    child: InteractiveViewer(
                                      clipBehavior: Clip.none,
                                      scaleEnabled: true,
                                      maxScale: 2.0, // Set the maximum scale to limit how much the image can be zoomed in
                                      minScale: 1.0, // Set the minimum scale to limit how much the image can be zoomed out// Create a TransformationController
                                      child: Image.file(
                                        File(data[index].imageUrl.toString()),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Text(data[index].title.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                  Spacer(),
                                  IconButton(onPressed: (){

                                    eidtMyDialog(data[index],data[index].title.toString(),data[index].description.toString(),data[index].imageUrl.toString());
                                  }, icon: Icon(Icons.edit)),
                                  SizedBox(width: 10,),

                                  IconButton(onPressed: (){
                                    delete(data[index]);
                                  }, icon: Icon(Icons.delete))
                                ],
                              ),
                              SizedBox(height: 10,),

                              Align(
                                  alignment: Alignment.center,
                                  child: Text(data[index].description.toString())),
                            ],
                          ),
                        ),
                      );
                    });
                },
                );
              }),
            )
          ],

        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            //var box= await Hive.openBox('myBox');

            ShowMyDialog();

            },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void delete(NotesModel notesModel)async{
    await notesModel.delete();
  }





  Future<void> eidtMyDialog(NotesModel notesModel,String title,String descrption,String Images) async {

    _edittitlecontroller.text=title;
    _editdescritioncontroller.text=descrption;

    pickedImage=File(Images);

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Add Notes"),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _edittitlecontroller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Title",
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ),
                                child: pickedImage != null
                                    ? Image.file(
                                  pickedImage!.absolute,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                )
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.image),
                                  onPressed: () async {

                                    final pickFile = await picker.pickImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 80,

                                    );

                                    setState(() {
                                      if (pickFile != null) {
                                        pickedImage = File(pickFile.path);
                                      } else {
                                        print('No Image Selected');
                                      }
                                    });

                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              //key: ,
                              controller: _editdescritioncontroller,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration.collapsed(
                                hintText: "Add Notes",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _edittitlecontroller.clear();
                    _editdescritioncontroller.clear();
                    pickedImage = null;
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {

                    notesModel.title=_edittitlecontroller.text.toString();
                    notesModel.description=_editdescritioncontroller.text.toString();
                    notesModel.imageUrl=pickedImage!.path;
                    await notesModel.save();
                    _edittitlecontroller.clear();
                    _editdescritioncontroller.clear();
                    pickedImage = null;
                    Navigator.pop(context);

                  },
                  child: const Text("Edit"),
                ),
              ],
            );
          },
        );
      },
    );
  }







  Future<void> ShowMyDialog() async {

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Add Notes"),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _titlecontroller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Title",
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ),
                                child: pickedImage != null
                                    ? Image.file(
                                  pickedImage!.absolute,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                )
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.image),
                                  onPressed: () async {

                                    final pickFile = await picker.pickImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 80,

                                    );

                                    setState(() {
                                      if (pickFile != null) {
                                        pickedImage = File(pickFile.path);
                                      } else {
                                        print('No Image Selected');
                                      }
                                    });

                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              //key: ,
                              controller: _descritioncontroller,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration.collapsed(
                                hintText: "Add Notes",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _titlecontroller.clear();
                    _descritioncontroller.clear();
                   pickedImage = null;
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {

                    if(pickedImage==null && _titlecontroller.text.isEmpty && _descritioncontroller.text.isEmpty )  {
                      Utils.flushBarErrorMessage("Please select all fileds", context);
                      return;
                    }
                    else if(pickedImage==null){
                      Utils.flushBarErrorMessage("Please select image", context);
                      return;
                    }
                    else if(_titlecontroller.text.isEmpty){
                      Utils.flushBarErrorMessage("Please enter title", context);
                      return;
                    }
                    else if(_descritioncontroller.text.isEmpty){
                      Utils.flushBarErrorMessage("Please enter description", context);
                      return;
                    }
                    else
                    {

                      SumbitData();
                      _titlecontroller.clear();
                      _descritioncontroller.clear();
                      pickedImage = null;
                    }


                  },
                  child: const Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

}
