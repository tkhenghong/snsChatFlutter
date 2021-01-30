Steps to have SSL Pinning in Flutter:
1. Go to Windows OS, open the Chrome browser, go to any website that you need the access. Eg. vmerchant.neurogine.com
2. Extract the certificate from the browser in CER format, refer: https://medium.com/@menakajain/export-download-ssl-certificate-from-server-site-url-bcfc41ea46a2
3. Bring the .cer file into PROJECT_ROOT_DIRECTORY/lib/keystore directory.
4. Then go to main.dart file, load the file and override global HTTPClient (already implemented).
5. Done. Any exceptions like HandshakeException will disappear from console and you can connect to backend without any problems.


NOTE: Flutter also does accept .p12 (PKCS12 format) files for SSL connection.