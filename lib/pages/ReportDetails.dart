import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import './take_picture_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:rounded_loading_button/rounded_loading_button.dart';



class ReportDetails extends StatefulWidget {
  const ReportDetails({Key? key}) : super(key: key);

  @override
  State<ReportDetails> createState() => _ReportDetailsState();
}

class _ReportDetailsState extends State<ReportDetails> {
  Map data = {};
  Map lang = {
    'English': {
      'header': 'Add report details',
      'type': 'Type Text',
      'selectImage': ' Select Image',
      'captureImage': 'Capture Image ',
      'selectVideo': 'Select Video',
      'captureVideo': 'Record Video',
      'audio': 'Record Audio',
      'location':'Add Location',
      'locationNot':'Location is not enabled',
      'locationYes':'Location enabled',
      'locationDenied':'Location is Denied',
      'btn': 'Send',
      'internet':'You need internet connection to report',
      'details':'Please fill atleast one field to send report'
    },
    'Hausa': {
      'header': 'Karin Banyanai',
      'type': 'Rubuta Bayani',
      'selectImage': 'Zaba Hoto',
      'captureImage': 'Dauka Hoto',
      'selectVideo': 'Zaba Video',
      'captureVideo': 'Dauka Video',
      'audio': 'Dauka Murya',
      'location':'Inda kake a map',
      'locationNot':'Sai an kunna Location',
      'locationYes':'An bada dama',
      'locationDenied':'Sai an bada daman Location',
      'btn': 'Tura Rahoton Gaggawa',
      'internet':'Ana bukatar a kunna internet domin tura rahoto ga hukumomi',
      'details':'Ana bukakar karin bayani domin tura tsako'
    }
  };
  TextEditingController textController = TextEditingController();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  String text = '';
  List pictures = [];
  Position userPosition = new Position(longitude: 0.0, latitude: 0.0, timestamp:null, accuracy: 0.0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
  ImagePicker picker = ImagePicker();
  String message = '';
  void _showPhotoLibrary() async {
    var file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        pictures.add(file.path);
      });
    }
  }

  void _showCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePicturePage(camera: camera)
        )
    );
    setState(() {
      pictures.add(result.path);
    });
  }
  Future<void> getLostData() async {
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
        setState(() {
          pictures.add(response.file?.path);
        });
    } else {

    }
  }
  Future<void> _determinePosition(context,dialect) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        message = lang[dialect]['locationNot'];
      });
      showAlertDialog(context);
      return;
    }
    if (serviceEnabled) {
      setState(() {
        message = lang[dialect]['locationYes'];
      });
      showAlertDialog(context);
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          message = lang[dialect]['locationDenied'];
        });
        showAlertDialog(context);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        message = "Location is Denied Forever";
      });
      showAlertDialog(context);
    }
    Position newPosition  = await Geolocator.getCurrentPosition();
    setState(() {
      userPosition = newPosition;
    });
  }
  Future<void> sendData(context,reportType,dialect) async {
    if(text.length ==0  && pictures.length ==0) {
      setState(() {
        message = lang[dialect]['details'];
      });
      showAlertDialog(context);
      _btnController.reset();
      return;
    }
    bool result = await InternetConnectionChecker().hasConnection;
    if(result == false) {
      setState(() {
        message = lang[dialect]['internet'];
      });
      showAlertDialog(context);
      _btnController.reset();
      return;
    }
    var host = 'https://notifying-server.herokuapp.com';
    Dio dio = Dio();
    Response response1 = await dio.get('$host/admin/get-all-company');
    var payload = response1.data['message'];
    var data;
    String id = '';
    for(var i =0;i<payload.length;i++){
      data = payload[i];
      if(data['companyName'] == reportType){
        id = data['username'];
      }
    }
    var newPosition = jsonEncode(userPosition);
    var formData = FormData.fromMap({
      'message': text,
      'position':newPosition
    });
    for(var i =0;i<pictures.length;i++){
      formData.files.add(MapEntry(
        'media',
          await MultipartFile.fromFile(
            pictures[i],
            filename: 'media'
          ),
      ));
    }
    Dio dio2 = Dio();
    Response response = await dio2.put('$host/admin/trigger-notification?companyId=$id', data: formData);
    var jsonResponse = jsonDecode(response.toString());
    if(jsonResponse['success']){
        await Navigator.pushReplacementNamed(context, '/submitted', arguments: {
          'language':dialect,
          'reportType':reportType
        });
        _btnController.success();
      return;
    }
  }
  @override
  void dispose() {
    getLostData();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute
        .of(context)
        ?.settings
        ?.arguments as Map;
    var dialect = data['language'];
    var reportType = data['reportType'];
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.blueAccent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 15.0,),
              Center(
                  child: Text(
                      lang[dialect]['header'],
                      style: const TextStyle(
                          color: Colors.white
                      )
                  )
              ),
              const SizedBox(width: 10.0,),
              Expanded(
                child: ClipRect(
                  child: Image.asset(
                    'assets/logo.png',
                    height: 40,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    textDetail(),
                    ListTile(
                      onTap: () {
                        // // close the modal
                        _showCamera();
                      },
                      leading: const Icon(
                          Icons.photo_camera, color: Colors.blueAccent),
                      title: Text(lang[dialect]['captureImage'],
                        style: const TextStyle(color: Colors.blueAccent),),
                    ),
                    ListTile(
                        onTap: () {
                          _showPhotoLibrary();
                        },
                        leading: const Icon(
                            Icons.photo_library, color: Colors.blueAccent),
                        title: Text(lang[dialect]['selectImage'],
                            style: const TextStyle(color: Colors.blueAccent))
                    ),

                    ListTile(
                      onTap: () {
                        // // close the modal
                         _determinePosition(context,dialect);
                      },
                      leading: const Icon(
                          Icons.location_on, color: Colors.blueAccent),
                      title: Text(
                          lang[dialect]['location'],
                          style: const TextStyle(
                              color: Colors.blueAccent
                          )
                      ),
                    ),
                  ],
                ),
              ),
              pictureDetail(),
              const SizedBox(height: 20,),
              SizedBox(
                  width: 270,
                  height: 50,
                child: RoundedLoadingButton(
                  controller: _btnController,
                  onPressed: () async {
                    await sendData(context, reportType,dialect);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      lang[dialect]['btn'],
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      ),
                    ),
                  ),

                ),
              )
            ],
          ),
        )
    );
  }

  Widget textDetail() {
    return Container(
        child: TextFormField(
          style: const TextStyle(color: Colors.blueAccent),
          controller: textController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            icon: Icon(Icons.text_fields_rounded, color: Colors.blueAccent
            ),
            labelText: 'Type',
          ),
          onChanged: (String value) {
            text = value;
          },
        )
    );
  }

  Widget pictureDetail() {
    return GridView.builder(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: (2 / 2),
            crossAxisSpacing: 5,
            mainAxisSpacing: 5
        ),
        itemCount: pictures.length,
        itemBuilder: (BuildContext ctx, index) {
          return Stack(
            children: [
              Container(
                width: 250.0,
                height: 350.0,
                child:   SafeArea(
                    child: Image.file(File(pictures[index]),
                    )
                ),
              ),
               Positioned(
                  right: 5,
                  child: InkWell(
                  child: const Icon(
                  Icons.remove_circle,
                  size: 30,
                  color: Colors.blueAccent,
              ),
              onTap: () {
                setState(
                      () {
                    pictures.remove(pictures[index]);
                  },
                );
              },
              )
            )
            ],
          );
        }
    );
  }
  showAlertDialog(BuildContext context) {
    // Init
    AlertDialog dialog = AlertDialog(
      title: Text("$message"),
      actions: [
        ElevatedButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            }
        )
      ],
    );
    // Show the dialog (showDialog() => showGeneralDialog())
    showGeneralDialog(
      context: context,
      pageBuilder: (context, anim1, anim2) {return Wrap();},
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform(
          transform: Matrix4.translationValues(
            0.0,
            (1.0-Curves.easeInOut.transform(anim1.value))*400,
            0.0,
          ),
          child: dialog,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

}

