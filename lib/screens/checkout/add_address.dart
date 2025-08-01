import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:omeg_bazaar/services/user/add_address_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'address_input_fields.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({super.key});

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Form controllers
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _pincodeController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _address1Controller.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final addressData = {
        'phoneNumber': _phoneController.text,
        'addressLine1': _addressController.text,
        'addressLine2':
            _address1Controller.text.isNotEmpty
                ? _address1Controller.text
                : null,
        'city': _cityController.text,
        'state': _stateController.text,
        'postalCode': _pincodeController.text,
        'country': _countryController.text,
        'street': _streetController.text,
      };

      try {
        final response = await AddAddressApi.addAddress(
          phone: _phoneController.text,
          street: _streetController.text,
          city: _cityController.text,
          state: _stateController.text,
          pincode: _pincodeController.text,
          country: _countryController.text,
          address: _addressController.text,
          address1:
              _address1Controller.text.isNotEmpty
                  ? _address1Controller.text
                  : null,
        );

        if (!mounted) return;

        if (response['success'] == true) {
          // Standardize the address format before returning
          final standardizedAddress = {
            'phoneNumber': _phoneController.text,
            'addressLine1': _addressController.text,
            'addressLine2':
                _address1Controller.text.isNotEmpty
                    ? _address1Controller.text
                    : null,
            'city': _cityController.text,
            'state': _stateController.text,
            'postalCode': _pincodeController.text,
            'country': _countryController.text,
            '_id': response['data']?['_id'],
          };

          await _saveAddressToLocalStorage(standardizedAddress);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Address added successfully')),
          );
          Navigator.pop(context, standardizedAddress);
        } else {
          await _saveAddressToLocalStorage(addressData);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Address saved locally'),
              backgroundColor: Colors.orange,
            ),
          );
          Navigator.pop(context, addressData);
        }
      } catch (e) {
        await _saveAddressToLocalStorage(addressData);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Network error - Address saved locally'),
            backgroundColor: Colors.orange,
          ),
        );
        Navigator.pop(context, addressData);
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  // Helper method to save address to local storage
  Future<void> _saveAddressToLocalStorage(
    Map<String, dynamic> addressData,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('useraddress', jsonEncode(addressData));
      // print('Address saved locally');
    } catch (e) {
      // print('Error saving address locally: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Address'),
        actions: [
          IconButton(
            icon:
                _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Icon(Icons.save),
            onPressed: _isLoading ? null : _submitForm,
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  AddressInputFields(
                    streetController: _streetController,
                    cityController: _cityController,
                    stateController: _stateController,
                    countryController: _countryController,
                    pincodeController: _pincodeController,
                    phoneController: _phoneController,
                    addressController: _addressController,
                    address1Controller: _address1Controller,
                  ),
                  const SizedBox(height: 80),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text('Save Address'),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
