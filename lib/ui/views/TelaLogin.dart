import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/Jogador.dart';
import '../../service/JogadorService.dart';
import 'TelaJogo.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final JogadorService jogadorService = JogadorService();

  final TextEditingController ctNome = TextEditingController();

  void entrar() async {
    String nome = ctNome.text.trim();
    if (nome.isEmpty) return;

    var jogador = await jogadorService.getByNome(nome);
    if (jogador == null) {
      jogador = Jogador(nome, 0, 0);
      await jogadorService.insert(jogador);
    }

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TelaJogo(jogador: jogador!),
    ));
  }

  void mostrarRanking() async {
    var ranking = await jogadorService.getAll();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ranking dos Jogadores'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: ranking.length,
            itemBuilder: (context, index) {
              var j = ranking[index];
              return ListTile(
                leading: Text('${index + 1}°'),
                title: Text(j.nome),
                trailing: Text('${j.pontuacao} (${j.acertos} x ${j.erros})'),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _limparRanking() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Ranking?'),
        content: const Text('Isso apagará todos os jogadores!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('jogadores');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ranking limpo com sucesso!')),
              );
            },
            child: const Text('LIMPAR', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treinar Tabuada'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: ctNome,
              decoration: const InputDecoration(
                labelText: "Seu Nome",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: ctNome.text.trim().isNotEmpty ? entrar : null,
              child: const Text('Iniciar Jogo'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _limparRanking,
              child: const Text('Limpar Ranking'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: mostrarRanking,
              child: const Text('Ranking'),
            ),
          ],
        ),
      ),
    );
  }
}