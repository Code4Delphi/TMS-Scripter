unit BusinessRules.Calculator;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Variants,
  System.Math,
  atScript;

type
  TOrderData = record
    Value: Currency;
    ItemCount: Integer;
    IsVIP: Boolean;
  end;

  TDiscountResult = record
    Percent: Double;
    Discount: Currency;
    Total: Currency;
  end;

  TBusinessRulesCalculator = class
  public
    class procedure ValidateOrder(const AOrder: TOrderData);
    class function Calculate(AScripter: TatCustomScripter; ASource: TStrings;
      const AOrder: TOrderData): TDiscountResult;
    class function DebugSource(const AOrder: TOrderData): string;
  end;

implementation

class procedure TBusinessRulesCalculator.ValidateOrder(const AOrder: TOrderData);
begin
  if (AOrder.Value <= 0) or (RoundTo(AOrder.Value, -2) <= 0) then
    raise EArgumentException.Create('Informe um valor de pedido maior que zero.');
  if AOrder.ItemCount <= 0 then
    raise EArgumentException.Create('Informe uma quantidade inteira maior que zero.');
end;

class function TBusinessRulesCalculator.Calculate(AScripter: TatCustomScripter;
  ASource: TStrings; const AOrder: TOrderData): TDiscountResult;
begin
  Self.ValidateOrder(AOrder);
  var LOrderValue: Currency := RoundTo(AOrder.Value, -2);

  // O script decide apenas o percentual. O Delphi cuida dos valores em moeda.
  AScripter.SourceCode := ASource;
  AScripter.Compile;
  var LReturn: Variant := AScripter.ExecuteSubroutine('CalcularDesconto',
    VarArrayOf([LOrderValue, AOrder.ItemCount, AOrder.IsVIP]));

  if not VarIsNumeric(LReturn) or (VarType(LReturn) = varBoolean) then
    raise EArgumentException.Create('O script deve retornar um percentual numérico entre 0 e 100.');

  Result.Percent := LReturn;
  if IsNan(Result.Percent) or IsInfinite(Result.Percent) or
    (Result.Percent < 0) or (Result.Percent > 100) then
    raise EArgumentException.Create('O percentual retornado deve estar entre 0 e 100.');

  Result.Discount := RoundTo(LOrderValue * Result.Percent / 100, -2);
  Result.Total := LOrderValue - Result.Discount;
end;

class function TBusinessRulesCalculator.DebugSource(const AOrder: TOrderData): string;
begin
  Self.ValidateOrder(AOrder);
  var LVIP := 'False';
  if AOrder.IsVIP then
    LVIP := 'True';
  // O ponto de entrada e separado da regra e usa os dados atuais do pedido.
  Result := 'uses Regra;' + sLineBreak + sLineBreak +
    'begin' + sLineBreak +
    '  ShowMessage(''Desconto: '' + VarToStr(CalcularDesconto(' +
    CurrToStr(RoundTo(AOrder.Value, -2), TFormatSettings.Invariant) + ', ' +
    AOrder.ItemCount.ToString + ', ' + LVIP + ')) + ''%'');' + sLineBreak +
    'end.';
end;

end.
