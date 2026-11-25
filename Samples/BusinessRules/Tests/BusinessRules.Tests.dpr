program BusinessRulesTests;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  System.Variants,
  atScript,
  atScripter,
  BusinessRules.Calculator in '..\Src\BusinessRules.Calculator.pas';

type
  TBusinessRulesTests = class
  private
    FScripter: TatScripter;
    FSource: TStringList;
    FChecks: Integer;
    function Order(AValue: Currency; ACount: Integer = 1; AVIP: Boolean = False): TOrderData;
    function Rule(const AExpression: string): string;
    procedure Check(ACondition: Boolean; const AName: string);
    procedure CheckResult(const AOrder: TOrderData; APercent: Double;
      ADiscount, ATotal: Currency; const AName: string);
    procedure LoadRule(const AFileName: string);
    procedure CheckDebugEntry(const AExpression, AExpected: string; const AOrder: TOrderData);
    procedure ExpectFailure(const ACode: string; const AOrder: TOrderData;
      const AMessage: string = '');
  public
    constructor Create;
    destructor Destroy; override;
    procedure Run;
  end;

constructor TBusinessRulesTests.Create;
begin
  inherited Create;
  FScripter := TatScripter.Create(nil);
  FScripter.CurrentScript := FScripter.AddScript(slPascal);
  FSource := TStringList.Create;
end;

destructor TBusinessRulesTests.Destroy;
begin
  FSource.Free;
  FScripter.Free;
  inherited;
end;

function TBusinessRulesTests.Order(AValue: Currency; ACount: Integer; AVIP: Boolean): TOrderData;
begin
  Result.Value := AValue;
  Result.ItemCount := ACount;
  Result.IsVIP := AVIP;
end;

function TBusinessRulesTests.Rule(const AExpression: string): string;
begin
  Result := 'function CalcularDesconto(ValorPedido, QuantidadeItens, ClienteVIP);' +
    sLineBreak + 'begin Result := ' + AExpression + '; end;';
end;

procedure TBusinessRulesTests.Check(ACondition: Boolean; const AName: string);
begin
  if not ACondition then
    raise Exception.Create('FALHOU: ' + AName);
  Inc(FChecks);
  WriteLn('OK: ', AName);
end;

procedure TBusinessRulesTests.CheckResult(const AOrder: TOrderData; APercent: Double;
  ADiscount, ATotal: Currency; const AName: string);
begin
  var LResult := TBusinessRulesCalculator.Calculate(FScripter, FSource, AOrder);
  Self.Check(Abs(LResult.Percent - APercent) < 0.000001, AName + ' / percentual');
  Self.Check(LResult.Discount = ADiscount, AName + ' / desconto');
  Self.Check(LResult.Total = ATotal, AName + ' / total');
end;

procedure TBusinessRulesTests.LoadRule(const AFileName: string);
begin
  FSource.LoadFromFile(TPath.Combine(ExtractFilePath(ParamStr(0)),
    'Scripts\' + AFileName), TEncoding.UTF8);
end;

procedure TBusinessRulesTests.ExpectFailure(const ACode: string;
  const AOrder: TOrderData; const AMessage: string);
begin
  FSource.Text := ACode;
  var LFailed := False;
  try
    TBusinessRulesCalculator.Calculate(FScripter, FSource, AOrder);
  except
    on E: Exception do
    begin
      LFailed := True;
      Self.Check(AMessage.IsEmpty or E.Message.Contains(AMessage), 'mensagem: ' + E.Message);
    end;
  end;
  Self.Check(LFailed, 'entrada ou script invalido rejeitado');
end;

procedure TBusinessRulesTests.CheckDebugEntry(const AExpression, AExpected: string;
  const AOrder: TOrderData);
begin
  var LDebugScripter := TatScripter.Create(nil);
  try
    var LRule := LDebugScripter.AddScript(slPascal);
    LRule.UnitName := 'Regra';
    LRule.SourceCode.Text := Self.Rule(AExpression);
    var LEntry := LDebugScripter.AddScript(slPascal);
    LEntry.UnitName := 'TestePedido';
    // Captura a mensagem como retorno para executar o mesmo ponto de entrada sem dialogo.
    LEntry.SourceCode.Text := StringReplace(TBusinessRulesCalculator.DebugSource(AOrder),
      'ShowMessage(', 'Result := (', [rfReplaceAll]);
    LDebugScripter.CurrentScript := LEntry;
    var LMessage: Variant := LDebugScripter.Execute;
    Self.Check(VarToStr(LMessage) = AExpected, 'ponto de entrada da IDE / ' + AExpected);
  finally
    LDebugScripter.Free;
  end;
end;

procedure TBusinessRulesTests.Run;
begin
  Self.LoadRule('Padrao.psc');
  Self.CheckResult(Self.Order(499.99), 0, 0, 499.99, 'padrao abaixo do limite');
  Self.CheckResult(Self.Order(500), 5, 25, 475, 'padrao no limite');
  Self.CheckResult(Self.Order(500.01), 5, 25, 475.01, 'padrao acima do limite');
  Self.CheckResult(Self.Order(1000), 5, 50, 950, 'pedido inicial');
  Self.CheckResult(Self.Order(1000, 10, True), 5, 50, 950, 'padrao nao acumula VIP ou campanha');

  Self.LoadRule('VIP.psc');
  Self.CheckResult(Self.Order(1000), 0, 0, 1000, 'cliente comum');
  Self.CheckResult(Self.Order(1000, 1, True), 10, 100, 900, 'cliente VIP');
  Self.CheckResult(Self.Order(1000, 10, True), 10, 100, 900, 'VIP independente da campanha');

  Self.LoadRule('Campanha.psc');
  Self.CheckResult(Self.Order(1000, 9), 0, 0, 1000, 'campanha abaixo do limite');
  Self.CheckResult(Self.Order(1000, 10), 15, 150, 850, 'campanha no limite');
  Self.CheckResult(Self.Order(1000, 11, True), 15, 150, 850, 'campanha independente de VIP');

  FSource.Text := Self.Rule('10');
  Self.CheckResult(Self.Order(1000), 10, 100, 900, 'regra alterada sem recompilar executavel');
  FSource.Text := Self.Rule('12.5');
  Self.CheckResult(Self.Order(19.99), 12.5, 2.50, 17.49, 'percentual fracionario e centavos');
  FSource.Text := Self.Rule('100');
  Self.CheckResult(Self.Order(19.99), 100, 19.99, 0, 'desconto integral');
  FSource.Text := Self.Rule('0');
  Self.CheckResult(Self.Order(19.99), 0, 0, 19.99, 'sem desconto');

  Self.ExpectFailure(Self.Rule('5'), Self.Order(0), 'maior que zero');
  Self.ExpectFailure(Self.Rule('5'), Self.Order(-10), 'maior que zero');
  Self.ExpectFailure(Self.Rule('5'), Self.Order(0.001), 'maior que zero');
  Self.ExpectFailure(Self.Rule('5'), Self.Order(1000, 0), 'quantidade');
  Self.ExpectFailure(Self.Rule('5'), Self.Order(1000, -2), 'quantidade');
  Self.ExpectFailure(Self.Rule('-1'), Self.Order(1000), 'entre 0 e 100');
  Self.ExpectFailure(Self.Rule('101'), Self.Order(1000), 'entre 0 e 100');
  Self.ExpectFailure(Self.Rule('''10'''), Self.Order(1000), 'percentual');
  Self.ExpectFailure(Self.Rule('''abc'''), Self.Order(1000), 'percentual');
  Self.ExpectFailure(Self.Rule('True'), Self.Order(1000), 'percentual');
  Self.ExpectFailure(Self.Rule('False'), Self.Order(1000), 'percentual');
  Self.ExpectFailure(Self.Rule(''), Self.Order(1000));
  Self.ExpectFailure('function OutraFuncao; begin Result := 5; end;', Self.Order(1000));
  Self.ExpectFailure(Self.Rule('1 div (QuantidadeItens - QuantidadeItens)'), Self.Order(1000));

  // Uma falha anterior nao pode impedir a proxima execucao valida.
  Self.LoadRule('Padrao.psc');
  Self.CheckResult(Self.Order(1000), 5, 50, 950, 'recuperacao apos erros');
  Self.CheckDebugEntry('5', 'Desconto: 5%', Self.Order(1000));
  Self.CheckDebugEntry('12.5', 'Desconto: ' + VarToStr(12.5) + '%', Self.Order(1000));
  Self.CheckDebugEntry('QuantidadeItens', 'Desconto: 10%', Self.Order(1000, 10));
  Self.CheckDebugEntry('ValorPedido', 'Desconto: ' + VarToStr(19.99) + '%', Self.Order(19.99));
  Self.CheckDebugEntry('ClienteVIP', 'Desconto: True%', Self.Order(1000, 1, True));
  WriteLn(FChecks, ' verificacoes passaram.');
end;

begin
  var LTests := TBusinessRulesTests.Create;
  try
    try
      LTests.Run;
    except
      on E: Exception do
      begin
        WriteLn(E.ClassName, ': ', E.Message);
        ExitCode := 1;
      end;
    end;
  finally
    LTests.Free;
  end;
end.
