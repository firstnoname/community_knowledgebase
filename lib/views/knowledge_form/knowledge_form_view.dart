import 'dart:io';
import 'dart:html' as html;
import 'package:community_knowledgebase/models/models.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as Path;

import 'package:community_knowledgebase/models/knowledge.dart';

import 'package:community_knowledgebase/views/knowledge_form/bloc/knowledge_form_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';

// ignore: must_be_immutable
class KnowledgeFormView extends StatefulWidget {
  final String title;
  KnowledgeFormView({Key? key, required this.title}) : super(key: key);

  @override
  _KnowledgeFormViewState createState() => _KnowledgeFormViewState();
}

class _KnowledgeFormViewState extends State<KnowledgeFormView> {
  Image? _imageWidget1;
  Image? _imageWidget2;
  File? _image1;
  File? _image2;

  int? _indexCategory = 0;

  final _formGK = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<KnowledgeFormBloc>(
      create: (context) => KnowledgeFormBloc(context),
      child: BlocBuilder<KnowledgeFormBloc, KnowledgeFormState>(
        builder: (context, state) {
          Knowledge knowledgeData =
              context.read<KnowledgeFormBloc>().knowledgeData;
          List<Category> _categories =
              context.read<KnowledgeFormBloc>().categories;
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                child: Form(
                  key: _formGK,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      // controller: _firstNameTextController,
                                      decoration: InputDecoration(
                                          hintText: 'ชื่อองค์ความรู้'),
                                      onChanged: (value) =>
                                          knowledgeData.knowledgeTitle = value,
                                      validator: (value) {
                                        if (value == null || value.isEmpty)
                                          return 'Please enter some text';
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('เลือกประเภทขององค์ความรู้'),
                                        Row(
                                          children: List<Widget>.generate(
                                              _categories.length,
                                              (index) => Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: ChoiceChip(
                                                      label: Text(
                                                          _categories[index]
                                                              .categoryName!),
                                                      selected:
                                                          _indexCategory ==
                                                              index,
                                                      onSelected:
                                                          (bool selected) {
                                                        setState(() {
                                                          _indexCategory =
                                                              selected
                                                                  ? index
                                                                  : null;
                                                          context
                                                              .read<
                                                                  KnowledgeFormBloc>()
                                                              .add(KnowledgeChangedCategory(
                                                                  _indexCategory!));
                                                        });
                                                      },
                                                    ),
                                                  )),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      // controller: _lastNameTextController,
                                      decoration:
                                          InputDecoration(hintText: 'คำอธิบาย'),
                                      onChanged: (value) => knowledgeData
                                          .knowledgeDesciption = value,

                                      validator: (value) {
                                        if (value == null || value.isEmpty)
                                          return 'Please enter some text';
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      // controller: _usernameTextController,
                                      decoration: InputDecoration(
                                          hintText: 'เนื้อหาขององค์ความรู้'),

                                      maxLines: 15,
                                      onChanged: (value) => knowledgeData
                                          .knowledgeContent = value,

                                      validator: (value) {
                                        if (value == null || value.isEmpty)
                                          return 'Please enter sometext';
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.blueGrey[200],
                              width: 1,
                            ),
                            Container(
                              width: 200,
                              height: 400,
                              child: GridView.count(
                                crossAxisCount: 1,
                                children: [
                                  Container(
                                    color: Colors.grey[200],
                                    child: Stack(
                                      children: [
                                        _imageWidget1 != null
                                            ? _imageWidget1!
                                            : Container(child: Text('Empty')),
                                        IconButton(
                                          onPressed: () async {
                                            _imageWidget1 =
                                                await getSingleImage();
                                            if (_imageWidget1 != null)
                                              setState(() {});
                                          },
                                          icon: Icon(Icons.image),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: Colors.grey[200],
                                    child: Stack(
                                      children: [
                                        _imageWidget2 != null
                                            ? _imageWidget2!
                                            : Container(),
                                        IconButton(
                                          onPressed: () async {
                                            _imageWidget2 =
                                                await getSingleImage();
                                            setState(() {});
                                          },
                                          icon: Icon(Icons.image),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // ----------------------------------------- //
                                  // Container(
                                  //   color: Colors.grey[200],
                                  //   child: Stack(
                                  //     children: [
                                  //       _image1 != null
                                  //           ? Image.file(_image1!)
                                  //           : Container(),
                                  //       IconButton(
                                  //         onPressed: () async {
                                  //           _image1 = (await filePicker())!;
                                  //         },
                                  //         icon: Icon(Icons.image),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  // Container(
                                  //   color: Colors.grey[200],
                                  //   child: Stack(
                                  //     children: [
                                  //       IconButton(
                                  //         onPressed: () async {
                                  //           _image2 = (await filePicker())!;
                                  //         },
                                  //         icon: Icon(Icons.image),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            print(
                                'knowledge data title -> ${knowledgeData.knowledgeTitle}');
                            context
                                .read<KnowledgeFormBloc>()
                                .add(KnowledgeFormSubmitted(knowledgeData));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text('บันทึกข้อมูล'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<File?> filePicker() async {
    File _image = File('');

    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      _image = File(result.files.first.path!);
    } else {
      // User canceled the picker

    }
    return _image;
  }

  Future<Image> getSingleImage() async {
    Image _selectedImage =
        await ImagePickerWeb.getImage(outputType: ImageType.widget) as Image;

    return _selectedImage;
  }

  Future<List<Image>> getImageDevice() async {
    MediaInfo mediaData = await ImagePickerWeb.getImageInfo;
    List<Image> _selectedImage = [];

    if (mediaData.data != null) {
      String mimeType = mime(Path.basename(mediaData.fileName!))!;
      var mediaFile =
          html.File(mediaData.data!, mediaData.fileName!, {'type': mimeType});
      _selectedImage.add(Image.memory(mediaData.data!));
    }

    return _selectedImage;
  }

  Future<List<html.File>> getImagesDevice() async {
    List<html.File> _selectedImage = [];
    _selectedImage =
        (await ImagePickerWeb.getMultiImages(outputType: ImageType.bytes))!
            as List<html.File>;

    String mimeType = mime(Path.basename(_selectedImage[0].name))!;

    return _selectedImage;
  }
}
