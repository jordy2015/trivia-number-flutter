import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import '../../../../injection_container.dart';
import 'package:meta/meta.dart';

class NumberTriviaPage extends StatelessWidget {
  final String title;

  NumberTriviaPage({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: buildBlocProvider(context),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBlocProvider(BuildContext context) {
    return BlocProvider(
      create: (_) => di<NumberTriviaBloc>(),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (context, state) {
                if (state is Empty) {
                  return EmptyMessage(
                    message: "Empty State!",
                  );
                } else if (state is Loading) {
                  return LoadingWidget();
                } else if (state is Loaded) {
                  return EmptyMessage(
                    message: state.trivia.text,
                  );
                } else if (state is Error) {
                  return EmptyMessage(
                    message: state.message,
                  );
                }
              },
            ),
            SizedBox(height: 20),
            TriviaControls()
          ],
        ),
      ),
    );
  }
}

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key key,
  }) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  String textInput;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          onChanged: (value) {
            textInput = value;
          },
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: "Insert the number"),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: RaisedButton(
                    color: Theme.of(context).accentColor,
                    child: Text("Search"),
                    onPressed: dispatchConcrete)),
            SizedBox(
              width: 5,
            ),
            Expanded(
                child: RaisedButton(
                    color: Theme.of(context).accentColor,
                    child: Text("Random"),
                    onPressed: dispatchRandom)),
          ],
        )
      ],
    );
  }

  void dispatchConcrete() {
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(number: textInput));
  }

  void dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandom());
  }
}

class EmptyMessage extends StatelessWidget {
  final String message;

  EmptyMessage({this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: SingleChildScrollView(
            child: Text(
          message,
          style: TextStyle(fontSize: 25),
        )),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
