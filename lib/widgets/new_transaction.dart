import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;
  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();

  DateTime? _selectedDate;

  void _SubmitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    widget.addTx(enteredTitle, enteredAmount, _selectedDate);
    Navigator.of(context).pop();
  }

  void _presentDataPicker() {
    showDatePicker(
      context: context,
      locale: const Locale("it", "IT"),
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2023),
    ).then((pickedData) {
      if (pickedData == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
          elevation: 5,
          child: Container(
            padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 8),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  TextField(
                    controller: _titleController,
                    /*  onChanged: (val) {
                              titleInput = val;
                            }, */
                    decoration: InputDecoration(labelText: 'Title'),
                    onSubmitted: (_) => _SubmitData(),
                  ),
                  TextField(
                    controller: _amountController,
                    //onChanged: (val) => amountInput =  val, //due modi di scrivere le funzioni
                    decoration: InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true), // per ios ci vuole il decimal separator
                    onSubmitted: (_) => _SubmitData(),
                  ),
                  Container(
                    height: 70,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(_selectedDate == null
                              ? 'Nessuna data selezionata'
                              : DateFormat('EEE dd/mm/yyyy')
                                  .format(_selectedDate!)),
                        ),
                        TextButton(
                          onPressed: _presentDataPicker,
                          child: Text('Seleziona data'),
                        )
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: _SubmitData,
                    child: Text('Add Transaction'),
                  )
                ]),
          )),
    );
  }
}
