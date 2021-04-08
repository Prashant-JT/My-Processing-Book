# Visualizador de música
> Realizado por Prashant Jeswani Tejwani

Índice del contenido:

1. TOC
{:toc}

## Introducción
Se implementa un visualizador de música utilizando la librería *Sound* usando los objetos *FFT* y *Amplitude*, con el objetivo de analizar la canción para su visualización. A continuación:

* Se describe el trabajo realizado argumentando las decisiones adoptadas para la solución propuesta
* Se incluye las referencias y herramientas utilizadas
* Se muestra el resultado con un gif animado

## Diseño 

El diseño ha sido el que se puede observar en la siguiente figura. El típico pájaro se ha representado como una pelota y los tubos verdes como líneas negras simulando paredes superiores e inferiores. El usuario es capaz de hacer click con el ratón o pestañear con los ojos para saltar y esquivar las paredes. En la parte inferior izquierda se muestra los puntos detectados de la cara del usuario con los datos crudos que proporciona FaceOSC y en la parte superior izquierda la puntuación actual.

![](/My-Processing-Book/images/music_visualizer/music_visualizer.PNG "Diseño del programa en Processing")

## Código implementado

A continuación se describe el trabajo realizado. Se crean e inicializan las variables necesarias para el juego y los controles del usuario que se irán explicando a medida que se avance. En la función **setup()** se inicializa el pájaro y las paredes creando un objeto de la clase *Bird* y de la clase *Pillar* que se explicarán más adelante. También se establece la conexión por el puerto 8338 y se cargan los eventos que capturan los ojos de FaceOSC. 

    import processing.sound.*;

    SoundFile song;
    PImage background;
    ArrayList<Particle> particles = new ArrayList<Particle>();
    boolean menu;
    FFT fft;
    Amplitude level;
    Amplitude amp;
    float amplitude;

<br>En la función **draw()** se dibuja el rostro del usuario en la parte inferior izquierda mediante las funciones **drawFacePoints()** y **drawFacePolygons()**. A continuación, se detecta si el usuario ha pestañeado comparando la altura de los ojos restando una restando una tolerancia. Luego, se dibuja la pelota y se chequea si ha habido colisión mediante la función **checkCollisions()** de la clase *Bird*, se dibujan las paredes aleatoriamente con la función **drawPillar()**. 

    void setup() {
      size(900, 600);
      song = new SoundFile(this, "sample.mp3");
      background = loadImage("background.jpg");
      menu = true;
      imageMode(CENTER);
      rectMode(CENTER);
      fft = new FFT(this);
      level = new Amplitude(this);
      fft.input(song);
      level.input(song);
    }
    
<br>Se llama a la función **help()** la cual imprime un lienzo de ayuda de los controles que dispone el usuario y para indicar las instrucciones para iniciar o reiniciar el juego.

    void draw() {
      background(0);
      translate(width/2, height/2);
      if (menu) {
        menu();
      } else {
        // Shake image depending on amplitude
        amplitude = level.analyze();
        //pushMatrix();
        if (amplitude > 0.8) rotate(random(-0.003, 0.003));
        image(background, 0, 0, width + 100, height + 100);
        //popMatrix();

        // Transparency depending on amplitude
        float alpha = map(amplitude*100, 0, 255, 180, 150);
        fill(0, alpha);
        noStroke();
        rect(0, 0, width, height);

        stroke(255);
        strokeWeight(3);
        noFill();

        createCircle();
        createParticles();

        fill(255);
        text("Press 'h' to show menu", (width/2) - 180, (height/2) - 10);
      }

      fill(255);
      text("© Prashant Jeswani Tejwani", -(width/2) + 10, (height/2) - 10);
    }

<br>Alternativamente el usuario puede saltar haciendo click, esto se captura mediante la función **mousePressed()**. En el caso de que haya una colisión, se reestablece el juego llamando a la función **reset()**.

    // Main menu
    void menu() {
      noFill();
      stroke(255);
      rect(0, -155, 300, 80);
      fill(255);

      textFont(createFont("Georgia", 20));
      text("Music visualizer", -70, -150);
      textFont(createFont("Georgia", 16));
      text("The song called 'sample.mp3' will be played and visualized", -220, 0);
      text("Click to play/pause song", -85, 30);
      text("Press 'h' to hide menu", (width/2) - 180, (height/2) - 10);
    }

![](/My-Processing-Book/images/music_visualizer/menu.PNG "Diseño del menú")

<br>La función **found()** es para la detección de la cara y las funciones **eyeLeftReceived(f)** y **eyeRightReceived(f)** se encargan de detectar el pestañeo del usuario. Para ello se compara la altura de los ojos anteriores con el actual menos una tolerancia que se ha establecido a 1,2.

    void createCircle() {
      float[] wave = fft.analyze();

      // Draw right side of circle
      beginShape();  
      for (int i = 0; i <= 180; i ++) {
        int index = floor(map(i, 0, 180, 0, wave.length-1));
        float r = map(wave[index], -1, 1, 150, 350);
        float x = r * sin(degrees(i));
        float y = r * cos(degrees(i));
        vertex(x, y);
      }
      endShape();

      // Draw left side of circle
      beginShape();  
      for (int i = 0; i <= 180; i ++) {
        int index = floor(map(i, 0, 180, 0, wave.length-1));
        float r = map(wave[index], -1, 1, 150, 350);
        float x = r * -sin(degrees(i));
        float y = r * cos(degrees(i));
        vertex(x, y);
      }
      endShape();
    }

<br>Para dibujar el rostro del usuario anteriormente comentado, se llaman a las tres siguientes funciones:

    void createParticles() {
      particles.add(new Particle());
      for (int i = particles.size() - 1; i >= 0; i--) {
        if (!particles.get(i).edges()) {
          // Accelerate particles when amplitude > 0.8
          particles.get(i).update(amplitude > 0.8);
          particles.get(i).show();
        } else {
          // Remove particle when out of borders
          particles.remove(i);
        }
      }
    }
      
<br>La clase *Bird* es la encagada de representar la pelota y se han declarado como atributos de la clase las coordenadas y su velocidad en el eje Y.
      
    void keyPressed() {
      if (key == 'h') {
        menu = !menu;
      }
    }

<br>

    void mouseClicked() {
      if (song.isPlaying()) {
        song.pause();
      } else {
        song.play();
      }
    }

<br> La función **drawBird()** dibuja la pelota y es la llamada en la función **draw()**:

    void drawBird() {
        stroke(255);
        noFill();
        strokeWeight(2);
        ellipse(xPos, yPos, 20, 20);
    }

<br> La siguientes funciones controlan la velocidad al saltar y al bajar de la pelota:

    class Particle {
      PVector pos;
      PVector vel;
      PVector acc;
      float w;
      float[] colorP;

      Particle() {
        pos = PVector.random2D().mult(250);
        vel = new PVector(0, 0);
        acc = pos.copy().mult(random(0.0001, 0.00001));
        w = random(3, 5);
        colorP = new float[3];
        for (int i = 0; i < colorP.length; i++) {
          colorP[i] = random(200, 255);
        }
      }

<br>Finalmente, la función **checkCollisions()** detecta cuando la pelota ha colisionado con alguna de las paredes:
  
    void update(boolean cond) {
      vel.add(acc);
      pos.add(vel);
      // Accelerate particle
      if (cond) {
        pos.add(vel);
        pos.add(vel);
        pos.add(vel);
      }
    }

<br>La clase *Pillar* representa un pilar/pared como forma de obstáculo dibujadas como líneas verticales en la parte superior e inferior de la pantalla de juego. Para ello se declaran como atributos la posición X, el tamaño de apertura y una variable booleana.
    
    boolean edges() {
      if (pos.x < -width / 2 || pos.x > width / 2 || pos.y < -height / 2 || pos.y > height / 2) {
        return true;
      } else {
        return false;
      }
    }

<br>Finalmente, la función **show()** dibuja las paredes superiores e inferiores con una apertura aleatoria para que el usuario tenga la posibilidad de pasar:

    void show() {
      noStroke();
      fill(colorP[0], colorP[1], colorP[2]);
      ellipse(pos.x, pos.y, w, w);
    }
 
<br>A continuación, se muestra el resultado final mediante un gif animado: 

![](/My-Processing-Book/images/music_visualizer/music-visualizer-demo.gif  "Ejecución del código en Processing")

## Descargar código en Processing
Para la correcta ejecución en Processing, es necesario instalar la librería Sound. Esto se puede hacer de la siguiente manera:

![](/My-Processing-Book/images/music_visualizer/sound-lib.gif  "Instalación de la librería Sound en Processing")

Para descargar el código en Processing, acceda a: <a href="https://downgit.github.io/#/home?url=https://github.com/Prashant-JT/My-Processing-Book/tree/master/projects/music_visualizer">Descargar código en Processing</a> o acceda a la carpeta del repositorio del proyecto en: <a href="https://github.com/Prashant-JT/My-Processing-Book/tree/master/projects/music_visualizer">Repositorio del proyecto</a>

---

## Referencias

[Guión de prácticas](https://ncvt-aep.ulpgc.es/cv/ulpgctp21/pluginfile.php/412240/mod_resource/content/37/CIU_Pr_cticas.pdf)

[Página de Processing](https://processing.org/examples/)

[Creación del enlace de descarga](https://downgit.github.io/#/home)

[Música sin copyright](https://pixabay.com/music/search/genre/beats)