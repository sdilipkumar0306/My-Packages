part of sdk0306;

class TextFormFieldService {
  bool isPasswordVisable;
  String? lableText;
  String? hintText;
  Widget? prefixIcon;
  Widget? sufixIcon;
  Color borderColor;
  Color iconBGColor;
  Function(String)? returnBack;
  String? Function(String?)? validator;

  TextFormFields textFormFields;

  TextFormFieldService(
      {required this.textFormFields,
      this.isPasswordVisable: true,
      this.borderColor: Colors.transparent,
      this.hintText,
      this.lableText,
      this.prefixIcon,
      this.sufixIcon,
      this.validator,
      this.iconBGColor: Colors.transparent,
      this.returnBack});
}

class TextFormFields {
  String textFieldType;
  TextEditingController? controller;

  TextFormFields(this.textFieldType, this.controller);
}

class TextType {
  static const String SUFIX_TAP = "SUFIX_TAP";
  static const String ON_CHANGE = "ON_CHANGE";
  static const String ON_SUBMIT = "ON_SUBMIT";

  static const String FOR_PASSWORD_WITH_TWO_ICONS_AND_EYE = "FOR_PASSWORD_WITH_TWO_ICONS_AND_EYE";
  static const String WITH_PREFIX_ICON_AND_BORDER = "WITH_PREFIX_ICON_AND_BORDER";
  static const String WITH_SUFIX_ICON_AND_BORDER = "WITH_SUFIX_ICON_AND_BORDER";
  static const String WITH_PREFIX_ICON_BG = "WITH_PREFIX_ICON_BG";
  static const String WITH_SUFIX_ICON_BG = "WITH_SUFIX_ICON_BG";
  static const String WITH_BOTH_ICONS_BG = "WITH_BOTH_ICONS_BG";
  static const String BASIC_WITH_BORDER = "BASIC_WITH_BORDER";
  static const String BASIC_WITHOUT_BORDER = "BASIC_WITHOUT_BORDER";
}

class CustomTextFormField extends StatefulWidget {
  final TextFormFieldService textFormFieldService;
  const CustomTextFormField({required this.textFormFieldService, Key? key}) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    switch (widget.textFormFieldService.textFormFields.textFieldType) {
      case "WITH_PREFIX_ICON_BG":
        {
          return withPrefixIconBg();
        }
      case "WITH_SUFIX_ICON_BG":
        {
          return withSufixIconBG();
        }
      case "WITH_BOTH_ICONS_BG":
        {
          return withBothIconsWitrhBG();
        }
      case "BASIC_WITH_BORDER":
        {
          return basicTextFieldWithBorder();
        }
      case "BASIC_WITHOUT_BORDER":
        {
          return basicTextFieldWithoutBorder();
        }

      default:
        {
          return basicTextFieldWithoutBorder();
        }
    }
  }

  Widget basicTextFieldWithoutBorder() {
    return TextFormField(
      controller: widget.textFormFieldService.textFormFields.controller,
      validator: widget.textFormFieldService.validator,
      onChanged: (text) {
        widget.textFormFieldService.returnBack!(TextType.ON_CHANGE);
      },
      onFieldSubmitted: (text) {
        widget.textFormFieldService.returnBack!(TextType.ON_SUBMIT);
      },
    );
  }

  Widget basicTextFieldWithBorder() {
    return TextFormField(
      controller: widget.textFormFieldService.textFormFields.controller,
      obscureText: !widget.textFormFieldService.isPasswordVisable,
      validator: widget.textFormFieldService.validator,
      onChanged: (text) {
        widget.textFormFieldService.returnBack!(TextType.ON_CHANGE);
      },
      onFieldSubmitted: (text) {
        widget.textFormFieldService.returnBack!(TextType.ON_SUBMIT);
      },
      decoration: new InputDecoration(
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: widget.textFormFieldService.borderColor)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: widget.textFormFieldService.borderColor)),
        disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: widget.textFormFieldService.borderColor)),
        labelText: widget.textFormFieldService.lableText ?? "",
        hintText: widget.textFormFieldService.hintText ?? "",
        fillColor: Colors.white,
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(5.0),
        ),
      ),
    );
  }

  Widget withPrefixIconBg() {
    return TextFormField(
        controller: widget.textFormFieldService.textFormFields.controller,
        obscureText: !widget.textFormFieldService.isPasswordVisable,
        validator: widget.textFormFieldService.validator,
        onChanged: (text) {
          widget.textFormFieldService.returnBack!(TextType.ON_CHANGE);
        },
        onFieldSubmitted: (text) {
          widget.textFormFieldService.returnBack!(TextType.ON_SUBMIT);
        },
        decoration: InputDecoration(
          labelText: widget.textFormFieldService.lableText ?? "",
          hintText: widget.textFormFieldService.hintText ?? "",
          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(5.0),
          ),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: widget.textFormFieldService.borderColor)),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: widget.textFormFieldService.borderColor)),
          disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: widget.textFormFieldService.borderColor)),
          prefixIcon: Container(
            margin: EdgeInsets.only(right: 8),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: widget.textFormFieldService.iconBGColor, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), topLeft: Radius.circular(5))),
            child: widget.textFormFieldService.prefixIcon,
          ),
        ));
  }

  Widget withSufixIconBG() {
    return TextFormField(
        controller: widget.textFormFieldService.textFormFields.controller,
        obscureText: !widget.textFormFieldService.isPasswordVisable,
        validator: widget.textFormFieldService.validator,
        onChanged: (text) {
          widget.textFormFieldService.returnBack!(TextType.ON_CHANGE);
        },
        onFieldSubmitted: (text) {
          widget.textFormFieldService.returnBack!(TextType.ON_SUBMIT);
        },
        decoration: InputDecoration(
          labelText: widget.textFormFieldService.lableText ?? "",
          hintText: widget.textFormFieldService.hintText ?? "",
          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(5.0),
          ),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: widget.textFormFieldService.borderColor)),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: widget.textFormFieldService.borderColor)),
          disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: widget.textFormFieldService.borderColor)),
          suffixIcon: Container(
            margin: EdgeInsets.only(right: 8),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: widget.textFormFieldService.iconBGColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  topLeft: Radius.circular(5),
                )),
            child: IconButton(
              splashRadius: 1,
              onPressed: () {
                widget.textFormFieldService.returnBack!(TextType.SUFIX_TAP);
              },
              icon: widget.textFormFieldService.sufixIcon ?? Icon(Icons.visibility),
            ),
          ),
        ));
  }

  Widget withBothIconsWitrhBG() {
    return TextFormField(
        controller: widget.textFormFieldService.textFormFields.controller,
        obscureText: !widget.textFormFieldService.isPasswordVisable,
        validator: widget.textFormFieldService.validator,
        onChanged: (text) {
          widget.textFormFieldService.returnBack!(TextType.ON_CHANGE);
        },
        onFieldSubmitted: (text) {
          widget.textFormFieldService.returnBack!(TextType.ON_SUBMIT);
        },
        decoration: InputDecoration(
          labelText: widget.textFormFieldService.lableText ?? "",
          hintText: widget.textFormFieldService.hintText ?? "",
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: widget.textFormFieldService.borderColor)),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: widget.textFormFieldService.borderColor)),
          disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: widget.textFormFieldService.borderColor)),
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(5.0),
          ),
          prefixIcon: Container(
              margin: EdgeInsets.only(right: 8),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: widget.textFormFieldService.iconBGColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5),
                  )),
              child: widget.textFormFieldService.prefixIcon),
          suffixIcon: Container(
            margin: EdgeInsets.only(left: 8),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: widget.textFormFieldService.iconBGColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(5),
                  topRight: Radius.circular(5),
                )),
            child: IconButton(
              splashRadius: 1,
              onPressed: () {
                widget.textFormFieldService.returnBack!(TextType.SUFIX_TAP);
              },
              icon: widget.textFormFieldService.sufixIcon ?? Icon(Icons.visibility),
            ),
          ),
        ));
  }
}
