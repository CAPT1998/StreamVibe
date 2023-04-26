import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'welcome_screen_model.dart';
export 'welcome_screen_model.dart';

class WelcomeScreenWidget extends StatefulWidget {
  const WelcomeScreenWidget({Key? key}) : super(key: key);

  @override
  _WelcomeScreenWidgetState createState() => _WelcomeScreenWidgetState();
}

class _WelcomeScreenWidgetState extends State<WelcomeScreenWidget> {
  late WelcomeScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WelcomeScreenModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Container(
                  width: double.infinity,
                  height: 350,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: Image.network(
                        'https://s3-alpha-sig.figma.com/img/b64f/210a/6df28648f1be3a09baf315967a1e1c7b?Expires=1676851200&Signature=jHirdKrCS7bhV6ywmu1BnocK8e-pA8XP9vJhY4SMKWPDPfBbHtkkw-k988Z0n8-eo6IN6Oe8ZBjq7kT41b9caAujUHWQv-uIS7sPcDcwtXzjRCBpyuEPYwZ-5mb4GR6tJ381TpvP-LuN3eXC9~r1nw4CuMa6pMbKp~kqUXJofpMV-hQSkrMnG~~-j0i0uiV3mkxXu6VWw8yjgQAWrtKw477RbxT2x8RguMt3kD2r8vX-KG3pd2up~NzuRduJgSERQXZDt~ngknRc00KWayhu8lwL5DB7X7o1QHOTPYmgLqUy9FJpCC99jBSdct9anZz1oP9lGx9bDKcCNi-4yWLawQ__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4',
                      ).image,
                    ),
                  ),
                  child: Container(
                    height: 316.8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF7310E1), Colors.black],
                        stops: [0, 1],
                        begin: AlignmentDirectional(0, -1),
                        end: AlignmentDirectional(0, 1),
                      ),
                    ),
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
