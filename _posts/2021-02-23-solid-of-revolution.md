> Realizado por Prashant Jeswani Tejwani

Índice del contenido:

1. TOC
{:toc}

## Introducción
Se implementa el juego *Pong* para dos jugadores. La propuesta realizada incluye: rebote, marcador, sonido, movimiento inicial aleatorio, entre otros. El objetivo de este proyecto es tener un primer contacto con Processing:

* Se describe el trabajo realizado argumentando las decisiones adoptadas para la solución propuesta
* Se incluye las referencias y herramientas utilizadas
* Se muestra el resultado con un gif animado
* Se implementa el código en p5.js con el fin de poder ejecutar y jugar en un navegador

## Diseño 

El diseño original del Pong es el que se puede observar en la siguiente figura. Un tablero color negro dividido en dos por una línea blanca central, dejando a cada lado una pala en forma vertical y su respectivo marcador en la zona inferior de cada campo de juego.

![](/My-Processing-Book/images/pong/pong-design.PNG "Diseño del juego en Processing")

## Código implementado

<p>A continuación se describe el trabajo realizado. Primeramente, se inicializan e importan las variables y librerías necesarias para el control y lógica del juego que se irán explicando a medida que se avance en la explicación del código:</p>

    import processing.sound.*;

    boolean start = false;
    boolean a, z, k, m;
    int posx1;
    int posy1;
    int posx2;
    int posy2;
    int score1 = 0;
    int score2 = 0;
    float ballposX;
    float ballposY;
    float angle;
    float movX;
    float movY;
    int diameter = 10;
    int showgoal = 0;
    SoundFile goal;
    SoundFile tock;
    SoundFile whistle;

<br>En la función **setup()** se establece el tamaño de la ventana a 800x500 píxeles, se inicializan las posiciones de las palas de ambos jugadores, la posición de la pelota y se cargan los sonidos que se han utilizado para el proyecto:

    void setup() {
      size(800, 500);
      posx1 = 5;
      posy1 = height/2 - 30;
      posx2 = width-15;
      posy2 = height/2 - 30;
      reset();
      textFont(createFont("Georgia", 20));
      textAlign(CENTER, CENTER);
      goal = new SoundFile(this, "data/goal.mp3");
      tock = new SoundFile(this, "data/tock.mp3");
      whistle = new SoundFile(this, "data/whistle.mp3");
    }

<br>En la función **reset()** se resetean las posición de la pelota, además se decide aleatoriamente la dirección a la que irá dirigida cuando comience la ronda del juego, así como en el ángulo al cual apuntará.
Para calcular el ángulo en el cual la pelota se lanzará, se utiliza la funión **random()** pasando como parámetros -pi/4 y pi/4. A continuación, se establece la velocidad del eje X a 3 (la velocidad irá aumentado cada vez que rebote contra una pala, que se explicará más adelante) y se calcula el del eje Y como *5 * sin(ángulo)*. Para el saque central, se vuelve a utilizar la función random(), al cual se pasa como parámetro un 1. Esto devolverá un valor aleatorio entre 0-1, si el valor es menor que 0.5 la pelota rodará hacia la izquierda, sino, hacia la derecha. 

    void reset() {
      // Reset positions variables
      ballposX = width/2;
      ballposY = height/2 - 20;
      angle = random(-PI/4, PI/4);
      movX = 3;
      movY = 5 * sin(angle);  

      // Left or right
      if (random(1) < 0.5) {
        movX = -movX;
      }
    }

<br>La función **draw()** se ejecuta por defecto de forma continua con una frecuencia de 60 llamadas por segundo. Se ha añadido al juego la funcionalidad de poder pausar o reanudar el juego al hacer click sobre la ventana. Para ello se ha hecho uso de una variable booleana *start* la cual indicará si el juego está en ejecución o en pausa. Por defecto, el juego estará en pausa, mostrando un mensaje textual e informará que al hacer click se podrá iniciar o pausar la partida y mostrará los controles de ambos jugadores para su movimiento de pala. Cuando el usuario desee comenzar a jugar, la variable *start* se establecerá a *true* y el juego comenzará hasta la siguiente pausa. 

Para que el código sea más legible y fácil de entender, se han implementado distintas funciones que realizarán una serie de acciones con el fin de que el juego se ejecute correctamente. 

    void draw() {
      if (start) {
        startGame();
        updateBall();
        move();
        checkCollision();
        checkGoal();
        updateScores();
      }else{
        textFont(createFont("Georgia", 40));
        fill(255);
        background(0);
        text("Click to start or pause game", width/2, height/2 - 30);
        textFont(createFont("Georgia", 16));
        text("-----------------------", width/2, height/2 + 20);
        text("Controls for players", width/2, height/2 + 35);
        text("-----------------------", width/2, height/2 + 50);
        text("Player 1 - A to move up | Z to move down", width/2, height/2 + 75);
        text("Player 2 - K to move up | M to move down", width/2, height/2 + 105);
        text("To restart scores, press r", width/2, height/2 + 135);
        text("© Prashant Jeswani Tejwani", width/2, height - 20);
      }
    }
    
<br>En el momento el cual el usuario decide empezar o reanudar el juego, se ejecutará la función **startGame()** el cual establecerá los colores de fondo utilizando las funciones **background()**, **fill()**. Se dibuja una línea en el centro con la función **line(x,y,h)** con el fin de diferenciar ambos lados de los jugadores y establecer un centro del campo. Para dibujar las palas de ambos jugadores se hace uso de la función **rect(x,y,w,h)** al cual se le pasa como parámetros las coordenadas (x, y), anchura y altura del rectángulo. 

    void startGame() {
      background(10);
      fill(255);
      line(width/2, 0, width/2, height);
      stroke(126);

      // Players bat
      rect(posx1, posy1, 10, 55); // Player 1
      rect(posx2, posy2, 10, 55); // Player 2
    }

<br>A continuación en la función **updateBall()** se dibuja la pelota mediante la función de **ellipse(x,y,w,h)** pasándole las coordenadas, ancho y alto (en este caso el ancho y el alto es igual, aunque también se podría haber hecho uso de la función **circle(x,y,r)**) y se establecen las velocidades en el cual cirulará la pelota. Además, se contrala los casos en el cual la pelota impacta contra las paredes superiores e inferiores, cuando esto ocurre, simplemente se cambia el signo del eje Y para que haya el efecto rebote. Cabe destacar que cada vez que la pelota rebote en alguna de las paredes (o en las palas como veremos más adelante), se reproduce un sonido. Este sonido se ejecuta lanzando un hilo mediante la función **thread()** (el cual llama la función **tock()**) ya que puede presentarse efectos extraños durante la reproducción de sonido dependiendo de su duración.

    void updateBall() {
      ellipse(ballposX, ballposY, diameter, diameter);
      ballposX += movX;
      ballposY += movY;

      // Lower and upper wall
      if (ballposY+(diameter/2) >= height - 25 || ballposY-(diameter/2) <= 0) {
        movY = -movY;
        thread("tock");
      }
    }

<br>Para el movimiento de los jugadores puedan ser simultáneos, se han tenido que crear las variables booleanas *a, z, k, m*, las cuales indicarán cuándo una tecla ha sido pulsada y cuando se ha dejado de pulsar. Dependiendo de qué tecla se ha pulsado la respectiva pala se moverá. Más adelante, veremos las inicializaciones de estas variables ya que serán modificadas en los eventos **keyPressed()** y **keyReleased()**.

    // Move players
    void move() {
      if (z) { // Player 1 down
        if (posy1 < height-89) {
          posy1 += 10;
        }
      }

      if (a) { 
        if (posy1 > 5) { // Player 1 up
          posy1 -= 10;
        }
      }

      if (k) { // Player 2 up
        if (posy2 > 5) {
          posy2 -= 10;
        }
      }

      if (m) {
        if (posy2 < height-89) { // Player 2 down
          posy2 += 10;
        }
      }
    }

<br>La función **checkCollision()** se encarga de detectar si la pelota ha colisionado con la pala de alguno de los jugadores. Si es así, se invierte la dirección de la cooredenada X de la pelota, la velocidad de la pelota aumenta y se reproduce el sonido de rebote, tanto para el jugador 1 como para el jugador 2.

    void checkCollision() {
      // Collision with player 1
      if (movX < 0 && ballposX-10 <= posx1+10 && ballposY >= posy1 && ballposY <= posy1+55) {
        movX--; // Speed up ball velocity
        movX = -movX;
        thread("tock");
      }

      // Collision with player 2
      if (movX > 0 && ballposX+10 >= posx2 && ballposY >= posy2 && ballposY <= posy2+55) {
        movX++; // Speed up ball velocity
        movX = -movX;
        thread("tock");
      }
    }
   
<br>La función **checkGoal()** chequea si la pelota a sobrepasado la posición de algunas de las palas de los jugadores, es decir, si ha habido un gol. Si hay un gol, se aumenta el contador del jugador que ha marcado, se muestra un texto ("GOOOAAAL !") y se reproduce un sonido de gol. Finalmente, se reestablecen las coordenadas de la pelota llamando la función **reset()**.

    void checkGoal() {
      if (ballposX >= width) {
        score1++; // Player 1 scores
        showgoal = 100;
        thread("goal");
      } else if (ballposX <= 0) {
        score2++; // Player 2 scores
        showgoal = 100;
        thread("goal");
      }

      // Show goal message
      if (showgoal > 0) {
        textFont(createFont("Georgia", 40));
        text("GOOOAAAL !", width/2, height/2 - 30);
        textFont(createFont("Georgia", 20));
        showgoal--;
        reset();
      }
    }

<br>La función **updateScores()** tiene como único objetivo mostrar y actualizar el marcador. Para ello se dibuja un rectángulo con el número de puntos de cada jugador en sus respectivos lados del campo. 

    void updateScores() {
      rect(0, height-25, width, height-25);
      fill(0);
      text("Scoreboard", width/2, height-16);
      text(str(score1), 20, height-16); // Player 1 score
      text(str(score2), width-20, height-16); // Player 2 score
    }

![](/My-Processing-Book/images/pong/scoreboard.PNG "Marcador de puntos")
 
<br>Se ha añadido otra funcionalidad la cual si el usuario desea reiniciar el marcador puiede pulsar la tecla *r* y los marcadores se pondrán a cero, reestableciendo la posición de la pelota al centro del campo mediante la función **reset()**. 

    void restartScores() {
      score1 = 0;
      score2 = 0;
      reset();
    }

<br>El evento **mouseClicked()** es el encargado de reanudar o pausar el juego, modificando la variable *start* comentada anteriormente. También se reproduce un sonido de pito para indicar que se reanuda o pausa el juego.

    void mouseClicked() {
      if (start) {
        // Resume game
        thread("whistle");
        start = false;
      }else{
        // Pause game
        thread("whistle");    
        start = true;
      }
    }

El menú del juego al pausar queda de la siguiente manera:

![](/My-Processing-Book/images/pong/pause-game.PNG "Juego en pausa en Processing")

<br>El evento **keyPressed()** es el encargado de detectar los movimientos de las palas de los jugadores y actualizar la coordenada Y de las mismas. Los controles que se han establecido son los siguientes:

Jugador 1: A para mover la pala arriba y Z para mover la pala abajo.

Jugador 2: K para mover la pala arriba y M para mover la pala abajo.

    // Detect key released
    void keyReleased() {
      if (key == 'z') z = false;
      if (key == 'a') a = false;
      if (key == 'k') k = false;
      if (key == 'm') m = false;
    }

    // Detect pressed keys
    void keyPressed() {
      if (keyPressed) {
        if (key == 'z') z = true;
        if (key == 'a') a = true;
        if (key == 'k') k = true;
        if (key == 'm') m = true;
        if (key == 'r') restartScores();
      }
    }
    
<br>Finalmente las siguientes funciones son las que se llaman para que se reproduzcan los sonidos:

    void whistle() {
      whistle.play();
    }

    void goal() {
      goal.play();
    }

    void tock() {
      tock.play();
    }
    
<br>A continuación, se muestra el resultado final del proyecto con un gif animado: 

![](/My-Processing-Book/images/pong/gif-demo.gif "Ejecución del código en Processing")


Para descargar el código en Processing, puede acceder al enlace del repositorio y descargar la carpeta del proyecto: <a href="https://github.com/Prashant-JT/My-Processing-Book/tree/master/projects/solid-of-revolution">Ver el código en Processing</a>

---


## Ver demo 

Se ha implementado el código a p5.js con el fin de poder jugar en un navegador. Para ello se han tenido que modificar algunos aspectos como el tamaño de letra, entre otros:
{% include info.html text="Para jugar debe abrir el enlace en un navegador. No se podrá jugar en dispositivos móviles" %}

| **Ver demo** | <a href="#">Dale click para ver demo</a> |

## Referencias

[Página de Processing](https://processing.org/examples/)

[Efectos de sonido](https://www.videvo.net/es/efectos-de-sonido/)

[Guión de prácticas](https://ncvt-aep.ulpgc.es/cv/ulpgctp21/pluginfile.php/412240/mod_resource/content/37/CIU_Pr_cticas.pdf)
