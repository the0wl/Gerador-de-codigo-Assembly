<p align="center">
  <img width="256" height="256" src="/images/under_construction_PNG66.png?raw=true">
</p>

# Calculadora-Assembly
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

<p>Aparencia inicial do programa</p>
<p align="center">
  <img src="/images/raw-project.png?raw=true">
</p>

# Método de organização
 A expressão a ser calculada se encontra dentro de um campo de texto, logo a informação é recebida em formato texto. Deste modo, o texto precisou ser analisado caracter por caracter. Após isso, para conseguir realizar os cálculos em ordem foram criados três vetores: <b><i>wVetInteger</i></b> que armazena valores inteiros, ou seja, os parametros de cada cálculo; <b><i>wVetSinais</i></b> que armazena as expressões aritméticas que serão efetuadas; <b><i>wVetCalculos</i></b> que armazena os resultados de cada conta intermediária para chegar no resultado final. Abaixo segue o registro criado para os dados de cada vetor:
 
<p><b>TInteiro</b> = record</p>
<p>Value : Integer;</p>
<p>Pos   : Integer;</p>
<p>end;</p>
<p><b>TSinal</b> = record</p>
<p>Value : String;</p>
<p>PossuiParenteses: Boolean;</p>
<p>Pos   : Integer</p>
<p>end;</p>
<p><b>TCalculo</b> = record
<p>FirstValue : Integer;</p>
<p>LastValue  : Integer;</p>
<p>Operation  : String;</p>
<p>Value      : Integer;</p>
<p>Pos        : Integer;</p>
<p>end;</p>
 
