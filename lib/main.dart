import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart'
    show
        ArCoreController,
        ArCoreHitTestResult,
        ArCoreImage,
        ArCoreMaterial,
        ArCoreNode,
        ArCoreSphere,
        ArCoreView;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

/// Adding the import here because it's named one

void main() async {
  ArCoreController arCoreController;
  void _addImage(ArCoreController controller) async {
    /**
     * Use rootBundle.load to retrieve the images Uint8
     * rootBundle.load('assets/test.jpg')
     * .then((data) => setState(() => this.imageData = data));
     */
    ByteData bytes = await rootBundle.load('assets/images/robo-cat.usdz');
    final image =
        ArCoreImage(height: 250, width: 250, bytes: bytes.buffer.asUint8List());
    final secondNode = ArCoreNode(
      image: image,
      position: vector.Vector3(0, 0, -3.5),
    );
    controller.addArCoreNode(secondNode);
  }

  void _addSphere(ArCoreController controller) {
    final material = ArCoreMaterial(
      color: Color.fromARGB(80, 128, 0, 128),
    );
    final sphere = ArCoreSphere(
      materials: [material],
      radius: 0.1,
    );
    final node = ArCoreNode(
      shape: sphere,
      position: vector.Vector3(0, 0, -1.5),
    );
    controller.addArCoreNode(node);
  }

  void _addTapSphere(ArCoreController controller, ArCoreHitTestResult plane) {
    final material = ArCoreMaterial(
      color: Color.fromARGB(80, 128, 0, 128),
    );
    final sphere = ArCoreSphere(
      materials: [material],
      radius: 0.2,
    );
    final node = ArCoreNode(
      shape: sphere,
      position: vector.Vector3(30.0, 10.0, -1.5),
    );
    controller.addArCoreNodeWithAnchor(node);
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;
    _addTapSphere(arCoreController, hit);
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    _addSphere(controller);
    _addImage(controller);
    arCoreController.onPlaneTap = _handleOnPlaneTap;
  }

  WidgetsFlutterBinding.ensureInitialized();
  print('ARCORE IS AVAILABLE?');
  print(await ArCoreController.checkArCoreAvailability());
  print('\nAR SERVICES INSTALLED?');
  print(await ArCoreController.checkIsArCoreInstalled());
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'AnsonErvin Inc.',
            style: TextStyle(color: Colors.purple),
          ),
          backgroundColor: Colors.black,
        ),
        body: Center(
            child: ArCoreView(
          onArCoreViewCreated: _onArCoreViewCreated,
          enableTapRecognizer: true,
        )),
      ),
    ),
  );
}
