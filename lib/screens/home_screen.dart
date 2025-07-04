
import 'package:family_tree/screens/add_family_chain.dart';
import 'package:family_tree/screens/tree_view.dart';
import 'package:family_tree/service/google_sheet_service.dart';
import 'package:flutter/material.dart';
import '../models/family_member.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoogleSheetsService _service = GoogleSheetsService();
  List<FamilyMember> _members = [];
  bool _isLoading = true;
  List<FamilyMember> _todaysBirthdays = [];

  @override
  void initState() {
    super.initState();
    _fetchFamilyMembers();
  }

Future<void> _fetchFamilyMembers() async {
  try {
    final members = await _service.fetchFamilyData();
    final now = DateTime.now();
    final todayDay = now.day;
    final todayMonth = now.month;

    final birthdays = members.where((m) {
  if (m.dob!.isNotEmpty) {
    try {
      DateTime parsed;

      if (RegExp(r'^\d{4}-\d{2}-\d{2}').hasMatch(m.dob!)) {
        parsed = DateTime.parse(m.dob!).toLocal();
      } else {
        parsed = DateFormat('dd-MM-yyyy').parse(m.dob!);
      }

      return parsed.day == now.day && parsed.month == now.month;
    } catch (e) {
      print("Error parsing DOB: ${m.dob} - $e");
      return false;
    }
  }
  return false;
}).toList();


    setState(() {
      _members = members;
      _todaysBirthdays = birthdays;
      _isLoading = false;
    });
  } catch (e) {
    print("Error fetching data: $e");
    setState(() {
      _isLoading = false;
    });
  }
}


  Widget _buildSummaryCards() {
    int maleCount = _members.where((m) => m.gender.toLowerCase() == 'male').length;
    int femaleCount = _members.where((m) => m.gender.toLowerCase() == 'female').length;
    int marriedCount = _members.where((m) => m.maritalStatus.toLowerCase() == 'married').length;
    int dobCount = _members.where((m) => m.dob.isNotEmpty).length;

    final stats = [
      ("Total Members", _members.length.toString(), Icons.people),
      ("Male Members", maleCount.toString(), Icons.male),
      ("Female Members", femaleCount.toString(), Icons.female),
      ("Married", marriedCount.toString(), Icons.favorite),
      ("DOB Added", dobCount.toString(), Icons.cake),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: stats.length,
      itemBuilder: (_, index) {
        final (title, count, icon) = stats[index];
        return Card(
          key: ValueKey(title),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Badge(
                  backgroundColor: Colors.blue.shade100,
                  label: Text(count, style: const TextStyle(fontWeight: FontWeight.bold)),
                  child: Icon(icon, size: 28, color: Colors.blueGrey),
                ),
                const SizedBox(height: 10),
                Text(title,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBirthdaySection() {
    if (_todaysBirthdays.isEmpty) return const SizedBox();

    final visible = _todaysBirthdays.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text("🎂 Birthdays Today", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: visible.map((m) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: (m.photoUrl.isNotEmpty)
                    ? NetworkImage(m.photoUrl)
                    : const AssetImage('assets/images/avatar.jpg') as ImageProvider,
              ),
              const SizedBox(height: 4),
              Text(m.name, style: const TextStyle(fontSize: 12)),
            ],
          )).toList(),
        ),
        if (_todaysBirthdays.length > 3)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("All Birthdays Today"),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _todaysBirthdays.map((m) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage: (m.photoUrl.isNotEmpty)
                                ? NetworkImage(m.photoUrl)
                                : const AssetImage('assets/default_avatar.png') as ImageProvider,
                          ),
                          title: Text(m.name),
                          subtitle: Text("DOB: ${m.dob}"),
                        )).toList(),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Close"),
                      )
                    ],
                  ),
                );
              },
              child: const Text("See More"),
            ),
          ),
      ],
    );
  }

 Widget _buildUpcomingBirthdays() {
  final now = DateTime.now();

  final upcoming = _members.where((m) {
    if (m.dob.isEmpty) return false;

    try {
      DateTime parsedDob;

      // Detect if dob is ISO string (from Sheets) or raw dd-MM-yyyy
      if (RegExp(r'^\d{4}-\d{2}-\d{2}').hasMatch(m.dob!)) {
        // Parse ISO and convert to local time
        parsedDob = DateTime.parse(m.dob!).toLocal();
      } else {
        // Parse raw dd-MM-yyyy
        parsedDob = DateFormat('dd-MM-yyyy').parse(m.dob!);
      }

      // Create this year's birthday using only month/day
      var birthdayThisYear = DateTime(now.year, parsedDob.month, parsedDob.day);

      // If it already passed, check next year's
      if (birthdayThisYear.isBefore(now)) {
        birthdayThisYear = DateTime(now.year + 1, parsedDob.month, parsedDob.day);
      }

      final diff = birthdayThisYear.difference(now).inDays;

      return diff > 0 && diff <= 7;
    } catch (e) {
      print('DOB parse error for "${m.name}": ${m.dob} - $e');
      return false;
    }
  }).toList();

  if (upcoming.isEmpty) return const SizedBox();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 20),
      const Text("🎈 Upcoming Birthdays", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      SizedBox(
        height: 100,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: upcoming.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (_, index) {
            final m = upcoming[index];
            return Card(
              elevation: 2,
              child: Container(
                width: 160,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text("🎂 ${m.dob}", style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            );
          },
        ),
      )
    ],
  );
}

  Widget _buildFooterTip() {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.amber),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "💡 Tip: Use the tree view icon at the top to explore the full family tree.\n\nYou can also filter family branches or search for a specific name in the tree screen.",
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Divider(),
          Text("Need help? Contact admin:", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("📧 Email: parthsheth100@gmail.com"),
          Text("📱 WhatsApp: +91 98765 43210"),
          SizedBox(height: 12),
          Center(
            child: Text(
              "Made with ❤️ for the Dahibanagar family",
              style: TextStyle(color: Colors.black54),
            ),
          ),
          SizedBox(height: 4),
          Center(child: Text("v1.0 • Updated: June 2025", style: TextStyle(fontSize: 12, color: Colors.grey))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Family Overview", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _fetchFamilyMembers,
          ),
          IconButton(
            icon: const Icon(Icons.account_tree),
            tooltip: 'View Trees',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TreeViewScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.family_restroom),
            tooltip: 'Add Family Chain',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddFamilyChainScreen()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 _buildBirthdaySection(),
                _buildUpcomingBirthdays(),
                SizedBox(height:10),
                _buildSummaryCards(),
                
               
               
              ],
            ),
          ),
    );
  }
}
