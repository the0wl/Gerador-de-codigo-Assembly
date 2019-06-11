<h1 align="center">Calculadora em Delphi 10.2 para a geração de código Assembly</h1>

<p align="center">
  <img src="/images/raw-project.png?raw=true">
</p>

<h2>Resumo</h2>
Calculadora desenvolvida na linguagem de programação Delphi na versão 10.2 (Berlin) com o objetivo de conseguir extrair a lógica necessária para um cálculo a partir de uma fórmula em notação polonesa inversa. Com isso pretende-se gerar o código correspondente no formato MIPS assembly, que será rodado no software MARS para validação do código e dos resultados.

<h2>Objetivos</h2>
<p>Realizar operações matemáticas básicas (Soma, subtraçao, multiplicação e divisão), além de outras especificações enunciadas no trabalho como: raiz quadrada, potênciação e fibonacci.</p>
<p>Construir uma interface em FMX (FireMonkey).</p>

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

<h2>Tipos de dados</h2>

Abaixo os três registros criados para atender à necessidade da lógica elaborada:

<b>TInteiro</b></br>
Tipo de dado do vetor que armazena os valores que serão parametros para os cálculos.
```
TInteiro = record
Valor : Integer;
Pos   : Integer;
end;
```
</br>

<b>TSinal</b></br>
Tipo de dado do vetor que armazena as operações dos cálculos. Os valores <i>UtilizaVetorCalculo</i> e <i>PossuiParenteses</i> são usados para conseguir uma interpretação consisa da notação polonesa reversa.
```
TSinal = record
  Valor               : String;
  UtilizaVetorCalculo : Boolean;
  PossuiParenteses    : Boolean;
  Pos                 : Integer;
end;</code>
```
</br>

<b>TCalculo</b></br>
Tipo de dado do vetor que armazena os cálculos concluídos.
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

<h2>Metodologia</h2>
Utilizando a propriedade <b>Text</b> do componente visual <b>TEdit</b> que retorna uma <i>String</i> (lembrando que uma string é apenas um vetor de <i>char</i>), foi realizada a retirada dos espaços nulos e foram lidos os caracteres alfanuméricos digitados um a um.
