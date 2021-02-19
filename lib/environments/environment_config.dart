import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';

/// This file is used for global variables, but also setting up different environments.
class EnvironmentConfig {
  static const ENVIRONMENT = String.fromEnvironment('app.flavor', defaultValue: 'development');

  final EnvironmentGlobalVariables environmentGlobalVariables = EnvironmentGlobalVariables(
    locales: ['en', 'ar', 'cn'],
    IP_GEO_LOCATION_HOST_ADDRESS: 'api.ipgeolocation.io',
    DEFAULT_COUNTRY_CODE: 'US',
    DEFAULT_COUNTRY_DIAL_CODE: '+1',
    // Get Location of the device using IP address. https://ipgeolocation.io/
    IP_GEOLOCATION_API_KEY: '219609b60fdd4898a14c3f23a097aeea',
    imagePickerQuality: 50,
    imageThumbnailWidthSize: 50,
    minimumRecordingLength: 500,
    // in milliseconds unit
    IMAGE_DIRECTORY: '',
    VIDEO_DIRECTORY: '',
    FILE_DIRECTORY: '',
    AUDIO_DIRECTORY: '',

    header1: 18,
    header2: 15.0,
    header3: 14.0,
    header4: 13.0,
    header5: 12.0,
    header6: 10.0,

    inkWellDefaultPadding: 15.0,

    // Emoji Picker configurations
    emojiRows: 5,
    emojiColumns: 7,
    recommendedEmojis: 10,

    // Pageable configurations (Pagination)
    // Control number of records that should be fetching every time a new page is pulled.
    numberOfRecords: 20,

    // Allowed user roles to be logged into the app.
    allowedLoginUserRoles: ['ROLE_MER_ADMIN', 'ROLE_MER_VP', 'ROLE_MER_SUP', 'ROLE_MPOSCASHIER'],

    // Support
    supportEmail: 'tkhenghong@gmail.com',

    // Copyright & Powered by
    copyrightYear: '2021 - 2022',
    copyrightCompanyName: 'PocketChat',
    copyrightCompanyLocation: 'Malaysia',
    poweredByCompanyText: 'A.W.P.G.H.O.S.T',

    // Version
    versionNumber: '1.0.0',
  );

  EnvironmentConfig() {
    switch (ENVIRONMENT) {
      case 'development':
        environmentGlobalVariables.REST_URL_HOST_IP = '192.168.68.106';
        environmentGlobalVariables.REST_URL_HOST_PORT = '8888';
        environmentGlobalVariables.ENVIRONMENT = 'DEVELOPMENT';
        environmentGlobalVariables.sslCertificateLocation = 'lib/certificates/keystore.p12';

        environmentGlobalVariables.recaptchaDisabledKeyword = 'DISABLED';
        environmentGlobalVariables.recaptchaSecretKey = '6LcJCksUAAAAAC8lDh-Y9C0SfHQM5pA0TmkACCJy'; // Recaptcha Key from development server.
        environmentGlobalVariables.recaptchaSkipKey = '2dd1c2ad-5314-4fa4-8144-7ec27a7b3429-reCaptcha'; // Used as signal to tell backend to skip recaptcha.
        environmentGlobalVariables.skipRecaptcha = true;
        break;
      case 'integration':
        environmentGlobalVariables.REST_URL_HOST_IP = '192.168.68.106';
        environmentGlobalVariables.REST_URL_HOST_PORT = '8888';
        environmentGlobalVariables.ENVIRONMENT = 'DEVELOPMENT';
        environmentGlobalVariables.sslCertificateLocation = 'lib/certificates/keystore.p12';

        environmentGlobalVariables.recaptchaDisabledKeyword = 'DISABLED';
        environmentGlobalVariables.recaptchaSecretKey = '6LcJCksUAAAAAC8lDh-Y9C0SfHQM5pA0TmkACCJy'; // Recaptcha Key from development server.
        environmentGlobalVariables.recaptchaSkipKey = '2dd1c2ad-5314-4fa4-8144-7ec27a7b3429-reCaptcha'; // Used as signal to tell backend to skip recaptcha.
        environmentGlobalVariables.skipRecaptcha = true;
        break;
      case 'production':
        environmentGlobalVariables.REST_URL_HOST_IP = '192.168.68.106';
        environmentGlobalVariables.REST_URL_HOST_PORT = '8888';
        environmentGlobalVariables.ENVIRONMENT = 'PRODUCTION';
        environmentGlobalVariables.sslCertificateLocation = 'lib/certificates/keystore.p12';

        environmentGlobalVariables.recaptchaDisabledKeyword = 'DISABLED';
        environmentGlobalVariables.recaptchaSecretKey = '6LcJCksUAAAAAC8lDh-Y9C0SfHQM5pA0TmkACCJy'; // Recaptcha Key from development server.
        environmentGlobalVariables.recaptchaSkipKey = '2dd1c2ad-5314-4fa4-8144-7ec27a7b3429-reCaptcha'; // Used as signal to tell backend to skip recaptcha.
        environmentGlobalVariables.skipRecaptcha = true;
        break;
      default:
        return;
        break;
    }

    environmentGlobalVariables.REST_URL = 'https://${environmentGlobalVariables.REST_URL_HOST_IP}:${environmentGlobalVariables.REST_URL_HOST_PORT}';
    environmentGlobalVariables.WEBSOCKET_URL = 'wss://${environmentGlobalVariables.REST_URL_HOST_IP}:${environmentGlobalVariables.REST_URL_HOST_PORT}/socket/websocket';
    environmentGlobalVariables.allowedHosts = [environmentGlobalVariables.REST_URL_HOST_IP, environmentGlobalVariables.IP_GEO_LOCATION_HOST_ADDRESS];
  }
}
