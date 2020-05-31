# Relatório do EP2 de Laboratório de Métodos Numéricos 
    
Feito por:
**Davi de Menezes Pereira (NUSP: 11221988)**
**Lucas Paiolla Forastiere (NUSP: 11221911)**

## Decisões de projeto quanto à implementação dos métodos

No enunciado, tínhamos que as coordenadas em y cresciam para cima, enquanto que no Octave, temos que as coordenadas das linhs crescem para baixo. Assim sendo, nós tivemos que adaptar isso e sempre que nas fórmulas existia um y+1, tínhamos que fazer j-1.

Além disso, achamos conveniente, na descompressão, pegar, de cada quadrado (como definido no enunciado), o ponto inferior esquerdo para iterar. Assim sendo, iteramos pelos pontos de i = 2 até a altura e de j = 1 até a largura menos um.

Quanto às demais decisões de projeto, não foram muitas:
1. Nós decidimos que seria mais fácil criar uma função para cada tipo de descompressão;
2. Nós guardamos, na descompressão bicúbica, matrizes com as derivadas para não ter que calcular toda vez;
3. Nós salvamos as imagens usando `imwrite` e lemos usando `imread` e `iminfo`.

## Observações pedidas quanto aos experimentos

### O zoológico

Separamos as funções dessa etapa em três: zoo1, zoo2 e zoo3.

Zoo1 (função pedida no enunciado):

$
f(x, y) = (\sin(x), \frac{\sin(x)+\sin(y)}{2}, sin(x))
$

Zoo2:

$
f(x, y) = (\cos(x), \sin(x^2)^2+y, sin(x+y))
$

Zoo3 (escolhida para gerar uma imagem em "preto e branco"):

$f(x, y) = (\cos(x+y)x + \sin(y), \cos(x+y)x + \sin(y), \cos(x+y)x + \sin(y))$

### A selva

Obervamos que a imagem `quadrinho.png` possui mais erro no geral do que a imagem `Lenna.ppm`. Imaginamos que seja ou de fato por causa da cor, ou por causa de, como pegamos um quadrinho, existem muitas bordas acentuadas que vão do branco para o preto quase que instantaneamente. Ou seja, a imagem `quadrinho.png` é muito menos contínua, dando a entender que imagens desse tipo geram mais erros.

Quanto ao valor de $h$, percebemos que, em ambos os métodos bilinear e bicúbico, o $h$ para de fazer efeito no erro depois que $h$ cresce demais. Observamos que para $h=1000$ e $h=10000$, o erro praticamente não muda.

Entretanto, algo interesante de notar é que o erro nos dois tipos de método acabam não diminuindo para sempre junto com o $h$,acomo era de se esperar. Na verdade, existe um ponto em que o erro é menor entre $h=10$ e $h=100$ e depois disso, para $h>=1000$, vemos que o erro é, na verdade maior. 

## Exemplos ilustrativos dos resultados