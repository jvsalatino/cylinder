# cylinder
Calcula la distribucion de perforaciones en un cilindro y genera el gcode para enviarlo a una maquina CNC

Parametros Todos las medidas en milimetros.

Diametro: diametro exterior del cilindro.

Largo   : Largo del cilindro.

Separacion Perimetro: Separacion de las perforaciones a lo largo del perimetro.

Separacion Largo: Separacion de las perforaciones a lo largo del cilindro.

Agujas: Largo de las agujas que sobresale del cilindro. Eventualmente se colocan agujas en las perforaciones, cuando eso sucede hay que tenrlo en cuenta para el calculo.

Pared: Grosor de la pered del cilindro.

Trasbolillo: es una forma de distribuir las perforaciones
             Consiste en intercalar una hilera de perforaciones alrededor del perimetro
             a la mitad de la distancia indicada por Separacion_Largo y desplazada
             una distancia equivalente  la mitad de Separacion_Perimetro
