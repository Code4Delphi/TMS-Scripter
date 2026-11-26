# TMS Scripter — Cálculo de frete

Exemplo VCL simples, com um formulário, um parâmetro e um retorno. O Delphi informa o valor da compra e um script Pascal calcula o frete. A regra pode ser alterada com o aplicativo aberto, sem recompilar.

## Executar

1. Abra `ScripterShippingCalculator.dproj` no Delphi 12 com o TMS Scripter instalado.
2. Compile em Debug para Win32 ou Win64 e execute.
3. Clique em **Calcular frete**: a compra inicial de **R$ 150,00** tem frete de **R$ 20,00**.

O projeto usa a instalação padrão do TMS Setup em `%LOCALAPPDATA%\TMS Setup\Products\tms.biz.scripter`. Para outra instalação, ajuste `TMSScripterDir` no `.dproj` ou passe `/p:TMSScripterDir="C:\caminho\tms.biz.scripter"` ao MSBuild.

## Script

```pascal
function CalcularFrete(ValorCompra);
begin
  Result := 20;

  if ValorCompra >= 200 then
    Result := 0;
end;
```

O botão valida o valor da compra, atribui `memoScript.Lines` ao Scripter, compila e chama `ExecuteSubroutineAsVariant('CalcularFrete', [LValorCompra])`. O retorno é o valor do frete em reais, exibido com duas casas decimais.

O valor da compra deve ser positivo e informado no formato brasileiro, como `150,00`. O retorno deve ser numérico, finito, não negativo e representável como `Currency`. Texto e booleanos são rejeitados. Alterar a compra ou o script limpa o resultado anterior; erros apresentam uma mensagem e permitem corrigir e calcular novamente.

Todos os componentes e o script inicial estão no `.dfm`. A unit `Vcl.ScripterInit` inicializa o interpretador, e o evento `OnCreate` prepara um script Pascal no `TatScripter`.

## Roteiro da aula

1. Calcule uma compra de **R$ 150,00**: frete de **R$ 20,00**.
2. Informe **R$ 200,00** ou **R$ 250,00**: frete de **R$ 0,00**.
3. No editor, altere `ValorCompra >= 200` para `ValorCompra >= 300`.
4. Calcule novamente os **R$ 250,00**: o frete passa para **R$ 20,00**, sem recompilar.
5. Provoque um erro de sintaxe, calcule e observe a mensagem. Corrija e calcule novamente.
6. Troque `Result := 20` por `Result := 'texto'` e calcule uma compra de R$ 150,00 para demonstrar a validação do retorno.

O script é editado apenas em memória. Fechar e abrir o aplicativo restaura o exemplo original. Não há arquivos externos, banco de dados, salvamento ou IDE de depuração.

## Compilação

Em um prompt configurado com `rsvars.bat` do RAD Studio, na pasta deste exemplo:

```bat
msbuild ScripterShippingCalculator.dproj /t:Build /p:Config=Debug /p:Platform=Win32
msbuild ScripterShippingCalculator.dproj /t:Build /p:Config=Debug /p:Platform=Win64
```

Os executáveis são gerados em `Bin\Win32` e `Bin\Win64`. O exemplo não depende de arquivos de script ao lado do executável.
