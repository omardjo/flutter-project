import 'package:flutter/material.dart';

enum DateFilterType {
  Year,
  Month,
  FullDate,
}

class FilterDialog extends StatefulWidget {
  final Function(String? status, DateFilterType? filterType, DateTime? date, String? project) onFilter;

  FilterDialog({required this.onFilter});

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String? _selectedStatus;
  DateFilterType _selectedDateFilterType = DateFilterType.FullDate;
  DateTime? _selectedDate;
  String? _selectedProject;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filter Options', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              onChanged: (newValue) {
                setState(() {
                  _selectedStatus = newValue;
                });
              },
              items: <String>['Accepted', 'Rejected', 'In Progress']
                  .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          fontWeight: _selectedStatus == value ? FontWeight.bold : FontWeight.normal,
                          color: _selectedStatus == value ? Colors.black : Colors.grey,
                        ),
                      ),
                    );
                  }).toList(),
              decoration: InputDecoration(
                labelText: 'Status',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2.0)),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<DateFilterType>(
              value: _selectedDateFilterType,
              onChanged: (newValue) {
                setState(() {
                  _selectedDateFilterType = newValue!;
                });
              },
              items: DateFilterType.values
                  .map((filterType) => DropdownMenuItem<DateFilterType>(
                    value: filterType,
                    child: Text(_getDateFilterTypeName(filterType)),
                  ))
                  .toList(),
              decoration: InputDecoration(
                labelText: 'Date Filter Type',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2.0)),
              ),
            ),
            SizedBox(height: 20),
            _buildDateSelector(),
            SizedBox(height: 20),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _selectedProject = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Project',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2.0)),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                widget.onFilter(_selectedStatus, _selectedDateFilterType, _selectedDate, _selectedProject);
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
               
                child: Row(
                  children: [
                    Icon(Icons.check, color: Colors.green),
                    SizedBox(width: 10),
                    Text('Apply Filters', style: TextStyle(color: Colors.green)),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
               
                child: Row(
                  children: [
                    Icon(Icons.cancel, color: Colors.orange),
                    SizedBox(width: 10),
                    Text('Cancel', style: TextStyle(color: Colors.orange)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    switch (_selectedDateFilterType) {
      case DateFilterType.Year:
        return DropdownButtonFormField<int>(
          value: _selectedDate?.year,
          onChanged: (newValue) {
            setState(() {
              _selectedDate = DateTime(newValue!, 1, 1);
            });
          },
          items: List.generate(50, (index) => index + 2000)
              .map<DropdownMenuItem<int>>((year) {
                return DropdownMenuItem<int>(
                  value: year,
                  child: Text(year.toString(), style: TextStyle(color: Colors.black)),
                );
              }).toList(),
          decoration: InputDecoration(
            labelText: 'Year',
            labelStyle: TextStyle(color: Colors.black),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2.0)),
          ),
        );
      case DateFilterType.Month:
        return DropdownButtonFormField<int>(
          value: _selectedDate?.month,
          onChanged: (newValue) {
            setState(() {
              _selectedDate = DateTime(2000, newValue!, 1);
            });
          },
          items: List.generate(12, (index) => index + 1)
              .map<DropdownMenuItem<int>>((month) {
                return DropdownMenuItem<int>(
                  value: month,
                  child: Text(month.toString(), style: TextStyle(color: Colors.black)),
                );
              }).toList(),
          decoration: InputDecoration(
            labelText: 'Month',
            labelStyle: TextStyle(color: Colors.black),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2.0)),
          ),
        );
    case DateFilterType.FullDate:
  return InkWell(
    onTap: () async {
      final selectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light().copyWith(
                primary: Colors.orange, 
                onPrimary: Colors.black, 
                surface: Colors.white, 
                onSurface: Colors.black, 
              ),
            ),
            child: child!,
          );
        },
      );
      if (selectedDate != null) {
        setState(() {
          _selectedDate = selectedDate;
        });
      }
    },
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: 'Date',
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2.0)),
        suffixIcon: Icon(Icons.date_range, color: Colors.black),
      ),
      child: Text(
        _selectedDate == null ? 'Select Date' : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
        style: TextStyle(color: _selectedDate == null ? Colors.grey : Colors.black, fontWeight: _selectedDate == null ? FontWeight.normal : FontWeight.bold),
      ),
    ),
  );

    }
  }

  String _getDateFilterTypeName(DateFilterType filterType) {
    switch (filterType) {
      case DateFilterType.Year:
        return 'Year';
      case DateFilterType.Month:
        return 'Month';
      case DateFilterType.FullDate:
      default:
        return 'Full Date';
    }
  }
}