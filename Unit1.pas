unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    GCalculo: String;

    GVetInteger: array of record
      Value : Integer;
      Pos   : Integer;
    end;
    GVetSinais: array of record
      Value : String;
      Pos   : Integer
    end;
    GVetCalculos: array of record
      FirstValue : Integer;
      LastValue  : Integer;
      Operation  : String;
      Value      : Double;
      Pos        : Integer;
    end;

    procedure Realocar(pPosicoesApagar: Integer = 2);
    procedure CriarArquivo();
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
var
  i, iInteger, iSinais, iCalculos: Integer;
begin
  iInteger  := 0;
  iSinais   := 0;
  iCalculos := 0;

  for i := 0 to High(GCalculo) do
  begin
    if (GCalculo[i] = '') or (GCalculo[i] = ' ') then
      Continue
    else if GCalculo[i] in ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'] then
    begin
      inc(iInteger);
      SetLength(GVetInteger, iInteger);
      GVetInteger[iInteger-1].Value := StrToInt(GCalculo[i]);
      GVetInteger[iInteger-1].Pos   := iInteger-1;
    end
    else
    begin
      inc(iSinais);
      SetLength(GVetSinais, iSinais);
      GVetSinais[iSinais-1].Value := GCalculo[i];
      GVetSinais[iSinais-1].Pos := iSinais-1;
    end;
  end;

  for i := 0 to High(GVetSinais) do
  begin
    inc(iCalculos);
    SetLength(GVetCalculos, iCalculos);
    if GVetSinais[i].Value = '+' then
    begin
      GVetCalculos[iCalculos-1].FirstValue := GVetInteger[0].Value;
      GVetCalculos[iCalculos-1].LastValue  := GVetInteger[1].Value;
      GVetCalculos[iCalculos-1].Operation  := GVetSinais[i].Value;
      GVetCalculos[iCalculos-1].Value      := GVetInteger[0].Value + GVetInteger[1].Value;
      GVetCalculos[iCalculos-1].Pos        := iCalculos;
    end;

    if GVetSinais[i].Value = '-' then
    begin
      GVetCalculos[iCalculos-1].FirstValue := GVetInteger[0].Value;
      GVetCalculos[iCalculos-1].LastValue  := GVetInteger[1].Value;
      GVetCalculos[iCalculos-1].Operation  := GVetSinais[i].Value;
      GVetCalculos[iCalculos-1].Value      := GVetInteger[0].Value - GVetInteger[1].Value;
      GVetCalculos[iCalculos-1].Pos        := iCalculos-1;
    end;

    if GVetSinais[i].Value = '/' then
    begin
      GVetCalculos[iCalculos-1].FirstValue := GVetInteger[0].Value;
      GVetCalculos[iCalculos-1].LastValue  := GVetInteger[1].Value;
      GVetCalculos[iCalculos-1].Operation  := GVetSinais[i].Value;
      GVetCalculos[iCalculos-1].Value      := GVetInteger[0].Value / GVetInteger[1].Value;
      GVetCalculos[iCalculos-1].Pos        := iCalculos-1;
    end;

    if GVetSinais[i].Value = '*' then
    begin
      GVetCalculos[iCalculos-1].FirstValue := GVetInteger[0].Value;
      GVetCalculos[iCalculos-1].LastValue  := GVetInteger[1].Value;
      GVetCalculos[iCalculos-1].Operation  := GVetSinais[i].Value;
      GVetCalculos[iCalculos-1].Value      := GVetInteger[0].Value * GVetInteger[1].Value;
      GVetCalculos[iCalculos-1].Pos        := iCalculos-1;
    end;

    Realocar;
  end;

  for i := 0 to High(GVetCalculos) do
  begin
    showMessage('First value:  ' + GVetCalculos[i].FirstValue.ToString + #13#10 +
                'Second value: ' + GVetCalculos[i].LastValue.ToString + #13#10 +
                'Operation:    ' + GVetCalculos[i].Operation + #13#10 +
                'Result:       ' + GVetCalculos[i].Value.ToString + #13#10 +
                'Position:     ' + GVetCalculos[i].Pos.ToString);
  end;

  CriarArquivo;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  GCalculo := '1 3 + 2 5 +';
end;

procedure TForm1.Realocar(pPosicoesApagar: Integer = 2);
var
  i: Integer;

begin
  for i := 0 to High(GVetInteger) - pPosicoesApagar do
    GVetInteger[i] := GVetInteger[i+pPosicoesApagar]
end;

procedure TForm1.CriarArquivo();
var
  wArquivo: TextFile;
  wCodigo: String;
  i: Integer;

  wVetorRegistradores: array[1..16] of Boolean;  // Limitar o uso de registradores para 16
  wVetorOperacoesAdicionadas: array[1..2] of Boolean; // Operacoes que ja foram implementadas no codigo

  procedure InicializaVetores;
  var
    wCont: Integer;
  begin
    for wCont := 1 to High(wVetorRegistradores) do
      wVetorRegistradores[wCont] := False;

    for wCont := 1 to High(wVetorOperacoesAdicionadas) do
      wVetorOperacoesAdicionadas[wCont] := False;
  end;

  procedure AlocaRegistradores(pPosAlocada: Integer);
  begin
    if not wVetorRegistradores[pPosAlocada] then
    begin
      wVetorRegistradores[pPosAlocada] := True;
    end
    else
    begin
      {$IFDEF DEBUG}
      showMessage('O registrador $' + pPosAlocada.ToString + ' já está alocado');
      {$ENDIF}
    end;
  end;

  procedure Soma();
  begin
    AlocaRegistradores(3);

    wCodigo := wCodigo + #13#10#13#10 + 'SOMA: ' + #13#10 +
               '  la $1 var_soma1'           + #13#10 +
               '  la $2 var_soma2'           + #13#10 +
               '  lw $1 $1'                  + #13#10 +
               '  lw $2 $2'                  + #13#10 +
               '  add $3 $1 $2'              + #13#10;
  end;

  procedure Subtracao();
  begin
    AlocaRegistradores(4);

    wCodigo := wCodigo + #13#10#13#10 + 'SUBT: ' + #13#10 +
               '  la $1 var_subt1'           + #13#10 +
               '  la $2 var_subt'            + #13#10 +
               '  lw $1 $1'                  + #13#10 +
               '  lw $2 $2'                  + #13#10 +
               '  add $4 $1 $2'              + #13#10;
  end;

begin
  InicializaVetores;

  AssignFile(wArquivo, 'Código assembly.txt');
  Rewrite(wArquivo);
  wCodigo := '.data' + #13#10;

  // LER VETOR COM CALCULOS E DISTRIBUIR FUNCOES USADAS NO ARQUIVO
  for i := 0 to High(GVetCalculos) do
  begin

    if GVetCalculos[i].Operation = '+' then
    begin
      if i = 0 then
      begin
        wCodigo := wCodigo + '  var_soma'+ i.ToString + '_' + GVetCalculos[i].FirstValue.ToString +
                   ': .word 0x' + GVetCalculos[i].FirstValue.ToString + #13#10 +
                   '  var_soma'+ i.ToString + '_' + GVetCalculos[i].LastValue.ToString +
                   ': .word 0x' + GVetCalculos[i].LastValue.ToString + #13#10 +
                   'PVAR';
      end
      else if i < High(GVetCalculos) then
      begin
        wCodigo := StringReplace(wCodigo, 'PVAR',
                   '  var_soma'+ i.ToString + '_' + GVetCalculos[i].FirstValue.ToString +
                   ': .word 0x' + GVetCalculos[i].FirstValue.ToString + #13#10 +
                   '  var_soma'+ i.ToString + '_' + GVetCalculos[i].LastValue.ToString +
                   ': .word 0x' + GVetCalculos[i].LastValue.ToString + #13#10 +
                   'PVAR', []);
      end
      else
      begin
        wCodigo := StringReplace(wCodigo, 'PVAR',
                   '  var_soma'+ i.ToString + '_' + GVetCalculos[i].FirstValue.ToString +
                   ': .word 0x' + GVetCalculos[i].FirstValue.ToString + #13#10 +
                   '  var_soma'+ i.ToString + '_' + GVetCalculos[i].LastValue.ToString +
                   ': .word 0x' + GVetCalculos[i].LastValue.ToString + #13#10, []);
      end;

      if not wVetorOperacoesAdicionadas[1] then
      begin
        wVetorOperacoesAdicionadas[1] := True;
        if i = 0 then
          wCodigo := wCodigo + #13#10 + 'CODIGO';
        Soma;
      end;
    end;
  end;
  // UTILIZAR JUMPS PARA PULAR DE FUNCAO EM FUNCAO

  WriteLn(wArquivo, wCodigo);
  CloseFile(wArquivo);
end;

end.
