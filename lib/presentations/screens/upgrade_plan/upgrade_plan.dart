import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wedstra_mobile_app/constants/app_constants.dart';

class UpgradePlan extends StatefulWidget {
  const UpgradePlan({super.key});

  @override
  State<UpgradePlan> createState() => _UpgradePlanState();
}

class _UpgradePlanState extends State<UpgradePlan> {
  String? _selectedPlan;
  String? _selectedPlanCost;
  bool _isLoading = false;

  final List<Map<String, dynamic>> plans = [
    {
      'label': 'WEEKLY',
      'price': '₹129.00',
      'savings': 'Save 34%',
      'value': 'Weekly',
    },
    {
      'label': 'MONTHLY',
      'price': '₹399.00',
      'savings': 'Save 65%',
      'value': 'Monthly',
      'badge': 'POPULAR',
    },
    {
      'label': 'ANNUAL',
      'price': '₹5900.00',
      'savings': 'Save 34%',
      'value': 'ANNUAL',
    },
  ];

  Widget buildPlanTile(Map<String, dynamic> plan) {
    final bool isSelected = _selectedPlan == plan['value'];

    return ListTile(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isSelected
              ? Color(AppConstants.primaryColor)
              : Colors.grey.shade700,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      tileColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            plan['label'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                plan['price'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                plan['savings'],
                style: const TextStyle(
                  color: Color(0xFF198754),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (plan.containsKey('badge')) ...[
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    plan['badge'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
      trailing: Radio<String>(
        activeColor: Colors.blue,
        value: plan['value'],
        groupValue: _selectedPlan,
        onChanged: (String? value) {
          setState(() {
            _selectedPlan = value;
          });
        },
      ),
      onTap: () {
        setState(() {
          _selectedPlanCost = plan['price'];
          _selectedPlan = plan['value'];
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Upgrade Plan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(child: Image.asset('assets/upgrade_plan.png')),
            const SizedBox(height: 20),

            /// Plan Tiles
            ...plans.map(
              (plan) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: buildPlanTile(plan),
              ),
            ),

            const SizedBox(height: 10),

            /// Feature List
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'ACCESS ALL EXCLUSIVE TOOLS AND BENEFITS',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Icon(Iconsax.direct, color: Colors.pink, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'Enjoy personalized chat with top vendors.',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              )
            ),
            const SizedBox(height: 5),
            const Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Icon(Iconsax.clipboard_tick, color: Colors.pink, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'Customized To-Dos for your perfect wedding.',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              )
            ),
            const SizedBox(height: 5),
            const Align(
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Iconsax.wallet_check, color: Colors.pink, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Track and manage your wedding expenses effortlessly.',
                      style: TextStyle(fontWeight: FontWeight.w500),
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              )

            ),
            const SizedBox(height: 5),
            const Align(
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Iconsax.diamonds, color: Colors.pink, size: 18),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Unlock top-tier vendors & premium services.',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              )
            ),

            const SizedBox(height: 50),

            /// Upgrade Button
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(AppConstants.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  disabledBackgroundColor: const Color(0xFFD63F66),
                ),
                onPressed: _isLoading || _selectedPlan == null
                    ? null
                    : () {
                        print("Selected Plan: $_selectedPlan");
                      },
                child: _isLoading
                    ? const Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      )
                    : Text(
                        _selectedPlanCost != null && _selectedPlan != null
                            ? 'Continue with ${_selectedPlanCost}/${_selectedPlan}'
                            : 'Select plan to upgrade',

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
