import 'package:logger/logger.dart';

var _logger = Logger();

extension ExtensionLog on Object? {
  void e() {
    if (this == null) return;
    _logger.log(Level.error, this);
  }

  void w() {
    if (this == null) return;
    _logger.log(Level.warning, this);
  }

  void i() {
    if (this == null) return;
    _logger.log(Level.info, this);
  }

  void d() {
    if (this == null) return;
    _logger.log(Level.debug, this);
  }

  void v() {
    if (this == null) return;
    _logger.log(Level.verbose, this);
  }

  void wtf() {
    if (this == null) return;
    _logger.log(Level.wtf, this);
  }
}
