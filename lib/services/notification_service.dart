import 'dart:convert';
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
      // "type": "service_account",
      // "project_id": "chat-app-bloc-c3ea9",
      // "private_key_id": "8c95d09d0f2ca81cf21812e17efbc7546add6211",
      // "private_key":
      //     "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDT+o3ujJew+Aul\nvmx3s/WApux+4SOVwQEjA8spJieTS22cZOyII2qMN8Nq0xO3Cv8gZXy6IrqCcykW\nYjP7vrQJroQyZCmfc/ePUXDufxVnGZQjSybaEhWKiNeYbLNuoCh4i39mt9sLH/9M\nrvhY8QmXB4RtfyHBTdGC+Mboy+UI4SDe9gjRGOBW55xP7ySWC/X6t0IeTkrcL0i6\n7aDAK7ufsaN4dq1ahTwwb+G9anub2/O7uIoBiZucLoejKBppedOmm3KUu2yhMUjQ\n+cVLMiZShp7eAmJzxwX+Frqw4JxkP4Ih0S2CAwRHBiPWFTVBDsS0S5nydGAZHuZa\n5IJs+uaTAgMBAAECggEADI0q50OS3csqIWO/l2zj7fy0RyT8jurxLsoUNvkH4dxW\n/qopKTxznB7XJtWdtrpjdd8cfgb9ZSj9d1JUQqU9ks8vC67LmiHrOCS5251RvpuQ\nnnBeOg5VETFeFqvlCflYvB6CaiobwbJg0wEPOnD3QOaUjEk5TfFWJPunB3S/OIHE\nbGxDQXiMOtiL10oCRvD5IBfRUXVXLJR+zyJxzHX3SO/PNN//1tqpKyVuPYVDj4ZE\nkp/wNDAPFOW2bnCYpWUypI3gj4yvATNtmKcr0Y+9mmGn+2CScHnuwryCRaKztBW7\nGPdf+5HGnvO4QDg6xdyjoMgc1DGWMqiN2XfYEsrQOQKBgQDzAt7YfXVbZhCt/HYM\nmWCF4VXv8wKqnh/hQa1HCTfaM4XYQHXdI3fqA0OKB3XY2HcnDkta6yz04lEhFoN9\nWL3iNl4V7FJC7aL0hXOjsEls3kiNafFhJWhCIX3p/p5qiHxBsUlp3d8jOpIMJdpt\nAp/ZueX8PLOvmvNUj3ywByOUywKBgQDfTxDHHuhyFIL4fxb1KFvfYz0ChijqoTx4\nOL+Dg3Hm1qzB55qkrxYHFNLLbUnU8rTIZXwJ54nKYtziVWxvBKv5xGJdMMGoxNhD\nVcw6KfaI01KHNY4yaxNxlbn3DIIqBaAkpx+AKBkMHNMkp9pEbZNEvJlty37j//v4\nk2ItubsEWQKBgAIHPRrreSZJJMx+9fFG+nJDnjcBfT01UqjLpomYPxoYIf7bEuDE\nogSXAGJPi6FCtUPjL6fTnK1ykiDHklNigTs5HvHp5gne9+Q4lO2B1CsPc+WSQ8x+\nxm7+3pEsaeATwY2+0BENJAakP4HQcxFD21ey4IOJcip+DZfgFrdVZ+ufAoGBAN8U\nn1AsQk3ky8nvPEIA5XbOLp6c47cxB7WaC0gYQes3PjIfas9l0X2VgdeTABTpuUwQ\nhc9nLLGv/bVlXQOzCRJk61bpZC1zKBBsX68jSJP7eBB2oe0gJrZruvFf35CXOhoj\nkkZ2yD7fdNbDkDqXtG0Qc73JcqPWkCMNKSFAz+FRAoGAFlf11sM2DY27pUiK2LZL\npL3edFdyeCsELOmT6UUyPJbFlFMULITA3DvQdbs5pEqrEsuZl/Cja1JI1Wi2M+B5\n9hHZBJRaPC+v/H4oLb8i9UZVXVODHwRKUC6m8KnCf40D4BBfxTpfl+UvcNPdJhdi\n/HSkrPJWUH5LoZjvu9fR6/4=\n-----END PRIVATE KEY-----\n",
      // "client_email":
      //     "firebase-adminsdk-ufdiu@chat-app-bloc-c3ea9.iam.gserviceaccount.com",
      // "client_id": "111024950175309721425",
      // "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      // "token_uri": "https://oauth2.googleapis.com/token",
      // "auth_provider_x509_cert_url":
      //     "https://www.googleapis.com/oauth2/v1/certs",
      // "client_x509_cert_url":
      //     "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-ufdiu%40chat-app-bloc-c3ea9.iam.gserviceaccount.com",
      // "universe_domain": "googleapis.com"
      "type": "service_account",
      "project_id": "chat-app-bloc-c3ea9",
      "private_key_id": "ec34b05f756a818638119a382457c9ccd5161ed7",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCJlh/9W0OCUWPl\nHCk/LlS+zKL7nbHaKEyP2up0/KAuMiUMp3ZFRQBVfSHGuDhhux9PL/yJs24coudo\nm3O5mYJiciRHGZ3R5ywwbY/XsF3LytQR37IcxKmIqrh40c4r6jLs+zPi800XyI0J\nKUWpPfpOGRGOQGUp2Sly7RSJHGjV92KYsCXRAVoJQJ43zW1+QsD5hraIeeMq0gvY\npBzdauvok0KjxranPjqfrpUFnHKQIc3cYqu2dqTSbBbsn6Um6P8nb38uKsfqmD86\negz0WX8UYAh42i6yLYpwya2HcFdz8zxFsuRYj4DXPXgfcumKTcjheR7tmDv/b7xv\nluQ6joV/AgMBAAECggEADwM5hFyj9iFJZCN5gLJeft83XXssf+Br0jqR4Kf8Fm5U\nSpgvOIm56poXyGYriMZxOSPES4YvmqJP28MykmrkpjdMLBHofZHa6YHa8y8EXQtJ\nrpWZCriOwyHVtSE3fOU2H1OdqsLfg5vXf8toFXp0yHbFyp7OKw3ODwM9fWSDL+2A\neL5yXyr3+Ey2IjgY/Sq/m+/rFCnbxON7fFmFYNj2FkNepaZnB7SfFvdsPKjrLIlc\nkikvuWOtuKeV7E2IHrzp9QFvdzQnnwNL0b7c6CBWTU2SDt3QvqIJTrAzQrMWN0rr\nRCW4eiZDNMVqEY0ZYtGtcTSBcrBvFn6A87NtKQcJqQKBgQC7rj6oA9Mcr+dmKVJc\nonuOiQhIrz3K4cwsXKbdglc7kvk9LJHJB97nQ0n+iaTn2iZ2YQZmyCeTu/WFVn05\nzkNs6wuBe7ZJXc1/Wg8QhwdGoyEIy/zy214hj/TPBHZ8QOnBZPq0Md1gpxer3MnV\nliBB1+DFTfPUdjwZKBNBWYTsawKBgQC7q6eLRplq4EBSsZLUPbLDgk2QCKvBRDeD\nV94cpzWqIhH81lv19buEEAPQugBauUGTbUOkvqVNk5IBiNYwDZxGPLLgI88SkthS\ny4XGuogC5lBiW6Pu4/38j0xwuBbtn1MifLuaOpLcPXFXBO/ImXXeSMhVW0UdbyeO\nuSm/3DKQPQKBgFgnhRioCz5bRWaQHDaUv1J4/SIe5fhozN09e8dp1I2QAHACgkuZ\n3dJkodnkT0f0CMLr2fTnKOfUjoNd154SS0tar+HW+Q1G+SJLa+4Ibpt4PikCn8J2\n1aUQGB4w63J7jxCe3L9M+L3QXmcEYu1nAanLu7ERZ2kxTBNI5pp4cN4XAoGAfelj\nFZyeXghq35BoFKH4iBeqdlJ6+cYNAMA5Mzw0UxtcuigPtuvRjX85MBc7GaNljcYn\nNib6vRufQAxQuBjJmo4q7RrZWXrQTGxkKrsHefqQQA1/5U1uIL776Dx6lZ7pph/N\ntmJKGh3XJy0Wu53KaQKn9iywKFllTuqISkMwYXkCgYEApryNYnyFQ1uhzIshB9B2\np7eovp/BEIxFSR1omencPFoaMciT5yq6JErxlFl5SOBKY+SVn3R+KiNJ9jVgpic9\ndOhfBHa+svR1HPwkoO4qsEcPY2CYxMb9FHMRHVC1JHXjXXFfuM2zdS+NRLxB8Y75\nkIZD6cp7up6k6zAUf32YVl8=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "friendz-dating@chat-app-bloc-c3ea9.iam.gserviceaccount.com",
      "client_id": "109971854526329126147",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/friendz-dating%40chat-app-bloc-c3ea9.iam.gserviceaccount.com",
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
