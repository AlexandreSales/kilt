unit kilt.dlgs.message;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, System.Math, FMX.MultiView, FMX.Layouts,
  FMX.Ani, FMX.Effects, FMX.VirtualKeyboard, FMX.Platform, FMX.Edit;

  type
  tbuttonResultDefaultClick = procedure(sender: TObject) of object;

  tkiltDlgsMessage = class(tframe)
    imgConfirm: TImage;
    imgWarning: TImage;
    imgWarningImportant: TImage;
    imgError: TImage;
    imgQuestionImportant: TImage;
    imgQuestion: TImage;
    rectMessageShadow: TRectangle;
    layMessageBackgroud: TLayout;
    layMessageCenter: TLayout;
    layMessage: TLayout;
    layMessageButtonCancel: TLayout;
    layMessageInfo: TLayout;
    layMessageButtonCancelButton: TLayout;
    layMessageInfoContainer: TLayout;
    layMessageInfoImages: TLayout;
    layMessageTitle: TLayout;
    layMessageInfoText: TLayout;
    txtMessageInfo: TText;
    layMessageInfoButons: TLayout;
    flaMessage: TFloatAnimation;
    flaFadeIn: TFloatAnimation;
    rect_usr_shadow: TRectangle;
    efc_usr_shadow: TShadowEffect;
    btnOk: TRectangle;
    txtBtnEntrar: TText;
    efcBtnOkShadow: TShadowEffect;
    btnYes: TRectangle;
    txtBtnYes: TText;
    efcBtnYesShadow: TShadowEffect;
    btnErroConfirm: TRectangle;
    txtBtnErroConfirm: TText;
    efcBtnErroConfirm: TShadowEffect;
    txtMessageTitle: TText;
    rect_message_button_cancel: TRectangle;
    recbtnNo: TRectangle;
    btnNo: TText;
    eftrectbtnNo: TShadowEffect;
    edtFocus: TEdit;
    procedure btnDefaultResultClick(Sender: TObject);
    procedure layMessageBackgroudResize(Sender: TObject);
    procedure FrameClick(Sender: TObject);
    procedure flaMessageFinish(Sender: TObject);
  private
    { Private declarations }
    fbuttonResultDefaultClick: tbuttonResultDefaultClick;
    fresultMessage: integer;
    fvkautoShowMode: tvkautoShowMode;
  public
    { Public declarations }
    constructor Create(pOwner: TComponent); override;
    destructor Destroy; override;
    property buttonResultDefaultClick: tbuttonResultDefaultClick read fbuttonResultDefaultClick write fbuttonResultDefaultClick;
    property resultMessage: integer read fresultMessage write fresultMessage;
  end;

var
  kiltDlgsMessage: TkiltDlgsMessage;

implementation

{$R *.fmx}

procedure TkiltDlgsMessage.btnDefaultResultClick(Sender: TObject);
begin
  inherited;
  if not((sender is tbutton) or (sender is trectangle)) then
    exit;
  if assigned(fbuttonResultDefaultClick) then
  begin
    if sender is tbutton then
      fresultMessage := tbutton(sender).tag
    else
      if sender is trectangle then
        fresultMessage := trectangle(sender).tag;
    fbuttonResultDefaultClick(sender);
  end;
end;

constructor tkiltDlgsMessage.Create(pOwner: TComponent);
begin
  inherited;
  fvkautoShowMode := vkAutoShowMode;
  vkAutoShowMode := tvkautoshowmode.Never;
  rectMessageShadow.opacity := 0;
  fresultMessage := mrNone;
end;

destructor tkiltDlgsMessage.Destroy;
begin
  vkAutoShowMode := fvkautoShowMode;
  inherited;
end;

procedure tkiltDlgsMessage.flaMessageFinish(Sender: TObject);
begin
  edtFocus.setFocus;
end;

procedure tkiltDlgsMessage.FrameClick(Sender: TObject);
begin
  inherited;
  fresultMessage := mrCancel;
  btnDefaultResultClick(btnNo);
end;

procedure tkiltDlgsMessage.layMessageBackgroudResize(Sender: TObject);
begin
  inherited;
  layMessageCenter.width := layMessageBackgroud.width - 10;
end;

end.

