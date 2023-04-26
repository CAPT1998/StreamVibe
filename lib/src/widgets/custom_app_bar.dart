import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koinonia/flutter_flow/flutter_flow_icon_button.dart';
import 'package:koinonia/flutter_flow/flutter_flow_widgets.dart';
import 'package:provider/provider.dart';

import '../../flutter_flow/flutter_flow_theme.dart';
import '../../model/notifications.dart';
import '../../payment/choosePlanScreen.dart';
import '../helpers/utils.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    Key? key,
    required this.title,
    required this.userid,
    this.elevation = 2,
    this.preferredSizee = 50,
  }) : super(key: key);
  String userid;
  String title;
  double elevation;
  double preferredSizee;

  @override
  // TODO: implement preferredSize
  Size get preferredSize => new Size.fromHeight(preferredSizee);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: FlutterFlowTheme.of(context).black600),
      automaticallyImplyLeading: true,
      titleSpacing: 0,
      title: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            '$title',
            style: FlutterFlowTheme.of(context).title2.override(
                  fontFamily: 'Urbanist',
                  color: FlutterFlowTheme.of(context).black600,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Spacer(),
          FFButtonWidget(
            onPressed: () => {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 300),
                  pageBuilder: (ctx, animation, secondaryAnimation) =>
                      ChoosePlanScreen(
                    userid: userid,
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: new Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset.zero,
                          end: const Offset(1.0, 0.0),
                        ).animate(secondaryAnimation),
                        child: child,
                      ),
                    );
                  },
                ),
              ),
            },
            text: 'Upgrade',
            options: FFButtonOptions(
              // width: MediaQuery.of(context).size.width * 0.26,
              height: 30,
              color: Color(0xFFF15C00),
              textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(23),
            ),
          ),
          FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: FaIcon(
              FontAwesomeIcons.solidBell,
              color: Color(0xFFF15C00),
              size: 25,
            ),
            onPressed: () => {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 300),
                  pageBuilder: (ctx, animation, secondaryAnimation) =>
                      notification(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: new Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset.zero,
                          end: const Offset(1.0, 0.0),
                        ).animate(secondaryAnimation),
                        child: child,
                      ),
                    );
                  },
                ),
              ),
            },
          ),
        ],
      ),
      actions: [],
      centerTitle: false,
      elevation: elevation,
    );
  }
}
