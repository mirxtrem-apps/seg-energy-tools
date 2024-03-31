import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seg Energy Tools',
      theme: ThemeData(
        colorScheme: ColorScheme.light(primary: Colors.lightGreen.shade900),
        useMaterial3: true,
        visualDensity: VisualDensity.compact,
        inputDecorationTheme: const InputDecorationTheme(
          isDense: true,
          border: OutlineInputBorder(),
        ),
      ),
      home: const MyHomePage(title: 'Seg Energy Tools'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _fpDeseado = 0;
  double _kvarNecesarios = 0.0;

  TextEditingController fpInicialCtrl = TextEditingController();
  TextEditingController fpDeseadoCtrl = TextEditingController();
  TextEditingController potenciaKwCtrl = TextEditingController();

  void _incrementCounter() {
    setState(() {
      _fpDeseado++;
    });
  }

  double calcularKVars(double potenciaKw, double fpInicial, double fpDeseado) {
    double tanInicial = tan(acos(fpInicial));
    double tanDeseado = tan(acos(fpDeseado));

    // Calcular la cantidad de kVAr necesarios
    double kvarsNecesarios = potenciaKw * (tanInicial - tanDeseado);

    return kvarsNecesarios;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              // onChanged: _calcular,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calcular el factor de potencia:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 12.0),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: fpInicialCtrl,
                      decoration: const InputDecoration(
                        hintText: "0.0",
                        labelText: "FP Inicial",
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (val) {
                        final fpInicial = num.tryParse(val!);

                        if (fpInicial is double && fpInicial > 1) {
                          return "Ingrese un FP entre 0.0 y 1.0";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: fpDeseadoCtrl,
                      decoration: const InputDecoration(
                        hintText: "0.0",
                        labelText: "FP Deseado",
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (val) {
                        final fpInicial = num.tryParse(val!);

                        if (fpInicial is double && fpInicial > 1) {
                          return "Ingrese un FP entre 0.0 y 1.0";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: potenciaKwCtrl,
                      decoration: const InputDecoration(
                        hintText: "0.0",
                        labelText: "Potencia Max (kW)",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            const Text(
              'Los kvar nencesarios para mejorar el factor de potencia son:',
            ),
            Text(
              "${_kvarNecesarios.toStringAsFixed(2)} kVar",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _calcular,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _calcular() {
    try {
      double fpInicial = double.parse(fpInicialCtrl.text);
      double fpDeseado = double.parse(fpDeseadoCtrl.text);
      double potenciaKw = double.parse(potenciaKwCtrl.text);
      final kvars = calcularKVars(potenciaKw, fpInicial, fpDeseado);
      setState(() {
        _kvarNecesarios = kvars;
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
