// Regra independente: 5% para pedidos a partir de R$ 500.
function CalcularDesconto(ValorPedido, QuantidadeItens, ClienteVIP);
begin
  Result := 0;
  if ValorPedido >= 500 then
    Result := 5;
end;
