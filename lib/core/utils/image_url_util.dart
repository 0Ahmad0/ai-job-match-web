import 'package:firebase_storage/firebase_storage.dart';

class ImageUrlUtil {
  static String normalize(
    String? url, {
    String? defaultBucket,
  }) {
    final raw = (url ?? '').trim();
    if (raw.isEmpty) {
      return '';
    }

    if (raw.startsWith('https://')) {
      return raw;
    }

    if (raw.startsWith('http://')) {
      return 'https://${raw.substring('http://'.length)}';
    }

    if (raw.startsWith('gs://')) {
      final withoutScheme = raw.substring('gs://'.length);
      final slashIndex = withoutScheme.indexOf('/');
      if (slashIndex <= 0 || slashIndex == withoutScheme.length - 1) {
        return '';
      }
      final bucket = withoutScheme.substring(0, slashIndex);
      final objectPath = withoutScheme.substring(slashIndex + 1);
      final encodedPath = Uri.encodeComponent(objectPath);
      return 'https://firebasestorage.googleapis.com/v0/b/$bucket/o/$encodedPath?alt=media';
    }

    if (raw.startsWith('/')) {
      final bucket = (defaultBucket ?? '').trim();
      if (bucket.isEmpty) {
        return '';
      }
      final encodedPath = Uri.encodeComponent(raw.substring(1));
      return 'https://firebasestorage.googleapis.com/v0/b/$bucket/o/$encodedPath?alt=media';
    }

    return raw;
  }

  static bool requiresDownloadUrlResolution(String? url) {
    final raw = (url ?? '').trim();
    if (raw.isEmpty) return false;
    return raw.startsWith('gs://') || raw.startsWith('/');
  }

  static Future<String> resolveForDisplay(
    String? url, {
    String? defaultBucket,
  }) async {
    final raw = (url ?? '').trim();
    if (raw.isEmpty) {
      return '';
    }

    if (raw.startsWith('https://') || raw.startsWith('http://')) {
      return normalize(raw, defaultBucket: defaultBucket);
    }

    try {
      if (raw.startsWith('gs://')) {
        return await FirebaseStorage.instance.refFromURL(raw).getDownloadURL();
      }

      if (raw.startsWith('/')) {
        return await FirebaseStorage.instance.ref(raw.substring(1)).getDownloadURL();
      }
    } catch (_) {
      return '';
    }

    return normalize(raw, defaultBucket: defaultBucket);
  }
}
