# TMS Scripter - Objeto como parâmetro

Exemplo baseado em `Samples/Functions`: o Delphi passa uma instância de `TClient` para a função `GetDiscount` do script. A função lê a propriedade `AClient.TypeClient` e retorna o percentual de desconto para um `TEdit`.

1. Abra `ScripterObjectParameters.dproj` no Delphi com o TMS Scripter instalado.
2. Execute, selecione **Normal**, **Vip** ou **Premium** e clique em **Calcular desconto**.
3. O resultado será **10%**, **20%** ou **30%**, respectivamente.
4. Altere a regra no editor e calcule novamente para aplicar a mudança sem recompilar o aplicativo.

A classe está em `Src/Client.Model.pas`. Ela herda de `TPersistent` e expõe `TypeClient` como propriedade `published`, com RTTI disponível para o Scripter. No `OnCreate` do formulário, a classe é registrada:

```pascal
IDEScripter1.DefineClassByRTTI(TClient);
```

No botão, o objeto é criado, preenchido e passado diretamente na lista de parâmetros:

```pascal
var LClient := TClient.Create;
try
  LClient.TypeClient := cBoxTypeClient.Text;
  IDEScripter1.SourceCode := IDEMemo1.Lines;
  IDEScripter1.Compile;
  var LDiscount := IDEScripter1.ExecuteSubroutineAsVariant('GetDiscount', [LClient]);
finally
  LClient.Free;
end;
```

O script inicial está no `.dfm`:

```pascal
function GetDiscount(AClient);
begin
  Result := 0;

  if AClient.TypeClient = 'Normal' then
    Result := 10
  else if AClient.TypeClient = 'Vip' then
    Result := 20
  else if AClient.TypeClient = 'Premium' then
    Result := 30;
end;
```

`AClient` recebe a referência à mesma instância criada no Delphi. Não é necessário usar `AddObject`, pois o objeto chega pelo parâmetro da função. O registro por RTTI torna a classe e sua propriedade conhecidas pelo Scripter.

O Delphi mantém o objeto vivo durante a execução e o libera no `finally`, inclusive em caso de erro. O script não deve liberar nem guardar essa referência para uso posterior. Alterar a seleção ou o script limpa o resultado anterior; o script é editado apenas em memória.

O projeto usa a instalação padrão em `%LOCALAPPDATA%\TMS Setup\Products\tms.biz.scripter`. Para outra instalação, ajuste a propriedade `TMSScripterDir` do `.dproj`.

Em um prompt configurado com `rsvars.bat`, compile com:

```bat
msbuild ScripterObjectParameters.dproj /t:Build /p:Config=Debug /p:Platform=Win32
msbuild ScripterObjectParameters.dproj /t:Build /p:Config=Debug /p:Platform=Win64
```

Referências: [registro de classes por RTTI](https://doc.tmssoftware.com/biz/scripter/guide/extending.html#registering-classes-with-rtti) e [passagem de parâmetros](https://doc.tmssoftware.com/biz/scripter/guide/scripter.html#passing-parameters-to-script).
