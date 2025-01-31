import 'package:flutter/material.dart';
import 'package:rachac/models/conta.dart';
import 'package:rachac/provider/contas.dart';
import 'package:rachac/widget/Resultado/ResultadoItem.dart';
import 'package:provider/provider.dart';

class Resultado extends StatelessWidget {
  static const routeName = '/resultado';
  @override
  Widget build(BuildContext context) {
    final conta = ModalRoute.of(context).settings.arguments as Conta;

    List<ResultadoItem> texts = [];

    final values = calculateValues(conta);

    values.forEach((key, value) {
      texts.add(ResultadoItem(
          Text('$key ',
              style: Theme.of(context).textTheme.headline1.copyWith(
                  color: Colors.grey[800], fontWeight: FontWeight.normal)),
          Text(' R\$' + value.toStringAsFixed(2),
              style: Theme.of(context).textTheme.headline1)));
    });

    if (conta.numberOfPeopleWhoDrink == 0 ||
        conta.numberOfPeopleWhoDrink == conta.numberOfPeople)
      texts = texts.sublist(0, 3);

    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.amber),
          backgroundColor: Color(0xffebead1),
          shadowColor: Colors.transparent,
        ),
        body: Center(
          child: Container(
            width: 270,
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Text(
                  'Resultado',
                  style: Theme.of(context).textTheme.headline2,
                ),
                const SizedBox(
                  height: 20,
                ),
                ...texts,
                const SizedBox(
                  height: 100,
                ),
                if (!conta.arquivada)
                  ElevatedButton(
                      child: Text(
                        'Arquivar',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      onPressed: () {
                        conta.arquivada = true;
                        Provider.of<Contas>(context, listen: false)
                            .update(conta);
                        Navigator.of(context).popUntil(
                            (route) => route.settings.name == '/homepage');
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor))),
              ],
            ),
          ),
        ));
  }

  Map<String, double> calculateValues(Conta c) {
    Map<String, double> result = {
      'Total': 0,
      'Garçom': 0,
      'Individual': 0,
      'Individual c/ Álcool': 0
    };

    result['Garçom'] = (c.fullPrice * c.waiterPercentage) / 100;
    result['Total'] = c.fullPrice + result['Garçom'];
    result['Individual'] =
        ((result['Total'] - c.drinkPrice) / c.numberOfPeople);

    if (c.numberOfPeopleWhoDrink != 0) {
      result['Individual c/ Álcool'] =
          result['Individual'] + (c.drinkPrice / c.numberOfPeopleWhoDrink);
      if (c.numberOfPeopleWhoDrink == c.numberOfPeople)
        result['Individual'] = result['Individual c/ Álcool'];
    }

    return result;
  }
}
