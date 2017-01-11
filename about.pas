unit about;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, lclintf;

type

  { Tf_about }

  Tf_about = class(TForm)
    b_donar: TBitBtn;
    textos: TMemo;
    procedure b_donarClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  f_about: Tf_about;

implementation

{$R *.lfm}

{ Tf_about }

procedure Tf_about.b_donarClick(Sender: TObject);
begin
  // ID button paypal: app001
  OpenURL('https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=webscom%2ear%40gmail%2ecom&lc='+
  'US&item_name=Webscom%20Sistemas&item_number=app001&no_note=0&currency_code=USD&bn='+
  'PP%2dDonationsBF%3abtn_donate_LG%2egif%3aNonHostedGuest');
end;

end.

