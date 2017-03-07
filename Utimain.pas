unit Utimain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdSocketHandle, IdUDPServer, inifiles,
  IdGlobal, Vcl.StdCtrls, IdBaseComponent, IdComponent, IdUDPBase, IdUDPClient,
  IdIPWatch, Vcl.ExtCtrls, Vcl.Imaging.pngimage, Vcl.Grids, SpeechLib_TLB,
  Vcl.OleServer, Vcl.Buttons, ActiveX, MMDevApi, IdTCPConnection, IdTCPClient,
  IdHTTP, Vcl.Menus,winsock;

type
  TForm1 = class(TForm)
    IdUDPClient1: TIdUDPClient;
    udpsvr: TIdUDPServer;
    IdIPWatch1: TIdIPWatch;
    TimSocket: TTimer;
    ComboBox1: TComboBox;
    timTime: TTimer;
    lblClass: TLabel;
    img1: TImage;
    lblTime: TLabel;
    lblcurname: TLabel;
    TimTimeOut: TTimer;
    Label1: TLabel;
    SpVoice1: TSpVoice;
    sbtnexit: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Label3: TLabel;
    IdHTTP1: TIdHTTP;
    PopupMenu1: TPopupMenu;
    IP1: TMenuItem;
    IP2: TMenuItem;
    N2: TMenuItem;
    gboxdate: TGroupBox;
    Label4: TLabel;
    lblcloudip: TLabel;
    lblbroadcastip: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lbllocalip: TLabel;
    lbllocalsend: TLabel;
    lblcloudsend: TLabel;
    lblbroadcastsend: TLabel;
    lbllocalrec: TLabel;
    lblcloudrec: TLabel;
    lblbroadcastrec: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    lblserverip: TLabel;
    lblserversend: TLabel;
    lblserverrec: TLabel;
    Memo1: TMemo;
    SpeedButton2: TSpeedButton;
    N1: TMenuItem;
    Image1: TImage;

    procedure FormCreate(Sender: TObject);
    procedure udpsvrUDPRead(AThread: TIdUDPListenerThread;
      AData: TArray < System.Byte > ; ABinding: TIdSocketHandle);
    procedure TimSocketTimer(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure timTimeTimer(Sender: TObject);


    procedure TimTimeOutTimer(Sender: TObject);


    procedure udpsvrUDPException(AThread: TIdUDPListenerThread;
      ABinding: TIdSocketHandle; const AMessage: string;
      const AExceptionClass: TClass);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure sbtnexitClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure IP1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure recdate();
    procedure IP2Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure N1Click(Sender: TObject);


  private
    { Private declarations }
    filename: string;
    myinifile: Tinifile;

    myclassname: string;
    norec: integer;
    serverip: string;
    localsaveip: string;
    arrlabel: array[1..10] of TLabel;
    arrstudent: array[1..30] of string;

    arrayimage: array[1..30] of Timage;
    arraylabel: array[1..30] of tlabel;

    btts: boolean;

    sendcount: integer;
    bolrec: boolean;
    isregclass: boolean;
    isrecstudent: boolean;
    sendmode:integer;
     png:TpngImage;



  public
    { Public declarations }
  end;


var
  Form1: TForm1;
  endpointVolume: IAudioEndpointVolume = nil;
  VolumeLevel: Single;
  sn: string;
  cloudip: string;
  idhtp1: TIdHTTP;
const
  SEND_LOCALIP =1;
  SEND_CLOUDIP =2;
  SEND_BROADCASTIP =3;
  SEND_SERVERIP =4;
   //SDXS,SDBW,sdbj
implementation

{$R *.dfm}
{$R image.res}



uses SuperObject;

procedure TForm1.SpeedButton1Click(Sender: TObject);

begin
  COMBOBOX1.Visible := TRUE;

  udpsvr.Send(serverip, 60016, 'BJ', TEncoding.UTF8);
  outputdebugstring(pchar(inttostr(combobox1.items.count)));

end;


procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  gboxdate.Visible:=false;
end;

procedure TForm1.recdate;
begin
  if bolrec then begin
    lblserverrec.Caption:=inttostr(strtoint(lblserverrec.Caption)+1);
  end;
  if sendmode=SEND_LOCALIP then
  begin
    lbllocalrec.Caption:=inttostr(strtoint(lbllocalrec.Caption)+1);
  end else if   sendmode=SEND_CLOUDIP then
  begin
    lblcloudrec.Caption:=inttostr(strtoint(lblcloudrec.Caption)+1);
  end else if sendmode=SEND_BROADCASTIP THEN
  begin
    lblbroadcastrec.Caption:=inttostr(strtoint(lblbroadcastrec.Caption)+1);
  end
end;

procedure TForm1.sbtnexitClick(Sender: TObject);
begin
  if not (endpointVolume = nil) then begin
    endpointvolume.SetMasterVolumeLevelScalar(VolumeLevel, nil)
  end;
  ExitProcess(0);
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
  udpsvr.Send(serverip, 60016, 'BX' + myclassname + 'END', teNCODING.UTF8);
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
var
  i: integer;
begin
  Png := TPngImage.Create;
  try
    Png.LoadFromResourceName(HInstance, 'hb');
    for i := 1 to 30 do
    begin
      arrayimage[i].Picture.Graphic := Png;
    end;
  finally
    Png.Free;
  end;
end;

procedure MyMethod;
var
  param: tstringList;
  rstream, rstream1: tstringstream;
  soTest: isuperobject;
  TEMP: string;
begin
  try

    idhtp1 := TidHTTp.create();
    param := tstringlist.Create;
    rstream := tstringstream.Create('');
    param.Add('sn=' + sn);

    idhtp1.Post('http://svr.itrustoor.com:8181/api/chd/stbip/get', param, rstream);

    rstream1 := TStringStream.Create(rstream.DataString, TEncoding.UTF8);

    TEMP := rstream1.DataString;

    soTest := so(TEMP);

    　　 //等价的方法 soTest := TSuperObject.ParseString('{"name":"张三","age":"25","address":{"Address1":"福州","address2":"厦门"}}';



    　cloudip := soTest['Data.LocalIp'].AsString;
      form1.lblcloudip.Caption :=cloudip;

  except
    OutputDebugString(pchar('查询云IP错误'));
  end;



end;


procedure TForm1.ComboBox1Select(Sender: TObject);
begin

  myinifile.WriteString('config', 'classname', combobox1.items[combobox1.ItemIndex]);
  myclassname := combobox1.items[combobox1.ItemIndex];
  lblClass.Caption := '正在注册教室 ';
  combobox1.Visible := false;

end;



procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not (endpointVolume = nil) then begin

    endpointvolume.SetMasterVolumeLevelScalar(VolumeLevel, nil)
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  endpos: integer;
  lab: Tlabel;
  i: integer;
  image: timage;
  deviceEnumerator: IMMDeviceEnumerator;
  defaultDevice: IMMDevice;

begin

  try

  //初始化TTS
  CoCreateInstance(CLASS_IMMDeviceEnumerator, nil, CLSCTX_INPROC_SERVER, IID_IMMDeviceEnumerator, deviceEnumerator);
  deviceEnumerator.GetDefaultAudioEndpoint(eRender, eConsole, defaultDevice);
  defaultDevice.Activate(IID_IAudioEndpointVolume, CLSCTX_INPROC_SERVER, nil, endpointVolume);
  if not (endpointVolume = nil) then begin

    endpointVolume.GetMasterVolumeLevelScaler(VolumeLevel);
    endpointvolume.SetMasterVolumeLevelScalar(0.99, nil)
  end;

  sendcount := 0;
  bolrec := false;
  norec := 0;
  if Spvoice1.GetVoices('', '').Count < 1 then
    btts := false
  else begin
    btts := true;

  end;
    Png := TPngImage.Create;

    Png.LoadFromResourceName(HInstance, 'hb');



  //初始化界面
  for i := 1 to 30 do
  begin

    image := Timage.Create(self);
    image.top := 180 + ((i - 1) div 5) * 70;
    image.Left := 80 + ((i - 1) mod 5) * 152;
    image.Width := 150;
    image.Height := 68;
    image.Picture.Graphic:=png;
    image.Stretch := true;
    image.Visible := true;
    image.Visible := false;
    image.Parent := form1;
    arrayimage[i] := image;
    lab := TLabel.Create(self);
    lab.Caption := '';
    lab.Width := 150;
    lab.Height := 68;
    lab.AutoSize := false;
    lab.Alignment := taCenter;
    lab.Font.Color := clWhite;
    lab.Layout := tlcenter;
    lab.Font.Height := -29;
    lab.Font.Name := '微软雅黑';
    lab.Visible := false;
    lab.Parent := form1;
    lab.top := 180 + ((i - 1) div 5) * 70;
    lab.Left := 80 + ((i - 1) mod 5) * 152;
    arraylabel[i] := lab;
  end;
  lblcurname.Left:=  form1.Width -150;
  lblcurname.Caption:='';
  for i := 1 to 10 do
  begin
    if arrlabel[i] = nil then begin
      lab := TLabel.Create(self);
      lab.Caption := '';
      lab.visible := true;
      lab.AutoSize := true;

      lab.Font.Color := clWhite;
      lab.Font.Height := -29;
      lab.Font.Name := '微软雅黑';
      lab.Parent := form1;
      lab.Anchors := [akTop] ;
      lab.Left:=form1.Width -150;
      lab.Top := 180 + (i - 1) * 40;
      arrlabel[i] := lab;
    end;
  end;

    //查看本地班级信息
  filename := ExtractFilePath(paramstr(0)) + 'myini.ini';

  myinifile := TInifile.Create(filename);

  myclassname := myinifile.ReadString('config', 'classname', '');
  sn := myinifile.ReadString('config', 'sn', '');
  isregclass := false;



  OutputDebugString(pchar('教室名称:' + myclassname));
  if not (myclassname = '') then begin
    lblClass.Caption := '正在查询学生信息 ';
    isregclass := true;
  end else begin
    lblClass.Caption := '教室参数为空,请选择教室';
    combobox1.Visible := true;

  end;

  isrecstudent := false;

   //绑定IP,端口号
  udpsvr.Bindings.Add;

  UDPSvr.Bindings[0].IP := idipwatch1.LocalIP;
  UDPSvr.Bindings[0].Port := 60016;
  UDPSvr.Active := True;
  localsaveip := myinifile.ReadString('config', 'serverip', '');
  lbllocalip.Caption:=localsaveip;

  if localsaveip = '' then
  begin
    endpos := lastdelimiter('.', idipwatch1.LocalIP);
    serverip := Copy(idipwatch1.LocalIP, 0, endpos) + '255';
    lblbroadcastip.Caption:=serverip;
  end else
  begin
    serverip := localsaveip;
    myinifile.WriteString('config', 'serverip', serverip);
  end;

  finally
    Png.Free;
  end;
end;




procedure TForm1.FormShow(Sender: TObject);
var
  i:integer;
begin
  TThread.CreateAnonymousThread(MyMethod).Start; //查询IP
  sbtnexit.left:=form1.Width div 2 - sbtnexit.width div 2;


end;

procedure TForm1.IP1Click(Sender: TObject);
begin
   TThread.CreateAnonymousThread(MyMethod).Start;
end;

procedure TForm1.IP2Click(Sender: TObject);


var str: string;
begin str := '默认输入内容';
if InputQuery('机顶盒IP设置', '请输入机顶盒IP地址', str) then
begin
 if(Longword(inet_addr(pansichar(str)))=INADDR_NONE) then begin
    showmessage('非法IP地址')
 end
 else begin
   serverip:=str;
    myinifile.WriteString('config', 'serverip', str);

 end;
end;
end;



procedure TForm1.Memo1Change(Sender: TObject);
begin
  if memo1.Lines.Count>1000 then
    memo1.Lines.Clear;
end;

procedure TForm1.N1Click(Sender: TObject);
begin
     myinifile.DeleteKey('config','classname');
     myinifile.DeleteKey('config','sn');
     myinifile.DeleteKey('config','serverip');
     showmessage('数据初始化完成,重新打开软件后生效.')  ;
end;

procedure TForm1.N2Click(Sender: TObject);
begin
  gboxdate.Visible:=true;
end;

procedure TForm1.TimSocketTimer(Sender: TObject);

begin
  //获取广播地址
  if not bolrec then
  begin
    sendcount := sendcount + 1;
    if sendcount > 6 then
    begin
      sendmode:=SEND_BROADCASTIP;
      lblbroadcastsend.Caption:=inttostr(strtoint(lblbroadcastsend.Caption)+1);
      if not (serverip = Copy(idipwatch1.LocalIP, 0, lastdelimiter('.', idipwatch1.LocalIP)) + '255') then
      begin
        serverip := Copy(idipwatch1.LocalIP, 0, lastdelimiter('.', idipwatch1.LocalIP)) + '255';
        lblbroadcastip.Caption:=serverip;
      end
    end else
    begin
       if (sendcount mod 2 = 0) then
       begin
          if not (cloudip = '') then
          begin
            serverip := cloudip;
            lblcloudsend.Caption:=inttostr(strtoint(lblcloudsend.Caption)+1);
            sendmode:=SEND_CLOUDIP;
          end else
          begin
            sendmode:=SEND_BROADCASTIP;
            lblbroadcastsend.Caption:=inttostr(strtoint(lblbroadcastsend.Caption)+1);
          end;
       end else
       begin
        if not (localsaveip = '') then
          begin
            serverip := localsaveip;
            sendmode:=SEND_LOCALIP;
            lbllocalsend.Caption:=inttostr(strtoint(lbllocalsend.Caption)+1);
          end else
          begin
            sendmode:=SEND_BROADCASTIP;
            lblbroadcastsend.Caption:=inttostr(strtoint(lblbroadcastsend.Caption)+1);
          end;
        end;

      end;

  end else
  begin
    sendmode:=SEND_SERVERIP;
    lblserversend.Caption:=inttostr(strtoint(lblserversend.Caption)+1);
  end;

  if (isregclass = false) then
  begin
    udpsvr.Send(serverip, 60016, 'BJ', TEncoding.UTF8);
    memo1.Lines.Add(timetostr(now())+' 查询班级信息 ' +serverip);

  end
  else begin
    if (isrecstudent = false) then
    begin
      //要学生信息
      lblClass.Caption := '正在查询学生信息';
      udpsvr.Send(serverip, 60016, 'BX' + myclassname + 'END', teNCODING.UTF8);
      memo1.Lines.Add(timetostr(now())+' 查询学生信息 ' +serverip);
      NOREC := NOREC + 1;
    end else
    begin
      memo1.Lines.Add(timetostr(now())+' 发送报名信息 ' +serverip);
      udpsvr.Send(serverip, 60016, 'BM' + myclassname + 'END', TEncoding.UTF8);

      norec := norec + 1;
    end;
  end;

end;

procedure TForm1.TimTimeOutTimer(Sender: TObject);
begin
  if norec > 3 then begin
    img1.Visible := true;
    label1.visible := true;
  end;
end;

procedure TForm1.timTimeTimer(Sender: TObject);
begin
  lbltime.Caption := FormatdateTime('hh:nn', now);
end;

procedure TForm1.udpsvrUDPException(AThread: TIdUDPListenerThread;
  ABinding: TIdSocketHandle; const AMessage: string;
  const AExceptionClass: TClass);
begin
  outputDebugString(pchar(AExceptioncLASS.ClassName));
  if AExceptioncLASS.ClassName = 'EIdSocketError' then
  begin
    img1.Visible := true;
    label1.visible := true;
  end;
end;



procedure TForm1.udpsvrUDPRead(AThread: TIdUDPListenerThread;
  AData: TArray < System.Byte > ; ABinding: TIdSocketHandle);

var

  recstr: string;
  cmd: string;
  list: TStringlist;
  i: integer;
  j: Integer;
begin
  recstr := bytestostring(adata, TEncoding.UTF8);

  cmd := copy(recstr, 0, 4);
  if cmd = 'SDBM' then
  begin
    memo1.Lines.Add(timetostr(now())+' 收到报名信息 ');
    recdate;
    norec := 0;
    timSocket.Interval := 20000;
    bolrec := true;
    lblserverip.Caption:= abinding.PeerIP;
    if serverip<>localsaveip then
    begin
      myinifile.WriteString('config', 'serverip', abinding.PeerIP);
      serverip := abinding.PeerIP;
      localsaveip := serverip;
    end;

    if not (sn = copy(recstr, 5, length(recstr) - 4)) then
    begin
      sn := copy(recstr, 5, length(recstr) - 4);
      myinifile.WriteString('config', 'sn', sn);
    end;

    img1.Visible := false;
    label1.visible := false;
    lblClass.Caption := myclassname;

  end else if cmd = 'SDBJ' then
  begin
    recdate;
    lblserverip.Caption:= abinding.PeerIP;
    memo1.Lines.Add(timetostr(now())+' 收到班级信息 ' +serverip);
    isregclass := true;
    bolrec := true;
    norec := 0;
    if serverip <>localsaveip then
    begin
      myinifile.WriteString('config', 'serverip', abinding.PeerIP);
      serverip := abinding.PeerIP;
      localsaveip := serverip;
    end;
    list := tstringlist.Create;
    combobox1.Items.Clear;
    img1.Visible := false;
    label1.visible := false;
    list.Delimiter := '|';
    list.DelimitedText := copy(recstr, 5, length(recstr) - 4);
    for i := 0 to list.Count - 1 do
    begin
      combobox1.Items.Add(list[i]);
    end;


  end else if cmd = 'SDBX' then
  begin
    recdate;
    lblserverip.Caption:= abinding.PeerIP;
    lblclass.caption := '学生信息已同步';
    memo1.Lines.Add(timetostr(now())+' 收到学生信息 ' +serverip);
    isrecstudent := true;
    bolrec := true;
    norec := 0;
    if serverip  <>localsaveip then
    begin
      myinifile.WriteString('config', 'serverip', abinding.PeerIP);
      serverip := abinding.PeerIP;
      localsaveip := serverip;
    end;
    list := tstringlist.Create;

    img1.Visible := false;
    label1.visible := false;
    list.Delimiter := '|';
    list.DelimitedText := copy(recstr, 5, length(recstr) - 4);
    for j := 1 to 30 do begin
      arrayimage[j].Visible := false;
      arraylabel[j].Visible := false;

    end;

  try
    Png := TPngImage.Create;
    Png.LoadFromResourceName(HInstance, 'hb');




    for i := 0 to list.Count - 1 do
    begin
      arrayimage[i + 1].Visible := true;
      arrayimage[i + 1].Picture.graphic :=png;
      arraylabel[i + 1].Visible := true;
      arraylabel[i + 1].Caption := list[i];
    end;
       finally
    Png.Free;
  end;
  end else if cmd = 'SDXS' then
  begin

    bolrec := true;
    norec := 0;
    arrstudent[1] := lblCurName.Caption;
    lblCurName.Caption := copy(recstr, 5, length(recstr) - 4);
    try
    Png := TPngImage.Create;

    Png.LoadFromResourceName(HInstance, 'lb');




    for i := 1 to 30 do
    begin
      if arraylabel[i].Caption = lblcurname.Caption then
        arrayimage[i].Picture.graphic:=png;
    end;
       finally
    Png.Free;
  end;
    if btts then spvoice1.Speak(lblCurName.Caption, svsflagsasync)
    else
      Winapi.Windows.Beep(900, 300);
    img1.Visible := false;
    label1.visible := false;
    for i := 10 downto 2 do begin
      arrstudent[i] := arrstudent[i - 1];
    end;

    for i := 2 to 10 do begin
      arrlabel[i].Caption := arrstudent[i];
    end;
  end;
end;
end.

