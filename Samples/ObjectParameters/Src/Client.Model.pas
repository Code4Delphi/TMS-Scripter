unit Client.Model;

interface

uses
  System.Classes;

type
  TClient = class
  private
    FId: Integer;
    FName: string;
    FTypeClient: string;
  public
    property Id: Integer read FId write FId;
    property Name: string read FName write FName;
    property TypeClient: string read FTypeClient write FTypeClient;
  end;

implementation

end.
