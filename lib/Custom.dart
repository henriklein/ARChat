import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class CustomProject extends StatefulWidget {
  @override
  _CustomProjectState createState() => _CustomProjectState();
}

class _CustomProjectState extends State<CustomProject> {
  ARKitController arkitController;
  ARKitNode node;
  String anchorId;
  int _numberOfAnchors = 0;
  bool placing = false;
  vector.Vector3 origin = vector.Vector3(0.0, 0, 0);

  vector.Vector3 lastPosition;

  @override
  void dispose() {
    arkitController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          child: ARKitSceneView(
            onARKitViewCreated: onARKitViewCreated,
            planeDetection: ARPlaneDetection.horizontal,
            showFeaturePoints: true,
            enableTapRecognizer: true,
          ),
        ),
        floatingActionButton: HoldDetector(
          onHold: () {
            placing = true;
          },
          holdTimeout: Duration(milliseconds: 200),
          enableHapticFeedback: true,
          child: FloatingActionButton(
            child: Text(
              '$_numberOfAnchors',
            ),
            onPressed: () {
              placing = false;
            },
          ),
        ),
      );

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;

    //this.arkitController.onAddNodeForAnchor = _handleAddAnchor;

    //3D Mesuring
    this.arkitController.onARTap = (ar) {
      _numberOfAnchors++;
      final point = ar.firstWhere(
        (o) => o.type == ARKitHitTestResultType.featurePoint,
        orElse: () => null,
      );
      if (point != null) {
        _onARTapHandler(point, arkitController);
      }
      ;
    };
  }

  // Adding messuring system
  void _onARTapHandler(ARKitTestResult point, ARKitController camera) {
    
    final position = vector.Vector3(
      point.worldTransform.getColumn(3).x,
      point.worldTransform.getColumn(3).y + 0,
      point.worldTransform.getColumn(3).z,
    );

    print("Print: Object Posotion: $position");
    print("Distance to camera: ${point.distance}");

    print("Camera Position? ${point.localTransform}");

    final node = ARKitReferenceNode(
      url: 'models.scnassets/Diplo.dae',
      scale: vector.Vector3.all(0.08),
      position: position,
    );
    arkitController.add(node);

    if (position != null) {
      final avatarPosition = position;
      final distanceIndicator = point.distance.toString();

      _showAvatarMenu(avatarPosition, distanceIndicator);
    }

    if (lastPosition != null) {
      final line = ARKitLine(
        fromVector: lastPosition + vector.Vector3(0, 1.5, 0),
        toVector: position + vector.Vector3(0, 1.5, 0),
      );
      final lineNode = ARKitNode(geometry: line);
      arkitController.add(lineNode);

      final distance = _calculateDistanceBetweenPoints(position, lastPosition);
      final point = _getMiddleVector(position, lastPosition);
      _drawText(distance, point);
    }

    if (origin != null) {
      final line = ARKitLine(
        fromVector: origin + vector.Vector3(0, 0, 0),
        toVector: position + vector.Vector3(0, 1.5, 0),
      );
      final lineNode = ARKitNode(geometry: line);
      arkitController.add(lineNode);
    }
    lastPosition = position;
  }

  void _showAvatarMenu(
      vector.Vector3 objectlocation, String distanceIndicator) {
    final toOrigin = _calculateDistanceBetweenPoints(objectlocation, origin);
    final textGeometry = ARKitText(
      text: toOrigin,
      extrusionDepth: 1,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty(color: Colors.white),
        )
      ],
    );

    const scale = 0.002;
    final vectorScale = vector.Vector3(scale, scale, scale);
    final node = ARKitNode(
      geometry: textGeometry,
      position: objectlocation + vector.Vector3(0.1, 1.6, 0),
      scale: vectorScale,
    );
    arkitController.add(node);
  }

  String _calculateDistanceBetweenPoints(vector.Vector3 A, vector.Vector3 B) {
    final length = A.distanceTo(B);
    return '${(length).toStringAsFixed(2)} Meter';
  }

  vector.Vector3 _getMiddleVector(vector.Vector3 A, vector.Vector3 B) {
    return vector.Vector3((A.x + B.x) / 2, (A.y + B.y) / 2, (A.z + B.z) / 2);
  }

  void _drawText(String text, vector.Vector3 point) {
    final textGeometry = ARKitText(
      text: text,
      extrusionDepth: 1,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty(color: Colors.red),
        )
      ],
    );
    const scale = 0.001;
    final vectorScale = vector.Vector3(scale, scale, scale);
    final node = ARKitNode(
      geometry: textGeometry,
      position: point + vector.Vector3(0, 1.5, 0),
      scale: vectorScale,
    );
    arkitController.add(node);
  }

}
