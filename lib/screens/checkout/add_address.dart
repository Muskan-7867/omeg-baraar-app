import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:omeg_bazaar/services/add_address_api.dart';
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

    // Create address data map
    final addressData = {
      'phone': _phoneController.text,
      'street': _streetController.text,
      'city': _cityController.text,
      'state': _stateController.text,
      'pincode': _pincodeController.text,
      'country': _countryController.text,
      'address': _addressController.text,
      'address1': _address1Controller.text,
    };

    try {
      // First try to send to API
      final response = await AddAddressApi.addAddress(
        phone: _phoneController.text,
        street: _streetController.text,
        city: _cityController.text,
        state: _stateController.text,
        pincode: _pincodeController.text,
        country: _countryController.text,
        address: _addressController.text,
        address1: _address1Controller.text.isNotEmpty ? _address1Controller.text : null,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (response['success'] == true) {
        // Add the ID to the address data if received from API
        if (response['data'] != null && response['data']['_id'] != null) {
          addressData['_id'] = response['data']['_id'];
        }
        
        // Save to local storage with ID
        await _saveAddressToLocalStorage(addressData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address added successfully')),
        );
        Navigator.pop(context, true); // Return success to previous screen
      } else {
        // Save without ID if API failed
        await _saveAddressToLocalStorage(addressData);
        
        String errorMessage = response['message'] ?? 'Failed to save address';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$errorMessage - Address saved locally'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      // Save without ID if network error
      await _saveAddressToLocalStorage(addressData);
      
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Network error - Address saved locally'),
          backgroundColor: Colors.orange,
        ),
      );
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
