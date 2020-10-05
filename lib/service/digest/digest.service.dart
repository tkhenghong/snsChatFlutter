import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method

/// MessageDigest Service which is related to cryptography secure hashing.
class DigestService {
  String encryptWithSHA1(String password) {
    var bytes = utf8.encode(password); // data being hashed

    var digest = sha1.convert(bytes);

    print("Digest as bytes: ${digest.bytes}");
    print("Digest as hex string: $digest");

    return digest.toString();
  }
}