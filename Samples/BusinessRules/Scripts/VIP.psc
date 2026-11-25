// Regra independente: 10% exclusivamente para clientes VIP.
function CalcularDesconto(ValorPedido, QuantidadeItens, ClienteVIP);
begin
  Result := 0;
  if ClienteVIP then
    Result := 10;
end;
