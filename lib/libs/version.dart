import 'package:package_info_plus/package_info_plus.dart';

void initVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  _version = packageInfo.version;
}

late String _version;

String get currentVersion {
  return _version;
}
