library intl_phone_field;

import 'package:flutter/material.dart';
import './countries.dart';
import './phone_number.dart';

class IntlPhoneField extends StatefulWidget {
  final bool obscureText;
  final TextAlign textAlign;
  final Function onPressed;
  final bool readOnly;
  final Function validator;
  final FormFieldSetter<PhoneNumber> onSaved;
  final ValueChanged<PhoneNumber> onChanged;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function onSubmitted;

  /// Country Code (e.g +65)
  String selectedCountryCode;
  final InputDecoration decoration;
  final TextStyle style;

  IntlPhoneField({
    this.selectedCountryCode = '+93',
    this.obscureText = false,
    this.textAlign = TextAlign.left,
    this.onPressed,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.focusNode,
    this.decoration,
    this.style,
    this.onSubmitted,
    this.validator,
    this.onChanged,
    this.onSaved,
  });

  @override
  _IntlPhoneFieldState createState() => _IntlPhoneFieldState();
}

class _IntlPhoneFieldState extends State<IntlPhoneField> {
  List<dynamic> filteredCountries = countries;

  Future<void> _changeCountry() async {
    filteredCountries = countries;
    await showDialog(
      context: context,
      child: StatefulBuilder(
        builder: (ctx, setState) => Dialog(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    labelText: 'Search by Country Name or Code',
                  ),
                  onChanged: (value) {
                    setState(() {
                      filteredCountries = countries.where((country) {
                        final matchesCountryName = country['name']
                            .toLowerCase()
                            .contains(value.toLowerCase());
                        final matchesCountryCode = country['dial_code']
                            .toLowerCase()
                            .contains(value.toLowerCase());
                        return matchesCountryName || matchesCountryCode;
                      }).toList();
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) => Column(
                      children: <Widget>[
                        ListTile(
                          leading: Text(
                            filteredCountries[index]['flag'],
                            style: TextStyle(fontSize: 30),
                          ),
                          title: Text(
                            filteredCountries[index]['name'],
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          trailing: Text(
                            filteredCountries[index]['dial_code'],
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          onTap: () {
                            widget.selectedCountryCode =
                                filteredCountries[index]['dial_code'];
                            Navigator.of(context).pop();
                          },
                        ),
                        Divider(
                          thickness: 1,
                        ),
                      ],
                    ),
                    itemCount: filteredCountries.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    setState(() {});
  }

  Map<String, dynamic> countryForCode(String countryCode) {
    return countries.where((item) {
      return item['dial_code'] == countryCode;
    }).toList()[0];
  }

  @override
  Widget build(BuildContext context) {
    final selectedCountry = countryForCode(widget.selectedCountryCode);
    return Row(
      children: <Widget>[
        InkWell(
          child: Container(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  selectedCountry['flag'],
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  width: 10,
                ),
                FittedBox(
                  child: Text(
                    selectedCountry['dial_code'],
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          onTap: _changeCountry,
        ),
        Expanded(
          child: TextFormField(
            readOnly: widget.readOnly,
            obscureText: widget.obscureText,
            textAlign: widget.textAlign,
            onTap: widget.onPressed,
            controller: widget.controller,
            focusNode: widget.focusNode,
            onFieldSubmitted: widget.onSubmitted,
            decoration: widget.decoration,
            style: widget.style,
            onSaved: (value) {
              widget.onSaved(
                PhoneNumber(
                    countryCode: selectedCountry['dial_code'], number: value),
              );
            },
            onChanged: (value) {
              widget.onChanged(
                PhoneNumber(
                    countryCode: selectedCountry['dial_code'], number: value),
              );
            },
            validator: widget.validator,
            keyboardType: widget.keyboardType,
          ),
        ),
      ],
    );
  }
}
