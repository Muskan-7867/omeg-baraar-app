import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/checkout/text_fields.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';

class AddressInputFields extends StatelessWidget {
  final TextEditingController streetController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController countryController;
  final TextEditingController pincodeController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController address1Controller;

  const AddressInputFields({
    super.key,
    required this.streetController,
    required this.cityController,
    required this.stateController,
    required this.countryController,
    required this.pincodeController,
    required this.phoneController,
    required this.addressController,
    required this.address1Controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: streetController,
          labelText: 'Street',
          hintText: 'Enter street name',
          borderColor: AppColour.primaryColor,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: cityController,
          labelText: 'City',
          hintText: 'Enter city name',
          borderColor: AppColour.primaryColor,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: stateController,
          labelText: 'State',
          hintText: 'Enter state or province',
          borderColor: AppColour.primaryColor,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: countryController,
          labelText: 'Country',
          hintText: 'Enter country name',
          borderColor: AppColour.primaryColor,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: pincodeController,
          labelText: 'Pin Code',
          hintText: 'Enter pin code',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter pin code';
            }
            if (int.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
          borderColor: AppColour.primaryColor,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: phoneController,
          labelText: 'Phone Number',
          hintText: 'Enter your phone number',
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter phone number';
            }
            if (int.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
          borderColor: AppColour.primaryColor,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: addressController,
          labelText: 'Address Line 1',
          hintText: 'Enter your primary address',

          borderColor: AppColour.primaryColor,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: address1Controller,
          labelText: 'Address Line 2 (Optional)',
          hintText: 'Enter additional address information',

          isRequired: false,
          borderColor: AppColour.primaryColor,
        ),
      ],
    );
  }
}
