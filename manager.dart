import 'dart:io';

// ==========================================
// Constants & Configuration
// ==========================================
const String libPath = 'lib';
const String modulesPath = '$libPath/modules';
const String routesPath = '$libPath/routes';

void main(List<String> args) {
  if (args.isEmpty) {
    print('❌ Please provide a command: "init" or "feature <name>"');
    return;
  }

  final command = args[0];

  switch (command) {
    case 'init':
      _initProject();
      break;
    case 'feature':
      if (args.length < 2) {
        print('❌ Please provide a feature name. Example: dart manager.dart feature auth/login');
      } else {
        _createFeature(args[1].toLowerCase());
      }
      break;
    default:
      print('❌ Unknown command. Use "init" or "feature <name>"');
  }
}

// ==========================================
// 1. Initialize Project Structure
// ==========================================
void _initProject() {
  print('🚀 Initializing Project Structure...');
  // ... (نفس كود init السابق لم يتغير)
  final dirs = [
    '$libPath/core/constants',
    '$libPath/core/theme',
    '$libPath/core/localization',
    '$libPath/core/utils',
    '$libPath/data/models',
    '$libPath/data/services',
    '$libPath/global_widgets',
    modulesPath,
    routesPath,
  ];

  for (var dir in dirs) {
    Directory(dir).createSync(recursive: true);
  }

  _createFile('$routesPath/app_routes.dart', _appRoutesStub());
  _createFile('$routesPath/app_pages.dart', _appPagesStub());

  print('✅ Project Structure Initialized Successfully!');
}

// ==========================================
// 2. Create Feature Logic (Updated for Nesting)
// ==========================================
void _createFeature(String pathInput) {
  // pathInput could be "auth/login" or just "home"
  final pathSegments = pathInput.split('/');
  final featureName = pathSegments.last; // "login"
  final parentPath = pathSegments.length > 1 ? pathSegments.join('/') : featureName; // "auth/login"

  print('🚀 Creating Feature: $featureName inside $parentPath...');

  final pascalCase = _toPascalCase(featureName);
  final featureDir = '$modulesPath/$parentPath';

  // 1. Create Directories
  Directory('$featureDir/bindings').createSync(recursive: true);
  Directory('$featureDir/controllers').createSync(recursive: true);
  Directory('$featureDir/views/widgets').createSync(recursive: true);

  // 2. Create Files
  _createFile(
      '$featureDir/bindings/${featureName}_binding.dart', _bindingStub(featureName, pascalCase));
  _createFile(
      '$featureDir/controllers/${featureName}_controller.dart', _controllerStub(featureName, pascalCase));
  _createFile(
      '$featureDir/views/${featureName}_view.dart', _viewStub(featureName, pascalCase));

  // 3. Update Routes (Handling nested naming like AUTH_LOGIN)
  final routeName = pathSegments.join('_').toUpperCase(); // AUTH_LOGIN
  final routeUrl = '/${pathSegments.join('/')}'; // /auth/login

  _updateAppRoutes(routeName, routeUrl);

  // 4. Update Pages
  _updateAppPages(featureName, pascalCase, routeName, parentPath);

  print('✅ Feature "$featureName" created at "$parentPath" successfully!');
}

// ==========================================
// File Manipulation Helpers
// ==========================================

void _createFile(String path, String content) {
  final file = File(path);
  if (!file.existsSync()) {
    file.writeAsStringSync(content);
    print('   📄 Created: $path');
  }
}

void _updateAppRoutes(String routeConstName, String routeUrl) {
  final file = File('$routesPath/app_routes.dart');
  if (!file.existsSync()) return;

  String content = file.readAsStringSync();
  final routeLine = '  static const $routeConstName = \'$routeUrl\';';

  if (!content.contains(routeConstName)) {
    final lastBraceIndex = content.lastIndexOf('}');
    content = content.replaceRange(lastBraceIndex, lastBraceIndex, '$routeLine\n');
    file.writeAsStringSync(content);
    print('   🔗 Updated: AppRoutes with $routeConstName');
  }
}

void _updateAppPages(String featureName, String pascalCase, String routeConstName, String fullPath) {
  final file = File('$routesPath/app_pages.dart');
  if (!file.existsSync()) return;

  String content = file.readAsStringSync();

  // 1. Add Imports
  final imports = """
import '../modules/$fullPath/bindings/${featureName}_binding.dart';
import '../modules/$fullPath/views/${featureName}_view.dart';
""";

  if (!content.contains('${featureName}_view.dart')) {
    final lastImportIndex = content.lastIndexOf('import');
    final insertPos = lastImportIndex != -1 ? content.indexOf(';', lastImportIndex) + 1 : 0;
    content = content.replaceRange(insertPos, insertPos, '\n$imports');
  }

  // 2. Add GetPage
  final pageEntry = """
    GetPage(
      name: Routes.$routeConstName,
      page: () => const ${pascalCase}View(),
      binding: ${pascalCase}Binding(),
    ),
""";

  if (!content.contains('Routes.$routeConstName')) {
    final listEndIndex = content.lastIndexOf('];');
    if (listEndIndex != -1) {
      content = content.replaceRange(listEndIndex, listEndIndex, pageEntry);
      file.writeAsStringSync(content);
      print('   🔗 Updated: AppPages with $routeConstName');
    }
  }
}

String _toPascalCase(String text) {
  return text.split('_').map((word) {
    if (word.isEmpty) return '';
    return '${word[0].toUpperCase()}${word.substring(1)}';
  }).join('');
}

// ==========================================
// Stubs
// ==========================================
// ... (Stubs نفسهم ما تغيروا، انسخهم من السكربت القديم أو اتركهم كما هم)
String _appRoutesStub() => '''
abstract class Routes {
  Routes._();
  static const INITIAL = '/';
}
''';

String _appPagesStub() => '''
import 'package:get/get.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.INITIAL;

  static final routes = [
  ];
}
''';

String _bindingStub(String name, String pascal) => '''
import 'package:get/get.dart';
import '../controllers/${name}_controller.dart';

class ${pascal}Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<${pascal}Controller>(
      () => ${pascal}Controller(),
    );
  }
}
''';

String _controllerStub(String name, String pascal) => '''
import 'package:get/get.dart';

class ${pascal}Controller extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }
}
''';

String _viewStub(String name, String pascal) => '''
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/${name}_controller.dart';

class ${pascal}View extends GetView<${pascal}Controller> {
  const ${pascal}View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('$pascal')),
      body: Center(
        child: Text(
          '$pascal is working',
          style: TextStyle(fontSize: 20.sp),
        ),
      ),
    );
  }
}
''';