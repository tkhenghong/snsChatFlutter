library snsChatFlutter.globals;
String REST_URL_HOST_IP = '192.168.68.109';
String REST_URL_HOST_PORT = '8888';

String REST_URL = "https://$REST_URL_HOST_IP:$REST_URL_HOST_PORT";
String WEBSOCKET_URL = "wss://$REST_URL_HOST_IP:$REST_URL_HOST_PORT/socket/websocket";
String IP_GEO_LOCATION_HOST_ADDRESS = 'api.ipgeolocation.io';
List<String> allowedHosts = [REST_URL_HOST_IP, IP_GEO_LOCATION_HOST_ADDRESS];
// In Google Cloud: http://35.184.11.203:8080
String ENVIRONMENT = "DEVELOPMENT"; //LOCAL_COMPUTER, DEVELOPMENT, PRODUCTION

String DEFAULT_COUNTRY_CODE = "US";

// Get Location of the device using IP address. https://ipgeolocation.io/
String IP_GEOLOCATION_API_KEY = "219609b60fdd4898a14c3f23a097aeea";

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

// Pageable configurations (Pagination)
int numberOfRecords = 20; // Control number of records that should be fetching every time a new page is pulled.