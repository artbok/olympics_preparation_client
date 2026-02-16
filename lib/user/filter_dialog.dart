import "package:flutter/material.dart";

void filterDialog(
  BuildContext context,
  List<String> selectedDifficulties,
  Set<String> selectedTopics,
  Map<String, dynamic> data,
  VoidCallback reloadScreen,
) {
  final colors = Theme.of(context).colorScheme;
  final List<String> filtersDifficulty = List.from(selectedDifficulties);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: colors.surface,
        insetPadding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
        child: Container(
          width: 400,
          constraints: const BoxConstraints(maxHeight: 500),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Фильтры',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                StatefulBuilder(
                  builder: (context, setState) {
                    bool isSelected(String label, List<String> category) {
                      return category.contains(label);
                    }

                    void toggleCategory(String category, bool? isSelected) {
                      setState(() {
                        if (isSelected == true) {
                          selectedTopics.addAll(
                            List<String>.from(data[category]!),
                          );
                        } else {
                          selectedTopics.removeAll(
                            List<String>.from(data[category]!),
                          );
                        }
                      });
                    }

                    void toggleItem(String item) {
                      setState(() {
                        if (selectedTopics.contains(item)) {
                          selectedTopics.remove(item);
                        } else {
                          selectedTopics.add(item);
                        }
                      });
                    }

                    Widget buildChip(String label, List<String> category) {
                      return FilterChip(
                        label: Text(label),
                        selected: isSelected(label, category),
                        onSelected: (bool value) {
                          setState(() {
                            if (value) {
                              category.add(label);
                            } else {
                              category.remove(label);
                            }
                          });
                        },
                      );
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 15.0),
                        const Text(
                          'Сложность:',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Wrap(
                          children: <Widget>[
                            buildChip('Простой', filtersDifficulty),
                            buildChip('Средний', filtersDifficulty),
                            buildChip('Сложный', filtersDifficulty),
                          ],
                        ),

                        ExpansionTile(
                          title: const Text("Предметы"),
                          children: data.entries.map((category) {
                            final String catName = category.key;
                            final List<dynamic> items = category.value;

                            final int selectedCount = items
                                .where((i) => selectedTopics.contains(i))
                                .length;
                            final bool allSelected =
                                selectedCount == items.length;
                            final bool noneSelected = selectedCount == 0;

                            return ExpansionTile(
                              leading: Checkbox(
                                value: allSelected
                                    ? true
                                    : (noneSelected ? false : null),
                                tristate: true,
                                onChanged: (bool? value) =>
                                    toggleCategory(catName, value),
                              ),
                              title: Text(catName),
                              children: items.map((item) {
                                return CheckboxListTile(
                                  contentPadding: const EdgeInsets.only(
                                    left: 40,
                                  ),
                                  title: Text(item),
                                  value: selectedTopics.contains(item),
                                  onChanged: (bool? value) => toggleItem(item),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                );
                              }).toList(),
                            );
                          }).toList(),
                        ),

                        TextButton(
                          onPressed: () {
                            selectedDifficulties.clear();
                            selectedDifficulties.addAll(filtersDifficulty);
                            Navigator.pop(context);
                            reloadScreen();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
