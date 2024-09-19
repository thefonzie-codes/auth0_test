import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  Credentials? _credentials;

  late Auth0 auth0;

  @override
  void initState() {
    super.initState();
    auth0 = Auth0('dev-2e3ex0gt72zcmkgy.us.auth0.com', 'RdTWCqgEzcvjM2PvSlN6xuhZBT04cmaB');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login View'),
      ),
      body: Center(
        child: _credentials == null
            ? ElevatedButton(
                onPressed: () async {
                  // Use a Universal Link callback URL on iOS 17.4+ / macOS 14.4+
                  // useHTTPS is ignored on Android
                  final credentials = await auth0.webAuthentication(scheme: 'demo').login(useHTTPS: true);

                  setState(() {
                    _credentials = credentials;
                  });

                  if (credentials != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileView(user: credentials.user),
                      ),
                    );
                  }
                },
                child: const Text("Log in"),
              )
            : ElevatedButton(
                onPressed: () async {
                  // Use a Universal Link logout URL on iOS 17.4+ / macOS 14.4+
                  // useHTTPS is ignored on Android
                  await auth0.webAuthentication(scheme: 'demo').logout(useHTTPS: true);

                  setState(() {
                    _credentials = null;
                  });
                },
                child: const Text("Log out"),
              ),
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key, required this.user}) : super(key: key);

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile View'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user.name != null) Text(user.name!),
            if (user.email != null) Text(user.email!)
          ],
        ),
      ),
    );
  }
}