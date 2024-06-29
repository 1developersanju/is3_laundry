import 'package:flutter/material.dart';
import 'package:laundry/helpers/colorRes.dart';
import 'package:laundry/providers/subscribtionPlanProvider.dart';
import 'package:provider/provider.dart';

class ManageSubscriptionPlansPage extends StatelessWidget {
  const ManageSubscriptionPlansPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Subscription Plans'),
      ),
      backgroundColor: ColorsRes.canvasColor,
      body: Consumer<SubscriptionPlanProvider>(
        builder: (context, provider, _) => ListView.builder(
          itemCount: provider.plans.length,
          itemBuilder: (context, index) {
            SubscriptionPlan plan = provider.plans[index];
            return ListTile(
              title: Text(plan.duration),
              subtitle: Text('Cost: ₹ ${plan.cost.toStringAsFixed(2)}'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => provider.deletePlan(plan.id),
              ),
              onTap: () {
                // Implement edit functionality here if needed
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a screen where admins can add new plans
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSubscriptionPlanPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddSubscriptionPlanPage extends StatefulWidget {
  const AddSubscriptionPlanPage({Key? key}) : super(key: key);

  @override
  _AddSubscriptionPlanPageState createState() => _AddSubscriptionPlanPageState();
}

class _AddSubscriptionPlanPageState extends State<AddSubscriptionPlanPage> {
  TextEditingController _durationController = TextEditingController();
  TextEditingController _costController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Subscription Plan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _durationController,
              decoration: InputDecoration(labelText: 'Duration'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _costController,
              decoration: InputDecoration(labelText: 'Cost'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String duration = _durationController.text.trim();
                double cost = double.parse(_costController.text.trim());

                Provider.of<SubscriptionPlanProvider>(context, listen: false).addPlan(
                  duration: duration,
                  cost: cost,
                  verified: false, // Initially not verified
                  subscribedOn: DateTime.now(),
                );

                Navigator.pop(context); // Return to previous page
              },
              child: Text('Add Plan'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _durationController.dispose();
    _costController.dispose();
    super.dispose();
  }
}
