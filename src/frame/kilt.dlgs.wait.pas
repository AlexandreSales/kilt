unit kilt.dlgs.wait;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Ani;

type
  tkiltDlgsWait = class(TFrame)
    rectMessage: TRectangle;
    Rectangle1: TRectangle;
    txt_tittle: TText;
    aniWait: TAniIndicator;
    Text1: TText;
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(pOwner: TComponent); override;
    destructor  Destroy; override;
  end;

var
  kiltDlgsWait: tkiltDlgsWait;

implementation

{$R *.fmx}

{ txutils_dlgs_wait }

constructor tkiltDlgsWait.Create(pOwner: TComponent);
begin
  inherited;

  aniWait.enabled := true;
end;

destructor tkiltDlgsWait.Destroy;
begin
  aniWait.enabled := false;

  inherited;
end;

end.
