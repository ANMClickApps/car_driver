import 'package:maps_toolkit/maps_toolkit.dart';

class MapKitHelper {
  static double getMarkerRotaton(
      sourceLat, sourceLng, destinationLat, destinationLng) {
    var rotation = SphericalUtil.computeHeading(
      LatLng(sourceLat, sourceLng),
      LatLng(destinationLat, destinationLng),
    );

    return rotation;
  }
}
