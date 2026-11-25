// Regra independente: 15% para pedidos com pelo menos 10 itens.
function CalcularDesconto(ValorPedido, QuantidadeItens, ClienteVIP);
begin
  Result := 0;
  if QuantidadeItens >= 10 then
    Result := 15;
end;
