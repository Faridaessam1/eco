import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_elevated_button.dart';
import '../paymentMethod/payment_method.dart';

class AddressScreen extends StatefulWidget {
  final String sellerId;
  final String orderType;

  const AddressScreen({
    Key? key,
    required this.sellerId,
    required this.orderType,
  }) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressInputScreenState();
}

class _AddressInputScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _buildingController = TextEditingController();
  final _floorController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _phoneController = TextEditingController();

  String? selectedCity;
  String? selectedArea;

  // قائمة المدن والمناطق - يمكن جلبها من API
  final Map<String, List<String>> citiesAreas = {
    'Cairo': ['Nasr City', 'Heliopolis', 'Maadi', 'Zamalek', 'Downtown', 'New Cairo'],
    'Giza': ['6th of October', 'Sheikh Zayed', 'Mohandessin', 'Dokki', 'Agouza'],
    'Alexandria': ['Sidi Gaber', 'Smouha', 'Miami', 'Montaza', 'Stanley'],
  };

  @override
  void dispose() {
    _streetController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _apartmentController.dispose();
    _landmarkController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: AppColors.black),
        title: const Text(
          "Delivery Address",
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on,
                size: 50,
                color: AppColors.primaryColor,
              ),
              const SizedBox(height: 10),
              const Text(
                "Enter Your Address",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "Please provide your complete address for delivery",
                style: TextStyle(fontSize: 14, color: AppColors.darkGrey),
              ),
              const SizedBox(height: 30),

              // City Dropdown
              _buildDropdown(
                label: "City",
                value: selectedCity,
                items: citiesAreas.keys.toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCity = value;
                    selectedArea = null; // Reset area when city changes
                  });
                },
              ),
              const SizedBox(height: 16),

              // Area Dropdown
              _buildDropdown(
                label: "Area",
                value: selectedArea,
                items: selectedCity != null ? citiesAreas[selectedCity!]! : [],
                onChanged: (value) {
                  setState(() {
                    selectedArea = value;
                  });
                },
                enabled: selectedCity != null,
              ),
              const SizedBox(height: 16),

              // Street Address
              _buildTextField(
                controller: _streetController,
                label: "Street Address",
                hint: "Enter street name",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Street address is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Building Number
              _buildTextField(
                controller: _buildingController,
                label: "Building Number",
                hint: "Enter building number",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Building number is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Floor and Apartment in one row
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _floorController,
                      label: "Floor",
                      hint: "Floor",
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _apartmentController,
                      label: "Apartment",
                      hint: "Apt.",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Landmark (Optional)
              _buildTextField(
                controller: _landmarkController,
                label: "Landmark (Optional)",
                hint: "Nearby landmark or additional info",
              ),
              const SizedBox(height: 16),

              // Phone Number
              _buildTextField(
                controller: _phoneController,
                label: "Phone Number",
                hint: "Enter your phone number",
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Phone number is required";
                  }
                  if (value.length < 10) {
                    return "Please enter a valid phone number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  onPressed: _submitAddress,
                  text: "Continue to Payment",
                  icon: Icons.arrow_forward,
                  buttonColor: AppColors.primaryColor,
                  borderRadius: 20,
                  textColor: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            hintText: "Select $label",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
          ),
          items: enabled
              ? items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList()
              : [],
          onChanged: enabled ? onChanged : null,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "$label is required";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  void _submitAddress() {
    if (_formKey.currentState!.validate()) {
      // Build complete address string
      String completeAddress = _buildCompleteAddress();

      // Navigate to payment method screen with address data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentMethodScreen(
            sellerId: widget.sellerId,
            orderType: widget.orderType,
            deliveryAddress: completeAddress,
            phoneNumber: _phoneController.text.trim(),
          ),
        ),
      );
    }
  }

  String _buildCompleteAddress() {
    List<String> addressParts = [];

    if (_buildingController.text.trim().isNotEmpty) {
      addressParts.add("Building: ${_buildingController.text.trim()}");
    }

    if (_floorController.text.trim().isNotEmpty) {
      addressParts.add("Floor: ${_floorController.text.trim()}");
    }

    if (_apartmentController.text.trim().isNotEmpty) {
      addressParts.add("Apt: ${_apartmentController.text.trim()}");
    }

    addressParts.add(_streetController.text.trim());

    if (selectedArea != null) {
      addressParts.add(selectedArea!);
    }

    if (selectedCity != null) {
      addressParts.add(selectedCity!);
    }

    if (_landmarkController.text.trim().isNotEmpty) {
      addressParts.add("Near: ${_landmarkController.text.trim()}");
    }

    return addressParts.join(", ");
  }
}