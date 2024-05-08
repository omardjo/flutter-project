import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn(
    // You do not typically need to provide the clientId for Android.
    // clientId is used for web applications.
    // serverClientId is used if you want to pass an authorization code to your server.
    // serverClientId: 'YOUR_SERVER_CLIENT_ID', // Only if needed
  );

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();

  static Future logout() => _googleSignIn.disconnect();
}