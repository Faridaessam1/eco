import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:multi_payment_gateway/services/paypal_service.dart';
import 'package:multi_payment_gateway/setup_payment.dart';
import 'package:multi_payment_gateway/transaction.dart';

class PaymentService {
  static Future<void> payWithPaypal(BuildContext context) async {
    final paypalModel = SetupePaypalPayment(
      context: context,
      clientId: dotenv.env["PAYPAL_CLIENT_ID"] ?? "",
      secretKey: dotenv.env["PAYPAL_SECRET_KEY"] ?? "",
    );

    await PaypalService.instance.pay(setupPayment: paypalModel);
  }
}
