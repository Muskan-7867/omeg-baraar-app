// lib/widgets/address_section.dart
import 'package:flutter/material.dart';

class AddressSection extends StatelessWidget {
  final Map<String, dynamic>? selectedAddress;
  final VoidCallback onAddOrChangeAddress;

  const AddressSection({
    super.key,
    required this.selectedAddress,
    required this.onAddOrChangeAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (selectedAddress != null)
                TextButton(
                  onPressed: onAddOrChangeAddress,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Change',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (selectedAddress != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedAddress!['addressLine1'] ??
                        selectedAddress!['address'] ??
                        '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if ((selectedAddress!['addressLine2'] ??
                          selectedAddress!['address1']) !=
                      null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        selectedAddress!['addressLine2'] ??
                            selectedAddress!['address1'] ??
                            '',
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${selectedAddress!['city']}, ${selectedAddress!['state']} - ${selectedAddress!['postalCode'] ?? selectedAddress!['pincode']}',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(selectedAddress!['country'] ?? ''),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Phone: ${selectedAddress!['phoneNumber'] ?? selectedAddress!['phone']}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            )
          else
            ElevatedButton(
              onPressed: onAddOrChangeAddress,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Add Address'),
            ),
        ],
      ),
    );
  }
}
