library snsChatFlutter.globals;
String REST_URL_HOST_IP = '192.168.68.106';
String REST_URL_HOST_PORT = '8888';

String REST_URL = 'https://$REST_URL_HOST_IP:$REST_URL_HOST_PORT';
String WEBSOCKET_URL = 'wss://$REST_URL_HOST_IP:$REST_URL_HOST_PORT/socket/websocket';

String IP_GEO_LOCATION_HOST_ADDRESS = 'api.ipgeolocation.io';
List<String> allowedHosts = [REST_URL_HOST_IP, IP_GEO_LOCATION_HOST_ADDRESS];

String ENVIRONMENT = 'LOCAL_COMPUTER'; // LOCAL_COMPUTER, DEVELOPMENT, PRODUCTION

String sslCertificateLocation = 'lib/keystore/keystore.p12';

String DEFAULT_COUNTRY_CODE = 'US';

// Get Location of the device using IP address. https://ipgeolocation.io/
String IP_GEOLOCATION_API_KEY = '219609b60fdd4898a14c3f23a097aeea';

int imagePickerQuality = 50;
int imageThumbnailWidthSize = 50;
int minimumRecordingLength = 500; // in milliseconds unit

String IMAGE_DIRECTORY = '';
String VIDEO_DIRECTORY = '';
String FILE_DIRECTORY = '';
String AUDIO_DIRECTORY = '';

// Support Email
String supportEmail = 'tkhenghong@gmail.com';

double header1 = 18.0;
double header2 = 15.0;
double header3 = 14.0;
double header4 = 13.0;
double header5 = 12.0;
double header6 = 10.0;

double inkWellDefaultPadding = 15.0;

// Emoji Picker configurations
int emojiRows = 5;
int emojiColumns = 7;
int recommendedEmojis = 10;

// Recaptcha
String recaptchaDisabledKeyword = 'DISABLED';
String recaptchaSecretKey = '6LcJCksUAAAAAC8lDh-Y9C0SfHQM5pA0TmkACCJy'; // Recaptcha Key from development server.
String recaptchaSkipKey = '2dd1c2ad-5314-4fa4-8144-7ec27a7b3429-reCaptcha'; // Used as signal to tell backend to skip recaptcha.
bool skipRecaptcha = true;

// Pageable configurations (Pagination)
int numberOfRecords = 20; // Control number of records that should be fetching every time a new page is pulled.

int verificationPinMaximumRetryTimes = 3;

// Allowed user roles to be logged into the app.
List<String> allowedLoginUserRoles = ['ROLE_MER_ADMIN', 'ROLE_MER_VP', 'ROLE_MER_SUP', 'ROLE_MPOSCASHIER'];

String copyrightYear = '2021 - 2022';
String copyrightCompanyName = 'PocketChat';
String copyrightCompanyLocation = 'Malaysia';
String poweredByCompanyText= 'A.W.P.G.H.O.S.T';

String versionNumber = '1.0.0';
