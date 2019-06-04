unit Main;

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
    PossuiParenteses: Boolean;
    Pos   : Integer
  end;
  TCalculo = record
    FirstValue : Integer;
    LastValue  : Integer;
    Operation  : String;
    Value      : Double;
    Pos        : Integer;
  end;
  TForm1 = class(TForm)
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
  private
    GCalculo: String;
    GCodigoAssembly: String;
    GVetorRegistradores: array[1..16] of Boolean;  // Limitar o uso de registradores para 16

    GVetInteger: array of TInteiro;
    GVetSinais: array of TSinal;
    GVetCalculos: array of TCalculo;

    procedure CriarArquivo;
    procedure AlocaRegistradores(pPosAlocada: Integer);
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
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.btAdicaoClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '+';
end;

procedure TForm1.btCalcularClick(Sender: TObject);
var
  i, iInteger, iSinais, iCalculos: Integer;

  procedure Realocar(pPosicoesApagar: Integer = 2);
  var
    wCont: Integer;

  begin
    for wCont := 0 to High(GVetInteger) - pPosicoesApagar do
      GVetInteger[wCont] := GVetInteger[wCont+pPosicoesApagar];
  end;

begin
  GCalculo := Trim(edExpressao.Text);

  iInteger  := 0;
  iSinais   := 0;
  iCalculos := 0;

  for i := 0 to High(GCalculo) do
  begin
    if GCalculo[i] in ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'] then
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
      GVetSinais[iSinais-1].PossuiParenteses := GCalculo[i-1] in ['+', '-', '*', '/', '√', '^', 'f'];
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

    if GVetSinais[i].Value = '√' then
    begin
      GVetCalculos[iCalculos-1].FirstValue := GVetInteger[0].Value;
      GVetCalculos[iCalculos-1].Operation  := GVetSinais[i].Value;
      GVetCalculos[iCalculos-1].Value      := sqrt(GVetInteger[0].Value);
      GVetCalculos[iCalculos-1].Pos        := iCalculos-1;
    end;

    if GVetSinais[i].Value = '^' then
    begin
      GVetCalculos[iCalculos-1].FirstValue := GVetInteger[0].Value;
      GVetCalculos[iCalculos-1].LastValue  := GVetInteger[1].Value;
      GVetCalculos[iCalculos-1].Operation  := GVetSinais[i].Value;
      GVetCalculos[iCalculos-1].Value      := Power(GVetInteger[0].Value, GVetInteger[1].Value);
      GVetCalculos[iCalculos-1].Pos        := iCalculos-1;
    end;

    if GVetSinais[i].Value = 'f' then
    begin
      GVetCalculos[iCalculos-1].FirstValue := GVetInteger[0].Value;
      GVetCalculos[iCalculos-1].LastValue  := 0;
      GVetCalculos[iCalculos-1].Operation  := GVetSinais[i].Value;
      GVetCalculos[iCalculos-1].Value      := fibonacci(GVetInteger[0].Value);
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

procedure TForm1.btCincoClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '5';
end;

procedure TForm1.btDivisaoClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '/';
end;

procedure TForm1.btDoisClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '2';
end;

procedure TForm1.btMultiplicacaoClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '*';
end;

procedure TForm1.btNoveClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '9';
end;

procedure TForm1.btOitoClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '8';
end;

procedure TForm1.btQuatroClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '4';
end;

procedure TForm1.btSeisClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '6';
end;

procedure TForm1.btSeteClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '7';
end;

procedure TForm1.btSubtracaoClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '-';
end;

procedure TForm1.btTresClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '3';
end;

procedure TForm1.btUmClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '1';
end;

procedure TForm1.btZeroClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '0';
end;

procedure TForm1.btsqrtClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '√';
end;

procedure TForm1.btpotenciaClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + '^';
end;

procedure TForm1.btfibonacciClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + 'f';
end;

procedure TForm1.btLimparClick(Sender: TObject);
begin
  edExpressao.Text := '';
end;

procedure TForm1.btEspacoClick(Sender: TObject);
begin
  edExpressao.Text := edExpressao.Text + ' ';
end;

procedure TForm1.CriarArquivo();
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
                       '  var_sqrt: .word 0x2' + #13#10 +
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
      GCodigoAssembly := StringReplace(GCodigoAssembly, 'CODIGO', '  la $t1, ' + wTipoDeVariavel + i.ToString + '_' + GVetCalculos[i].FirstValue.ToString + #13#10 +
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
      GCodigoAssembly := StringReplace(GCodigoAssembly, 'CODIGO', '  la $t1, ' + wTipoDeVariavel + i.ToString + '_' + GVetCalculos[i].FirstValue.ToString + #13#10 +
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
      GCodigoAssembly := StringReplace(GCodigoAssembly, 'CODIGO', '  la $t1, ' + wTipoDeVariavel + i.ToString + '_' + GVetCalculos[i].FirstValue.ToString + #13#10 +
                                                  '  la $t2, ' + wTipoDeVariavel + i.ToString + '_' + GVetCalculos[i].LastValue.ToString + #13#10 +
                                                  '  jal MULT' + #13#10 + 'CODIGO', []);

      if not wVetorOperacoesAdicionadas[2] then
      begin
        wVetorOperacoesAdicionadas[2] := True;
        Multiplicacao;
      end;

    end
    else
    if GVetCalculos[i].Operation = '/' then
    begin

      wTipoDeVariavel := 'var_divi';
      GCodigoAssembly := StringReplace(GCodigoAssembly, 'CODIGO', '  la $t1, ' + wTipoDeVariavel + i.ToString + '_' + GVetCalculos[i].FirstValue.ToString + #13#10 +
                                                  '  la $t2, ' + wTipoDeVariavel + i.ToString + '_' + GVetCalculos[i].LastValue.ToString + #13#10 +
                                                  '  jal DIVI' + #13#10 + 'CODIGO', []);

      if not wVetorOperacoesAdicionadas[3] then
      begin
        wVetorOperacoesAdicionadas[3] := True;
        Divisao;
      end;

    end
    else if GVetCalculos[i].Operation = 'sqrt' then
    begin

      wTipoDeVariavel := 'var_sqrt';
      GCodigoAssembly := StringReplace(GCodigoAssembly, 'CODIGO', '  la $t1, ' + wTipoDeVariavel + i.ToString + '_' + GVetCalculos[i].FirstValue.ToString + #13#10 +
                                                  '  la $t2, var_sqrt' + #13#10 +
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
      GCodigoAssembly := StringReplace(GCodigoAssembly, 'CODIGO', '  la $t1, ' + wTipoDeVariavel + i.ToString + '_' + GVetCalculos[i].FirstValue.ToString + #13#10 +
                                                  '  la $t2, ' + wTipoDeVariavel + i.ToString + '_' + GVetCalculos[i].LastValue.ToString + #13#10 +
                                                  '  jal SQRT' + #13#10 + 'CODIGO', []);

      if not wVetorOperacoesAdicionadas[5] then
      begin
        wVetorOperacoesAdicionadas[5] := True;
        Potencia;
      end;

    end
    else if GVetCalculos[i].Operation = 'f' then
    begin

      wTipoDeVariavel := 'var_fibo';
      GCodigoAssembly := StringReplace(GCodigoAssembly, 'CODIGO', '  la $t1, ' + wTipoDeVariavel + i.ToString + '_' + GVetCalculos[i].FirstValue.ToString + #13#10 +
                                                        '  la $t2, ' + wTipoDeVariavel + i.ToString + '_0' + #13#10 +
                                                        '  jal FIBO' + #13#10 + 'CODIGO', []);

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
  GCodigoAssembly := GCodigoAssembly + #13#10 + 'FIM:';

  WriteLn(wArquivo, GCodigoAssembly);
  CloseFile(wArquivo);
end;

procedure TForm1.AlocaRegistradores(pPosAlocada: Integer); // realizar melhora para exibir todos registradores e quais estao ocupados
  begin
    if not GVetorRegistradores[pPosAlocada] then
    begin
      GVetorRegistradores[pPosAlocada] := True;
    end
    else
    begin
      {$IFDEF DEBUG}
      showMessage('O registrador $' + pPosAlocada.ToString + ' já está alocado');
      {$ENDIF}
    end;
  end;

procedure TForm1.Soma;
begin
  AlocaRegistradores(3);

  GCodigoAssembly := GCodigoAssembly + #13#10 + 'SOMA: ' + #13#10 +
                     '  lw $t3, 0($t1)'                    + #13#10 +
                     '  lw $t4, 0($t2)'                    + #13#10 +
                     '  add $4, $t3, $t4'                  + #13#10 +
                     '  jr $ra';
end;

procedure TForm1.Subtracao;
begin
  AlocaRegistradores(4);

  GCodigoAssembly := GCodigoAssembly + #13#10 + 'SUBT: ' + #13#10 +
                     '  lw $t3, 0($t1)'                    + #13#10 +
                     '  lw $t4, 0($t2)'                    + #13#10 +
                     '  sub $5, $t3, $t4'                  + #13#10 +
                     '  jr $ra';
end;

procedure TForm1.Multiplicacao;
begin
  AlocaRegistradores(5);

  GCodigoAssembly := GCodigoAssembly + #13#10 + 'MULT: ' + #13#10 +
                     '  lw $t3, 0($t1)'                    + #13#10 +
                     '  lw $t4, 0($t2)'                    + #13#10 +
                     '  mul $6, $t3, $t4'                  + #13#10 +
                     '  jr $ra';
end;

procedure TForm1.Divisao;
begin
  AlocaRegistradores(6);

  GCodigoAssembly := GCodigoAssembly + #13#10 + 'DIVI: ' + #13#10 +
                     '  lw $t3, 0($t1)'                    + #13#10 +
                     '  lw $t4, 0($t2)'                    + #13#10 +
                     '  div $7, $t3, $t4'                  + #13#10 +
                     '  jr $ra';
end;

procedure TForm1.RaizQuadrada;
begin
  AlocaRegistradores(7);

  GCodigoAssembly := GCodigoAssembly + #13#10 + 'SQRT: ' + #13#10 +
                     '  lw $t3, 0($t1)' + #13#10 +
                     '  lw $t4, 0($t2)' + #13#10 +
                     '  lw $a1, 0($t1)' + #13#10 +    // x = n
                     '  div $a2, $t3, $t4' + #13#10 + // n/2
                     '  j FORS' + #13#10 +
                     #13#10 +
                     'FORS' + #13#10 +
                     '  div $a3, $t3, a1' + #13#10 +  // n / x
                     '  add $a4, $a4, $a3' + #13#10 +  // x + (n / x)
                     '  div $a1, $a4, $t4' + #13#10 + // x + (n / x) / 2
                     '  addi $a5, $a5, 1' + #13#10 + // i ++
                     '  bne  $a5, $a2, FORS' + #13#10 +
                     '  jr $ra';
end;

procedure TForm1.Potencia;
begin
  AlocaRegistradores(8);

  GCodigoAssembly := GCodigoAssembly + #13#10 + 'POTE: ' + #13#10 +
                     '  lw $t3, 0($t1)' + #13#10 +
                     '  lw $t4, 0($t2)' + #13#10 +
                     '  j FORP' + #13#10 +
                     #13#10 +
                     'FORP' + #13#10 +
                     '  mul $a3, $t3, $t3' + #13#10 +  // x * x
                     '  addi $a1, $a1, 1' + #13#10 + // i ++
                     '  bne  $a1, $t4, FORP' + #13#10 +
                     '  jr $ra';
end;

procedure TForm1.FibonacciAssembly;
begin
  AlocaRegistradores(9);

  GCodigoAssembly := GCodigoAssembly + #13#10 + 'FIBO: ' + #13#10 +
                     '  lw $t3, 0($t1)' + #13#10 +
                     '  lw $a1, 0($t2)' + #13#10 +
                     '  beq $t3, $a1, RETURN_B' + #13#10 +
                     '  addi $t4, $t4, 1' + #13#10 +  // i = 1
                     '  addi $t5, $t5, 1' + #13#10 +  // b = 1
                     '  jal RETURN_A' + #13#10 +
                     #13#10 +
                     'RETURN_A' + #13#10 +
                     '  add $t6, $t4, $t5' + #13#10 + // c = a + b
                     '  move $t4, $t5' + #13#10 + // a = b
                     '  move $t5, $t6' + #13#10 + // b = c
                     '  bne $t4, $t3, RETURN_A' + #13#10 + // for i = 1 to pElemento - 1
                     '  move $v0, $t5' + #13#10 + // result := b
                     #13#10 +
                     'RETURN_B' + #13#10 + // if pElemento = 0 then result := 0;
                     '  jr $ra';
end;

function TForm1.fibonacci(pElemento: Integer): Integer;
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

procedure TForm1.AdicionarVariaveis(pNome: String; pPosicao: Integer; pElemento: TCalculo; pAdicionaPVAR: Boolean = True);
begin
  if pAdicionaPVAR then
  begin
    GCodigoAssembly := StringReplace(GCodigoAssembly, 'PVAR',
                       '  ' + pNome + pPosicao.ToString + '_' + pElemento.FirstValue.ToString +
                       ': .word 0x' + pElemento.FirstValue.ToString + #13#10 +
                       '  ' + pNome + pPosicao.ToString + '_' + pElemento.LastValue.ToString +
                       ': .word 0x' + pElemento.LastValue.ToString + #13#10 +
                       'PVAR', []);
  end
  else
  begin
    GCodigoAssembly := StringReplace(GCodigoAssembly, 'PVAR',
                       '  ' + pNome + pPosicao.ToString + '_' + pElemento.FirstValue.ToString +
                       ': .word 0x' + pElemento.FirstValue.ToString + #13#10 +
                       '  ' + pNome + pPosicao.ToString + '_' + pElemento.LastValue.ToString +
                       ': .word 0x' + pElemento.LastValue.ToString + #13#10, []);
  end;
end;

end.