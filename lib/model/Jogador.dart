class Jogador {
  String nome;
  int acertos;
  int erros;

  Jogador(this.nome, this.acertos, this.erros);

  int get pontuacao {
    int pontos = acertos - erros;
    if (pontos < 0) return 0;
    return pontos;
  }
}