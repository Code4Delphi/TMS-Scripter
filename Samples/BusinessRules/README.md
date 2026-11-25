# TMS Scripter — Regras de desconto sem recompilar

Simulador VCL que envia os dados de um pedido para uma função Pascal e recebe o percentual de desconto. O Delphi calcula os valores em moeda; a regra pode ser editada e executada com o aplicativo aberto.

## Executar

1. Abra `ScripterBusinessRules.dproj` no Delphi 12 com o TMS Scripter instalado.
2. Compile em Debug para Win32 ou Win64 e execute.
3. O pedido inicial é de **R$ 1.000,00**, com **1 item**, sem VIP e usando a regra padrão.

O build copia os três exemplos de `Scripts` para `Bin\Win32\Scripts` ou `Bin\Win64\Scripts`. O aplicativo procura os scripts ao lado do executável, independentemente do diretório de trabalho. Para distribuir, copie o executável e essa pasta juntos.

As edições no aplicativo afetam as cópias em `Bin`. Para incorporá-las aos próximos builds, salve também na pasta `Scripts` do projeto.

O projeto usa a instalação padrão do TMS Setup em `%LOCALAPPDATA%\TMS Setup\Products\tms.biz.scripter`. Se sua instalação for diferente, configure `TMSScripterDir` no `.dproj` ou passe `/p:TMSScripterDir="C:\caminho\tms.biz.scripter"` ao MSBuild. Não são necessários banco de dados nem outros componentes de terceiros.

Os caminhos de compilação são declarados no próprio projeto para evitar dependência de bibliotecas globais de outros componentes instalados na máquina.

## Contrato da regra

```pascal
function CalcularDesconto(ValorPedido, QuantidadeItens, ClienteVIP);
begin
  Result := 0;
  if ValorPedido >= 500 then
    Result := 5;
end;
```

- `ValorPedido`: valor positivo em reais, normalizado para centavos pelo Delphi.
- `QuantidadeItens`: inteiro positivo.
- `ClienteVIP`: booleano.
- Retorno: número de **0 a 100**, representando o percentual; textos e booleanos são rejeitados.

A unit `BusinessRules.Calculator` atribui o código ao Scripter, compila e chama `ExecuteSubroutine` com os três parâmetros. O desconto é arredondado para duas casas usando `RoundTo`; o total é a diferença entre o valor do pedido e o desconto arredondado. Nenhuma regra manipula diretamente os componentes da tela.

| Arquivo | Condição | Percentual |
|---|---|---|
| `Padrao.psc` | Valor a partir de R$ 500 | 5% |
| `VIP.psc` | Cliente VIP marcado | 10% |
| `Campanha.psc` | Pelo menos 10 itens | 15% |

As regras são independentes e não acumulam descontos. Quando a condição não é satisfeita, retornam zero.

## Roteiro da aula

1. Execute o pedido inicial: desconto de **R$ 50,00**, total de **R$ 950,00**.
2. No editor, altere `Result := 5` para `Result := 10` e calcule novamente: desconto de **R$ 100,00**, total de **R$ 900,00**, sem recompilar.
3. Salve em outro arquivo `.psc`, abra-o novamente e mostre a persistência em UTF-8.
4. Selecione VIP e alterne a marcação de cliente VIP.
5. Selecione Campanha e compare pedidos com 9 e 10 itens.
6. Provoque um erro de sintaxe, uma divisão por zero e um retorno maior que 100. Os resultados anteriores são limpos e a mensagem de erro é apresentada. Erros do interpretador incluem linha e coluna quando disponíveis.
7. Corrija o script e calcule novamente para mostrar a recuperação.

Alterações nos dados ou no script limpam o resultado. Trocar de arquivo, selecionar outro exemplo ou fechar a tela oferece salvar, descartar ou cancelar quando há edição pendente. O asterisco ao lado do caminho indica alterações ainda não salvas.

## Depurar na IDE

Clique em **Abrir IDE / Depurar** com dados válidos. A IDE recebe dois scripts em memória:

- `Regra`: uma cópia exata do editor, que pode ser alterada.
- `TestePedido`: ponto de entrada gerado com os dados atuais, que chama a função e mostra o percentual retornado.

Coloque um breakpoint na regra com **F5**, execute com **F9** e acompanhe com **F7/F8**. O script principal é `TestePedido`, mesmo que a aba `Regra` esteja selecionada. Para testar outros dados da tela, feche a IDE, altere o pedido e abra-a novamente.

Ao fechar a IDE, o conteúdo de `Regra` volta ao editor principal. Use **Calcular pedido** para atualizar os resultados e **Salvar script** para persistir a regra em UTF-8. O ponto de entrada é temporário e é recriado a cada abertura; não é necessário salvar um projeto da IDE. Se a regra for removida do projeto da IDE, o editor principal é preservado e uma mensagem informa o ocorrido.

## Compilação e testes

Em um prompt configurado com `rsvars.bat` do RAD Studio, na pasta deste exemplo:

```bat
msbuild ScripterBusinessRules.dproj /t:Build /p:Config=Debug /p:Platform=Win32
msbuild ScripterBusinessRules.dproj /t:Build /p:Config=Debug /p:Platform=Win64
msbuild Tests\BusinessRules.Tests.dproj /t:Build /p:Config=Debug /p:Platform=Win32
Bin\Win32\BusinessRules.Tests.exe
msbuild Tests\BusinessRules.Tests.dproj /t:Build /p:Config=Debug /p:Platform=Win64
Bin\Win64\BusinessRules.Tests.exe
```

Os testes usam o interpretador real e os arquivos distribuídos com o exemplo: limites das três regras, independência dos descontos, alteração do código em memória, arredondamento, entradas e retornos inválidos, erros de compilação/execução e recuperação após falhas.
