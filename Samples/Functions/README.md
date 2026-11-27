# TMS Scripter - Funções com parâmetros e retorno

Exemplo VCL simples: o Delphi passa o tipo de cliente para uma função do script e exibe o percentual retornado em um `TEdit`.

1. Abra `ScripterFunctions.dproj` no Delphi com o TMS Scripter instalado.
2. Execute, selecione **Normal**, **Vip** ou **Premium** e clique em **Calcular desconto**.
3. O resultado será **10%**, **20%** ou **30%**, respectivamente.
4. Altere os percentuais no `IDEMemo` e calcule novamente para aplicar a regra sem recompilar o aplicativo.

O script inicial está no `.dfm`:

```pascal
function GetDiscount(ATypeClient);
begin
  Result := 0;

  if ATypeClient = 'Normal' then
    Result := 10
  else if ATypeClient = 'Vip' then
    Result := 20
  else if ATypeClient = 'Premium' then
    Result := 30;
end;
```

O botão compila o conteúdo atual do editor e chama a função pelo nome:

```pascal
var LTypeClient := cBoxTypeClient.Text;
IDEScripter1.SourceCode := IDEMemo1.Lines;
IDEScripter1.Compile;
var LDiscount := IDEScripter1.ExecuteSubroutineAsVariant('GetDiscount', [LTypeClient]);
```

`LTypeClient` é recebido em `ATypeClient`, e o valor atribuído a `Result` volta para `LDiscount`. Após validar que o retorno é numérico, o Delphi o exibe em `edtDiscount`. Alterar a seleção ou o script limpa o resultado anterior. O script é editado apenas em memória.

O projeto usa a instalação padrão em `%LOCALAPPDATA%\TMS Setup\Products\tms.biz.scripter`. Para outra instalação, ajuste a propriedade `TMSScripterDir` do `.dproj`.

Em um prompt configurado com `rsvars.bat`, compile com:

```bat
msbuild ScripterFunctions.dproj /t:Build /p:Config=Debug /p:Platform=Win32
msbuild ScripterFunctions.dproj /t:Build /p:Config=Debug /p:Platform=Win64
```
