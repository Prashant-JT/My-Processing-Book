# Visualizador de música
> Realizado por Prashant Jeswani Tejwani

Índice del contenido:

1. TOC
{:toc}

## Introducción
Se implementa el famoso juego *Flappy Bird* usando reconocimiento facial (mediante FaceOSC) para implementar los controles del juego. A continuación:

* Se describe el trabajo realizado argumentando las decisiones adoptadas para la solución propuesta
* Se incluye las referencias y herramientas utilizadas
* Se muestra el resultado con un gif animado

## Diseño 

El diseño ha sido el que se puede observar en la siguiente figura. El típico pájaro se ha representado como una pelota y los tubos verdes como líneas negras simulando paredes superiores e inferiores. El usuario es capaz de hacer click con el ratón o pestañear con los ojos para saltar y esquivar las paredes. En la parte inferior izquierda se muestra los puntos detectados de la cara del usuario con los datos crudos que proporciona FaceOSC y en la parte superior izquierda la puntuación actual.

![](/My-Processing-Book/images/music_visualizer.PNG "Diseño del programa en Processing")

## Código implementado

A continuación se describe el trabajo realizado. Se crean e inicializan las variables necesarias para el juego y los controles del usuario que se irán explicando a medida que se avance. En la función **setup()** se inicializa el pájaro y las paredes creando un objeto de la clase *Bird* y de la clase *Pillar* que se explicarán más adelante. También se establece la conexión por el puerto 8338 y se cargan los eventos que capturan los ojos de FaceOSC. 

    import oscP5.*;

    Bird bird = new Bird();
    Pillar[] pillars = new Pillar[3];
    boolean end = false;
    boolean intro = true;
    int score = 0;
    OscP5 oscP5;
    int found;
    float eyeLeftBefore, eyeRightBefore;
    float eyeLeft, eyeRight;
    float[] rawArray;

    void setup() {
      size(500, 600);
      frameRate(50);

      for (int i = 0; i < 3; i++) {
        pillars[i] = new Pillar(i);
      }

      oscP5 = new OscP5(this, 8338);
      oscP5.plug(this, "found", "/found");
      oscP5.plug(this, "eyeLeftReceived", "/gesture/eye/left");
      oscP5.plug(this, "eyeRightReceived", "/gesture/eye/right");
      oscP5.plug(this, "rawData", "/raw");

      rawArray = new float[132]; 
      eyeLeftBefore = -1;
      eyeRightBefore = -1;
    }

<br>En la función **draw()** se dibuja el rostro del usuario en la parte inferior izquierda mediante las funciones **drawFacePoints()** y **drawFacePolygons()**. A continuación, se detecta si el usuario ha pestañeado comparando la altura de los ojos restando una restando una tolerancia. Luego, se dibuja la pelota y se chequea si ha habido colisión mediante la función **checkCollisions()** de la clase *Bird*, se dibujan las paredes aleatoriamente con la función **drawPillar()**. 

    void draw() {
      background(0);

      if (found > 0) {
        pushMatrix();
        translate(60, height-100);
        scale(2);
        drawFacePoints(); 
        drawFacePolygons();
        popMatrix();

        if (eyeLeft < eyeLeftBefore - 0.8 && eyeRight < eyeRightBefore - 0.8) {
          if (end) {
            bird.jump();
            intro = false;
            if (!end) {
              reset();
            }
          }
        }
      }

      if (end) bird.move();
      bird.drawBird();
      if (end) bird.drag();
      bird.checkCollisions();

      for (int i = 0; i < 3; i++) {
        pillars[i].drawPillar();
        pillars[i].checkPosition();
      }

      fill(0);
      stroke(255);
      textSize(32);

      if (end) {
        rect(20, 20, 100, 50);
        fill(255);
        text(score, 30, 58);
      } else {
        help();
      }
    }
    
<br>Se llama a la función **help()** la cual imprime un lienzo de ayuda de los controles que dispone el usuario y para indicar las instrucciones para iniciar o reiniciar el juego.

    // User controls
    void help() {
      rect(110, 105, 300, 50);
      rect(160, 200, 200, 90);
      fill(255);

      if (intro) {
        text("Face Flappy bird", 140, 140);
        text("Click to Play", 175, 240);
        textFont(createFont("Georgia", 16));
        text("Click or blink eyes to jump", 166, 270);
        text("© Prashant Jeswani Tejwani", 10, height-10);
      } else {
        text("Game over", 180, 140);
        text("Score", 195, 240);
        text(score, 300, 240);
        textFont(createFont("Georgia", 16));
        text("Click to restart", 210, 270);
        textFont(createFont("Georgia", 16));
        text("© Prashant Jeswani Tejwani", 10, height-10);
      }
    }

<br>Alternativamente el usuario puede saltar haciendo click, esto se captura mediante la función **mousePressed()**. En el caso de que haya una colisión, se reestablece el juego llamando a la función **reset()**.

    void mousePressed() {
      bird.jump();
      intro = false;
      if (!end) {
        reset();
      }
    }
    
<br>

    void reset() {
      end = true;
      score = 0;
      bird.yPos = 300;
      for (int i = 0; i < 3; i++) {
        pillars[i].xPos += 550;
        pillars[i].crashed = false;
      }
    }

<br>La función **found()** es para la detección de la cara y las funciones **eyeLeftReceived(f)** y **eyeRightReceived(f)** se encargan de detectar el pestañeo del usuario. Para ello se compara la altura de los ojos anteriores con el actual menos una tolerancia que se ha establecido a 1,2.

    public void found (int i) {
      found = i;
    }

    public void eyeLeftReceived(float f) { 
      if (eyeLeftBefore == 6) eyeLeftBefore = f; 

      if (f < eyeLeftBefore - 1.2) {
        eyeLeftBefore = f;
      }

      if (eyeLeft > eyeLeftBefore) {
        eyeLeftBefore = eyeLeft;
      }

      eyeLeft = f;
    }

    public void eyeRightReceived(float f) {
      if (eyeRightBefore == -1) eyeRightBefore = f; 

      if (f < eyeLeftBefore - 1.2) {
        eyeLeftBefore = f;
      }

      if (eyeRight > eyeRightBefore) {
        eyeRightBefore = eyeRight;
      }

      eyeRight = f;
    }

<br>Para dibujar el rostro del usuario anteriormente comentado, se llaman a las tres siguientes funciones:

    void drawFacePoints() {
      int nData = rawArray.length;
      for (int val=0; val<nData; val+=2) {
        fill(255);
        ellipse(rawArray[val], rawArray[val+1], 3, 3);
      }
    }

    void drawFacePolygons() {
      fill(255);
      stroke(50); 

      // Face outline
      beginShape();
      for (int i=0; i<34; i+=2) {
        vertex(rawArray[i], rawArray[i+1]);
      }
      for (int i=52; i>32; i-=2) {
        vertex(rawArray[i], rawArray[i+1]);
      }
      endShape(CLOSE);

      // Eyes
      beginShape();
      for (int i=72; i<84; i+=2) {
        vertex(rawArray[i], rawArray[i+1]);
      }
      endShape(CLOSE);
      beginShape();
      for (int i=84; i<96; i+=2) {
        vertex(rawArray[i], rawArray[i+1]);
      }
      endShape(CLOSE);

      // Upper lip
      beginShape();
      for (int i=96; i<110; i+=2) {
        vertex(rawArray[i], rawArray[i+1]);
      }
      for (int i=124; i>118; i-=2) {
        vertex(rawArray[i], rawArray[i+1]);
      }
      endShape(CLOSE);

      // Lower lip
      beginShape();
      for (int i=108; i<120; i+=2) {
        vertex(rawArray[i], rawArray[i+1]);
      }
      vertex(rawArray[96], rawArray[97]);
      for (int i=130; i>124; i-=2) {
        vertex(rawArray[i], rawArray[i+1]);
      }
      endShape(CLOSE);

      // Nose bridge
      beginShape();
      for (int i=54; i<62; i+=2) {
        vertex(rawArray[i], rawArray[i+1]);
      }
      endShape();

      // Nose bottom
      beginShape();
      for (int i=62; i<72; i+=2) {
        vertex(rawArray[i], rawArray[i+1]);
      }
      endShape();
    }

    public void rawData(float[] raw) {
      rawArray = raw; 
    }
      
<br>La clase *Bird* es la encagada de representar la pelota y se han declarado como atributos de la clase las coordenadas y su velocidad en el eje Y.
      
    class Bird {
      float xPos, yPos, ySpeed;

      Bird() {
        xPos = 250;
        yPos = 400;
      }

<br> La función **drawBird()** dibuja la pelota y es la llamada en la función **draw()**:

    void drawBird() {
        stroke(255);
        noFill();
        strokeWeight(2);
        ellipse(xPos, yPos, 20, 20);
    }

<br> La siguientes funciones controlan la velocidad al saltar y al bajar de la pelota:

    void jump() {
      ySpeed = -10;
    }

    void drag() {
      ySpeed += 0.4;
    }
    
    void move() {
      yPos += ySpeed; 
      for (int i = 0; i < 3; i++) {
        pillars[i].xPos -= 3;
      }
    }

<br>Finalmente, la función **checkCollisions()** detecta cuando la pelota ha colisionado con alguna de las paredes:
  
    void checkCollisions() {
      if (yPos > 800) end = false;
      for (int i = 0; i < 3; i++) {
          if ((xPos < pillars[i].xPos + 10 && xPos > pillars[i].xPos - 10) && 
              (yPos < pillars[i].opening - 100||yPos > pillars[i].opening + 100)) {
              end = false;
          }
      }
    }

<br>La clase *Pillar* representa un pilar/pared como forma de obstáculo dibujadas como líneas verticales en la parte superior e inferior de la pantalla de juego. Para ello se declaran como atributos la posición X, el tamaño de apertura y una variable booleana.
    
    class Pillar {
      float xPos, opening;
      boolean crashed = false;

      Pillar(int i) {
        xPos = 100 + (i * 200);
        opening = random(200) + 100;
      }

<br>La función **show()** dibuja las paredes superiores e inferiores con una apertura aleatoria para que el usuario tenga la posibilidad de pasar:

    void drawPillar() {
      line(xPos, 0, xPos, opening - 100);  
      line(xPos, opening + 100, xPos, 800);
    }

<br>Finalmente, la siguiente función incrementa el contador de puntos cuando no ha habido una colisión:
    
    void checkPosition() {
      if (xPos < 0) {
        xPos += (200 * 3);
        opening = random(200) + 100;
        crashed = false;
      }
    
      if (xPos < 250 && !crashed) {
        crashed = true;
        score++;
      }
    }  
 
 ![](/My-Processing-Book/images/menu.PNG "Diseño del programa en Processing")
 
<br>A continuación, se muestra el resultado final mediante un gif animado: 

![](/My-Processing-Book/images/blink_flappy_bird/blink-flappy-bird-demo.gif  "Ejecución del código en Processing")

## Descargar código en Processing
Para la correcta ejecución en Processing, es necesario instalar la librería oscP5 (del autor Andreas Schlegel). Esto se puede hacer de la siguiente manera:

![](/My-Processing-Book/images/blink_flappy_bird/oscP5-lib.gif  "Instalación de la librería oscP5 en Processing")

{% include info.html text="Es necesario descargar FaceOSC para la ejecución el cual se puede obtener accediendo al siguiente enlace: https://github.com/kylemcdonald/ofxFaceTracker/releases (descargando FaceOSC-v1.11-win.zip). Debe estar en ejecución antes de iniciar el juego con todas sus casillas (en la parte superior izquierda) seleccionadas." %}
Para descargar el código en Processing, acceda a: <a href="https://downgit.github.io/#/home?url=https://github.com/Prashant-JT/My-Processing-Book/tree/master/projects/blink_flappy_bird">Descargar código en Processing</a> o acceda a la carpeta del repositorio del proyecto en: <a href="https://github.com/Prashant-JT/My-Processing-Book/tree/master/projects/blink_flappy_bird">Repositorio del proyecto</a>

---

## Referencias

[Guión de prácticas](https://ncvt-aep.ulpgc.es/cv/ulpgctp21/pluginfile.php/412240/mod_resource/content/37/CIU_Pr_cticas.pdf)

[Página de Processing](https://processing.org/examples/)

[Creación del enlace de descarga](https://downgit.github.io/#/home)

[Música sin copyright](https://pixabay.com/music/search/genre/beats)
