#!/usr/bin/env dart

// Simple build runner that auto-increments version before build
import 'dart:io';

Future<void> main() async {
  print('🔨 Auto-incrementing build version...');
  
  final pubspecFile = File('pubspec.yaml');
  final content = await pubspecFile.readAsString();
  
  // Find version line
  final versionLine = content.split('\n').firstWhere(
    (line) => line.startsWith('version:'),
    orElse: () => '',
  );
  
  if (versionLine.isEmpty) {
    print('❌ Version not found');
    exit(1);
  }
  
  final currentVersion = versionLine.split(':')[1].trim();
  final parts = currentVersion.split('+');
  final versionName = parts[0];
  final buildCode = int.parse(parts[1]);
  
  final newVersion = '$versionName+${buildCode + 1}';
  
  // Update pubspec.yaml
  final newContent = content.replaceFirst(
    'version: $currentVersion',
    'version: $newVersion',
  );
  await pubspecFile.writeAsString(newContent);
  
  print('✅ Version updated: $currentVersion → $newVersion');
  
  // Run flutter build
  print('🏗️  Building release bundle...');
  final result = await Process.run('flutter', ['build', 'appbundle', '--release']);
  
  if (result.exitCode == 0) {
    print('✅ Build completed successfully!');
    print('📁 Bundle: build/app/outputs/bundle/release/app-release.aab');
  } else {
    print('❌ Build failed:');
    print(result.stderr);
    exit(1);
  }
}
