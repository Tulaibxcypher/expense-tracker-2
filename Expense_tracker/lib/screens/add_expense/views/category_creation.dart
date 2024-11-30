import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expenses_tracker/screens/add_expense/blocs/create_categorybloc/create_category_bloc.dart';
import 'package:expense_repository/expense_repository.dart';

Future getCategoryCreation(BuildContext context) {
  List<String> myCategoryIcons = [
    'beauty',
    'electricity',
    'fuel',
    'investment',
    'medicine',
    'school',
    'travel'
  ];

  return showDialog(
    context: context,
    builder: (ctx) {
      String iconSelected = '';
      Color categoryColor = Colors.white;
      TextEditingController categoryNameController = TextEditingController();
      TextEditingController categoryIconController = TextEditingController();
      TextEditingController categoryColorController = TextEditingController();
      bool isLoading = false;
      Category category = Category.empty;

      return BlocProvider.value(
        value: context.read<CreateCategoryBloc>(),
        child: StatefulBuilder(
          builder: (ctx, setState) {
            return BlocListener<CreateCategoryBloc, CreateCategoryState>(
              listener: (context, state) {
                if (state is CreateCategorySuccess) {
                  Navigator.pop(ctx, category);
                } else if (state is CreateCategoryLoading) {
                  setState(() {
                    isLoading = true;
                  });
                } else if (state is CreateCategoryFailure) {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Enter the item'),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: categoryNameController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    // Category selection (icon)
                    TextFormField(
                      controller: categoryIconController,
                      textAlignVertical: TextAlignVertical.center,
                      readOnly: true,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(CupertinoIcons.chevron_down),
                        hintText: 'Icons',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Select an Icon'),
                                  const SizedBox(height: 10),
                                  Container(
                                    color: Colors.grey, // Temporary color for debugging
                                    child: GridView.builder(
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 5,
                                        crossAxisSpacing: 5,
                                      ),
                                      itemCount: myCategoryIcons.length,
                                      itemBuilder: (context, int i) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              iconSelected = myCategoryIcons[i];
                                            });
                                            Navigator.pop(context); // Close dialog after selection
                                          },
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                width: 3,
                                                color: iconSelected == myCategoryIcons[i]
                                                    ? Colors.green
                                                    : Colors.grey,
                                              ),
                                              image: DecorationImage(
                                                image: AssetImage('assets/icons/${myCategoryIcons[i]}.png'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    // Color picker
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: categoryColorController,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx2) {
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text("Pick a color"),
                                  const SizedBox(height: 10),
                                  ColorPicker(
                                    pickerColor: categoryColor,
                                    onColorChanged: (value) {
                                      setState(() {
                                        categoryColor = value;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: TextButton(
                                      onPressed: () {
                                        categoryColorController.text =
                                            categoryColor.value.toRadixString(16);
                                        Navigator.pop(ctx2);
                                      },
                                      child: const Text('Save'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      textAlignVertical: TextAlignVertical.center,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Color',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : TextButton(
                              onPressed: () {
                                setState(() {
                                  category.categoryId = const Uuid().v1();
                                  category.name = categoryNameController.text;
                                  category.icon = iconSelected;
                                  category.color = categoryColor.value;
                                });
                                context
                                    .read<CreateCategoryBloc>()
                                    .add(CreateCategory(category));
                              },
                              child: const Text('Save'),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
