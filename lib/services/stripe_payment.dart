import 'dart:convert';
import 'dart:developer';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

const stripeSECRET = 'STRIPE_SECRET';
const testSTRIPESECRET = 'TEST_STRIPE_SECRET';

final apiKey = dotenv.env[testSTRIPESECRET];
const baseUrl = 'https://api.stripe.com';
const returnUrl = '';
const String currency = 'MXN';

class StripSetupIntent extends GetConnect implements GetxService {
  Map<String, dynamic>? _setupIntent;
  final String _customerId;
  final BuildContext context;
  StripSetupIntent(this._customerId, this.context);

  // final _baseController = BaseController(Get.context!, () {});

  Future<void> makeDefaultCard() async {
    try {
      //STEP 1: Create Payment Intent
      LoadingDialog.showProgress(context);
      _setupIntent = await createSetupIntent(_customerId);
      LoadingDialog.hideProgress(context);
      log('PaymentIntent>>>$_setupIntent');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: 'Kiip',
          setupIntentClientSecret: _setupIntent!['client_secret'],
          customerId: _setupIntent!['customer'],
          style: ThemeMode.light,
          billingDetailsCollectionConfiguration:
              const BillingDetailsCollectionConfiguration(
                  attachDefaultsToPaymentMethod: true),
        ),
      );
      await Stripe.instance.presentPaymentSheet();
    } catch (err) {
      LoadingDialog.hideProgress(context);
      throw Exception(err);
    }
  }

  createSetupIntent(String customerId) async {
    try {
      //Request body

      final body = {'customer': customerId, 'usage': 'off_session'}
          .entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');

      //Make post request to Stripe
      var response = await post(
        '$baseUrl/v1/setup_intents',
        body,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );
      return _checkResult(response);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<void> displaySetupSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: Get.context!,
            builder: (_) => const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100.0,
                      ),
                      SizedBox(height: 10.0),
                      Text("Payment Successful!"),
                    ],
                  ),
                ));
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      log("^^^^^^^^^^^^^^^^^^^^^^${e.toString()}");
      const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  static Future<dynamic> getPaymentList(String activityId,
      {String? uid}) async {
    try {
      var query = '';
      if (uid?.isNotEmpty ?? false) {
        query = "metadata['uid']:\"$uid\" AND ";
      }
      query = "$query metadata['activity_id']:\"$activityId\"";
      var queryParameters = {'query': query};
      // Make the payment request

      final uri = Uri.parse('$baseUrl/v1/payment_intents/search')
          .replace(queryParameters: queryParameters);

      //Make post request to Stripe
      var response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );

      var list = [];
      for (var e in (_checkResult(response)['data'] as List<dynamic>)) {
        if (e['status'] != 'canceled') {
          list.add(e);
        }
      }
      return list;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  static Future<dynamic> cancelPayment(String paymentId) async {
    try {
      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('$baseUrl/v1/payment_intents/$paymentId/cancel'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );
      return _checkResult(response);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  static Future<dynamic> capturePayment(String paymentId) async {
    try {
      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('$baseUrl/v1/payment_intents/$paymentId/capture'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );
      return _checkResult(response);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

/*
  static Future<dynamic> createPaymentIntent(
      String amount, String currency) async {
    var requestBody = {
      'amount': _calculateAmount(amount),
      'currency': currency,
    };
    var encodedBody = requestBody.entries.map((entry) {
      return '${Uri.encodeQueryComponent(entry.key)}=${Uri.encodeQueryComponent(entry.value.toString())}';
    }).join('&');

    // Add the metadata to the encodedBody
    var metadata = {
      'user_id': '12345',
      'subscription': 'premium',
      'signup_date': '2024-05-17',
    };

    // Add each metadata entry to the encoded body
    metadata.forEach((key, value) {
      encodedBody +=
          '&metadata[${Uri.encodeQueryComponent(key)}]=${Uri.encodeQueryComponent(value)}';
    });
    // Make the payment request
    var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Authorization': 'Bearer $API_KEY',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: encodedBody,
    );

    return _checkResult(response);
  }*/

  static String get googlePayPaymentProfile => """{
  "provider": "google_pay",
  "data": {
    "environment": "${kDebugMode ? "TEST" : "PRODUCTION"}",
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
            "gateway": "stripe",
            "stripe:version": "2024-04-10",
            "stripe:publishableKey": "${Stripe.publishableKey}"
          }
        },
        "parameters": {
          "allowedCardNetworks": ["VISA", "MASTERCARD"],
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "billingAddressRequired": false,
          "billingAddressParameters": {
            "format": "FULL",
            "phoneNumberRequired": true
          }
        }
      }
    ],
    "merchantInfo": {
      "merchantId": "BCR2DN4TZXQ3TJD4",
      "merchantName": "Lumo Aps"
    },
    "transactionInfo": {
      "countryCode": "DK",
      "currencyCode": "DKK"
    }
  }
}""";

  static String get applePayPaymentProfile => """{
  "provider": "apple_pay",
  "data": {
    "merchantIdentifier": "merchant.lumo.dk",
    "displayName": "Lumo",
    "merchantCapabilities": ["3DS", "debit", "credit"],
    "supportedNetworks": ["amex", "visa", "discover", "masterCard"],
    "countryCode": "DK",
    "currencyCode": "DKK",
    "requiredBillingContactFields": ["emailAddress", "name", "phoneNumber"],
    "requiredShippingContactFields": [],
    "shippingMethods": []
  }
}""";
}

class StripCard extends GetConnect implements GetxService {
  final String customerId;

  StripCard(this.customerId);

  Future<dynamic> getMyCards() async {
    // Make the payment request
    var response = await get(
      '$baseUrl/v1/customers/$customerId/payment_methods',
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$apiKey:'))}',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );

    log("^^^^^^^^^^^^^^^^^^^^^map ${response.body}");

    return _checkResult(response);
  }
}

class StripCustomer extends GetConnect implements GetxService {
  final String _uid;
  final String _email;

  StripCustomer(this._uid, this._email);

  Future<dynamic> getCustomer() async {
    List<dynamic>? existing = await _existingCustomer();
    //  print('Existing.>${existing?.length}>>$existing');
    if (existing?.isNotEmpty ?? false) {
      return existing?.first;
    }

    dynamic newCus = await _createCustomer();

    return newCus;
  }

  Future<dynamic> _existingCustomer() async {
    //   var queryParameters = {'query': "metadata['uid']:\"$_uid\""};
    var queryParameters = {'query': "email:\"$_email\""};

    // Make the payment request
    final response = await get(
      '$baseUrl/v1/customers/search',
      query: queryParameters,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );

    /*  final uri = Uri.parse('').replace(queryParameters: queryParameters);
    var response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $API_KEY',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );*/
    if (response.isOk) {
      return _checkResult(response)['data'] as List<dynamic>;
    }
    return null;
  }

  Future<dynamic> _createCustomer() async {
    var requestBody = {'email': _email};
    var metadata = {'uid': _uid};

    // Make the payment request
    final response = await post(
      '$baseUrl/v1/customers',
      _encodeData(requestBody, metadata),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );

    /*   var response = await http.post(
      Uri.parse('$BASE_URL/v1/customers'),
      headers: {
        'Authorization': 'Bearer $API_KEY',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: _encodeData(requestBody, metadata),
    );*/

    if (response.isOk) {
      return _checkResult(response);
    }
    return null;
    //['data'];
    //?? (List<dynamic>?;
  }
}

class StripCharges {}

class StripPayout {
  final String _accountId;
  final String _amount;
  final String _uid;
  final String _activityId;

  StripPayout(this._accountId, this._amount, this._uid, this._activityId);

  Future<dynamic> getPayoutToConnectedAccount() async {
    var metadata = {'uid': _uid, 'activity_id': _activityId};
    var requestBody = {
      'destination': _accountId,
      'amount': _calculateAmount(_amount),
      'currency': currency,
    };

    // Make the payment request
    var response = await http.post(
      Uri.parse('$baseUrl/v1/transfers'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: _encodeData(requestBody, metadata),
    );

    return _checkResult(response);
    //['data'];
    //?? (List<dynamic>?;
  }

  Future<dynamic> getPayoutToBank(String bankId) async {
    var metadata = {'uid': _uid, 'activity_id': _activityId};
    var requestBody = {
      'destination': bankId,
      'amount': _calculateAmount(_amount),
      'currency': currency,
    };

    // Make the payment request
    var response = await http.post(
      Uri.parse('$baseUrl/v1/payouts'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Stripe-Account': _accountId,
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: _encodeData(requestBody, metadata),
    );
    return _checkResult(response);
    //['data'];
    //?? (List<dynamic>?;
  }

  static Future<bool> isAlreadyPayout(
      String activityId, String uid, String email) async {
    var account = StripAccount(uid, email);
    var acc = await account.getAccount();
    if (acc['external_accounts']['data']?.isEmpty ?? true) {
      return false;
    }

    // Make the payment request
    var response = await http.get(
      Uri.parse('$baseUrl/v1/payouts?limit=100'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Stripe-Account': acc['id'],
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );

    if (kDebugMode) {
      print('Payouts>>>>${_checkResult(response)['data'].length}');
    }
    var body = _checkResult(response)['data']
        .where((e) => e['metadata']['activity_id'] == activityId)
        .toList();
    if (kDebugMode) {
      print('Body>>$body');
    }

    return body?.isNotEmpty ?? false;

    //['data'];
    //?? (List<dynamic>?;
  }
}

class StripAccount {
  final String _uid;
  final String _email;

  StripAccount(this._uid, this._email);

  Future<dynamic> getAccount() async {
    List<dynamic>? existing = await _existingAccount();
    if (existing?.isNotEmpty ?? false) {
      return existing?.first;
    }

    dynamic newCus = await _createAccount();

    return newCus;
  }

  Future<dynamic> _existingAccount() async {
    var queryParameters = {'query': "metadata['uid']:\"$_uid\""};
    // Make the payment request

    Uri.parse('$baseUrl/v1/accounts').replace(queryParameters: queryParameters);
    var response = await http.get(
      Uri.parse('$baseUrl/v1/accounts'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );
    // print('response>>>${_checkResult(response)['data'][0]['metadata']}');

    return _checkResult(response)['data']
            .where((e) => e['metadata']['uid'] == _uid)
            .toList() ??
        [];
  }

  Future<dynamic> _createAccount() async {
    var requestBody = {
      'email': _email,
      'business_type': 'individual',
      'type': 'express',
      'country': 'DK',
      'capabilities[transfers][requested]': 'true',
    };
    var metadata = {'uid': _uid};

    // Make the payment request
    var response = await http.post(
      Uri.parse('$baseUrl/v1/accounts'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: _encodeData(requestBody, metadata),
    );

    return _checkResult(response);
    //['data'];
    //?? (List<dynamic>?;
  }

  Future<dynamic> getBalance() async {
    var response = await http.get(
      Uri.parse('$baseUrl/v1/balance'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );
    // print('response>>>${_checkResult(response)['data'][0]['metadata']}');

    return _checkResult(response);
  }
}

class StripAccountLogin {
  final String _accountId;

  StripAccountLogin(this._accountId);

  Future<dynamic> getLoginUrl() async {
    // Make the payment request
    var response = await http.post(
      Uri.parse('$baseUrl/v1/account_links'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {
        'account': _accountId,
        'type': 'account_onboarding',
        'refresh_url': 'https://lumo.dk',
        'return_url': 'https://lumo.dk',
      },
    );
    return _checkResult(response);
    //['data'];
    //?? (List<dynamic>?;
  }
}

class StripSubscription extends GetConnect implements GetxService {
  final String _customerId;
  final String _price;
  final String _name;
  final String _requestId;

  StripSubscription(this._customerId, this._price, this._name, this._requestId);

  dynamic subscribe() async {
    final response = await post(
      'https://us-central1-kiip-51772.cloudfunctions.net/subscribe/subscribe',
      {
        'customerId': _customerId,
        'price': _price,
        'name': _name,
        'requestId': _requestId,
      }
          .entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
    if (response.isOk) {
      return response.body;
    }
    throw response.body;
  }

  dynamic subscribePrice() async {
    final response = await post(
      '$baseUrl/v1/prices',
      {
        'unit_amount': _calculateAmount(_price),
        'currency': currency,
        'recurring[interval]': 'month',
        'product_data[name]': _name,
      }
          .entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );

    if (response.isOk) {
      return response.body;
    }
    return null;
  }

  static getSubscriptionByRequestId(String requestId) async {
    var queryParameters = {'query': "metadata['requestId']:\"$requestId\""};
    final response = await GetConnect().get(
      '$baseUrl/v1/subscriptions/search',
      query: queryParameters,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );

    return response.body;
  }

  static cancelSubscription(String subscriptionId) async {
    final response = await GetConnect().delete(
      '$baseUrl/v1/subscriptions/$subscriptionId',
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );

    return response.body;
  }
}

dynamic _checkResult(dynamic response) {
  switch (response.statusCode) {
    case 200:
      {
        var data = response.body;
        if (kDebugMode) {
          print(data);
        }
        return data;
      }
    case 400:
      throw 'Bad Request \n The request was unacceptable, often due to missing a required parameter.>>${response.body}';
    case 401:
      throw 'Unauthorized \nNo valid API key provided.';
    case 402:
      throw 'Request Failed\nThe parameters were valid but the request failed.>>${response.body}';
    case 403:
      throw 'Forbidden\nThe API key doesn’t have permissions to perform the request.>>>>${response.body}';
    case 404:
      throw 'Not Found\nThe requested resource doesn’t exist.>>>${response.body}';
    case 409:
      throw 'Conflict\nThe request conflicts with another request (perhaps due to using the same idempotent key).';
    case 429:
      throw 'Too Many Requests\nToo many requests hit the API too quickly. We recommend an exponential backoff of your requests.';
    case 500 || 502 || 503 || 504:
      throw 'Server Errors\nSomething went wrong on Stripe’s end. (These are rare.)';
    default:
      throw 'Status Code:${response.statusCode}\n${response.body}';
  }
}

String _calculateAmount(String amount) {
  final calculatedAmount = (int.parse(amount)) * 100;
  return calculatedAmount.toString();
}

dynamic _encodeData(Map<String, dynamic> data, Map<String, dynamic> metadata,
    {String? keyValue}) {
  var encodedBody = data.entries.map((entry) {
    return '${Uri.encodeQueryComponent(entry.key)}=${Uri.encodeQueryComponent(entry.value.toString())}';
  }).join('&');
  metadata.forEach((key, value) {
    encodedBody +=
        '&${keyValue ?? 'metadata'}[${Uri.encodeQueryComponent(key)}]=${Uri.encodeQueryComponent(value)}';
  });

  return encodedBody;
}
