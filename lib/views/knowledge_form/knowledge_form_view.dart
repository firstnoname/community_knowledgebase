import 'dart:io';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:community_knowledgebase/models/models.dart';
import 'package:community_knowledgebase/utilities/constants.dart';
import 'package:community_knowledgebase/utilities/image_selection.dart';
import 'package:community_knowledgebase/utilities/ui_feedback.dart';
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
  html.File? _videoFile;

  List<Uint8List> _imagesWidget = [];

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
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [firstColor, secondColor],
                    stops: [0.5, 1.0],
                  ),
                ),
              ),
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
                              flex: 3,
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
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                            'เลือกวีดีโอ : ${_videoFile?.name ?? ''}'),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: GestureDetector(
                                            onTap: () async {
                                              await getVideo();
                                              setState(() {});
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              child: Icon(Icons.video_library),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      _imagesWidget = await ImageSelection()
                                          .getMultiImagesBytes(context);
                                      setState(() {});
                                    },
                                    child: _imagesWidget.length > 0
                                        ? Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            height: 400,
                                            margin: const EdgeInsets.all(15.0),
                                            padding: const EdgeInsets.all(3.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            child: GridView.count(
                                              crossAxisCount: 2,
                                              children: List.generate(
                                                _imagesWidget.length,
                                                (index) => Container(
                                                  child: _imagesWidget.length >
                                                          0
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Image.memory(
                                                            _imagesWidget[
                                                                index],
                                                          ),
                                                        )
                                                      : Container(
                                                          height: 100,
                                                          width: 100,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Icon(Icons
                                                                  .photo_album),
                                                              Text(
                                                                  'เลือกรูปภาพไม่เกิน 5 รูป')
                                                            ],
                                                          ),
                                                        ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            height: 400,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.photo_album),
                                                Text('เลือกรูปภาพไม่เกิน 5 รูป')
                                              ],
                                            ),
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
                                    images: _imagesWidget, video: _videoFile));
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

  Future getVideo() async {
    _videoFile = await ImagePickerWeb.getVideo(outputType: VideoType.file);

    debugPrint('--Picked Video File--');
    debugPrint(
        '${_videoFile?.name} - ${_videoFile?.size} ${_videoFile!.relativePath}');

    if (_videoFile != null) {
      if (_videoFile!.size > 50000000) {
        UIFeedback(context).showErrorDialog(context,
            title: 'เกิดข้อผิดพลาด',
            content: 'ขนาดวีดีใหญ่เกินไป, เลือกวีดีโอขนาดไม่เกิน 50 MB');
        _videoFile = null;
      }
    }
    setState(() {});
  }

  Future<List<Uint8List>> getMultiImagesBytes() async {
    List<Uint8List> fromPicker =
        (await ImagePickerWeb.getMultiImages(outputType: ImageType.bytes) ?? [])
            as List<Uint8List>;

    if (fromPicker.isNotEmpty) {
      if (fromPicker.length > 10) {
        fromPicker = [];
        UIFeedback(context).showErrorDialog(context,
            title: 'เกิดข้อผิดพลาด',
            content: 'ท่านเลือกรูปจำนวนมากเกินไป, เลือกรูปภาพไม่เกิน 10 รูป');
      }
    }

    return _imagesWidget = fromPicker.map((e) => e).toList();
  }
}
