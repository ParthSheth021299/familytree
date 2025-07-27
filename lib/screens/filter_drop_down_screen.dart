import 'package:family_tree/l10n/app_localizations.dart';
import 'package:family_tree/models/family_member.dart';
import 'package:flutter/material.dart';

class FilterDropdownSheet extends StatefulWidget {
  final List<FamilyMember> members;
  final Set<String> selected;
  final void Function(Set<String>) onApply;
  final VoidCallback onClear;

  const FilterDropdownSheet({
    required this.members,
    required this.selected,
    required this.onApply,
    required this.onClear,
    Key? key,
  }) : super(key: key);

  @override
  State<FilterDropdownSheet> createState() => _FilterDropdownSheetState();
}

class _FilterDropdownSheetState extends State<FilterDropdownSheet> {
  late Set<String> selected = {...widget.selected};
  String? selectedGender;
  String? selectedBloodGroup;
  String? selectedHouseRoot;
  String? selectedHasChildren;

  @override
  void initState() {
    super.initState();
    selectedGender = selected.firstWhere(
      (e) => _isIn(widget.members.map((m) => m.gender), e),
      orElse: () => '',
    );
    selectedBloodGroup = selected.firstWhere(
      (e) => _isIn(widget.members.map((m) => m.bloodGroup), e),
      orElse: () => '',
    );
    selectedHouseRoot = selected.firstWhere(
      (e) => _isIn(widget.members.map((m) => m.mainRoot), e),
      orElse: () => '',
    );
    selectedHasChildren = selected.contains('true')
        ? 'true'
        : (selected.contains('false') ? 'false' : null);
  }

  bool _isIn(Iterable<String> values, String val) =>
      values.toSet().contains(val);

  void _updateSelected() {
    selected.clear();
    if (selectedGender != null) selected.add(selectedGender!);
    if (selectedBloodGroup != null) selected.add(selectedBloodGroup!);
    if (selectedHouseRoot != null) selected.add(selectedHouseRoot!);
    if (selectedHasChildren != null) selected.add(selectedHasChildren!);
  }

  @override
  Widget build(BuildContext context) {
    final genders = widget.members
        .map((e) => e.gender)
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
    final bloodGroups = widget.members
        .map((e) => e.bloodGroup)
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
    final houseRoots = widget.members
        .map((e) => e.mainRoot)
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.applyFilters),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildDropdown(
              AppLocalizations.of(context)!.gender,
              genders,
              selectedGender,
              (val) => setState(() => selectedGender = val),
            ),
            const SizedBox(height: 12),
            _buildDropdown(
              AppLocalizations.of(context)!.bloodGroup,
              bloodGroups,
              selectedBloodGroup,
              (val) => setState(() => selectedBloodGroup = val),
            ),
            const SizedBox(height: 12),
            _buildDropdown(
              AppLocalizations.of(context)!.houseRoot,
              houseRoots,
              selectedHouseRoot,
              (val) => setState(() => selectedHouseRoot = val),
            ),
            const SizedBox(height: 12),
            _buildDropdown(
              AppLocalizations.of(context)!.hasChildren,
              ['true', 'false'],
              selectedHasChildren,
              (val) => setState(() => selectedHasChildren = val),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: () {
                  setState(() {
                    selectedGender = null;
                    selectedBloodGroup = null;
                    selectedHouseRoot = null;
                    selectedHasChildren = null;
                  });
                  widget.onClear();
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.clear),
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _updateSelected();
                  widget.onApply(selected);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),

                child: Text(AppLocalizations.of(context)!.applyFilter),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String? selectedValue,
    void Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        DropdownButtonFormField<String>(
          value: items.contains(selectedValue) ? selectedValue : null,
          hint: Text("${AppLocalizations.of(context)!.select} $label"),
          isExpanded: true,
          items: items
              .toSet()
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ],
    );
  }
}
