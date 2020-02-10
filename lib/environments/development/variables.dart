library snsChatFlutter.globals;

String REST_URL = "http://192.168.88.188:8080";
String WEBSOCKET_URL = "ws://192.168.88.188:8080/socket";
//String REST_URL = "http://35.184.11.203:8080";
//String WEBSOCKET_URL = "ws://35.184.11.203:8080/socket";
// At Home: http://192.168.0.139:8080
// At Neurogine: http://192.168.88.159:8080
// In Google Cloud: http://35.184.11.203:8080
String ENVIRONMENT = "PRODUCTION"; //DEVELOPMENT, PRODUCTION

String DEFAULT_COUNTRY_CODE = "US";

// Get Location of the device using IP address. https://ipgeolocation.io/
String IP_GEOLOCATION_API_KEY  = "219609b60fdd4898a14c3f23a097aeea";

int imagePickerQuality = 50;
int imageThumbnailWidthSize = 50;
int minimumRecordingLength = 500; // in miliseconds unit

String IMAGE_DIRECTORY = '';
String VIDEO_DIRECTORY = '';
String FILE_DIRECTORY = '';
String AUDIO_DIRECTORY = '';