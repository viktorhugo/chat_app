
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum TypeShowAlert { info, error, success, warning }
const Color warning = Color(0xffee8d30);
const Color subWarning = Color(0xffcf571f);
const Color error = Color(0xffc82c41);
const Color subError = Color(0xff811437);
const Color success = Color(0xff0b7142);
const Color subSuccess = Color(0xff014e30);
const Color info = Color(0xff026fe0);
const Color subInfo = Color(0xff05488a);

const String warningIcon = 'assets/warning.svg';
const String errorIcon = 'assets/error.svg';
const String successIcon = 'assets/done.svg';
const String  infoIcon = 'assets/info.svg';

const String subIcon = 'assets/octopus.svg';


showAlert({ required BuildContext context, required String title, required String subtitle, required TypeShowAlert typeShowAlert}) {

  if (typeShowAlert == TypeShowAlert.error) {
    return alertView(
      context:context, 
      title: title, 
      subtitle: subtitle, 
      color: error, 
      icon: errorIcon,
      subColor: subError,
      subIcon: subIcon
    );
  }
  if (typeShowAlert == TypeShowAlert.info) {
    return alertView(
      context:context, 
      title: title, 
      subtitle: subtitle, 
      color: info, 
      subColor: subInfo,
      icon: infoIcon,
      subIcon: subIcon
    );
  }
  if (typeShowAlert == TypeShowAlert.success) {
    return alertView(
      context:context, 
      title: title, 
      subtitle: subtitle, 
      color: success, 
      subColor: subSuccess,
      icon: successIcon,
      subIcon: subIcon
    );
  }
  if (typeShowAlert == TypeShowAlert.warning) {
    return alertView(
      context:context, 
      title: title, 
      subtitle: subtitle, 
      color: warning, 
      subColor: subWarning,
      icon: warningIcon,
      subIcon: subIcon
    );
  }
}

alertView ({ 
  required BuildContext context, 
  required String title,
  required String subtitle,
  required Color color,
  required Color subColor,
  required String icon,
  required String subIcon 
} ) {

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 3500),
      content: BounceInUp(
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
          
              Container(
                padding: const EdgeInsets.all(15),
                height: 90,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.all(Radius.circular(20))
                ),
                child: Row(
                  children: [
          
                    const SizedBox(width: 48),
          
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle( fontSize: 19, color: Colors.white),
                          ),
                          Text(
                            subtitle,
                            style: const TextStyle( fontSize: 14, color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ),
          
              Positioned(
                top: -18,
                left: 6,
                child: ClipRRect(
                  child: Stack(
                    children: [
                      SvgPicture.asset(
                        icon,
                        height: 48,
                        width: 48,
                      )
                    ],
                  ),
                )
              ),
          
              Positioned(
                left: 6,
                bottom: 5,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20)),
                  child: Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/octopus.svg',
                        height: 50,
                        width: 30,
                        colorFilter: ColorFilter.mode(subColor, BlendMode.srcIn)
                      )
                    ],
                  ),
                )
              ),
            ]
          ),
        ),
      )
    )
  );
}

