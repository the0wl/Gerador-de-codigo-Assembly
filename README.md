<p align="center">
  <img width="256" height="256" src="/images/under_construction_PNG66.png?raw=true">
</p>

<h1>Calculadora-Assembly</h1>
Calculadora que a partir de uma fórmula em notação polonesa inversa gera o respectivo código do cálculo em assembly, que é guardado em um arquivo.

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

Requisitos da calculadora:
* Operações matemáticas básicas (Soma, subtraçao, multiplicação e divisão)
* Raiz quadrada
* Potênciação
* Fibonacci

<h2>Tipos de dados</h2>

<p>Abaixo os três registros criados para atender à necessidade da lógica elaborada:</p>
<b>TInteiro</b></br>
<code>TInteiro = record</code></br>
<code>Valor : Integer;</code></br>
<code>Pos   : Integer;</code></br>
<code>end;</code></br></br>

<p>Tipo de dado do vetor que armazena os valores que serão parametros para os cálculos.</p>
<b>TSinal</b></br>
<code>TSinal = record</code></code></br>
<code>Valor               : String;</code></br>
<code>UtilizaVetorCalculo : Boolean;</code></br>
<code>PossuiParenteses    : Boolean;</code></br>
<code>Pos                 : Integer;</code></br>
<code>end;</code></br></br>

<p>Tipo de dado do vetor que armazena as operações dos cálculos. Os valores <i>UtilizaVetorCalculo</i> e <i>PossuiParenteses</i> são usados para conseguir uma interpretação consisa da notação polonesa reversa.</p>
<b>TCalculo</b></br>
<code>TCalculo = record</code></br>
<code>PriValor : Integer;</code></br>
<code>SegValor : Integer;</code></br>
<code>Operacao : String;</code></br>
<code>Valor    : Integer;</code></br>
<code>Pos      : Integer;</code></br>
<code>end;</code></br></br>

<p>Tipo de dado do vetor que armazena os cálculos concluídos.</p>

<p>Aparencia inicial do programa</p>
<p align="center">
  <img src="/images/raw-project.png?raw=true">
</p>
