class PromptPayQr {
  static const String promptPayId = '0626173934';

  static String _tlv(String tag, String value) {
    return '$tag${value.length.toString().padLeft(2, '0')}$value';
  }

  static String _normalizeId(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 10 && digits.startsWith('0')) {
      return '0066${digits.substring(1)}';
    }
    if (digits.length == 13) return '0066$digits';
    throw ArgumentError('Invalid PromptPay ID');
  }

  static String _crc16(String value) {
    var crc = 0xFFFF;
    for (final codeUnit in value.codeUnits) {
      crc ^= codeUnit << 8;
      for (var bit = 0; bit < 8; bit++) {
        crc = (crc & 0x8000) != 0
            ? ((crc << 1) ^ 0x1021) & 0xFFFF
            : (crc << 1) & 0xFFFF;
      }
    }
    return crc.toRadixString(16).toUpperCase().padLeft(4, '0');
  }

  static String createPayload(double amount) {
    final merchantAccount = [
      _tlv('00', 'A000000677010111'),
      _tlv('01', _normalizeId(promptPayId)),
    ].join();
    final payload = [
      _tlv('00', '01'),
      _tlv('01', '12'),
      _tlv('29', merchantAccount),
      _tlv('52', '0000'),
      _tlv('53', '764'),
      _tlv('54', amount.toStringAsFixed(2)),
      _tlv('58', 'TH'),
      _tlv('59', 'HOTEL'),
      _tlv('60', 'BANGKOK'),
      '6304',
    ].join();
    return '$payload${_crc16(payload)}';
  }
}
