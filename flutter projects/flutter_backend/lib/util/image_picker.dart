import 'package:flutter/foundation.dart';
import 'package:sdk0306/sdk0306.dart';
import "package:universal_html/html.dart" as html;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:async';

class SDKImagePicker extends StatefulWidget {
  final String btnText;
  final Function(String, dynamic)? returnPath;
  final bool? isFirstTime;
  final bool circleBtn;

  SDKImagePicker({this.btnText: "Select Image", this.returnPath, this.isFirstTime = true, this.circleBtn: false});

  @override
  SDKImagePickerSelectioState createState() => SDKImagePickerSelectioState(isFirstTime ?? false);
}

class SDKImagePickerSelectioState extends State<SDKImagePicker> {
  bool isFirstTime = true;
  SDKImagePickerSelectioState(bool isFirstime) {
    this.isFirstTime = isFirstTime;
  }

  PickedFile? _imageFile;
  String? status;
  bool? imgLoading;
  ImagePicker? imagePicker;

  @override
  Widget build(BuildContext context) {
    if (widget.isFirstTime!) {
      isFirstTime = !isFirstTime;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          child: (widget.circleBtn)
              ? Container(
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.cyan),
                child: IconButton(
                  splashRadius: 20,
                  color: Colors.white,
                    onPressed: () {
                      (kIsWeb) ? chooseFileForWeb() : chooseFileForAndroid();
                    },
                    icon: Icon(Icons.photo_camera,size: 20,)),
              )
              : ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(primary: Colors.orange),
                  icon: Icon(Icons.image),
                  onPressed: () => {
                        if (kIsWeb) {chooseFileForWeb()} else {chooseFileForAndroid()}
                      },
                  label: Text(widget.btnText)),
        )
      ],
    );
  }

  _button(String text, icon, ImageSource imageSource) {
    return Container(
      width: 300,
      height: 40,
      child: Buttons(
        ButtonService(
          buttonData: ButtonData(
            text: widget.btnText,
            type: BtnConstants.FILE_PICKER,
            returnBack: (data) async {
              if (data == BtnConstants.ON_TAP) {
                setState(() {
                  imgLoading = true;
                  _imageFile = null;
                });
                imagePicker = new ImagePicker();
                PickedFile? file = await _loadImage(imageSource);
                Navigator.pop(context, true);
                if (null != file) {
                  setState(() {
                    _imageFile = file;
                    widget.returnPath!(_imageFile?.path ?? "", "");
                    imgLoading = false;
                  });
                  return;
                }
                setState(() {
                  _imageFile = null;
                  imgLoading = false;
                });
              }
            },
          ),
          bGColor: Colors.grey,
          textColor: Colors.black,
          txtSize: 18,
          borderRadius: 1,
          iconColor: Colors.black,
          borderColor: Colors.black,
        ),
      ),
    );
  }

  Future<PickedFile?> _loadImage(ImageSource imageSource) async {
    PickedFile? file = await imagePicker?.getImage(source: imageSource);
    if (null != file) {
      print("PATH");
    }
    return file;
  }

  void chooseFileForWeb() {
    print("Choose Web Picker");
    html.InputElement? uploadInput = html.FileUploadInputElement() as html.InputElement?;
    uploadInput?.click();

    uploadInput?.onChange.listen((e) {
      final files = uploadInput.files;
      final file = files?.elementAt(0);
      final fileName = files?.elementAt(0).name;
      int lastDot = fileName!.lastIndexOf('.');
      String ext = fileName.substring(lastDot + 1);
      final html.FileReader reader = new html.FileReader();
      reader.onLoad.listen((e) {
        widget.returnPath!(ext, reader.result);
      });
      reader.readAsArrayBuffer(file!);
    });
  }

  void chooseFileForAndroid() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 16,
            actions: [
              _button("Camera", Icons.camera, ImageSource.camera),
              _button("Gallery", Icons.insert_photo, ImageSource.gallery),
            ],
          );
        });
  }
}
