#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';

void main(List<String> args) async {
  if (args.isEmpty) {
    print('Usage: dart tools/version_bumper.dart [patch|minor|major|build]');
    exit(1);
  }

  final versionType = args[0];
  final pubspecFile = File('pubspec.yaml');
  
  if (!pubspecFile.existsSync()) {
    print('❌ pubspec.yaml not found');
    exit(1);
  }

  // Read current version
  final content = await pubspecFile.readAsString();
  final versionLine = content.split('\n').firstWhere(
    (line) => line.startsWith('version:'),
    orElse: () => '',
  );

  if (versionLine.isEmpty) {
    print('❌ Version line not found in pubspec.yaml');
    exit(1);
  }

  final currentVersion = versionLine.split(':')[1].trim();
  final parts = currentVersion.split('+');
  final versionName = parts[0];
  final buildCode = int.parse(parts[1]);

  print('📊 Current version: $currentVersion');

  // Parse version name
  final versionParts = versionName.split('.');
  final major = int.parse(versionParts[0]);
  final minor = int.parse(versionParts[1]);
  final patch = versionParts.length > 2 ? int.parse(versionParts[2]) : 0;

  // Calculate new version
  String newVersionName;
  switch (versionType) {
    case 'patch':
      newVersionName = '$major.$minor.${patch + 1}';
      break;
    case 'minor':
      newVersionName = '$major.${minor + 1}.0';
      break;
    case 'major':
      newVersionName = '${major + 1}.0.0';
      break;
    case 'build':
      newVersionName = versionName;
      break;
    default:
      print('❌ Invalid version type: $versionType');
      print('Use: patch, minor, major, or build');
      exit(1);
  }

  final newBuildCode = buildCode + 1;
  final newVersion = '$newVersionName+$newBuildCode';

  print('🎯 New version: $newVersion');

  // Update pubspec.yaml
  final newContent = content.replaceFirst(
    'version: $currentVersion',
    'version: $newVersion',
  );
  await pubspecFile.writeAsString(newContent);

  print('✅ Version updated in pubspec.yaml');
  
  // Update Android build.gradle.kts if needed
  final buildGradleFile = File('android/app/build.gradle.kts');
  if (buildGradleFile.existsSync()) {
    final gradleContent = await buildGradleFile.readAsString();
    final updatedGradleContent = gradleContent.replaceFirst(
      'versionCode = flutter.versionCode',
      'versionCode = $newBuildCode',
    ).replaceFirst(
      'versionName = flutter.versionName',
      'versionName = "$newVersionName"',
    );
    await buildGradleFile.writeAsString(updatedGradleContent);
    print('✅ Android build.gradle.kts updated');
  }

  print('🎉 Version bump completed!');
}
