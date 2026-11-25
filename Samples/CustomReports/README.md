# TMS Scripter — Relatório de vendas personalizado

Exemplo VCL com três vendas fixas, totalizando **R$ 1.000,00**. O Delphi prepara os dados e monta um relatório em texto; um script Pascal define o título e calcula a comissão.

## Executar

1. Abra `ScripterCustomReports.dproj` no Delphi 12 com o TMS Scripter instalado.
2. Compile em Debug para Win32 ou Win64 e execute.
3. Clique em **Gerar relatório**: a comissão inicial é **R$ 30,00** (3%).

O projeto usa a instalação padrão do TMS Setup em `%LOCALAPPDATA%\TMS Setup\Products\tms.biz.scripter`. Para outra instalação, ajuste `TMSScripterDir` no `.dproj` ou passe `/p:TMSScripterDir="C:\caminho\tms.biz.scripter"` ao MSBuild. Não são necessários banco de dados nem outros componentes de terceiros.

## Script

```pascal
function TituloRelatorio;
begin
  Result := 'Relatório de vendas';
end;

function CalcularComissao(ValorTotal);
begin
  Result := ValorTotal * 3 / 100;
end;
```

`TituloRelatorio` deve retornar um texto. `CalcularComissao` recebe o total das vendas em reais e retorna o valor da comissão, também em reais. O Delphi arredonda a comissão para centavos e formata os valores em pt-BR.

O editor usa um `TMemo` comum. Ao gerar, o Delphi compila seu conteúdo e chama as duas funções com `ExecuteSubroutineAsVariant`. A unit `Vcl.ScripterInit` inicializa o interpretador usado pelo `TatScripter`. Alterações no script limpam o relatório anterior; erros também limpam a saída e apresentam uma mensagem.

## Roteiro da aula

1. Gere o relatório com o script original: total de **R$ 1.000,00** e comissão de **R$ 30,00**.
2. Altere `ValorTotal * 3 / 100` para `ValorTotal * 5 / 100` e gere novamente: **R$ 50,00**, sem recompilar.
3. Altere o título para `Vendas da minha loja` e gere novamente.
4. Clique em **Salvar script**, feche o aplicativo e abra novamente para conferir a persistência.
5. Provoque um erro de sintaxe, tente gerar, corrija e gere novamente para mostrar a recuperação.

As alterações do editor só são gravadas ao clicar em **Salvar script**; fechar a tela descarta alterações não salvas.

## Arquivos e compilação

O build copia `Scripts\Relatorio.psc` para `Bin\Win32\Scripts` ou `Bin\Win64\Scripts`. O aplicativo carrega e salva essa cópia em UTF-8, procurando o arquivo ao lado do executável, independentemente do diretório de trabalho. Para distribuir, copie o executável e a pasta `Scripts` juntos.

As alterações salvas pelo aplicativo afetam a cópia em `Bin`. Para mantê-las nos próximos builds, atualize também o arquivo na pasta `Scripts` do projeto.

Em um prompt configurado com `rsvars.bat` do RAD Studio, na pasta do exemplo:

```bat
msbuild ScripterCustomReports.dproj /t:Build /p:Config=Debug /p:Platform=Win32
msbuild ScripterCustomReports.dproj /t:Build /p:Config=Debug /p:Platform=Win64
```
