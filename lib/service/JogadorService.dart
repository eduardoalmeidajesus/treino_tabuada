import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/Jogador.dart';

class JogadorService {
  static const String _chaveJogadores = 'jogadores';

  // criar ou atualizar jogador
  Future<void> insert(Jogador novo) async {
    final prefs = await SharedPreferences.getInstance();
    List<Jogador> jogadores = await getAll();
    jogadores.removeWhere((j) => j.nome == novo.nome);
    jogadores.add(novo);
    String jsonJogadores = _paraJson(jogadores);
    await prefs.setString(_chaveJogadores, jsonJogadores);
  }

  Future<Jogador?> getByNome(String nome) async {
    List<Jogador> jogadores = await getAll();

    for (Jogador j in jogadores) {
      if (j.nome == nome) {
        return j;
      }
    }
    return null;
  }

  Future<List<Jogador>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonJogadores = prefs.getString(_chaveJogadores);

    if (jsonJogadores == null || jsonJogadores.isEmpty) {
      return [];
    }

    List<Jogador> jogadores = _deJson(jsonJogadores);

    jogadores.sort((a, b) => b.pontuacao.compareTo(a.pontuacao));

    return jogadores;
  }

  Future<void> update(Jogador jogador) async {
    await insert(jogador);
  }

  // converte pra json
  String _paraJson(List<Jogador> jogadores) {
    List<Map<String, dynamic>> jsonList = [];

    for (Jogador j in jogadores) {
      jsonList.add({
        'nome': j.nome,
        'acertos': j.acertos,
        'erros': j.erros,
      });
    }

    return json.encode(jsonList);
  }

  // converte pra lista
  List<Jogador> _deJson(String jsonString) {
    List<Jogador> jogadores = [];

    try {
      List<dynamic> jsonList = json.decode(jsonString);

      for (var item in jsonList) {
        jogadores.add(Jogador(
          item['nome'],
          item['acertos'],
          item['erros'],
        ));
      }
    } catch (e) {
      return [];
    }

    return jogadores;
  }
}