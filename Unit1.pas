unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,WinSock,   ScktComp,   CheckLst;
 const 
  MAX_ADAPTER_NAME_LENGTH = 256;
  MAX_ADAPTER_DESCRIPTION_LENGTH = 128;
  MAX_ADAPTER_ADDRESS_LENGTH = 8;
type
  TIP_ADDRESS_STRING = record
    IPstring: array [0..15] of Char;
  end;
  PIP_ADDRESS_STRING = ^TIP_ADDRESS_STRING;
  TIP_MASK_STRING = TIP_ADDRESS_STRING;
  PIP_MASK_STRING = ^TIP_MASK_STRING;

  PIP_ADDR_STRING = ^TIP_ADDR_STRING;
  TIP_ADDR_STRING = record
    Next: PIP_ADDR_STRING;
    IpAddress: TIP_ADDRESS_STRING;
    IpMask: TIP_MASK_STRING;
    Context:DWORD;
  end;

  PIP_ADAPTER_INFO = ^TIP_ADAPTER_INFO;
  TIP_ADAPTER_INFO = packed record
    Next: PIP_ADAPTER_INFO;
    ComboIndex: DWORD;
    AdapterName: array [0..MAX_ADAPTER_NAME_LENGTH + 4-1] of Char;
    Description: array [0..MAX_ADAPTER_DESCRIPTION_LENGTH + 4-1] of Char;
    AddressLength: UINT;
    Address: array [0..MAX_ADAPTER_ADDRESS_LENGTH-1] of BYTE;
    Index: DWORD;
    dwType: UINT;
    DhcpEnabled: UINT;
    CurrentIpAddress: PIP_ADDR_STRING;
    IpAddressList: TIP_ADDR_STRING;
    GatewayList: TIP_ADDR_STRING;
    DhcpServer: TIP_ADDR_STRING;
    HaveWins: BOOL;
    PrimaryWinsServer: TIP_ADDR_STRING;
    SecondaryWinsServer: TIP_ADDR_STRING;
  end;
  ///////////////
  TForm1 = class(TForm)
    Button1: TButton;
    function   GetipFangshi:Boolean;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
function   GetAdaptersInfo(pAdapterInfo: PIP_ADAPTER_INFO;
                pOutBufLen: PDWORD): DWORD; stdcall;
                external 'IPHLPAPI.DLL' name 'GetAdaptersInfo';
{$R *.dfm}
function TForm1.GetipFangshi:Boolean;

var
  pbuf:PIP_ADAPTER_INFO;
  buflen:DWORD;
  i:   integer;
begin
  buflen:= 0;
  if GetAdaptersInfo(pbuf, @bufLen) = ERROR_BUFFER_OVERFLOW then
  begin
    pbuf:= AllocMem(buflen);
    if GetAdaptersInfo(pbuf, @bufLen) = ERROR_SUCCESS then
    while pbuf <> nil do
    begin
      //showmessage( IntToStr( pbuf.DhcpEnabled ) );//1动态分配
      if  pbuf.DhcpEnabled=1 then
      Result:=False else
      Result:=True;
      pbuf   :=   pbuf.Next;
    end;
    FreeMem(pbuf);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
if GetipFangshi=True then
ShowMessage('你的电脑是固定IP上网')
else
ShowMessage('你的电脑是动态IP上网');
end;

end.
 