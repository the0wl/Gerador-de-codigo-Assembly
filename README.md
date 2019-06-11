<p>
  Kelvin Isael Seibt
</p>
<h1>Calculadora em Delphi 10.2 para a geração de código Assembly</h1>

<h2>Resumo</h2>
Calculadora desenvolvida na linguagem de programação Delphi na versão 10.2 (Berlin) com o objetivo de conseguir extrair a lógica necessária para um cálculo a partir de uma fórmula em notação polonesa inversa. Com isso pretende-se gerar o código correspondente no formato MIPS assembly, que será rodado no software MARS para validação do código e dos resultados.

<h2>Notação polonesa inversa</h2>
<table>
    <tr>
        <td>Operação</td>
        <td>Notação convencional</td>
        <td>Notação Polonesa</td>
        <td>Notação Polonesa Inversa</td>
    </tr>
    <tr>
        <td><b>a+b</b></td>
        <td>a+b</td>
        <td>+ a b</td>
        <td>a b +</td>
    </tr>
    <tr>
        <td><b>(a+b)/c</b></td>
        <td>(a+b)/c</td>
        <td>/ + a b</td>
        <td>a b + /</td>
    </tr>
</table>

<h2>Requisitos da calculadora</h2>
  Realizar operações matemáticas básicas (Soma, subtraçao, multiplicação e divisão), além de outras especificações enunciadas no trabalho como: raiz quadrada, potênciação e fibonacci.

<h2>Tipos de dados</h2>

<p>Abaixo os três registros criados para atender à necessidade da lógica elaborada:</p>

<b>TInteiro</b></br>
```
TInteiro = record
Valor : Integer;
Pos   : Integer;
end;
```
</br>

<p>Tipo de dado do vetor que armazena os valores que serão parametros para os cálculos.</p>

<b>TSinal</b></br>
```
TSinal = record
  Valor               : String;
  UtilizaVetorCalculo : Boolean;
  PossuiParenteses    : Boolean;
  Pos                 : Integer;
end;</code>
```
</br>

<p>Tipo de dado do vetor que armazena as operações dos cálculos. Os valores <i>UtilizaVetorCalculo</i> e <i>PossuiParenteses</i> são usados para conseguir uma interpretação consisa da notação polonesa reversa.</p>

<b>TCalculo</b></br>
```
TCalculo = record
  PriValor : Integer;
  SegValor : Integer;
  Operacao : String;
  Valor    : Integer;
  Pos      : Integer;
end;
```
</br>

<p>Tipo de dado do vetor que armazena os cálculos concluídos.</p>

<h2>Aparencia inicial do programa</h2>
<p align="center">
  <img src="/images/raw-project.png?raw=true">
</p>
