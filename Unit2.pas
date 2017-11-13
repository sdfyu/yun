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
  function test:string;
  begin
Result:='
[zjnbjsq]3CBB208C8231A122BCFE6C0A1CA56DED1D77BB0BFA5CC8F42CEF2F491D529EE14FD5695B06E9A211842987A3C1AD49B525E6C515B5C0DD1D9E50D0BBB1CF5672E70C1C9D2B54F83D5A28F5EE024D7B3EE8F8CCE6BEB3E166C60CF5DF1C8B38DEAD8289BEACEFEABD2270C7A257D8D65BFCC7B87BCD57BA1E4E154903075C7F8985E9CA9FE97E30FD8B49E5888B18FBF59BEB4CDA1DC9E80AD9787846EB8B86F940C3C41A1430F55376788D3293465114DF9DDB161E67AF21ECA1F7B098908D6102DCB05491AC4B1CFB1D22076DE02CBD0F6A88AE1FCA9D71860CAED7B7EF66B0331181567C97A12655AA6D794BBC84DDAAB336CE45427B962F7A2E029F4B435144D61DEFE986FDEDE4CF1CA2B84F78D9E37DB235A6A5A62E3FD443D56B98C7C05ACBA6119E3BCAA06CD752B3D3B4051B1108476A0EC45D15E52C20ECBBC810C452CFABAFD2B5A088CE1DC61067956EE9AAF3D19B55AA4CF901E769BF6D0B1AD685B381E373D39054AEC1A5A2A7DADD307FE2522B7CAD510AEE79BBEFCADA5FF3029CF295FF9C15297EDBB631F88E9771FA0EA5D4B56BB452FCDDFE47DC8937B5BD8DA8830A8A6F2FEA8B1A9ADD7142FE838DFDA505C48238FCF721392267A78E973D61D8B4414E33FAF4514FBD1140CC0F45A6507892F65333204A77864919[/zjnbjsq]
';
   end;  
procedure TForm1.Button1Click(Sender: TObject);
begin
if GetipFangshi=True then
ShowMessage('你的电脑是固定IP上网')
else
ShowMessage('你的电脑是动态IP上网');
end;

end.
 