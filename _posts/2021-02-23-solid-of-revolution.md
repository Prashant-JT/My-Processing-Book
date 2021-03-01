# Sólido de revolución
> Realizado por Prashant Jeswani Tejwani

Índice del contenido:

1. TOC
{:toc}

## Introducción
Se implementa un prototipo que recoge puntos de un perfil del sólido de revolución al hacer clic con el ratón sobre la pantalla. Dicho perfil será utilizado por el prototipo para crear un objeto tridimensional por medio de una superficie de revolución, almacenando la geometría resultante en una variable de tipoPShape. A continuación:

* Se describe el trabajo realizado argumentando las decisiones adoptadas para la solución propuesta
* Se incluye las referencias y herramientas utilizadas
* Se muestra el resultado con un gif animado
* Se implementa el código en p5.js con el fin de poder ejecutarse en un navegador

## Diseño 

El diseño original del Pong es el que se puede observar en la siguiente figura. Un tablero color negro dividido en dos por una línea blanca central, dejando a cada lado una pala en forma vertical y su respectivo marcador en la zona inferior de cada campo de juego.

![](/My-Processing-Book/images/solid_of_revolution/solid_of_revolution.PNG "Diseño del programa en Processing")

## Código implementado

<p>A continuación se describe el trabajo realizado. Primeramente, se inicializan e importan las variables y librerías necesarias para el control y lógica del juego que se irán explicando a medida que se avance en la explicación del código:</p>

    PShape figure;
    PShape figureSolid;
    ArrayList <PVector> points;
    boolean drawFigure;

    void setup() {
      size(800, 700, P3D);
      background(0);
      fill(255);
      stroke(255);
      strokeWeight(3);
      drawFigure = false;
      points = new ArrayList<PVector>();
    }

<br>En la función **setup()** se establece el tamaño de la ventana a 800x500 píxeles, se inicializan las posiciones de las palas de ambos jugadores, la posición de la pelota y se cargan los sonidos que se han utilizado para el proyecto:

    void draw() {
      background(0);
      // Center line
      line(width/2, 0, width/2, height);
      controlsMessage();

      if (drawFigure) {
        // [minY, maxY]
        float[] minMaxY = minMaxY();
        // Place mouse in the center of the figure
        translate(mouseX, mouseY - (minMaxY[0] - (minMaxY[0] - minMaxY[1])/2));
        shape(figureSolid);
      }else if (!points.isEmpty()) {
        line((points.get(points.size()-1).x), (points.get(points.size()-1).y), mouseX, mouseY);
        ellipse((points.get(points.size()-1).x), (points.get(points.size()-1).y), 5, 5);
        // Draw current edges
        if (points.size() > 1) {
          for (int i = 0; i < points.size()-1; i++) {
            line(points.get(i).x, points.get(i).y, points.get(i+1).x, points.get(i+1).y);
            ellipse((points.get(i).x), (points.get(i).y), 5, 5);
          }
        }
      }
    }

<br>La función **draw()** se ejecuta por defecto de forma continua con una frecuencia de 60 llamadas por segundo. Se ha añadido al juego la funcionalidad de poder pausar o reanudar el juego al hacer click sobre la ventana. Para ello se ha hecho uso de una variable booleana *start* la cual indicará si el juego está en ejecución o en pausa. Por defecto, el juego estará en pausa, mostrando un mensaje textual e informará que al hacer click se podrá iniciar o pausar la partida y mostrará los controles de ambos jugadores para su movimiento de pala. Cuando el usuario desee comenzar a jugar, la variable *start* se establecerá a *true* y el juego comenzará hasta la siguiente pausa. 

Para que el código sea más legible y fácil de entender, se han implementado distintas funciones que realizarán una serie de acciones con el fin de que el juego se ejecute correctamente. 

    // Create figure
    void drawFigure() {
      ArrayList <ArrayList> solid = new ArrayList<ArrayList>();
      figureSolid = createShape(GROUP);
      figure = createShape();
      figure.beginShape(LINES);

      // Translate points
      for (PVector point : points) {
        ArrayList <PVector> pointTranslated = new ArrayList<PVector>();
        for (int i = 0; i < 360; i++) {
          pointTranslated.add(translatePoints(point, radians(i)));
        }
        solid.add(pointTranslated);
      }

      // Close shape and add to final figure
      figure.endShape(CLOSE);
      figureSolid.addChild(figure);

      // Create solid of revolution
      drawSolidRevolution(solid);
    }

    PVector translatePoints(PVector point, float theta) { 
      // x2 = x1 * cos0 - y1 * sen0
      float x2 = (point.x - width/2) * cos(theta) - point.z * sin(theta);
      // y2 = y1
      float y2 = point.y;
      // z2 = x1 * sen0 + z1 * cos0
      float z2 = (point.x - width/2) * sin(theta) + point.z * cos(theta);
      figure.vertex(x2, y2, z2);
      return new PVector(x2, y2, z2);
    }

<br>En el momento el cual el usuario decide empezar o reanudar el juego, se ejecutará la función **startGame()** el cual establecerá los colores de fondo utilizando las funciones **background()**, **fill()**. Se dibuja una línea en el centro con la función **line(x,y,h)** con el fin de diferenciar ambos lados de los jugadores y establecer un centro del campo. Para dibujar las palas de ambos jugadores se hace uso de la función **rect(x,y,w,h)** al cual se le pasa como parámetros las coordenadas (x, y), anchura y altura del rectángulo. 

    // Create solid of revolution
    void drawSolidRevolution(ArrayList solid) {
      fill(0);
      for (int i = 1; i < solid.size(); i++) {
        ArrayList <PVector> currentPoint = (ArrayList) solid.get(i);
        ArrayList <PVector> previousPoint = (ArrayList) solid.get(i-1);
        for (int j = 11; j < 360; j = j+10) {
           PShape t = createShape();
           t.beginShape(TRIANGLES);
           t.vertex(currentPoint.get(j).x, currentPoint.get(j).y, currentPoint.get(j).z);
           t.vertex(previousPoint.get(j).x, previousPoint.get(j).y, previousPoint.get(j).z);
           t.vertex(currentPoint.get(j-9).x, currentPoint.get(j-9).y, currentPoint.get(j-9).z);
           t.endShape(CLOSE);

           figureSolid.addChild(t);
        }
      }
    }
    
<br>En el momento el cual el usuario decide empezar o reanudar el juego, se ejecutará la función **startGame()** el cual establecerá los colores de fondo utilizando las funciones **background()**, **fill()**. Se dibuja una línea en el centro con la función **line(x,y,h)** con el fin de diferenciar ambos lados de los jugadores y establecer un centro del campo. Para dibujar las palas de ambos jugadores se hace uso de la función **rect(x,y,w,h)** al cual se le pasa como parámetros las coordenadas (x, y), anchura y altura del rectángulo. 

    float[] minMaxY() {
      float maxY = 0;
      float minY = 0;
      for (PVector point : points) {
        if (point.y > maxY) maxY = point.y;
        if (point.y < minY) minY = point.y;
      }
      return new float[] {minY, maxY};
    }

<br>A continuación en la función **updateBall()** se dibuja la pelota mediante la función de **ellipse(x,y,w,h)** pasándole las coordenadas, ancho y alto (en este caso el ancho y el alto es igual, aunque también se podría haber hecho uso de la función **circle(x,y,r)**) y se establecen las velocidades en el cual cirulará la pelota. Además, se contrala los casos en el cual la pelota impacta contra las paredes superiores e inferiores, cuando esto ocurre, simplemente se cambia el signo del eje Y para que haya el efecto rebote. Cabe destacar que cada vez que la pelota rebote en alguna de las paredes (o en las palas como veremos más adelante), se reproduce un sonido. Este sonido se ejecuta lanzando un hilo mediante la función **thread()** (el cual llama la función **tock()**) ya que puede presentarse efectos extraños durante la reproducción de sonido dependiendo de su duración.

    // Clear all points of the figure
    void clearPoints() {
      points.clear();
    }

<br>Para el movimiento de los jugadores puedan ser simultáneos, se han tenido que crear las variables booleanas *a, z, k, m*, las cuales indicarán cuándo una tecla ha sido pulsada y cuando se ha dejado de pulsar. Dependiendo de qué tecla se ha pulsado la respectiva pala se moverá. Más adelante, veremos las inicializaciones de estas variables ya que serán modificadas en los eventos **keyPressed()** y **keyReleased()**.

    void controlsMessage() {
      fill(255);
      textFont(createFont("Georgia", 12));
      text("Draw vertexes on the right side of the centered line", 10, height - 140);
      text("Right click to create new vertex", 10, height - 120);
      text("Press 'x' to delete last vertex", 10, height - 80);
      text("Press 'd' to draw solid of revolution", 10, height - 60);
      text("Press 'c' to clear screen", 10, height - 100);
      text("© Prashant Jeswani Tejwani", 10, height - 20);
    }

<br>La función **checkCollision()** se encarga de detectar si la pelota ha colisionado con la pala de alguno de los jugadores. Si es así, se invierte la dirección de la cooredenada X de la pelota, la velocidad de la pelota aumenta y se reproduce el sonido de rebote, tanto para el jugador 1 como para el jugador 2.

    // Detect when user clicks to create a new vertex
    void mousePressed() {
      if (mouseX >= width/2 && !drawFigure) {
        points.add(new PVector(mouseX, mouseY));
      }
    }
   
<br>La función **checkGoal()** chequea si la pelota a sobrepasado la posición de algunas de las palas de los jugadores, es decir, si ha habido un gol. Si hay un gol, se aumenta el contador del jugador que ha marcado, se muestra un texto ("GOOOAAAL !") y se reproduce un sonido de gol. Finalmente, se reestablecen las coordenadas de la pelota llamando la función **reset()**.

    // Detect controls
    void keyPressed() {
      if (key == 'c') {
        // Clear screen
        drawFigure = false;
        clearPoints();
      }else if(key == 'x' && points.size() > 0 && !drawFigure) {
        // Remove last vertex
        points.remove(points.get(points.size()-1));
      }else if (key == 'd' && points.size() > 2) {
        // Draw last vertex
        line((points.get(points.size()-1).x), (points.get(points.size()-1).y), points.get(0).x, points.get(0).y);
        drawFigure = true;
        drawFigure();
      }
    }

<br>El evento **keyPressed()** es el encargado de detectar los movimientos de las palas de los jugadores y actualizar la coordenada Y de las mismas. Los controles que se han establecido son los siguientes:
    
<br>A continuación, se muestra el resultado final del proyecto con un gif animado: 

![](/My-Processing-Book/images/solid_of_revolution/solid-of-revolution-demo.gif  "Ejecución del código en Processing")

## Descargar código en Processing 
Para descargar el código en Processing, acceda a: <a href="https://downgit.github.io/#/home?url=https://github.com/Prashant-JT/My-Processing-Book/blob/master/projects/solid_of_revolution/solid_of_revolution.pde">Descargar código en Processing</a> o acceda a la carpeta del repositorio del proyecto en: <a href="https://github.com/Prashant-JT/My-Processing-Book/tree/master/projects/solid_of_revolution">Repositorio del proyecto</a>

---


## Ver demo 

Se ha implementado el código a p5.js con el fin de poder probarlo en un navegador. Para ello se han tenido que modificar algunos aspectos como el tamaño de letra, tipos de variables, entre otros:
{% include info.html text="Para probarlo debe abrir el enlace en un navegador. No se podrá jugar en dispositivos móviles" %}

| **Ver demo** | <a href="https://editor.p5js.org/Prashant-JT/full/XKp-ISITk">Dale click para ver demo</a> |

## Referencias

[Guión de prácticas](https://ncvt-aep.ulpgc.es/cv/ulpgctp21/pluginfile.php/412240/mod_resource/content/37/CIU_Pr_cticas.pdf)

[Página de Processing](https://processing.org/examples/)

[Creación del enlace de descarga](https://downgit.github.io/#/home)
