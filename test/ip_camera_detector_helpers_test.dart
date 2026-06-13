import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/services/ip_camera_detector.dart';

void main() {
  group('IpCameraDetector.matchCameraFingerprint', () {
    test('returns the first matching fingerprint by table order', () {
      // 'ip camera' appears earlier in the table than 'hikvision'/'webs', so
      // it wins even though the banner also contains those keywords.
      expect(
        IpCameraDetector.matchCameraFingerprint(
            'server: hikvision-webs realm="ip camera"'),
        'ip camera',
      );
    });

    test('matches ONVIF banners', () {
      expect(
          IpCameraDetector.matchCameraFingerprint('content: onvif device'),
          'onvif');
    });

    test('matches RTSP url and vendor names', () {
      expect(IpCameraDetector.matchCameraFingerprint('rtsp://host/stream'),
          'rtsp://');
      expect(IpCameraDetector.matchCameraFingerprint('built by dahua'), 'dahua');
    });

    test('returns null when nothing matches', () {
      expect(
          IpCameraDetector.matchCameraFingerprint('plain old nginx welcome'),
          isNull);
    });
  });

  group('IpCameraDetector.parseXAddrs', () {
    test('extracts namespaced XAddrs content', () {
      const body =
          '<env:Body><d:XAddrs>http://10.0.0.5:8080/onvif/device</d:XAddrs></env:Body>';
      expect(IpCameraDetector.parseXAddrs(body),
          'http://10.0.0.5:8080/onvif/device');
    });

    test('extracts non-namespaced XAddrs content', () {
      const body = '<XAddrs> http://10.0.0.6/onvif </XAddrs>';
      expect(IpCameraDetector.parseXAddrs(body), 'http://10.0.0.6/onvif');
    });

    test('returns null when XAddrs is absent', () {
      expect(IpCameraDetector.parseXAddrs('<env:Body/>'), isNull);
    });
  });

  group('IpCameraDetector.portFromXAddrs', () {
    test('parses an explicit port', () {
      expect(IpCameraDetector.portFromXAddrs('http://10.0.0.5:8554/onvif'), 8554);
    });

    test('defaults to 80 when no port present', () {
      expect(IpCameraDetector.portFromXAddrs('http://10.0.0.5/onvif'), 80);
    });
  });

  group('IpCameraDetector.specificPortEvidence', () {
    test('maps each known camera port to its description', () {
      expect(IpCameraDetector.specificPortEvidence(554), 'RTSP (standard)');
      expect(IpCameraDetector.specificPortEvidence(5554), 'RTSP (alternate)');
      expect(IpCameraDetector.specificPortEvidence(8554), 'RTSP (alternate)');
      expect(IpCameraDetector.specificPortEvidence(10554), 'RTSP (alternate)');
      expect(IpCameraDetector.specificPortEvidence(37777),
          'Dahua/Reolink proprietary');
      expect(IpCameraDetector.specificPortEvidence(37778),
          'Dahua/Reolink proprietary');
      expect(IpCameraDetector.specificPortEvidence(9000),
          'Dahua/Reolink alternate');
      expect(IpCameraDetector.specificPortEvidence(9001),
          'Dahua/Reolink alternate');
      expect(IpCameraDetector.specificPortEvidence(1935), 'RTMP streaming');
      expect(IpCameraDetector.specificPortEvidence(34567),
          'XMEye/DVR proprietary');
      expect(IpCameraDetector.specificPortEvidence(34599),
          'XMEye/DVR proprietary');
      expect(IpCameraDetector.specificPortEvidence(8000), 'Hikvision SDK port');
    });

    test('unknown port falls back to generic camera description', () {
      expect(IpCameraDetector.specificPortEvidence(12345),
          'Camera-specific port');
    });
  });

  group('IpCameraDetector.expandCidr', () {
    test('expands a /30 into two usable hosts', () {
      expect(IpCameraDetector.expandCidr('192.168.0.0/30'),
          ['192.168.0.1', '192.168.0.2']);
    });

    test('rejects malformed CIDR strings', () {
      expect(IpCameraDetector.expandCidr('not-a-cidr'), isNull);
      expect(IpCameraDetector.expandCidr('10.0.0.0'), isNull);
      expect(IpCameraDetector.expandCidr('10.0.0.0/99'), isNull);
      expect(IpCameraDetector.expandCidr('10.0.0/24'), isNull);
      expect(IpCameraDetector.expandCidr('999.0.0.0/24'), isNotNull);
    });
  });
}
