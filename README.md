# Treino Tabuada
 
Aplicativo desenvolvido em **Flutter** para praticar operações de multiplicação da tabuada de forma dinâmica e gamificada.
 
## 📚 Descrição do Projeto
 
O aplicativo sorteia dois números de 1 a 10 e o usuário deve responder o resultado da multiplicação dentro de um tempo limite. O tempo se ajusta automaticamente conforme o desempenho do jogador — diminuindo a cada acerto e aumentando após erros consecutivos, tornando o desafio progressivo e adaptativo.
 
O projeto foi desenvolvido como trabalho da disciplina de **Desenvolvimento de Aplicações Móveis**, aplicando conceitos de Flutter, gerenciamento de estado e persistência local de dados.
 
## 🎯 Funcionalidades
 
- ✅ Sorteio aleatório de operações da tabuada (1 a 10)
- ✅ Tempo inicial de 20 segundos por resposta
- ✅ Redução do tempo limite a cada acerto consecutivo
- ✅ Aumento do tempo após 2 erros consecutivos
- ✅ Cadastro do nome do jogador
- ✅ Contabilização de acertos e erros em tempo real
- ✅ Armazenamento local do placar com **Shared Preferences**
- ✅ Recuperação automática do placar ao reiniciar o app
- ✅ Ranking de jogadores baseado na pontuação *(acertos – erros)*
- ✅ Opção para reiniciar estatísticas
 
## 🛠️ Tecnologias Utilizadas
 
- Flutter
- Dart
- Shared Preferences
 
## ▶️ Como Executar o Projeto

O app também está disponível na web via Vercel:
 
🔗 **Acesse o app:** [treino-tabuada.vercel.app](https://treino-tabuada.vercel.app)
 
### Pré-requisitos
 
- Flutter SDK 3.x ou superior
- Dart SDK
- Android Studio ou VS Code com extensão Flutter
 
### Passos para execução
 
1. Clonar o repositório:
 
```bash
git clone https://github.com/eduardoalmeidajesus/treino_tabuada
```
 
2. Acessar a pasta do projeto:
 
```bash
cd treino_tabuada
```
 
3. Instalar as dependências:
 
```bash
flutter pub get
```
 
4. Executar o app:
 
```bash
flutter run
```
