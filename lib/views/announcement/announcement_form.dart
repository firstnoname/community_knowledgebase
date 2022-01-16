import 'dart:typed_data';

import 'package:community_knowledgebase/utilities/constants.dart';
import 'package:community_knowledgebase/utilities/image_selection.dart';
import 'package:path/path.dart' as Path;
import 'dart:html' as html;
import 'dart:io';

import 'package:community_knowledgebase/models/announcement.dart';
import 'package:community_knowledgebase/views/announcement/bloc/announcement_form_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';

class AnnouncementForm extends StatefulWidget {
  AnnouncementForm({Key? key}) : super(key: key);

  @override
  _AnnouncementFormState createState() => _AnnouncementFormState();
}

class _AnnouncementFormState extends State<AnnouncementForm> {
  final _formGK = GlobalKey<FormState>();
  Image? _imageWidget;
  MediaInfo? mediaData;
  List<Uint8List> _imagesWidget = [];

  Future getImage() async {
    mediaData = await ImagePickerWeb.getImageInfo;

    String mimeType = mime(Path.basename(mediaData!.fileName!))!;

    html.File mediaFile =
        html.File(mediaData!.data!, mediaData!.fileName!, {'type': mimeType});

    setState(() {
      _imageWidget = Image.memory(mediaData!.data!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnnouncementFormBloc(context),
      child: BlocBuilder<AnnouncementFormBloc, AnnouncementFormState>(
        builder: (context, state) {
          Announcement announcement =
              context.read<AnnouncementFormBloc>().announchment;
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
              title: Text('สร้างประกาศ'),
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
                                      decoration:
                                          InputDecoration(hintText: 'หัวข้อ'),
                                      onChanged: (value) =>
                                          announcement.title = value,
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
                                          hintText: 'เนื้อหาของประกาศ'),

                                      maxLines: 15,
                                      onChanged: (value) =>
                                          announcement.content = value,

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
                            // Container(
                            //   width: 200,
                            //   height: 400,
                            //   child: GridView.count(
                            //     crossAxisCount: 1,
                            //     children: [
                            //       Container(
                            //         color: Colors.grey[200],
                            //         child: Stack(
                            //           children: [
                            //             _imageWidget == null
                            //                 ? IconButton(
                            //                     icon: Icon(Icons.image),
                            //                     onPressed: getImage,
                            //                   )
                            //                 : _imageWidget!,
                            //           ],
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () async {
                                  _imagesWidget = await ImageSelection()
                                      .getMultiImagesBytes(context);
                                  setState(() {});
                                },
                                child: _imagesWidget.length > 0
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width /
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
                                              child: _imagesWidget.length > 0
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Image.memory(
                                                        _imagesWidget[index],
                                                      ),
                                                    )
                                                  : Container(
                                                      height: 100,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
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
                                        width:
                                            MediaQuery.of(context).size.width /
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
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            print(
                                'knowledge data title -> ${announcement.title}');
                            context.read<AnnouncementFormBloc>().add(
                                  AnnouncementFormEventSubmitted(announcement,
                                      images: _imagesWidget),
                                );
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
}
