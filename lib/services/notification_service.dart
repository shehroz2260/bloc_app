import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as authss;
// import 'package:googleapis/servicecontrol/v1.dart' as serviceControl;

class NotificationService {
  // final _storage = GetStorage();
  // List<NotificationModel> _notifications = [];
  // List<NotificationModel> get notifications => _notifications;

  // void initNotificaitons() {
  //   final data = _storage.read("notification") as List? ?? [];
  //   _notifications = data.map((e) => NotificationModel().fromJson(e)).toList();
  //   update();
  // }

  // Future<void> saveNotification(NotificationModel notification) async {
  //   _notifications.insert(0, notification);
  //   _storage.write("notification", _notifications.map((e) => e.toJson()));
  // }

  Future<bool> sendNotification({
    // required String senderToToken,
    required String titleNotification,
    required String bodyNotification,
    required String type,
    // required Foster foster,
    required String fcmToken,
  }) async {
    debugPrint("+++ $fcmToken");
    debugPrint("+++ $bodyNotification");
    debugPrint("+++ $titleNotification");
    debugPrint("+++ $type");
    try {
      final Map<String, dynamic> body = {
        "message": {
          "token": fcmToken,
          "notification": {
            "title": titleNotification,
            "body": bodyNotification
          },
          "data": {"type": type}
        }
      };
      final asscessToken = await getAccessToken();
      final response = await http.post(
        Uri.parse(
            "https://fcm.googleapis.com/v1/projects/chat-app-bloc-c3ea9/messages:send"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer $asscessToken"
        },
        body: json.encode(body),
      );
      log("^^^^^^^^^^^^^^^${response.statusCode}");
      log("==>>>>>>>>${response.body}");

      if (response.statusCode != 200) {
        debugPrint("Status Code ${response.body}");
        return false;
      }
      return true;
    } catch (error) {
      debugPrint("Create token error");
      return false;
    }
  }

  Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "chat-app-bloc-c3ea9",
      "private_key_id": "4a4b30c4f664f9e2b62d80c5b71d850691d65488",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDIZJoZrtwG+p67\nnVGknK1ce1G6UHB72TBqOvHbGIldkW+XPNmm2aNRrOm8pZaDNcUYAmEmB7rOP+F8\nF2YLAxBPNUkMaXdUqsNcW22E25GHIx6KdHItRjjofU6kMrbl5TekAx5zUOPCrfrj\nTa+kxfcHUU/9j29spRON0Gx0YxVYuxIKMWQyTQH46R1AUniUkI8rygzorHbDIda1\nP2grRsMsNQLHSRmV6uIWINIFa0BQ4da6M7ebmUBVzgSDQGcZD/B3cYwNgCHL8QZ3\nI9f5yl6YPAJTTLoEmgngHcYR5XzYrwNUyYKjP29ppJNrUleKTyx1t/vFVGUsyc8a\nhbHMde0RAgMBAAECggEAAIl15qzuTskxoXojQnlEAF5Upx/m+4sdsNhShILPbWrv\nhlycoR5J0RB1ugS22tqB/ro5eeqBB3WqSflMODxn1HXuxRGjImXomL64r4MOrQUP\nLZG5zwYtLoDemIpArUfPIhvELIO27/MkUrVii7UpYAqb1957s3xcdxZ+NHl9WbBn\nazPitv+Y++J9FRTZ0YF1+Ei4YmBKYBHw91vgh5WoxS/bplzBYgWSrmjNxgzN/btJ\n3XqZ6VtbHEFCPG/zy0uAujvGSCD2Z+m8nIcoKRm0Jt27HjtZm/FFxMI/Tz6ztLe9\naU7MkdcxIxNkGj6xlIXZmxXhKNP9xqDTQMW4h0UuFQKBgQDwl0x7o/fyJzrtUNZ1\nhS2x/859yWBBLemYuERp1u712cO4ZfZ0dJS6G4CfgEMJNSuWPoZFyFHAkpBiZgu3\nNlAntmN2V40kpFqFsDtdLB8hU/zcOQtppl94TABvgawwxj4yXS90nXPv2b5J4Gjb\nHuuBDzmKI1k0ADF66Fp/eo9Q5QKBgQDVOjiXgTmmT4H7CkpvxWmQVRi63zZJx11c\n8gPZyL5fONki6BlhnYWnt+avlVbOCrIaFhjbUQqHC9pcHT5Yk/WjVv9GvXRsE6XG\nNZHvNV7bmKhXdjHtLP4FytzwbLL9rRk2UaBgfz5v0BsiCTRmtJbekcfconAvYs2A\n4Y8wqrskvQKBgQCXRSnrm17sPEpKqEcPQRtIDaTRZepFUQ7M3R72xRMeNTtgF4vs\nENjqYxxuLQD5KxsqrklSWu87+2sY0zyOh3HCZmUHJWkzHrtjzzikDnfMRrh35s4M\nMXVZd7/WXFvdlufIVtrdoZohtnB0lsqW60v7q4zsE+mkTnLN6oXsHS07GQKBgQC2\nFM2Wsscj+ekpEpSV9aI7mi9QBKQ7RH+5iwE2zHGkpsrlQAXMkdM8cZIQhhpmQEPu\nesgnIIE46SpCVsaSpWaxYO0E32u3jt+U7tH7zzt9klLOvSPNQQp6r80Tkf8XGOXa\nuMGXJZGPsco5ulqBCd17mkltY1khXeHXGMZJ7MF6kQKBgQDW74j17KMjO7j02VUt\naxLLQw3MsdT2xpYi57RCDEpuS+zQPpp2UZreOCPzET3Vw3Y8R+MpGH3bovYdiSl3\nTUQOIr6KbnAgKeAy2uZvC5stx6MTdBaifm8+K9VUelMUwFl7P6w83WqQZG+77dLF\nycracYbCq6PM48nqe7dHtfKKwA==\n-----END PRIVATE KEY-----\n",
      "client_email": "chat-bloc@chat-app-bloc-c3ea9.iam.gserviceaccount.com",
      "client_id": "115294422211429272606",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/chat-bloc%40chat-app-bloc-c3ea9.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await authss.clientViaServiceAccount(
        authss.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

    authss.AccessCredentials credentials =
        await authss.obtainAccessCredentialsViaServiceAccount(
            authss.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);
    client.close();
    return credentials.accessToken.data;
  }
}
