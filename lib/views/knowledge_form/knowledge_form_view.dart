import 'dart:io';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:community_knowledgebase/models/models.dart';
import 'package:path/path.dart' as Path;

import 'package:community_knowledgebase/models/knowledge.dart';

import 'package:community_knowledgebase/views/knowledge_form/bloc/knowledge_form_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path_provider/path_provider.dart';

// ignore: must_be_immutable
class KnowledgeFormView extends StatefulWidget {
  final String title;
  KnowledgeFormView({Key? key, required this.title}) : super(key: key);

  @override
  _KnowledgeFormViewState createState() => _KnowledgeFormViewState();
}

class _KnowledgeFormViewState extends State<KnowledgeFormView> {
  Image? _imageWidget;
  MediaInfo? mediaData;

  int? _indexCategory = 0;

  final _formGK = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<KnowledgeFormBloc>(
      create: (context) => KnowledgeFormBloc(context),
      child: BlocBuilder<KnowledgeFormBloc, KnowledgeFormState>(
        buildWhen: (previous, current) {
          if (current is KnowledgeAddSuccess) {
            Navigator.pop(context);
          }
          return true;
        },
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
                                        _imageWidget != null
                                            ? Center(child: _imageWidget!)
                                            : Container(),
                                        Center(
                                          child: IconButton(
                                            onPressed: () async {
                                              _imageWidget = await getImage();
                                              setState(() {});
                                            },
                                            icon: Icon(Icons.image),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                            context.read<KnowledgeFormBloc>().add(
                                KnowledgeFormSubmitted(knowledgeData,
                                    image: mediaData));
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

  Future<List<Image?>> getMultiImages() async {
    List? fromPicker =
        await ImagePickerWeb.getMultiImages(outputType: ImageType.bytes);

    if (fromPicker != null) {
      Uint8List tempImage = fromPicker.first as Uint8List;
      Directory tempDir = await getTemporaryDirectory();
      // final file = await File(tempImage).create();
    }

    return fromPicker as List<Image>;
  }

  Future<Image?> getImage() async {
    mediaData = await ImagePickerWeb.getImageInfo;

    String mimeType = mime(Path.basename(mediaData!.fileName!))!;

    html.File mediaFile =
        html.File(mediaData!.data!, mediaData!.fileName!, {'type': mimeType});

    return _imageWidget = Image.memory(mediaData!.data!);
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
