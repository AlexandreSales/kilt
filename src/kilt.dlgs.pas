unit kilt.dlgs;

interface

uses
  System.SysUtils,
  System.Classes,
  FMX.Forms,
  FMX.Types,
  FMX.VirtualKeyboard,
  FMX.Platform,
  kilt.dlgs.types;

var
  ffrmMessage: tframe;
  ffrmWait: tframe;

type
  tprocClosedlg = reference to procedure(const result: integer);
  toptionsMessage = array of string;

  tkiltDlgs = class
  strict private
    { strinct private declarations }
    class var ftimerClose: ttimer;
    class var fprocClosedlg: tprocClosedlg;

    {messagens result}
    class procedure buttonResultDefaultClick(sender: tobject);
  private
    { private declarations }
  public
    { public declarations }
    class function showMessage( const text: string;
                                const title: string = '';
                                const router: string = '';
                                const msgType: tmsgType = tminformacao;
                                const procClosedlg: tprocClosedlg = nil;
                                const parent: tform = nil;
                                const options: toptionsMessage = [];
                                const showCancelButton : boolean = false;
                                const cancelButtonTitle: string = 'Cancelar'): Integer;

    class procedure showWait(
                             const text: string = 'Aguarde...';
                             const parent: tform = nil
                             );

    class procedure hideWait(
                             habilitapanel: boolean = false
                             );

    class procedure closeMessage(const pmsgShow: tmsgShow);
    class procedure timerCloseMessage(sender: tobject);
  end;

implementation

  { tkiltDlgs }

uses
  FMX.Objects,
  FMX.Graphics,
  FMX.Effects,
  FMX.StdCtrls,
  kilt.dlgs.message,
  kilt.dlgs.wait;

class function tkiltDlgs.showMessage( const text: string;
                                const title: string = '';
                                const router: string = '';
                                const msgType: tmsgType = tminformacao;
                                const procClosedlg: tprocClosedlg = nil;
                                const parent: tform = nil;
                                const options: toptionsMessage = [];
                                const showCancelButton : boolean = false;
                                const cancelButtonTitle: string = 'Cancelar'): Integer;
const
  cintDefaultHeigth = 250;
begin
  hideWait;

  application.mainform.focused := nil;
  if parent <> nil then
    parent.focused := nil;

  fprocClosedlg := procClosedlg;

  if ffrmMessage <> nil then
    freeandnil(ffrmMessage);

  if parent = nil then
    ffrmMessage := tkiltDlgsMessage.create(application.mainForm)
  else
    ffrmMessage := tkiltDlgsMessage.create(parent);

  ffrmMessage.Visible := false;
  ffrmMessage.align := talignlayout.contents;

  if parent = nil then
    ffrmMessage.parent := application.mainform
  else
    ffrmMessage.parent := parent;

  with tkiltDlgsMessage(ffrmMessage) do
  begin
    txtMessageInfo.text := text;

    if title.trim <> '' then
      txtMessageTitle.text := title
    else
      case msgType of
      tmCancelar: txtMessageTitle.text :=  'Cancelar';
      tmConfirmar: txtMessageTitle.text :=  'Confirmação';
      tmErro: txtMessageTitle.text :=  'Ops!';
      tmInformacao: txtMessageTitle.text :=  'Informação';
      tmInformacaoImportante: txtMessageTitle.text :=  'Importante';
      tmPergunta: txtMessageTitle.text :=  'Pergunta!';
      tmPerguntaImportante: txtMessageTitle.text :=  'Atenção!';
      end;

    btnOk.visible := (msgType in [tmConfirmar, tmCancelar, tmOk]);
    btnYes.visible := (msgType in [tmPergunta, tmPerguntaImportante]);
    btnErroConfirm.visible := (msgType in [tmErro, tmInformacao, tmInformacaoImportante]);

    layMessageButtonCancel.visible := (msgType in [tmpergunta, tmperguntaimportante]) or showCancelButton;
    if showCancelButton then
      btnNo.text := cancelButtonTitle;

    imgQuestion.visible := msgType in [tmPergunta, tmMulti];
    imgQuestionImportant.visible := msgType in [tmPerguntaImportante];
    imgWarning.visible := msgType in [tmInformacao];
    imgWarningImportant.visible := msgType in [tmInformacaoImportante];
    imgConfirm.visible := msgType in [tmConfirmar, tmOk];
    imgError.visible := msgType in [tmCancelar, tmErro];

    if (msgType = tmMulti) and (Length(options) > 0) then
      for var lintCount := low(options) to high(options) do
      begin
        var lrectOption : trectangle;
        lrectOption := trectangle.create(ffrmMessage);

        with lrectOption do
        begin
          parent      := layMessageInfoButons;
          align       := talignlayout.top;
          height      := btnOk.height;
          position.y  := (lintCount * btnOk.height) + 1;
          tag         := 100 + lintCount;
          hittest     := true;

          margins := btnOk.margins;
          margins.bottom := 10;

          xradius := btnOk.xradius;
          yradius := btnOk.yradius;
          stroke.kind := tbrushkind.none;

          fill.color := btnOk.fill.color;
        end;

        lrectOption.onclick := tkiltDlgsMessage(ffrmMessage).btnDefaultResultClick;
        lrectOption.bringtofront;

        with ttext.create(lrectOption) do
        begin
          parent := lrectOption;
          align  := talignlayout.client;

          hittest := false;

          textsettings := txtBtnEntrar.textSettings;
          text := options[lintCount];
        end;

        with tshadoweffect.create(lrectOption) do
        begin
          parent := lrectOption;
          direction := efcBtnOkShadow.direction;
          distance := efcBtnOkShadow.distance;
          opacity := efcBtnOkShadow.opacity;

          shadowcolor := efcBtnOkShadow.shadowcolor;
          softness := efcBtnOkShadow.softness;
        end;
      end;
  end;

  tkiltDlgsMessage(ffrmMessage).layMessage.visible := false;
  var ldblHeight: double;
  ldblHeight := 25;

  ffrmMessage.visible := true;
  ffrmMessage.bringtofront;

  with tkiltDlgsMessage(ffrmMessage) do
  begin
    if btnOk.visible then
      ldblHeight := ldblHeight + btnOk.height;

    if btnYes.Visible then
      ldblHeight := ldblHeight + btnYes.height;

    if btnErroConfirm.visible then
      ldblHeight := ldblHeight + btnErroConfirm.height;

    if length(options) > 0 then
      ldblHeight := ldblHeight + (length(options) * (btnOk.height + 10));

    if layMessageButtonCancel.visible  then
      ldblHeight := ldblHeight + layMessageButtonCancel.height + layMessageButtonCancel.margins.top;

    layMessage.height := cintDefaultHeigth + ldblHeight;
    layMessage.tagfloat := layMessage.height;
    layMessage.position.y := layMessageCenter.position.y + layMessageCenter.height;

    flaMessage.stopvalue := layMessageCenter.height - layMessage.height;
    flaMessage.startvalue := layMessage.position.y;

    layMessage.visible := true;
  end;

  tkiltDlgsMessage(ffrmMessage).buttonResultDefaultClick := buttonResultDefaultClick;
  tkiltDlgsMessage(ffrmMessage).flaFadeIn.start;
  tkiltDlgsMessage(ffrmMessage).flaMessage.start;

  case msgType of
  tmErro, tmInformacao, tmInformacaoImportante: tkiltDlgsMessage(ffrmMessage).btnErroConfirm.setfocus;
  end;

  ffrmMessage.setfocus;
end;

class procedure tkiltDlgs.showWait(const text: string = 'Aguarde...'; const parent: tform = nil);
begin
  application.mainform.focused := nil;

  if ffrmWait <> nil then
    Exit;

  ffrmWait := tkiltDlgsWait.Create(nil);
  ffrmWait.Visible  := false;

  if parent = nil then
    ffrmWait.parent := application.mainForm
  else
    ffrmWait.Parent := parent;

  ffrmWait.Align := talignlayout.contents;

  if text.trim <> 'Aguarde...' then
    tkiltDlgsWait(ffrmWait).txt_tittle.text := text;

  ffrmWait.Visible  := true;
  ffrmWait.BringToFront;

  ffrmWait.SetFocus;
  application.processmessages;
end;

class procedure tkiltDlgs.timerCloseMessage(sender: tobject);
var
  lmsgShow: tmsgShow;
  lresultMessage: integer;
begin
  ftimerClose.enabled := false;

  if not(sender is ttimer) then
    exit;

  lmsgShow := tmsgShow(ttimer(sender).tag);
  freeandnil(ftimerClose);

  case lmsgShow of
  tmsAll:
    begin
      if ffrmMessage <> nil then
        disposeofandnil(ffrmMessage);
    end;
  tmsMessage:
    begin
      lresultMessage := tkiltDlgsMessage(ffrmMessage).resultMessage;
      if ffrmMessage <> nil then
        disposeofandnil(ffrmMessage);

      if assigned(fprocClosedlg) then
        fprocClosedlg(lresultMessage);
    end;
  end;
end;

class procedure tkiltDlgs.buttonResultDefaultClick(sender: tobject);

  function getParentFrame(octrlControlFind: tfmxobject; topFrame: boolean = true): fmx.Forms.tframe;
  begin
    if csDesigning in octrlControlFind.ComponentState then
      topFrame := False;

    while (topFrame or not (octrlControlFind is fmx.forms.tframe)) and (octrlControlFind.Parent <> nil) do
      octrlControlFind := octrlControlFind.parent;

    if octrlControlFind is fmx.Forms.TFrame then
      result := tframe(octrlControlFind)
    else
      result := nil;
  end;

var
  frmMessageSender: tframe;

begin
  if not((sender is tbutton) or (sender is trectangle)) then
    exit;

  frmMessageSender := getparentframe(tfmxobject(sender), false);
  if frmMessageSender <> nil then
  begin
    if frmMessageSender is tkiltDlgsMessage then
      closeMessage(tmsgShow.tmsMessage)
    else
      closeMessage(tmsgShow.tmsAll);
  end
  else
    closeMessage(tmsgShow.tmsAll);

  if frmMessageSender <> nil then
    frmMessageSender := nil;
end;

class procedure tkiltDlgs.closeMessage(const pmsgShow: tmsgShow);
begin
  if ftimerClose = nil then
  begin
    ftimerClose := ttimer.create(nil);
    ftimerClose.interval := 100;
    ftimerClose.OnTimer := timerCloseMessage;
  end;

  if ftimerClose <> nil then
  begin
    ftimerClose.tag := integer(pmsgShow);
    ftimerClose.enabled := true;
  end;
end;

class procedure tkiltDlgs.hideWait(HabilitaPanel: Boolean = False);
begin
  if ffrmWait <> nil then
    DisposeOfAndNil(ffrmWait);
end;

end.

