function TituloRelatorio;
begin
  Result := 'Relatório de vendas';
end;

function CalcularComissao(ValorTotal);
begin
  Result := ValorTotal * 3 / 100;
end;
