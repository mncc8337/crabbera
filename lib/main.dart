import 'package:flutter/material.dart';

void main() {
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Crabera',
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
            ),
            home: const MyHomePage(title: 'Crabera'),
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
    int counter = 0;

    void incrementCounter() {
        setState(() {
            counter++;
        });
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            // appBar: AppBar(
            //     backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            //     title: Text(widget.title),
            // ),

            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        const Text('hi chim'),
                        const Text('You have pushed the button this many times:'),
                        Text('$counter', style: Theme.of(context).textTheme.headlineMedium),
                        ElevatedButton(
                            onPressed: () {
                                print('button pressed');
                            },
                            child: Text('this thing does nothing'),
                        )
                    ],
                ),
            ),

            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: FloatingActionButton(
                                onPressed: incrementCounter,
                                tooltip: 'Increment',
                                child: const Icon(Icons.add),
                            ),
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: FloatingActionButton(
                                onPressed: incrementCounter,
                                tooltip: 'Increment',
                                child: const Icon(Icons.add),
                            ),
                        ),
                    ],
                )
            ),
        );
    }
}
