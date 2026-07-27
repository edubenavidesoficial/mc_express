import 'package:flutter/material.dart';
import 'package:mc_express/features/auth/presentation/auth_screen.dart';
import 'package:mc_express/features/booking/presentation/balance_payment_screen.dart';
import 'package:mc_express/features/booking/presentation/booking_success_screen.dart';
import 'package:mc_express/features/booking/presentation/booking_summary_screen.dart';
import 'package:mc_express/features/booking/presentation/quote_request_screen.dart';
import 'package:mc_express/features/booking/presentation/rating_screen.dart';
import 'package:mc_express/features/booking/presentation/recharge_screen.dart';
import 'package:mc_express/features/booking/presentation/service_payment_screen.dart';
import 'package:mc_express/features/booking/presentation/tracking_screen.dart';
import 'package:mc_express/features/home/presentation/home_screen.dart';
import 'package:mc_express/features/professional/presentation/professional_profile_screen.dart';
import 'package:mc_express/features/profile/presentation/account_screen.dart';
import 'package:mc_express/features/profile/presentation/history_screen.dart';
import 'package:mc_express/features/search/presentation/professionals_screen.dart';
import 'package:mc_express/features/splash/presentation/splash_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String auth = '/auth';
  static const String home = '/home';
  static const String professionals = '/professionals';
  static const String professionalProfile = '/professional-profile';
  static const String quoteRequest = '/quote-request';
  static const String bookingSummary = '/booking-summary';
  static const String bookingSuccess = '/booking-success';
  static const String tracking = '/tracking';
  static const String servicePayment = '/service-payment';
  static const String balancePayment = '/balance-payment';
  static const String recharge = '/recharge';
  static const String rating = '/rating';
  static const String history = '/history';
  static const String account = '/account';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (_) => const SplashScreen(),
      auth: (_) => const AuthScreen(),
      home: (_) => const HomeScreen(),
      professionals: (_) => const ProfessionalsScreen(),
      professionalProfile: (_) => const ProfessionalProfileScreen(),
      quoteRequest: (_) => const QuoteRequestScreen(),
      bookingSummary: (_) => const BookingSummaryScreen(),
      bookingSuccess: (_) => const BookingSuccessScreen(),
      tracking: (_) => const TrackingScreen(),
      servicePayment: (_) => const ServicePaymentScreen(),
      balancePayment: (_) => const BalancePaymentScreen(),
      recharge: (_) => const RechargeScreen(),
      rating: (_) => const RatingScreen(),
      history: (_) => const HistoryScreen(),
      account: (_) => const AccountScreen(),
    };
  }
}
