import 'package:flutter/material.dart';

import '../flutter_flow/flutter_flow_theme.dart';

class TermsPrivacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        iconTheme:
            IconThemeData(color: FlutterFlowTheme.of(context).customColor4),
        automaticallyImplyLeading: true,
        title: Align(
          alignment: AlignmentDirectional(-0.20, 0),
          child: Text(
            'Terms and Privacy',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).title2.override(
                  fontFamily: 'Poppins',
                  color: Color(0xFF150734),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 2,
      ),

      //AppBar(
      //   title: Text('Terms and Privacy'),
      //  ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms of Use',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Welcome to Koinonia Connect, a music streaming platform that allows you to discover and listen to your favorite music anytime, anywhere. By using our service, you agree to the following terms of use:',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '1. Content',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'All content on Koinonia Connect is for personal use only. You are not allowed to reproduce, distribute, or modify any of the content without the explicit permission of Koinonia Connect.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '2. Account',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'You must create an account in order to use Koinonia Connect. Your account information must be accurate and up-to-date. You are responsible for maintaining the confidentiality of your account information and password.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Koinonia Connect takes your privacy seriously. We only collect and use your personal information in accordance with our privacy policy. By using our service, you agree to our privacy policy.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to the full privacy policy page.
                },
                child: Text(
                  'Read our full privacy policy',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
