﻿unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, Math;

type
  TInteiro = record
    Value : Integer;
    Pos   : Integer;
  end;
  TSinal = record
    Value : String;
    UtilizaVetorCalculo: Boolean;
    PossuiParenteses: Boolean;
    Pos   : Integer;
  end;
  TCalculo = record
    PriValor : Integer;
    LastValue  : Integer;
    Operation  : String;
    Value      : Integer;
    Pos        : Integer;
  end;
  TfMain = class(TForm)
    edExpressao: TEdit;
    btUm: TButton;
    liTela: TLayout;
    btDois: TButton;
    btTres: TButton;
    liNumeros: TLayout;
    liPrimeiraLinha: TLayout;
    liTerceiraLinha: TLayout;
    liSegundaLinha: TLayout;
    btCinco: TButton;
    btSeis: TButton;
    btQuatro: TButton;
    btOito: TButton;
    btSete: TButton;
    btNove: TButton;
    liQuartaLinha: TLayout;
    btZero: TButton;
    liOperacoes: TLayout;
    btDivisao: TButton;
    btMultiplicacao: TButton;
    btSubtracao: TButton;
    btAdicao: TButton;
    Layout1: TLayout;
    btsqrt: TButton;
    btpotencia: TButton;
    btfibonacci: TButton;
    btCalcular: TButton;
    btEspaco: TButton;
    btLimpar: TButton;
    procedure btCalcularClick(Sender: TObject);
    procedure btEspacoClick(Sender: TObject);
    procedure btfibonacciClick(Sender: TObject);
    procedure btpotenciaClick(Sender: TObject);
    procedure btsqrtClick(Sender: TObject);
    procedure btDivisaoClick(Sender: TObject);
    procedure btMultiplicacaoClick(Sender: TObject);
    procedure btSubtracaoClick(Sender: TObject);
    procedure btAdicaoClick(Sender: TObject);
    procedure btUmClick(Sender: TObject);
    procedure btDoisClick(Sender: TObject);
    procedure btTresClick(Sender: TObject);
    procedure btZeroClick(Sender: TObject);
    procedure btSeisClick(Sender: TObject);
    procedure btCincoClick(Sender: TObject);
    procedure btQuatroClick(Sender: TObject);
    procedure btNoveClick(Sender: TObject);
    procedure btOitoClick(Sender: TObject);
    procedure btSeteClick(Sender: TObject);
    procedure btLimparClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    GCalculo: String;
    GCodigoAssembly: String;
    GVetorRegistradores: array[1..16] of Boolean;  // Limitar o uso de registradores para 16

    GVetInteger: array of TInteiro;
    GVetSinais: array of TSinal;
    GVetCalculos: array of TCalculo;

    procedure CriarArquivo;
    procedure Soma;
    procedure Subtracao;
    procedure Multiplicacao;
    procedure Divisao;
    procedure RaizQuadrada;
    procedure Potencia;
    function fibonacci(pElemento: Integer): Integer;
    procedure FibonacciAssembly;
    procedure AdicionarVariaveis(pNome: String; pPosicao: Integer; pElemento: TCalculo; pAdicionaPVAR: Boolean = True);
  protected
  public
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation

{$R *.fmx}

procedure TfMain.btCalcularClick(Sender: TObject);
var
  i, iInteger, iSinais, iPos, iCalculos: Integer;

begin
  SetLength(GVetInteger, 0);
  SetLength(GVetSinais, 0);

  GCalculo := Trim(edExpressao.Text);

  iInteger  := 0;
  iSinais   := 0;
  iPos      := 0;
  iCalculos := 0;

  for i := 0 to High(GCalculo) do
  begin
    if GCalculo[i] in ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'] then
    begin
      if GCalculo[i-1] in ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'] then
      begin
        Continue;
      end
      else
      begin
        inc(iInteger);
        inc(iPos);
        SetLength(GVetInteger, iInteger);

        if GCalculo[i+1] in ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'] then
        begin
          GVetInteger[iInteger-1].Value := StrToInt(GCalculo[i])*10 + StrToInt(GCalculo[i+1]);
          GVetInteger[iInteger-1].Pos   := iPos-1;
        end
        else
          GVetInteger[iInteger-1].Value := StrToInt(GCalculo[i]);
          GVetInteger[iInteger-1].Pos   := iPos-1;
        end;
      end;

    if GCalculo[i] in ['+', '-', '*', '/', 's', '^', 'f'] then
    begin
      inc(iSinais);
      inc(iPos);
      SetLength(GVetSinais, iSinais);
      GVetSinais[iSinais-1].Value := GCalculo[i];
      GVetSinais[iSinais-1].UtilizaVetorCalculo := GCalculo[i-4] in ['+', '-', '*', '/', 's', '^', 'f'];
      GVetSinais[iSinais-1].PossuiParenteses := GCalculo[i-2] in ['+', '-', '*', '/', 's', '^', 'f'];
      GVetSinais[iSinais-1].Pos := iPos-1;
      dec(iPos);
    end;
  end;

  for i := 0 to High(GVetSinais) do
  begin
    inc(iCalculos);
    SetLength(GVetCalculos, iCalculos);
    if GVetSinais[i].Value = '+' then
    begin
      if GVetSinais[i].PossuiParenteses then
      begin
        GVetCalculos[iCalculos-1].PriValor   := GVetCalculos[iCalculos-3].Value;
        GVetCalculos[iCalculos-1].LastValue  := GVetCalculos[iCalculos-2].Value;
        GVetCalculos[iCalculos-1].Operation  := GVetSinais[i].Value;
        GVetCalculos[iCalculos-1].Value      := GVetCalculos[iCalculos-3].Value + GVetCalculos[iCalculos-2].Value;
        GVetCalculos[iCalculos-1].Pos        := iCalculos-1;
      end
      else
      begin
        if GVetSinais[i].UtilizaVetorCalculo then
        begin
          GVetCalculos[iCalculos-1].PriValor    := GVetCalculos[High(GVetCalculos) - 1].Value;
          GVetCalculos[iCalculos-1].LastValue   := GVetInteger[GVetSinais[i].Pos - 1].Value;
          GVetCalculos[iCalculos-1].Value       := GVetCalculos[High(GVetCalculos) - 1].Value + GVetInteger[GVetSinais[i].Pos - 1].Value;
        end
        else
        begin
          GVetCalculos[iCalculos-1].PriValor   := GVetInteger[GVetSinais[i].Pos - 2].Value;
          GVetCalculos[iCalculos-1].LastValue  := GVetInteger[GVetSinais[i].Pos - 1].Value;
          GVetCalculos[iCalculos-1].Value      := GVetInteger[GVetSinais[i].Pos - 2].Value + GVetInteger[GVetSinais[i].Pos - 1].Value;
        end;

        GVetCalculos[iCalculos-1].Operation  := GVetSinais[i].Value;
        GVetCalculos[iCalculos-1].Pos        := iCalculos-1;
      end;
    end
    else if GVetSinais[i].Value = '-' then
    begin
      if GVetSinais[i].PossuiParenteses then
      begin
        GVetCalculos[iCalculos-1].PriValor   := GVetCalculos[iCalculos-3].Value;
        GVetCalculos[iCalculos-1].LastValue  := GVetCalculos[iCalculos-2].Value;
        GVetCalculos[iCalculos-1].Operation  := GVetSinais[i].Value;
        GVetCalculos[iCalculos-1].Value      := GVetCalculos[iCalculos-3].Value - GVetCalculos[iCalculos-2].Value;
        GVetCalculos[iCalculos-1].Pos        := iCalculos-1;
      end
      else
      begin
        if GVetSinais[i].UtilizaVetorCalculo then
        begin
          GVetCalculos[iCalculos-1].PriValor    := GVetCalculos[High(GVetCalculos) - 1].Value;
          GVetCalculos[iCalculos-1].LastValue   := GVetInteger[GVetSinais[i].Pos - 1].Value;
          GVetCalculos[iCalculos-1].Value       := GVetCalculos[High(GVetCalculos) - 1].Value - GVetInteger[GVetSinais[i].Pos - 1].Value;
        end
        else
        begin
          GVetCalculos[iCalculos-1].PriValor   := GVetInteger[GVetSinais[i].Pos - 2].Value;
          GVetCalculos[iCalculos-1].LastValue  := GVetInteger[GVetSinais[i].Pos - 1].Value;
          GVetCalculos[iCalculos-1].Value      := GVetInteger[GVetSinais[i].Pos - 2].Value - GVetInteger[GVetSinais[i].Pos - 1].Value;
        end;

        GVetCalculos[iCalculos-1].Operation  := GVetSinais[i].Value;
        GVetCalculos[iCalculos-1].Pos        := iCalculos-1;
      end;
    end
    else if GVetSinais[i].Value = '/' then
    begin
    if GVetSinais[i].PossuiParenteses then
      begin
        GVetCalculos[iCalculos-1].PriValor   := GVetCalculos[iCalculos-3].Value;
        GVetCalculos[iCalculos-1].LastValue  := GVetCalculos[iCalculos-2].Value;
        GVetCalculos[iCalculos-1].Operation  := GVetSinais[i].Value;
        GVetCalculos[iCalculos-1].Value      := Floor(GVetCalculos[iCalculos-3].Value / GVetCalculos[iCalculos-2].Value);
        GVetCalculos[iCalculos-1].Pos        := iCalculos-1;
      end
      else
      begin
        if GVetSinais[i].UtilizaVetorCalculo then
        begin
          GVetCalculos[iCalculos-1].PriValor    := GVetCalculos[High(GVetCalculos) - 1].Value;
          GVetCalculos[iCalculos-1].LastValue   := GVetInteger[GVetSinais[i].Pos - 1].Value;
          GVetCalculos[iCalculos-1].Value       := Floor(GVetCalculos[High(GVetCalculos) - 1].Value / GVetInteger[GVetSinais[i].Pos - 1].Value);
        end
        else
        begin
          GVetCalculos[iCalculos-1].PriValor   := GVetInteger[GVetSinais[i].Pos - 2].Value;
          GVetCalculos[iCalculos-1].LastValue  := GVetInteger[GVetSinais[i].Pos - 1].Value;
          GVetCalculos[iCalculos-1].Value      := Floor(GVetInteger[GVetSinais[i].Pos - 2].Value / GVetInteger[GVetSinais[i].Pos - 1].Value);
        end;

        GVetCalculos[iCalculos-1].Operation  := GVetSinais[i].Value;
        GVetCalculos[iCalculos-1].Pos        := iCalculos-1;
      end;
    end
    else if GVetSinais[i].Value = '*' then
    begin
      if GVetSinais[i].PossuiParenteses then
      begin
        GVetCalculos[iCalculos-1].PriValor   := GVetCalculos[iCalculos-3].Value;
        GVetCalculos[iCalculos-1].LastValue  := GVetCalculos[iCalculos-2].Value;
        GVetCalculos[iCalculos-1].Operation  := GVetSinais[i].Value;
        GVetCalculos[iCalculos-1].Value      := GVetCalculos[iCalculos-3].Value * GVetCalculos[iCalculos-2].Value;
        GVetCalculos[iCalculos-1].Pos        := iCalculos-1;
      end
      else
      begin
        if GVetSinais[i].UtilizaVetorCalculo then
        begin
          GVetCalculos[iCalculos-1].PriValor    := GVetCalculos[High(GVetCalculos) - 1].Value;
          GVetCalculos[iCalculos-1].LastValue   := GVetInteger[GVetSinais[i].Pos - 1].Value;
          GVetCalculos[iCalculos-1].Value       := GVetCalculos[High(GVetCalculos) - 1].Value * GVetInteger[GVetSinais[i].Pos - 1].Value;
        end
        else
        begin
          GVetCalculos[iCalculos-1].PriValor   := GVetInteger[GVetSinais[i].Pos - 2].Value;
          GVetCalculos[iCalculos-1].LastValue  := GVetInteger[GVetSinais[i].Pos - 1].Value;
          GVetCalculos[iCalculos-1].Value      := GVetInteger[GVetSinais[i].Pos - 2].Value * GVetInteger[GVetSinais[i].Pos - 1].Value;
        end;

        GVetCalculos[iCalculos-1].Operation  := GVetSinais[i].Value;
        GVetCalculos[iCalculos-1].Pos        := iCalculos-1;
      end;
    end
    else if GVetSinais[i].Value = 's' then
    begin
      if GVetSinais[i].PossuiParenteses then
      begin
        GVetCalculos[iCalculos-1].PriValor   := GVetCalculos[iCalculos-2].Value;
        GVetCalculos[iCalculos-1].LastValue  := 0;
        GVetCalculos[iCalculos-1].Operation  := GVetSinais[i].Value;
        GVetCalculos[iCalculos-1].Value      := Floor(sqrt(GVetCalculos[iCalculos-2].Value));
        GVetCalculos[iCalculos-1].Pos        := iCalculos-1;
      end
      else
      begin
        GVetCalculos[iCalculos-1].PriValor   := GVetInteger[GVetSinais[i].Pos - 2].Value;
        GVetCalculos[iCalculos-1].LastValue  := 0;
        GVetCalculos[iCalculos-1].Value      := Floor(sqrt(GVetInteger[GVetSinais[i].Pos - 2].Value));
        GVetCalculos[iCalculos-1].Operation  := GVetSinais[i].Value;
        GVetCalculos[iCalculos-1].Pos        := iCalculos-1;
      end;
    end
    else if GVetSinais[i].Value = '^' then
    begin
      if GVetSinais[i].PossuiParenteses then
      begin
        GVetCalculos[iCalculos-1].PriValor   := GVetCalculos[iCalculos-3].Value;
        GVetCalculos[iCalculos-1].LastValue  := GVetCalculos[iCalculos-2].Value;
        GVetCalculos[iCalculos-1].Operation  := GVetSinais[i].Value;
        GVetCalculos[iCalculos-1].Value      := Floor(Power(GVetInteger[iCalculos-3].Value, GVetInteger[iCalculos-2].Value));
        GVetCalculos[iCalculos-1].Pos        := iCalculos-1;
      end
      else
      begin
        if GVetSinais[i].UtilizaVetorCalculo then
        begin
          GVetCalculos[iCalculos-1].PriValor    := GVetCalculos[High(GVetCalculos) - 1].Value;
          GVetCalculos[iCalculos-1].LastValue   := GVetInteger[GVetSinais[i].Pos - 1].Value;
          GVetCalculos[iCalculos-1].Value       := Floor(Power(GVetCalculos[High(GVetCalculos) - 1].Value, GVetInteger[GVetSinais[i].Pos - 1].Value));
        end
        else
        begin
          GVetCalculos[iCalculos-1].PriValor   := GVetInteger[GVetSinais[i].Pos - 2].Value;
          GVetCalculos[iCalculos-1].LastValue  := GVetInteger[GVetSinais[i].Pos - 1].Value;
          GVetCalculos[iCalculos-1].Value      := Floor(Power(GVetInteger[GVetSinais[i].Pos - 2].Value, GVetInteger[GVetSinais[i].Pos - 1].Value));
        end;

        GVetCalculos[iCalculos-1].Operation  := GVetSinais[i].Value;
        GVetCalculos[iCalculos-1].Pos        := iCalculos-1;
      end;
    end
    else if GVetSinais[i].Value = 'f' then
    begin
      if GVetSinais[i].PossuiParenteses then
      begin
        GVetCalculos[iCalculos-1].PriValor   := GVetCalculos[iCalculos-2].Value;
        GVetCalculos[iCalculos-1].LastValue  := 0;
        GVetCalculos[iCalculos-1].Operation  := GVetSinais[i].Value;
        GVetCalculos[iCalculos-1].Value      := fibonacci(GVetCalculos[iCalculos-2].Value);
        GVetCalculos[iCalculos-1].Pos        := iCalculos-1;
      end
      else
      begin
        GVetCalculos[iCalculos-1].PriValor   := GVetInteger[GVetSinais[i].Pos - 1].Value;
        GVetCalculos[iCalculos-1].LastValue  := 0;
        GVetCalculos[iCalculos-1].Operation  := GVetSinais[i].Value;
        GVetCalculos[iCalculos-1].Value      := fibonacci(GVetInteger[GVetSinais[i].Pos - 1].Value);
        GVetCalculos[iCalculos-1].Pos        := iCalculos-1;
      end;
    end;
  end;

  for i := 0 to High(GVetCalculos) do
  begin
    showMessage('First value:  ' + GVetCalculos[i].PriValor.ToString + #13#10 +
                'Second value: ' + GVetCalculos[i].LastValue.ToString + #13#10 +
                'Operation:    ' + GVetCalculos[i].Operation + #13#10 +
                'Result:       ' + GVetCalculos[i].Value.ToString + #13#10 +
                'Position:     ' + GVetCalculos[i].Pos.ToString);
  end;

  CriarArquivo;
end;

procedure TfMain.CriarArquivo();
var
  wArquivo: TextFile;
  wTipoDeVariavel: String;
  i: Integer;

  wVetorOperacoesAdicionadas: array[0..6] of Boolean; // Operacoes que ja foram implementadas no codigo

  procedure Inicializar;
  var
    wCont: Integer;
  begin
    for wCont := 1 to High(GVetorRegistradores) do
      GVetorRegistradores[wCont] := False;

    for wCont := 1 to High(wVetorOperacoesAdicionadas) do // Vetor com os tipos de funcoes
      wVetorOperacoesAdicionadas[wCont] := False;

    GCodigoAssembly := '.data' + #13#10 +
                       'PVAR' + #13#10 +
                       '.text' + #13#10 +
                       'main:' + #13#10 +
                       'CODIGO' + #13#10;
  end;

begin
  AssignFile(wArquivo, 'Código assembly.mars');
  Rewrite(wArquivo);
  Inicializar;

  for i := 0 to High(GVetCalculos) do
  begin

    if GVetCalculos[i].Operation = '+' then
    begin

      wTipoDeVariavel := 'var_soma';

      // Define qual variavel os registradores $1 e $2 devem ler
      GCodigoAssembly := StringReplace(GCodigoAssembly, 'CODIGO', '  la $t1, ' + wTipoDeVariavel + i.ToString + '_' + GVetCalculos[i].PriValor.ToString + #13#10 +
                                                  '  la $t2, ' + wTipoDeVariavel + i.ToString + '_' + GVetCalculos[i].LastValue.ToString + #13#10 +
                                                  '  jal SOMA' + #13#10 + 'CODIGO', []);

      // Se a função de soma ainda não foi utilizada declara ela no fim do codigo
      if not wVetorOperacoesAdicionadas[0] then
      begin
        wVetorOperacoesAdicionadas[0] := True;
        Soma;
      end;

    end
    else if GVetCalculos[i].Operation = '-' then
    begin

      wTipoDeVariavel := 'var_subt';
      GCodigoAssembly := StringReplace(GCodigoAssembly, 'CODIGO', '  la $t1, ' + wTipoDeVariavel + i.ToString + '_' + GVetCalculos[i].PriValor.ToString + #13#10 +
                                                  '  la $t2, ' + wTipoDeVariavel + i.ToString + '_' + GVetCalculos[i].LastValue.ToString + #13#10 +
                                                  '  jal SUBT' + #13#10 + 'CODIGO', []);

      if not wVetorOperacoesAdicionadas[1] then
      begin
        wVetorOperacoesAdicionadas[1] := True;
        Subtracao;
      end;

    end
    else if GVetCalculos[i].Operation = '*' then
    begin

      wTipoDeVariavel := 'var_mult';
      GCodigoAssembly := StringReplace(GCodigoAssembly, 'CODIGO', '  la $t1, ' + wTipoDeVariavel + i.ToString + '_' + GVetCalculos[i].PriValor.ToString + #13#10 +
                                                  '  la $t2, ' + wTipoDeVariavel + i.ToString + '_' + GVetCalculos[i].LastValue.ToString + #13#10 +
                                                  '  jal MULT' + #13#10 + 'CODIGO', []);

      if not wVetorOperacoesAdicionadas[2] then
      begin
        wVetorOperacoesAdicionadas[2] := True;
        Multiplicacao;
      end;

    end
    else if GVetCalculos[i].Operation = '/' then
    begin

      wTipoDeVariavel := 'var_divi';
      GCodigoAssembly := StringReplace(GCodigoAssembly, 'CODIGO', '  la $t1, ' + wTipoDeVariavel + i.ToString + '_' + GVetCalculos[i].PriValor.ToString + #13#10 +
                                                  '  la $t2, ' + wTipoDeVariavel + i.ToString + '_' + GVetCalculos[i].LastValue.ToString + #13#10 +
                                                  '  jal DIVI' + #13#10 + 'CODIGO', []);

      if not wVetorOperacoesAdicionadas[3] then
      begin
        wVetorOperacoesAdicionadas[3] := True;
        Divisao;
      end;

    end
    else if GVetCalculos[i].Operation = 's' then
    begin

      wTipoDeVariavel := 'var_sqrt';
      GCodigoAssembly := StringReplace(GCodigoAssembly, 'CODIGO', '  la $t1, ' + wTipoDeVariavel + i.ToString + '_' + GVetCalculos[i].PriValor.ToString + #13#10 +
                                                  '  jal SQRT' + #13#10 + 'CODIGO', []);

      if not wVetorOperacoesAdicionadas[4] then
      begin
        wVetorOperacoesAdicionadas[4] := True;
        RaizQuadrada;
      end;

    end
    else if GVetCalculos[i].Operation = '^' then
    begin

      wTipoDeVariavel := 'var_pote';
      GCodigoAssembly := StringReplace(GCodigoAssembly, 'CODIGO', '  la $t1, ' + wTipoDeVariavel + i.ToString + '_' + GVetCalculos[i].PriValor.ToString + #13#10 +
                                                  '  la $t2, ' + wTipoDeVariavel + i.ToString + '_' + GVetCalculos[i].LastValue.ToString + #13#10 +
                                                  '  jal POTE' + #13#10 + 'CODIGO', []);

      if not wVetorOperacoesAdicionadas[5] then
      begin
        wVetorOperacoesAdicionadas[5] := True;
        Potencia;
      end;

    end
    else if GVetCalculos[i].Operation = 'f' then
    begin

      wTipoDeVariavel := 'var_fibo';
      GCodigoAssembly := StringReplace(GCodigoAssembly, 'CODIGO', '  la $t1, ' + wTipoDeVariavel + i.ToString + '_' + GVetCalculos[i].PriValor.ToString + #13#10 +
                                                        '  la $t2, ' + wTipoDeVariavel + i.ToString + '_0' + #13#10 +
                                                        '  jal FIBO' + #13#10 +
                                                        #13#10 +
                                                        'CONTINUE:' + #13#10 +
                                                        'CODIGO', []);

      if not wVetorOperacoesAdicionadas[6] then
      begin
        wVetorOperacoesAdicionadas[6] := True;
        FibonacciAssembly;
      end;

    end;

    if i < High(GVetCalculos) then
      AdicionarVariaveis(wTipoDeVariavel, i, GVetCalculos[i])
    else
      AdicionarVariaveis(wTipoDeVariavel, i, GVetCalculos[i], False);
  end;

  GCodigoAssembly := StringReplace(GCodigoAssembly, 'CODIGO', '  j FIM', []);
  GCodigoAssembly := GCodigoAssembly + #13#10#13#10 + 'FIM:';

  WriteLn(wArquivo, GCodigoAssembly);
  CloseFile(wArquivo);
end;

procedure TfMain.Soma;
begin
  GCodigoAssembly := GCodigoAssembly + #13#10 + 'SOMA: ' + #13#10 +
                     '  lw $t3, 0($t1)'                    + #13#10 +
                     '  lw $t4, 0($t2)'                    + #13#10 +
                     '  add $s1, $t3, $t4'                  + #13#10 +  // salvará no $s1
                     '  jr $ra';
end;

procedure TfMain.Subtracao;
begin
  GCodigoAssembly := GCodigoAssembly + #13#10 + 'SUBT: ' + #13#10 +
                     '  lw $t3, 0($t1)'                    + #13#10 +
                     '  lw $t4, 0($t2)'                    + #13#10 +
                     '  sub $s2, $t3, $t4'                  + #13#10 +  // salvará no $s2
                     '  jr $ra';
end;

procedure TfMain.Multiplicacao;
begin
  GCodigoAssembly := GCodigoAssembly + #13#10 + 'MULT: ' + #13#10 +
                     '  lw $t3, 0($t1)'                    + #13#10 +
                     '  lw $t4, 0($t2)'                    + #13#10 +
                     '  mul $s3, $t3, $t4'                  + #13#10 +  // salvará no $s3
                     '  jr $ra';
end;

procedure TfMain.Divisao;
begin
  GCodigoAssembly := GCodigoAssembly + #13#10 + 'DIVI: ' + #13#10 +
                     '  lw $t3, 0($t1)'                    + #13#10 +
                     '  lw $t4, 0($t2)'                    + #13#10 +
                     '  div $s4, $t3, $t4'                  + #13#10 +  // salvará no $s4
                     '  jr $ra';
end;

procedure TfMain.RaizQuadrada;
begin
  GCodigoAssembly := GCodigoAssembly + #13#10 + 'SQRT: ' + #13#10 +
                     '  lw $t3, 0($t1)' + #13#10 +
                     '  addi $s5, $s5, 0' + #13#10 + // n = 0
                     '  addi $t4, $t4, 1' + #13#10 + // i = 1
                     '  j WHILES' + #13#10 +
                     #13#10 +
                     'WHILES:' + #13#10 +
                     '  sub $t5, $t3, $t4' + #13#10 + // teste $t5 = m - i
                     '  bltz $t5, RETORNA' + #13#10 + // se (m - i) < 0 entao m é menor que i, logo while(m >= i)
                     '  move $t3, $t5' + #13#10 +     // m - i
                     '  addi $t4, $t4, 2' + #13#10 +  // i + 2
                     '  addi $s5, $s5, 1' + #13#10 +  // n + 1   // salvará no $s5
                     '  j WHILES' + #13#10 +
                     #13#10 +
                     'RETORNA:' + #13#10 +
                     '  jr $ra';

   // FORMULA RAIZ QUADRADA : Equação de Pell
   // n = 0
   // i = 1
   // while (m >= i){
   //    m = m – i;
   //    i = i + 2;
   //    n = n + 1;
   // }
end;

procedure TfMain.Potencia;
begin
  GCodigoAssembly := GCodigoAssembly + #13#10 +
                     'RETORNAP:' + #13#10 +
                     '  jr $ra' +
                     #13#10 +
                     'POTE: ' + #13#10 +
                     '  lw $t3, 0($t1)' + #13#10 +
                     '  lw $t4, 0($t2)' + #13#10 +
                     '  addi $s6, $s6, 1' + #13#10 +
                     '  j FORP' + #13#10 +
                     #13#10 +
                     'FORP:' + #13#10 +
                     '  mul $s6, $s6, $t3' + #13#10 +  // x * x  e  salvará no $s6
                     '  addi $t5, $t5, 1' + #13#10 + // i ++
                     '  bne  $t5, $t4, FORP' + #13#10 +
                     '  j RETORNAP';
end;

procedure TfMain.FibonacciAssembly;
begin
  GCodigoAssembly := GCodigoAssembly + #13#10 + 'FIBO: ' + #13#10 +
                     '  lw $t3, 0($t1)' + #13#10 +
                     '  lw $t4, 0($t2)' + #13#10 +
                     '  beq $t3, $t4, RETURN_B' + #13#10 +
                     '  addi $t5, $t5, 1' + #13#10 +
                     '  addi $t6, $t6, 1' + #13#10 +
                     '  j RETURN_A' + #13#10 +
                     #13#10 +
                     'RETURN_A:' + #13#10 +
                     '  addi $t6, $t6, 1' + #13#10 +
                     '  add $t7, $t4, $t5' + #13#10 +
                     '  move $t4, $t5' + #13#10 +
                     '  move $t5, $t7' + #13#10 +
                     '  bne $t6, $t3, RETURN_A' + #13#10 +
                     '  move $s7, $t5' + #13#10 +  // salvará no $s7
                     '  j FIM' + #13#10 +
                     #13#10 +
                     'RETURN_B:' + #13#10 +
                     '  move $s7, $t4' + #13#10 +  // salvará no $s7
                     '  jr $ra';
end;

procedure TfMain.FormActivate(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to fMain.ComponentCount - 1 do
  begin
    if fMain.components[i] is TButton then
    begin
      TButton(fMain.components[i]).CanFocus := False;
    end;
  end;
end;

function TfMain.fibonacci(pElemento: Integer): Integer;
var
  a, b, c, i: Integer;
begin
  a := 0;
  b := 1;

  if pElemento = 0 then
    Result := a;

  for i := 2 to pElemento do
  begin
     c := a + b;
     a := b;
     b := c;
  end;

  Result := b;
end;

procedure TfMain.AdicionarVariaveis(pNome: String; pPosicao: Integer; pElemento: TCalculo; pAdicionaPVAR: Boolean = True);
begin
  if pAdicionaPVAR then
  begin
    GCodigoAssembly := StringReplace(GCodigoAssembly, 'PVAR',
                       '  ' + pNome + pPosicao.ToString + '_' + pElemento.PriValor.ToString +
                       ': .word 0x' + pElemento.PriValor.ToString + #13#10 +
                       '  ' + pNome + pPosicao.ToString + '_' + pElemento.LastValue.ToString +
                       ': .word 0x' + pElemento.LastValue.ToString + #13#10 +
                       'PVAR', []);
  end
  else
  begin
    GCodigoAssembly := StringReplace(GCodigoAssembly, 'PVAR',
                       '  ' + pNome + pPosicao.ToString + '_' + pElemento.PriValor.ToString +
                       ': .word 0x' + pElemento.PriValor.ToString + #13#10 +
                       '  ' + pNome + pPosicao.ToString + '_' + pElemento.LastValue.ToString +
                       ': .word 0x' + pElemento.LastValue.ToString + #13#10, []);
  end;
end;

procedure TfMain.btAdicaoClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '+';
end;

procedure TfMain.btCincoClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '5';
end;

procedure TfMain.btDivisaoClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '/';
end;

procedure TfMain.btDoisClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '2';
end;

procedure TfMain.btMultiplicacaoClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '*';
end;

procedure TfMain.btNoveClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '9';
end;

procedure TfMain.btOitoClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '8';
end;

procedure TfMain.btQuatroClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '4';
end;

procedure TfMain.btSeisClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '6';
end;

procedure TfMain.btSeteClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '7';
end;

procedure TfMain.btSubtracaoClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '-';
end;

procedure TfMain.btTresClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '3';
end;

procedure TfMain.btUmClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '1';
end;

procedure TfMain.btZeroClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '0';
end;

procedure TfMain.btsqrtClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + 's';
end;

procedure TfMain.btpotenciaClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '^';
end;

procedure TfMain.btfibonacciClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + 'f';
end;

procedure TfMain.btLimparClick(Sender: TObject);
begin
  edExpressao.Text := '';
end;

procedure TfMain.btEspacoClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + ' ';
end;

end.