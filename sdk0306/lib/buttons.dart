part of sdk0306;

class Buttons extends StatefulWidget {
  final ButtonService buttonService;
  const Buttons(this.buttonService, {Key? key}) : super(key: key);

  @override
  _ButtonsState createState() => _ButtonsState();
}

class BtnConstants {
  static const String WITHOUT_ICON = "WITHOUT_ICON";
  static const String WITH_SUFIX_ICON = "WITH_SUFIX_ICON";
  static const String CUSTOM_RADIUS_WITHOUT_ICON = "CUSTOM_RADIUS_WITHOUT_ICON";
  static const String CUSTOM_RADIUS_WITH_ICON = "CUSTOM_RADIUS_WITH_ICON";
  static const String BASIC_BUTTON = "BASIC_BUTTON";

  static const String ON_TAP = "ON_TAP";
  static const String ON_LONG_PRESS = "ON_LONG_PRESS";
}

class _ButtonsState extends State<Buttons> {
  @override
  Widget build(BuildContext context) {
    switch (widget.buttonService.buttonData.type) {
      case BtnConstants.WITHOUT_ICON:
        return customButtonWithoutIcons();
      case BtnConstants.WITH_SUFIX_ICON:
        return customButtonWithSufixIcons();
      case BtnConstants.CUSTOM_RADIUS_WITHOUT_ICON:
        return customBtnRadiusWithoutIcons();
      case BtnConstants.CUSTOM_RADIUS_WITH_ICON:
        return customBtnRadiusWithIcons();
      default:
        return basicButton();
    }
  }

  Widget basicButton() {
    return ElevatedButton(
        onPressed: () {
          widget.buttonService.buttonData.returnBack(BtnConstants.ON_TAP);
        },
        onLongPress: () {
          widget.buttonService.buttonData.returnBack(BtnConstants.ON_LONG_PRESS);
        },
        child: Text(
          widget.buttonService.buttonData.text,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: widget.buttonService.textColor, fontSize: widget.buttonService.txtSize),
        ));
  }

  Widget customButtonWithoutIcons() {
    return ElevatedButton(
      child: Text(
        widget.buttonService.buttonData.text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: widget.buttonService.textColor, fontSize: widget.buttonService.txtSize),
      ),
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(widget.buttonService.textColor),
          backgroundColor: MaterialStateProperty.all<Color>(widget.buttonService.bGColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.buttonService.borderRadius),
              side: BorderSide(color: widget.buttonService.borderColor),
            ),
          )),
      onPressed: () {
        widget.buttonService.buttonData.returnBack(BtnConstants.ON_TAP);
      },
      onLongPress: () {
        widget.buttonService.buttonData.returnBack(BtnConstants.ON_LONG_PRESS);
      },
    );
  }

  Widget customButtonWithSufixIcons() {
    return ElevatedButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            widget.buttonService.buttonData.text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: widget.buttonService.textColor, fontSize: widget.buttonService.txtSize),
          ),
          Icon(
            widget.buttonService.sufixIcon,
            color: widget.buttonService.iconColor,
          )
        ],
      ),
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(widget.buttonService.textColor),
          backgroundColor: MaterialStateProperty.all<Color>(widget.buttonService.bGColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.buttonService.borderRadius),
              side: BorderSide(color: widget.buttonService.borderColor),
            ),
          )),
      onPressed: () {
        widget.buttonService.buttonData.returnBack(BtnConstants.ON_TAP);
      },
      onLongPress: () {
        widget.buttonService.buttonData.returnBack(BtnConstants.ON_LONG_PRESS);
      },
    );
  }

  Widget customBtnRadiusWithoutIcons() {
    return ElevatedButton(
      child: Text(
        widget.buttonService.buttonData.text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: widget.buttonService.textColor, fontSize: widget.buttonService.txtSize),
      ),
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(widget.buttonService.textColor),
          backgroundColor: MaterialStateProperty.all<Color>(widget.buttonService.bGColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(widget.buttonService.customBorderSides!.topLeft),
                bottomLeft: Radius.circular(widget.buttonService.customBorderSides!.bottonleft),
                topRight: Radius.circular(widget.buttonService.customBorderSides!.topRight),
                bottomRight: Radius.circular(widget.buttonService.customBorderSides!.bottonRight),
              ),
              side: BorderSide(color: widget.buttonService.borderColor),
            ),
          )),
      onPressed: () {
        widget.buttonService.buttonData.returnBack(BtnConstants.ON_TAP);
      },
      onLongPress: () {
        widget.buttonService.buttonData.returnBack(BtnConstants.ON_LONG_PRESS);
      },
    );
  }

  Widget customBtnRadiusWithIcons() {
    return ElevatedButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            widget.buttonService.buttonData.text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: widget.buttonService.textColor, fontSize: widget.buttonService.txtSize),
          ),
          Icon(
            widget.buttonService.sufixIcon,
            color: widget.buttonService.iconColor,
          )
        ],
      ),
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(widget.buttonService.textColor),
          backgroundColor: MaterialStateProperty.all<Color>(widget.buttonService.bGColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(widget.buttonService.customBorderSides!.topLeft),
                bottomLeft: Radius.circular(widget.buttonService.customBorderSides!.bottonleft),
                topRight: Radius.circular(widget.buttonService.customBorderSides!.topRight),
                bottomRight: Radius.circular(widget.buttonService.customBorderSides!.bottonRight),
              ),
              side: BorderSide(color: widget.buttonService.borderColor),
            ),
          )),
      onPressed: () {
        widget.buttonService.buttonData.returnBack(BtnConstants.ON_TAP);
      },
      onLongPress: () {
        widget.buttonService.buttonData.returnBack(BtnConstants.ON_LONG_PRESS);
      },
    );
  }
}

class ButtonService {
  Color textColor;
  double txtSize;
  double borderRadius;
  Color bGColor;
  Color borderColor;
  Color iconColor;
  IconData? sufixIcon;
  ButtonData buttonData;
  CustomBorderSides? customBorderSides;

  ButtonService({
    required this.buttonData,
    this.borderRadius: 5,
    this.txtSize: 18,
    this.textColor: Colors.black,
    this.bGColor: Colors.transparent,
    this.borderColor: Colors.black,
    this.iconColor: Colors.black,
    this.sufixIcon,
    this.customBorderSides,
  });
}

class CustomBorderSides {
  double topRight;
  double bottonRight;
  double topLeft;
  double bottonleft;

  CustomBorderSides({
    this.topRight: 5.0,
    this.bottonRight: 5.0,
    this.topLeft: 5.0,
    this.bottonleft: 5.0,
  });
}

class ButtonData {
  String type;
  String text;
  Function(String) returnBack;
  ButtonData({
    required this.type,
    required this.text,
    required this.returnBack,
  });
}
