# Nave en el sistema planetario
> Realizado por Prashant Jeswani Tejwani

Índice del contenido:

1. TOC
{:toc}

## Introducción
Se extiende el programa del artículo anterior incluyendo una nave/cohete que el usuario de forma interactiva podrá navegar por el sistema planetario. A continuación:

* Se describe el trabajo realizado argumentando las decisiones adoptadas para la solución propuesta
* Se incluye las referencias y herramientas utilizadas
* Se muestra el resultado con un gif animado
* Se implementa el código en p5.js con el fin de poder ejecutarse en un navegador

## Diseño 

El diseño ha sido el que se puede observar en la siguiente figura. Un lienzo con un fondo de imagen del espacio en el cual se sitúa un sol en el centro, con planetas que giran entorno su órbita. Estos planetas pueden tener a su vez lunas que giran en una órbita alrededor de ellas. Cada planeta o luna tiene una textura aleatoria. Se sitúa el cohete en el espacio, se permite que se alterne entre una vista general y la vista desde el cohete mediante los controles situados en la parte superior izquierda.

![](/My-Processing-Book/images/planetary_system_generator_rocket/planetary_system_generator_rocket.PNG "Diseño del programa en Processing")

## Código implementado

A continuación se describe el trabajo añadido respecto al artículo anterior. Se crean e inicializan las variables necesarias para el control del cohete que se irán explicando a medida que se avance.  se añaden las variables booleanas para contorlar los movimientos del cohete y comprobar si la cámara de primera persona se ha activado o no (variable *rocketCam*). En la función **setup()** se inicializa el cohete creando un objeto de la nueva clase *Rocket* que se explicará más adelante.

    Planet sun;
    PImage sunTexture;
    PImage space;
    PImage[] textures = new PImage[8];
    Rocket rocket;
    boolean rocketCam;
    boolean moveLeft, moveRight, moveForward, moveDown, moveUp, moveBack = false;
    boolean help;

    void setup() {
      size(800, 600, P3D);
      sunTexture = loadImage("sun.png");
      space = loadImage("space.jpg");
      textures[0] = loadImage("mars.jpg");
      textures[1] = loadImage("earth.jpg");
      textures[2] = loadImage("mercury.jpg");
      textures[3] = loadImage("neptune.jpg");
      textures[4] = loadImage("pluto.jpg");
      textures[5] = loadImage("uranus.jpg");
      textures[5] = loadImage("saturn.jpg");
      textures[7] = loadImage("jupiter.jpg");
      sun = new Planet(50, 0, 0, sunTexture);
      sun.spawnMoons(6, 1);
      rocket = new Rocket();
      rocketCam = false;
      help = false;
    }

<br>En la función **draw()** se añade el chequeo si el usuario ha está en primera o tercera persona. En el caso de que el usuario se encuentre dentro del cohete (primera persona) se establecen los parámetros de la función **camera(x1,y1,z1,x2,y2,z2,x3,y3,z3)** situando la vista en la posición del cohete que se obtiene mediante la función **getRocketPosition()** el cual devuelve las coordenadas. En caso contrario, se establece la vista de tercera persona con sus valores por defecto. Para actualizar las coordenadas del cohete se realiza mediante la función **setPosition(forward, backward, left, right, up, down)**. Se muestra o ocultan los controles si el usuario presiona la tecla 'h'.

    void draw() {
      space.resize(width, height);
      background(space);
      translate(width/2, height/2);
      lights();

      // Check if user is in the rocket or not
      if (rocketCam) {
        camera(rocket.getRocketPosition().x, rocket.getRocketPosition().y, rocket.getRocketPosition().z, 
          0, 0, -width, 0, 1, 0);

      } else {
        camera(0, 0, (height/2) / tan(PI/6), 0, 0, 0, 0, 1, 0);
      }

      // Show planetary and position rocket
      sun.show();
      sun.orbit();
      rocket.show();
      rocket.setPosition(moveForward, moveBack, moveLeft, moveRight, moveUp, moveDown);

      // Show or hide controls
      if (help) {
        pushMatrix();
        camera(0, 0, (height/2) / tan(PI/6), 0, 0, 0, 0, 1, 0); 
        help();
        popMatrix();
      }else{
        camera(0, 0, (height/2) / tan(PI/6), 0, 0, 0, 0, 1, 0); 
        textFont(createFont("Georgia", 14));
        text("Press 'h' to show controls", -(width/2)+20, -(height/2)+30);
        text("© Prashant Jeswani Tejwani", -(width/2)+20, -(height/2)+70);
      }
    }
    
<br>Se llama a la función **help()** la cual imprime en el lado superior izquierdo una pequeña ayuda de los controles que dispone el usuario.

    // User controls
    void help() {
      fill(255);
      //textFont(createFont("Georgia", 14));
      text("Press 'h' to hide controls", -(width/2)+20, -(height/2)+30);
      if (rocketCam) {
        text("Press 'e' to exit rocket", -(width/2)+20, -(height/2)+50);
      } else {
        text("Press 'c' to enter rocket", -(width/2)+20, -(height/2)+50);
      }
      text("Press 'w' to move forward", -(width/2)+20, -(height/2)+70);
      text("Press 's' to move backward", -(width/2)+20, -(height/2)+90);
      text("Press 'a' to move left", -(width/2)+20, -(height/2)+110);
      text("Press 'd' to move right", -(width/2)+20, -(height/2)+130);
      text("Press 'q' to move up", -(width/2)+20, -(height/2)+150);
      text("Press 'x' to move down", -(width/2)+20, -(height/2)+170);
      text("Press 'r' to reset position", -(width/2)+20, -(height/2)+190);
      text("© Prashant Jeswani Tejwani", -(width/2)+20, -(height/2)+220);
    }

<br>Para el movimiento del cohete se utiliza las funciones **keyPressed** y **keyReleased**. Dependiendo de la tecla pulsada, se moverá el cohete arriba, abajo, a la izquierda, a la derecha, hacia delante o hacia atrás. El usuario también tiene la opción de reestablecer la posición del cohete al estado inicial en el caso de estar en primera persona y no saber donde se encuentra en el sistema planetario. Para cambiar de vistas, al pulsar la tecla 'c' se establece la vista en primera persona y al pulsar 'e' se regresa a tercera persona.

    void keyReleased() {
      if (key == 'w') moveForward = false;
      if (key == 's') moveBack = false;
      if (key == 'x') moveDown = false;
      if (key == 'q') moveUp = false;
      if (key == 'a') moveLeft = false;
      if (key == 'd') moveRight = false;
    }
    
<br>

    void keyPressed() {
      // Step out from rocket
      if (key == 'c') {
        rocketCam = true;
      } 

      // Enter rocket
      if (key == 'e') {
        rocketCam = false;
      }

      // Reset rocket position
      if (key == 'r') {
        rocket.resetPosition();
        rocketCam = false;
      }

      // Show or hide controls
      if (key == 'h') {
        if (help) {
          help = false;
        }else{
          help = true;
        }
      }

      // Rocket movement
      if (key == 'w') moveForward = true;
      if (key == 's') moveBack = true;
      if (key == 'x') moveDown = true;
      if (key == 'q') moveUp = true;
      if (key == 'a') moveLeft = true;
      if (key == 'd') moveRight = true;
    }

<br>Respecto la clase *Rocket*, este contiene atributos como el ángulo, vector de posiciones y un PShape con el fin de poder representar un cohete cargando una figura 3D mediante la función **loadShape("path")** en el constructor. Se ha tenido que ampliar la figura mediante la función **scale(s)**.

    class Rocket {
      float angle;
      PVector vector;
      PShape rocket;

      Rocket() {
        vector = new PVector(0, 0, 400);
        angle = PI/10;

        rocket = loadShape("rocket.obj");
        rocket.scale(50);
      }
      
<br>La función **show()** dibuja el cohete en la posición y rota la figura:
      
      void show() {
        pushMatrix();
        noStroke();
        fill(255);

        translate(vector.x, vector.y, vector.z);
        rotateZ(PI);
        rotateX(-PI/2);
        shape(rocket);

        popMatrix();
      }

      PVector getRocketPosition() {
        return vector;
      }
    
<br>La función **setPosition()** es la encargada de recalcular las posiciones del cohete y el movimiento del mismo:
    
    void setPosition(boolean forward, boolean back, boolean left, boolean right, boolean up, boolean down) {
        if (forward) {
          vector.z -= 3;
        } else if (back) {
          vector.z += 3;
        } else if (left) {
          vector.x -= 3;
        } else if (right) {
          vector.x += 3;
        } else if (up) {
          vector.y -= 3;
        } else if (down) {
          vector.y += 3;
        }
      }

<br>Finalmente, se llama a la función **resetPosition()** cuando el usuario decide reestablecer la posición inicial del cohete:

    void resetPosition() {
        vector = new PVector(0, 0, 400);
    }    
 
<br>A continuación, se muestra el resultado final mediante un gif animado: 

![](/My-Processing-Book/images/planetary_system_generator_rocket/planetary-system-generator-rocket-demo.gif  "Ejecución del código en Processing")

## Descargar código en Processing 
Para descargar el código en Processing, acceda a: <a href="https://downgit.github.io/#/home?url=https://github.com/Prashant-JT/My-Processing-Book/tree/master/projects/planetary_system_generator_rocket">Descargar código en Processing</a> o acceda a la carpeta del repositorio del proyecto en: <a href="https://github.com/Prashant-JT/My-Processing-Book/tree/master/projects/planetary_system_generator_rocket">Repositorio del proyecto</a>

---

## Referencias

[Guión de prácticas](https://ncvt-aep.ulpgc.es/cv/ulpgctp21/pluginfile.php/412240/mod_resource/content/37/CIU_Pr_cticas.pdf)

[Página de Processing](https://processing.org/examples/)

[Creación del enlace de descarga](https://downgit.github.io/#/home)

[Modelo 3D del cohete](https://clara.io/)
