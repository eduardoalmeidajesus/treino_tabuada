import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../model/Jogador.dart';
import '../../service/JogadorService.dart';

class TelaJogo extends StatefulWidget {
  final Jogador jogador;

  const TelaJogo({super.key, required this.jogador});

  @override
  State<TelaJogo> createState() => _TelaJogoState();
}

class _TelaJogoState extends State<TelaJogo> {
  final JogadorService jogadorService = JogadorService();

  final TextEditingController ctResposta = TextEditingController();
  final FocusNode focusResposta = FocusNode();

  int numero1 = 0;
  int numero2 = 0;
  int respostaCorreta = 0;
  int tempoBase = 20;
  int tempoRestante = 20;
  Timer? timer;
  bool jogoAtivo = false;
  int errosSeguidos = 0;

  @override
  void initState() {
    super.initState();
    iniciarJogo();
  }

  void iniciarJogo() {
    sortearQuestao();
    jogoAtivo = true;
    ctResposta.text = "";
    tempoRestante = tempoBase;
    iniciarTemporizador();
    Future.delayed(const Duration(milliseconds: 100), () {
      focusResposta.requestFocus();
    });
  }

  void sortearQuestao() {
    Random random = Random();
    numero1 = random.nextInt(10) + 1;
    numero2 = random.nextInt(10) + 1;
    respostaCorreta = numero1 * numero2;
  }

  void iniciarTemporizador() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        tempoRestante--;
      });
      if (tempoRestante <= 0) {
        timer.cancel();
        registrarErro();
      }
    });
  }

  void verificarResposta() {
    if (!jogoAtivo) return;
    timer?.cancel();
    try {
      int respostaUsuario = int.parse(ctResposta.text);
      if (respostaUsuario == respostaCorreta) {
        registrarAcerto();
      } else {
        registrarErro();
      }
    } catch (e) {
      registrarErro();
    }
  }

  void registrarAcerto() {
    setState(() {
      widget.jogador.acertos++;
      errosSeguidos = 0;
      if (tempoBase > 5) {
        tempoBase--;
      }
    });
    jogadorService.update(widget.jogador);
    proximaQuestao();
  }

  void registrarErro() {
    setState(() {
      widget.jogador.erros++;
      errosSeguidos++;
      if (errosSeguidos >= 2 && tempoBase < 30) {
        tempoBase += 2;
        if (tempoBase > 30) {
          tempoBase = 30;
        }
      }
    });
    jogadorService.update(widget.jogador);
    proximaQuestao();
  }

  void proximaQuestao() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (jogoAtivo) {
        iniciarJogo();
      }
    });
  }

  void reiniciarEstatisticas() {
    setState(() {
      widget.jogador.acertos = 0;
      widget.jogador.erros = 0;
      tempoBase = 20;
      errosSeguidos = 0;
    });
    jogadorService.update(widget.jogador);
  }

  void sair() {
    timer?.cancel();
    jogoAtivo = false;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treinar Tabuada'),
        actions: [
          IconButton(
            onPressed: reiniciarEstatisticas,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reiniciar Estatísticas',
          ),
          IconButton(
            onPressed: sair,
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.jogador.nome,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'ACERTOS ${widget.jogador.acertos} x ${widget.jogador.erros} ERROS',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            Text(
              '$numero1 × $numero2',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Tempo: $tempoRestante segundos',
              style: TextStyle(
                fontSize: 18,
                color: tempoRestante <= 5 ? Colors.red : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: ctResposta,
              focusNode: focusResposta,
              decoration: const InputDecoration(
                labelText: "Resposta",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
              onFieldSubmitted: (value) => verificarResposta(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: verificarResposta,
              child: const Text('Verificar Resposta'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    focusResposta.dispose();
    super.dispose();
  }
}