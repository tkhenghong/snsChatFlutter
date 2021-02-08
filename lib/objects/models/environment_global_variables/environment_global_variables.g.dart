// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'environment_global_variables.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnvironmentGlobalVariables _$EnvironmentGlobalVariablesFromJson(
    Map<String, dynamic> json) {
  return EnvironmentGlobalVariables(
    locales: (json['locales'] as List)?.map((e) => e as String)?.toList(),
    REST_URL_HOST_IP: json['REST_URL_HOST_IP'] as String,
    REST_URL_HOST_PORT: json['REST_URL_HOST_PORT'] as String,
    REST_URL: json['REST_URL'] as String,
    WEBSOCKET_URL: json['WEBSOCKET_URL'] as String,
    IP_GEO_LOCATION_HOST_ADDRESS:
        json['IP_GEO_LOCATION_HOST_ADDRESS'] as String,
    allowedHosts:
        (json['allowedHosts'] as List)?.map((e) => e as String)?.toList(),
    ENVIRONMENT: json['ENVIRONMENT'] as String,
    sslCertificateLocation: json['sslCertificateLocation'] as String,
    DEFAULT_COUNTRY_CODE: json['DEFAULT_COUNTRY_CODE'] as String,
    DEFAULT_COUNTRY_DIAL_CODE: json['DEFAULT_COUNTRY_DIAL_CODE'] as String,
    IP_GEOLOCATION_API_KEY: json['IP_GEOLOCATION_API_KEY'] as String,
    imagePickerQuality: json['imagePickerQuality'] as int,
    imageThumbnailWidthSize: json['imageThumbnailWidthSize'] as int,
    minimumRecordingLength: json['minimumRecordingLength'] as int,
    IMAGE_DIRECTORY: json['IMAGE_DIRECTORY'] as String,
    VIDEO_DIRECTORY: json['VIDEO_DIRECTORY'] as String,
    FILE_DIRECTORY: json['FILE_DIRECTORY'] as String,
    AUDIO_DIRECTORY: json['AUDIO_DIRECTORY'] as String,
    supportEmail: json['supportEmail'] as String,
    header1: (json['header1'] as num)?.toDouble(),
    header2: (json['header2'] as num)?.toDouble(),
    header3: (json['header3'] as num)?.toDouble(),
    header4: (json['header4'] as num)?.toDouble(),
    header5: (json['header5'] as num)?.toDouble(),
    header6: (json['header6'] as num)?.toDouble(),
    inkWellDefaultPadding: (json['inkWellDefaultPadding'] as num)?.toDouble(),
    emojiRows: json['emojiRows'] as int,
    emojiColumns: json['emojiColumns'] as int,
    recommendedEmojis: json['recommendedEmojis'] as int,
    recaptchaDisabledKeyword: json['recaptchaDisabledKeyword'] as String,
    recaptchaSecretKey: json['recaptchaSecretKey'] as String,
    recaptchaSkipKey: json['recaptchaSkipKey'] as String,
    skipRecaptcha: json['skipRecaptcha'] as bool,
    numberOfRecords: json['numberOfRecords'] as int,
    verificationPinMaximumRetryTimes:
        json['verificationPinMaximumRetryTimes'] as int,
    allowedLoginUserRoles: (json['allowedLoginUserRoles'] as List)
        ?.map((e) => e as String)
        ?.toList(),
    copyrightYear: json['copyrightYear'] as String,
    copyrightCompanyName: json['copyrightCompanyName'] as String,
    copyrightCompanyLocation: json['copyrightCompanyLocation'] as String,
    poweredByCompanyText: json['poweredByCompanyText'] as String,
    versionNumber: json['versionNumber'] as String,
  );
}

Map<String, dynamic> _$EnvironmentGlobalVariablesToJson(
        EnvironmentGlobalVariables instance) =>
    <String, dynamic>{
      'locales': instance.locales,
      'REST_URL_HOST_IP': instance.REST_URL_HOST_IP,
      'REST_URL_HOST_PORT': instance.REST_URL_HOST_PORT,
      'REST_URL': instance.REST_URL,
      'WEBSOCKET_URL': instance.WEBSOCKET_URL,
      'IP_GEO_LOCATION_HOST_ADDRESS': instance.IP_GEO_LOCATION_HOST_ADDRESS,
      'allowedHosts': instance.allowedHosts,
      'ENVIRONMENT': instance.ENVIRONMENT,
      'sslCertificateLocation': instance.sslCertificateLocation,
      'DEFAULT_COUNTRY_CODE': instance.DEFAULT_COUNTRY_CODE,
      'DEFAULT_COUNTRY_DIAL_CODE': instance.DEFAULT_COUNTRY_DIAL_CODE,
      'IP_GEOLOCATION_API_KEY': instance.IP_GEOLOCATION_API_KEY,
      'imagePickerQuality': instance.imagePickerQuality,
      'imageThumbnailWidthSize': instance.imageThumbnailWidthSize,
      'minimumRecordingLength': instance.minimumRecordingLength,
      'IMAGE_DIRECTORY': instance.IMAGE_DIRECTORY,
      'VIDEO_DIRECTORY': instance.VIDEO_DIRECTORY,
      'FILE_DIRECTORY': instance.FILE_DIRECTORY,
      'AUDIO_DIRECTORY': instance.AUDIO_DIRECTORY,
      'supportEmail': instance.supportEmail,
      'header1': instance.header1,
      'header2': instance.header2,
      'header3': instance.header3,
      'header4': instance.header4,
      'header5': instance.header5,
      'header6': instance.header6,
      'inkWellDefaultPadding': instance.inkWellDefaultPadding,
      'emojiRows': instance.emojiRows,
      'emojiColumns': instance.emojiColumns,
      'recommendedEmojis': instance.recommendedEmojis,
      'recaptchaDisabledKeyword': instance.recaptchaDisabledKeyword,
      'recaptchaSecretKey': instance.recaptchaSecretKey,
      'recaptchaSkipKey': instance.recaptchaSkipKey,
      'skipRecaptcha': instance.skipRecaptcha,
      'numberOfRecords': instance.numberOfRecords,
      'verificationPinMaximumRetryTimes':
          instance.verificationPinMaximumRetryTimes,
      'allowedLoginUserRoles': instance.allowedLoginUserRoles,
      'copyrightYear': instance.copyrightYear,
      'copyrightCompanyName': instance.copyrightCompanyName,
      'copyrightCompanyLocation': instance.copyrightCompanyLocation,
      'poweredByCompanyText': instance.poweredByCompanyText,
      'versionNumber': instance.versionNumber,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$EnvironmentGlobalVariablesLombok {
  /// Field
  List<String> locales;
  String REST_URL_HOST_IP;
  String REST_URL_HOST_PORT;
  String REST_URL;
  String WEBSOCKET_URL;
  String IP_GEO_LOCATION_HOST_ADDRESS;
  List<String> allowedHosts;
  String ENVIRONMENT;
  String sslCertificateLocation;
  String DEFAULT_COUNTRY_CODE;
  String DEFAULT_COUNTRY_DIAL_CODE;
  String IP_GEOLOCATION_API_KEY;
  int imagePickerQuality;
  int imageThumbnailWidthSize;
  int minimumRecordingLength;
  String IMAGE_DIRECTORY;
  String VIDEO_DIRECTORY;
  String FILE_DIRECTORY;
  String AUDIO_DIRECTORY;
  String supportEmail;
  double header1;
  double header2;
  double header3;
  double header4;
  double header5;
  double header6;
  double inkWellDefaultPadding;
  int emojiRows;
  int emojiColumns;
  int recommendedEmojis;
  String recaptchaDisabledKeyword;
  String recaptchaSecretKey;
  String recaptchaSkipKey;
  bool skipRecaptcha;
  int numberOfRecords;
  int verificationPinMaximumRetryTimes;
  List<String> allowedLoginUserRoles;
  String copyrightYear;
  String copyrightCompanyName;
  String copyrightCompanyLocation;
  String poweredByCompanyText;
  String versionNumber;

  /// Setter

  void setLocales(List<String> locales) {
    this.locales = locales;
  }

  void setREST_URL_HOST_IP(String REST_URL_HOST_IP) {
    this.REST_URL_HOST_IP = REST_URL_HOST_IP;
  }

  void setREST_URL_HOST_PORT(String REST_URL_HOST_PORT) {
    this.REST_URL_HOST_PORT = REST_URL_HOST_PORT;
  }

  void setREST_URL(String REST_URL) {
    this.REST_URL = REST_URL;
  }

  void setWEBSOCKET_URL(String WEBSOCKET_URL) {
    this.WEBSOCKET_URL = WEBSOCKET_URL;
  }

  void setIP_GEO_LOCATION_HOST_ADDRESS(String IP_GEO_LOCATION_HOST_ADDRESS) {
    this.IP_GEO_LOCATION_HOST_ADDRESS = IP_GEO_LOCATION_HOST_ADDRESS;
  }

  void setAllowedHosts(List<String> allowedHosts) {
    this.allowedHosts = allowedHosts;
  }

  void setENVIRONMENT(String ENVIRONMENT) {
    this.ENVIRONMENT = ENVIRONMENT;
  }

  void setSslCertificateLocation(String sslCertificateLocation) {
    this.sslCertificateLocation = sslCertificateLocation;
  }

  void setDEFAULT_COUNTRY_CODE(String DEFAULT_COUNTRY_CODE) {
    this.DEFAULT_COUNTRY_CODE = DEFAULT_COUNTRY_CODE;
  }

  void setDEFAULT_COUNTRY_DIAL_CODE(String DEFAULT_COUNTRY_DIAL_CODE) {
    this.DEFAULT_COUNTRY_DIAL_CODE = DEFAULT_COUNTRY_DIAL_CODE;
  }

  void setIP_GEOLOCATION_API_KEY(String IP_GEOLOCATION_API_KEY) {
    this.IP_GEOLOCATION_API_KEY = IP_GEOLOCATION_API_KEY;
  }

  void setImagePickerQuality(int imagePickerQuality) {
    this.imagePickerQuality = imagePickerQuality;
  }

  void setImageThumbnailWidthSize(int imageThumbnailWidthSize) {
    this.imageThumbnailWidthSize = imageThumbnailWidthSize;
  }

  void setMinimumRecordingLength(int minimumRecordingLength) {
    this.minimumRecordingLength = minimumRecordingLength;
  }

  void setIMAGE_DIRECTORY(String IMAGE_DIRECTORY) {
    this.IMAGE_DIRECTORY = IMAGE_DIRECTORY;
  }

  void setVIDEO_DIRECTORY(String VIDEO_DIRECTORY) {
    this.VIDEO_DIRECTORY = VIDEO_DIRECTORY;
  }

  void setFILE_DIRECTORY(String FILE_DIRECTORY) {
    this.FILE_DIRECTORY = FILE_DIRECTORY;
  }

  void setAUDIO_DIRECTORY(String AUDIO_DIRECTORY) {
    this.AUDIO_DIRECTORY = AUDIO_DIRECTORY;
  }

  void setSupportEmail(String supportEmail) {
    this.supportEmail = supportEmail;
  }

  void setHeader1(double header1) {
    this.header1 = header1;
  }

  void setHeader2(double header2) {
    this.header2 = header2;
  }

  void setHeader3(double header3) {
    this.header3 = header3;
  }

  void setHeader4(double header4) {
    this.header4 = header4;
  }

  void setHeader5(double header5) {
    this.header5 = header5;
  }

  void setHeader6(double header6) {
    this.header6 = header6;
  }

  void setInkWellDefaultPadding(double inkWellDefaultPadding) {
    this.inkWellDefaultPadding = inkWellDefaultPadding;
  }

  void setEmojiRows(int emojiRows) {
    this.emojiRows = emojiRows;
  }

  void setEmojiColumns(int emojiColumns) {
    this.emojiColumns = emojiColumns;
  }

  void setRecommendedEmojis(int recommendedEmojis) {
    this.recommendedEmojis = recommendedEmojis;
  }

  void setRecaptchaDisabledKeyword(String recaptchaDisabledKeyword) {
    this.recaptchaDisabledKeyword = recaptchaDisabledKeyword;
  }

  void setRecaptchaSecretKey(String recaptchaSecretKey) {
    this.recaptchaSecretKey = recaptchaSecretKey;
  }

  void setRecaptchaSkipKey(String recaptchaSkipKey) {
    this.recaptchaSkipKey = recaptchaSkipKey;
  }

  void setSkipRecaptcha(bool skipRecaptcha) {
    this.skipRecaptcha = skipRecaptcha;
  }

  void setNumberOfRecords(int numberOfRecords) {
    this.numberOfRecords = numberOfRecords;
  }

  void setVerificationPinMaximumRetryTimes(
      int verificationPinMaximumRetryTimes) {
    this.verificationPinMaximumRetryTimes = verificationPinMaximumRetryTimes;
  }

  void setAllowedLoginUserRoles(List<String> allowedLoginUserRoles) {
    this.allowedLoginUserRoles = allowedLoginUserRoles;
  }

  void setCopyrightYear(String copyrightYear) {
    this.copyrightYear = copyrightYear;
  }

  void setCopyrightCompanyName(String copyrightCompanyName) {
    this.copyrightCompanyName = copyrightCompanyName;
  }

  void setCopyrightCompanyLocation(String copyrightCompanyLocation) {
    this.copyrightCompanyLocation = copyrightCompanyLocation;
  }

  void setPoweredByCompanyText(String poweredByCompanyText) {
    this.poweredByCompanyText = poweredByCompanyText;
  }

  void setVersionNumber(String versionNumber) {
    this.versionNumber = versionNumber;
  }

  /// Getter
  List<String> getLocales() {
    return locales;
  }

  String getREST_URL_HOST_IP() {
    return REST_URL_HOST_IP;
  }

  String getREST_URL_HOST_PORT() {
    return REST_URL_HOST_PORT;
  }

  String getREST_URL() {
    return REST_URL;
  }

  String getWEBSOCKET_URL() {
    return WEBSOCKET_URL;
  }

  String getIP_GEO_LOCATION_HOST_ADDRESS() {
    return IP_GEO_LOCATION_HOST_ADDRESS;
  }

  List<String> getAllowedHosts() {
    return allowedHosts;
  }

  String getENVIRONMENT() {
    return ENVIRONMENT;
  }

  String getSslCertificateLocation() {
    return sslCertificateLocation;
  }

  String getDEFAULT_COUNTRY_CODE() {
    return DEFAULT_COUNTRY_CODE;
  }

  String getDEFAULT_COUNTRY_DIAL_CODE() {
    return DEFAULT_COUNTRY_DIAL_CODE;
  }

  String getIP_GEOLOCATION_API_KEY() {
    return IP_GEOLOCATION_API_KEY;
  }

  int getImagePickerQuality() {
    return imagePickerQuality;
  }

  int getImageThumbnailWidthSize() {
    return imageThumbnailWidthSize;
  }

  int getMinimumRecordingLength() {
    return minimumRecordingLength;
  }

  String getIMAGE_DIRECTORY() {
    return IMAGE_DIRECTORY;
  }

  String getVIDEO_DIRECTORY() {
    return VIDEO_DIRECTORY;
  }

  String getFILE_DIRECTORY() {
    return FILE_DIRECTORY;
  }

  String getAUDIO_DIRECTORY() {
    return AUDIO_DIRECTORY;
  }

  String getSupportEmail() {
    return supportEmail;
  }

  double getHeader1() {
    return header1;
  }

  double getHeader2() {
    return header2;
  }

  double getHeader3() {
    return header3;
  }

  double getHeader4() {
    return header4;
  }

  double getHeader5() {
    return header5;
  }

  double getHeader6() {
    return header6;
  }

  double getInkWellDefaultPadding() {
    return inkWellDefaultPadding;
  }

  int getEmojiRows() {
    return emojiRows;
  }

  int getEmojiColumns() {
    return emojiColumns;
  }

  int getRecommendedEmojis() {
    return recommendedEmojis;
  }

  String getRecaptchaDisabledKeyword() {
    return recaptchaDisabledKeyword;
  }

  String getRecaptchaSecretKey() {
    return recaptchaSecretKey;
  }

  String getRecaptchaSkipKey() {
    return recaptchaSkipKey;
  }

  bool getSkipRecaptcha() {
    return skipRecaptcha;
  }

  int getNumberOfRecords() {
    return numberOfRecords;
  }

  int getVerificationPinMaximumRetryTimes() {
    return verificationPinMaximumRetryTimes;
  }

  List<String> getAllowedLoginUserRoles() {
    return allowedLoginUserRoles;
  }

  String getCopyrightYear() {
    return copyrightYear;
  }

  String getCopyrightCompanyName() {
    return copyrightCompanyName;
  }

  String getCopyrightCompanyLocation() {
    return copyrightCompanyLocation;
  }

  String getPoweredByCompanyText() {
    return poweredByCompanyText;
  }

  String getVersionNumber() {
    return versionNumber;
  }
}
