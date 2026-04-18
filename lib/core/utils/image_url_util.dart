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
}
