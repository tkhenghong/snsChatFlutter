import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'environment_global_variables.g.dart';

/// The purpose of building this model is to control the consistency of the environment variables.
@data
@JsonSerializable()
class EnvironmentGlobalVariables {
  // Follows ISO 3166-1 alpha-2.
  @JsonKey(name: 'locales')
  List<String> locales;

  @JsonKey(name: 'REST_URL_HOST_IP')
  String REST_URL_HOST_IP;

  @JsonKey(name: 'REST_URL_HOST_PORT')
  String REST_URL_HOST_PORT;

  @JsonKey(name: 'REST_URL')
  String REST_URL;

  @JsonKey(name: 'WEBSOCKET_URL')
  String WEBSOCKET_URL;

  @JsonKey(name: 'IP_GEO_LOCATION_HOST_ADDRESS')
  String IP_GEO_LOCATION_HOST_ADDRESS;

  @JsonKey(name: 'allowedHosts')
  List<String> allowedHosts;

  @JsonKey(name: 'ENVIRONMENT')
  String ENVIRONMENT;

  @JsonKey(name: 'sslCertificateLocation')
  String sslCertificateLocation;

  @JsonKey(name: 'DEFAULT_COUNTRY_CODE')
  String DEFAULT_COUNTRY_CODE;

  @JsonKey(name: 'IP_GEOLOCATION_API_KEY')
  String IP_GEOLOCATION_API_KEY;

  @JsonKey(name: 'imagePickerQuality')
  int imagePickerQuality;

  @JsonKey(name: 'imageThumbnailWidthSize')
  int imageThumbnailWidthSize;

  @JsonKey(name: 'minimumRecordingLength')
  int minimumRecordingLength;

  @JsonKey(name: 'IMAGE_DIRECTORY')
  String IMAGE_DIRECTORY;

  @JsonKey(name: 'VIDEO_DIRECTORY')
  String VIDEO_DIRECTORY;

  @JsonKey(name: 'FILE_DIRECTORY')
  String FILE_DIRECTORY;

  @JsonKey(name: 'AUDIO_DIRECTORY')
  String AUDIO_DIRECTORY;

  // Support Email
  @JsonKey(name: 'supportEmail')
  String supportEmail;

  @JsonKey(name: 'header1')
  double header1;

  @JsonKey(name: 'header2')
  double header2;

  @JsonKey(name: 'header3')
  double header3;

  @JsonKey(name: 'header4')
  double header4;

  @JsonKey(name: 'header5')
  double header5;

  @JsonKey(name: 'header6')
  double header6;

  @JsonKey(name: 'inkWellDefaultPadding')
  double inkWellDefaultPadding;

  @JsonKey(name: 'emojiRows')
  int emojiRows;

  @JsonKey(name: 'emojiColumns')
  int emojiColumns;

  @JsonKey(name: 'recommendedEmojis')
  int recommendedEmojis;

  // Recaptcha
  @JsonKey(name: 'recaptchaDisabledKeyword')
  String recaptchaDisabledKeyword;

  @JsonKey(name: 'recaptchaSecretKey')
  String recaptchaSecretKey;

  @JsonKey(name: 'recaptchaSkipKey')
  String recaptchaSkipKey;

  @JsonKey(name: 'skipRecaptcha')
  bool skipRecaptcha;

  // Pageable configurations (Pagination)
  @JsonKey(name: 'numberOfRecords')
  int numberOfRecords;

  @JsonKey(name: 'verificationPinMaximumRetryTimes')
  int verificationPinMaximumRetryTimes;

  // Allowed user roles to be logged into the app.
  @JsonKey(name: 'allowedLoginUserRoles')
  List<String> allowedLoginUserRoles;

  @JsonKey(name: 'copyrightYear')
  String copyrightYear;

  @JsonKey(name: 'copyrightCompanyName')
  String copyrightCompanyName;

  @JsonKey(name: 'copyrightCompanyLocation')
  String copyrightCompanyLocation;

  @JsonKey(name: 'poweredByCompanyText')
  String poweredByCompanyText;

  @JsonKey(name: 'versionNumber')
  String versionNumber;

  EnvironmentGlobalVariables({
    this.locales,
    this.REST_URL_HOST_IP,
    this.REST_URL_HOST_PORT,
    this.REST_URL,
    this.WEBSOCKET_URL,
    this.IP_GEO_LOCATION_HOST_ADDRESS,
    this.allowedHosts,
    this.ENVIRONMENT,
    this.sslCertificateLocation,
    this.DEFAULT_COUNTRY_CODE,
    this.IP_GEOLOCATION_API_KEY,
    this.imagePickerQuality,
    this.imageThumbnailWidthSize,
    this.minimumRecordingLength,
    this.IMAGE_DIRECTORY,
    this.VIDEO_DIRECTORY,
    this.FILE_DIRECTORY,
    this.AUDIO_DIRECTORY,
    this.supportEmail,
    this.header1,
    this.header2,
    this.header3,
    this.header4,
    this.header5,
    this.header6,
    this.inkWellDefaultPadding,
    this.emojiRows,
    this.emojiColumns,
    this.recommendedEmojis,
    this.recaptchaDisabledKeyword,
    this.recaptchaSecretKey,
    this.recaptchaSkipKey,
    this.skipRecaptcha,
    this.numberOfRecords,
    this.verificationPinMaximumRetryTimes,
    this.allowedLoginUserRoles,
    this.copyrightYear,
    this.copyrightCompanyName,
    this.copyrightCompanyLocation,
    this.poweredByCompanyText,
    this.versionNumber,
  });

  factory EnvironmentGlobalVariables.fromJson(Map<String, dynamic> json) => _$EnvironmentGlobalVariablesFromJson(json);

  Map<String, dynamic> toJson() => _$EnvironmentGlobalVariablesToJson(this);
}
