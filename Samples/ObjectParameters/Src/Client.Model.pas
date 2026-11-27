unit Client.Model;

interface

uses
  System.Classes;

type
  TClient = class(TPersistent)
  private
    FTypeClient: string;
  published
    property TypeClient: string read FTypeClient write FTypeClient;
  end;

implementation

end.
