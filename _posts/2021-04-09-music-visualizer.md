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
* Se implementa el código en p5.js con el fin de poder ejecutarse en un navegador

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
    
<br>En la función **draw()** se muestra u oculta el menú si el usuario ha presionado la tecla 'h'. En el caso de que el menú esté oculto, se analiza la amplitud de la canción mediante la función **analyze()** que obtiene un valor entre 0-1, si es mayor que 0.8 se agita la imagen de fondo. También se crea un rectángulo para tener una capa de transparencia que será más o menos transparente dependiendo de la amplitud. Finalmente se crea el círculo central y las partículas que también moverán acorde las música.

    void draw() {
      background(0);
      translate(width/2, height/2);
      if (menu) {
        menu();
      } else {
        // Shake image depending on amplitude
        amplitude = level.analyze();
        if (amplitude > 0.8) rotate(random(-0.003, 0.003));
        image(background, 0, 0, width + 100, height + 100);

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

<br>Se llama a la función **menu()** la cual imprime un lienzo de ayuda de los controles que dispone el usuario.

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

<br>La función **createCircle()** crea la circunferencia central, para ello se utiliza las coordenadas polares para representar la parte derecha e izquierda del círculo. Para ello se analiza la onda de mediante la función **analyze()** del objeto *FFT*.

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

<br>La función **createParticles()** crea las partículas que parten de la circunferencia, se van creando partículas y se aceleran dependiendo de la amplitud de la canción en todo momento para dar un efecto inmersivo. Las partículas que sobrepasan el tamaño de la ventana se eliminan (para que no se crean partículas infinitamente y ralentice la ejecución), esto se puede comprobar mediante la función **edges()** de la clase *Particle*.

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
      
<br>Las funciones **keyPressed()** y **mouseClicked()** detectan cuando el usuario presiona la tecla 'h' para mostrar u ocultar el menú y para reproducir o pausar la canción, respectivamente.
      
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

<br>La clase *Particle* representa una partícula, para ello, se necesita la posición, velocidad, aceleración, tamaño y color de la partícula. Estos se inicializan en el constructor aleatoriamente a partir de la circunferencia y colores entre el rango 200-255:

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

<br>La función **update(cond)** acelera las partículas cuando la amplitud es mayor que 0.8:
  
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

<br>La función **edges()** devuelve verdadero si una partícula sobrepasa el tamaño de la ventana:
    
    boolean edges() {
      if (pos.x < -width / 2 || pos.x > width / 2 || pos.y < -height / 2 || pos.y > height / 2) {
        return true;
      } else {
        return false;
      }
    }

<br>Finalmente, la función **show()** dibuja las partículas con los colores aleatorios:

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

## Probar demo 

Se ha implementado el código a p5.js con el fin de poder ejecutarse en un navegador. Para ello se han tenido que modificar algunos aspectos como el tamaño de letra, la visualización (ya que en p5 existen más funciones interesantes como *fft.getEnergy()*), entre otros:
{% include info.html text="Para jugar debe abrir el enlace en un navegador. No se podrá ejecutar en dispositivos móviles" %}

| **Probar demo** | <a href="https://editor.p5js.org/Prashant-JT/full/cdnNL5Oqx">Dale click para probar demo</a> |

## Referencias

[Guión de prácticas](https://ncvt-aep.ulpgc.es/cv/ulpgctp21/pluginfile.php/412240/mod_resource/content/37/CIU_Pr_cticas.pdf)

[Página de Processing](https://processing.org/examples/)

[Creación del enlace de descarga](https://downgit.github.io/#/home)

[Música sin copyright](https://pixabay.com/music/search/genre/beats)
