part of '_constants.dart';

class Assets {
  static final svg = _SvgAssets();
  static final image = _ImageAssets();
}

class _SvgAssets {
  final String _basePath = 'assets/svgs';
}

class _ImageAssets {
  final String _basePath = 'assets/images';
}
