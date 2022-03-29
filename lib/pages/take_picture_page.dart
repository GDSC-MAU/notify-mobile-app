import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class TakePicturePage extends StatefulWidget {
  final CameraDescription camera;

  TakePicturePage({required this.camera});

  @override
  _TakePicturePageState createState() => _TakePicturePageState();
}

class _TakePicturePageState extends State<TakePicturePage> {
  late CameraController _cameraController  ;
  late Future<void> _initializeCameraControllerFuture;

  @override
  void initState() {
    super.initState();

    _cameraController = CameraController(widget.camera, ResolutionPreset.max);

    _initializeCameraControllerFuture = _cameraController.initialize();
  }

  void _takePicture(BuildContext context) async {
    try {
      await _initializeCameraControllerFuture;

      final path = join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');

      XFile? image  = await _cameraController.takePicture(); //their is path argument

      Navigator.pop(context,image);

    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      FutureBuilder(
        future: _initializeCameraControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_cameraController);
          } else {
            return const  Center(child: CircularProgressIndicator());
          }
        },
      ),
      SafeArea(
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: FloatingActionButton(
              backgroundColor: Colors.black,
              child:const Icon(Icons.camera),
              onPressed: () {
                _takePicture(context);
              },
            ),
          ),
        ),
      )
    ]);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }
}
