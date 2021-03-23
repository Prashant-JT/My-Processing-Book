# Oficina con iluminación
> Realizado por Prashant Jeswani Tejwani

Índice del contenido:

1. TOC
{:toc}

## Introducción
Se compone una escena de una oficina, con objetos tridimensionales con texturas, luces y movimiento de cámara. A continuación:

* Se describe el trabajo realizado argumentando las decisiones adoptadas para la solución propuesta
* Se incluye las referencias y herramientas utilizadas
* Se muestra el resultado con un gif animado

## Diseño 

El diseño ha sido el que se puede observar en la siguiente figura. Una habitación con objetos como escritorio, estantería, televisión, ventanas y personas. El usuario es capaz de moverse por toda la oficina creando nuevos puntos de luz (en unas posiciones preestablecida) con distintos colores al hacer click. Para ir variando la intensidad de los colores puede mover el ratón hacia la izquierda para colores más oscuros o hacia la derecha para más claros. El techo está iluminado por una luz blanca/gris que ilumina la oficina. 

![](/My-Processing-Book/images/office_scene/office_scene.PNG "Diseño del programa en Processing")

## Código implementado

A continuación se describe el trabajo realizado. Se crean e inicializan las variables necesarias los controles del usuario que se irán explicando a medida que se avance. Se añaden las variables booleanas para controlar los movimientos del usuario cuando se desplace por la oficina y una variable booleana mostrar los controles cuando el usuario desee. En la función **setup()** se inicializa una persona y una oficina creando un objeto de la clase *Person* y de la clase *Office* que se explicarán más adelante.

    Office office;
    Person person;
    boolean moveLeft, moveRight, moveForward, moveBack = false;
    boolean help;

    void setup() {
      size(1000, 600, P3D);
      office = new Office();
      person = new Person();
      help = true;
    }

<br>En la función **draw()** se chequea si el usuario ha elegido ver los controles o no. Se dibuja la escena de la oficina mediante la función **show()** de la clase *Office*. Inicialmente, el usuario se encuentra en el centro de la oficina situándolo con los parámetros de la función **camera(x1,y1,z1,x2,y2,z2,x3,y3,z3)** mediante la función **getPosition()** el cual devuelve las coordenadas del usuario. En caso contrario, se establece la vista de tercera persona con sus valores por defecto. Para actualizar las coordenadas del usuario se utiliza la función **setPosition(forward, backward, left, right)** de la clase *Person*. Se muestra o ocultan los controles si el usuario presiona la tecla 'h'.

    void draw() {
      // Show controls
      if (help) {
        pushMatrix();
        translate(width/2, height/2, 0);
        camera(0, 0, (height/2) / tan(PI/6), 0, 0, 0, 0, 1, 0); 
        help();
        popMatrix();
      } else {
        // Create office scene
        office.show();

        // Update camera
        person.updateAngle();
        person.show();
        person.setPosition(moveForward, moveBack, moveLeft, moveRight);
        camera(person.getPosition().x, person.getPosition().y, person.getPosition().z, 
          person.rotatePerson().x, 0, person.rotatePerson().y, 0, 1, 0);
      }
    }
    
<br>Se llama a la función **help()** la cual imprime un lienzo de ayuda de los controles que dispone el usuario.

    // User controls
    void help() {
      fill(255);
      background(0);
      textAlign(CENTER);
      textFont(createFont("Georgia", 18));
      text("Press 'h' to show/hide controls", 0, -120);
      text("Press 'w' to move forward", 0, -90);
      text("Press 's' to move backward", 0, -60);
      text("Press 'a' to rotate left", 0, -30);
      text("Press 'd' to rotate right", 0, 0);
      text("Left click to create colored spot light (4 max)", 0, 30);
      text("Move mouse left/right to change color intensity", 0, 60);
      text("Press 'r' to reset position", 0, 90);
      text("© Prashant Jeswani Tejwani", 0, 150);
      textFont(createFont("Georgia", 12));
      text("Note: Rendering time when hiding controls for the first time is high, it may take a few seconds", 0, 250);
    }

<br>Para el movimiento del usuario se utiliza las funciones **keyPressed** y **keyReleased**. Dependiendo de la tecla pulsada, el usuario se moverá hacia delante, hacia atrás o podrá girar hacia la izquierda o derecha. El usuario también tiene la opción de reestablecer la posición al estado inicial.

    void keyReleased() {
      if (!help) { 
        if (key == 'w') moveForward = false;
        if (key == 's') moveBack = false;
        if (key == 'a') moveLeft = false;
        if (key == 'd') moveRight = false;
      }
    }
    
<br>

    void keyPressed() {
      if (key == 'h') {
        if (help) {
          help = false;
        } else {
          help = true;
        }
      }

      if (!help) { 
        if (key == 'w') moveForward = true;
        if (key == 's') moveBack = true;
        if (key == 'a') moveLeft = true;
        if (key == 'd') moveRight = true;
        if (key == 'r') person.resetPosition();
      }
    }

<br>El usuario tiene la posibilidad de crear puntos de luz de distinto color que irán apareciendo en las distintas paredes en un sitio predeterminado (como máximo 4, cuando el usuario haga click por quinta vez, se reestablecerá a un solo punto de luz).

    // Create spot lights
    void mousePressed() {
      office.setLights();
    }

<br>Respecto la clase *Office*, este contiene atributos como los objetos que aparecerán en la escena, cargando las figuras 3D mediante la función **loadShape("path")** en el constructor. Se ha tenido que rescalar las figuras mediante la función **scale(s)**.

    class Office {
      PShape window;
      PShape guy;
      PShape girl;
      PShape desk1;
      PShape bookshelf;
      PShape lamp;
      PShape tv;
      PShape painting;
      int spotLights;

      Office() {
        guy = loadShape("office-guy.obj");
        guy.scale(3);
        girl = loadShape("mei-posed-001.obj");
        girl.scale(320);
        window = loadShape("window-frame-and-pane.obj");
        window.scale(100);
        desk1 = loadShape("office-desk.obj");
        desk1.scale(300);
        bookshelf = loadShape("bookshelf-antonio-rodriguez.obj");
        bookshelf.scale(500);
        lamp = loadShape("lamp.obj");
        lamp.scale(20);
        tv = loadShape("screen.obj");
        tv.scale(100);
        painting = loadShape("oil-paintings-with-frame.obj");
        painting.scale(30);

        spotLights = 0;
      }
      
<br>La función **show()** dibuja la escena llamando a las funciones que van creando objetos de la oficina:
      
      void show() {
        textureMode(NORMAL);
        showPerson();
        showWindow();
        showDesk();
        showTV();
        showRoom();
        showBookshelf();
        showPainting();
      }

<br> La siguiente función dibuja a las personas:

      void showPerson() {
        // Guy
        pushMatrix();
        translate(-400, 300, -1000);
        rotateX(PI-0.25);
        rotateY(PI);
        shape(guy);
        popMatrix();

        // Girl
        pushMatrix();
        translate(400, 300, 1000);
        rotateX(PI);
        shape(girl);
        popMatrix();
      }

<br> La siguiente función dibuja las ventanas de la pared derecha:

      void showWindow() {
        // Window 1
        pushMatrix();
        translate(750, -100, 0);
        rotateY(PI/2);
        shape(window);
        popMatrix();

        // Window 2
        pushMatrix();
        translate(750, -100, 700);
        rotateY(PI/2);
        shape(window);
        popMatrix();
      }

<br> La siguiente función dibuja un escritorio con una lámpara:

      void showDesk() {
        // Desk
        pushMatrix();
        translate(650, 80, -750);
        rotateX(PI);
        shininess(5.0); 
        desk1.setFill(color(128, 128, 128));
        shape(desk1);
        popMatrix();

        // Lamp
        pushMatrix();
        translate(650, 90, -1000);
        rotateX(PI);
        rotateY(PI);
        shininess(5.0); 
        lamp.setFill(color(192, 192, 192));
        shape(lamp);
        popMatrix();
      }

<br> La siguiente función dibuja una televisión en la pared izquierda:

      void showTV() {
        // Television
        pushMatrix();
        translate(-730, 200, 300);
        rotateY(PI/2);
        rotateZ(PI);
        shininess(5.0); 
        shape(tv);
        popMatrix();
      }

<br> La siguiente función es la encargada de crear los distintos puntos de luz en las paredes según las veces que el usuario haya hecho click. Además, se establece luz ambiente y una luz en el techo que ilumina la oficina. También controla la intensidad de los colores según la posición en la que se encuentre el ratón:

      void showRoom() {
        // Create room
        // Different spot lights
        switch (spotLights) {
        case 1:
          spotLight(255, 0, 0, 200, -500, 1000, -1, 1, -1, PI/2, 10);
          break;
        case 2:
          spotLight(255, 0, 0, 200, -500, 1000, -1, 1, -1, PI/2, 10);
          spotLight(255, 255, 0, -1000, -500, 1000, 1, 1, -1, PI/2, 10);
          break;
        case 3:
          spotLight(255, 0, 0, 200, -500, 1000, -1, 1, -1, PI/2, 10);
          spotLight(255, 255, 0, -1000, -500, 1000, 1, 1, -1, PI/2, 10);
          spotLight(0, 255, 0, -1000, -500, -1000, 1, 1, 1, PI/2, 10);
          break;
        default:
          spotLight(255, 0, 0, 200, -500, 1000, -1, 1, -1, PI/2, 10);
          spotLight(255, 255, 0, -1000, -500, 1000, 1, 1, -1, PI/2, 10);
          spotLight(0, 255, 0, -1000, -500, -1000, 1, 1, 1, PI/2, 10);
          spotLight(0, 0, 255, 1000, -500, -1000, -1, 1, 1, PI/2, 10);
          break;
        }

        // Ceilling light
        directionalLight(150, 150, 150, 0, -1, 0);
        lightSpecular(200, 200, 200);

        float val = (float) mouseX / (float) width*(float) 180;
        ambientLight ((int)val, (int)val, (int)val);
        box(1500, height, 3000);
      }

      void showBookshelf() {
        // Bookshelf
        pushMatrix();
        translate(-400, 370, 1415);
        rotateX(PI);
        shape(bookshelf);
        popMatrix();
      }

<br> La siguiente función dibuja unas pinturas en la pared trasera:

      void showPainting() {
        // Paintings
        pushMatrix();
        translate(300, -20, 1495);
        rotateX(PI);
        shape(painting);
        popMatrix();
      }

<br> Finalmente, la función **setLights()** controla el número de puntos de luz:

      // Set number of spot lights
      void setLights() {
        if (spotLights < 4) {
          spotLights++;
        } else {
          spotLights = 0;
        }
      }
    
<br>Respecto la clase *Office*, este contiene atributos como el vector que representa las coordenadas en la que se encuentra actualmente y el ángulo en el que gira cuando el usuario decide rotar hacia la izquierda o derecha.
    
    class Person {
      PVector vector;
      float angle;

      Person() {
        vector = new PVector(0, 0, 0);
        angle = 0;
    }

<br>La función **show()** establece las coordenadas y sitúa al usuario en la escena de la oficina.

    void show() {
      pushMatrix();
      translate(vector.x, vector.y, vector.z);
      popMatrix();
    }

<br>La función **getPosition()** simplemente devuelve la posición actual del usuario.

    // Actual position
    PVector getPosition() {
      return vector;
    }

<br>La función **setPosition(forward, back, left, right)** actualiza las posiciones del usuario. Se ha hecho uso del coseno y seno para la rotación del usuario:

    // Update positions
    void setPosition(boolean forward, boolean back, boolean left, boolean right) {
      if (forward) {
        vector.z -= cos(radians(angle))*20;
        vector.x += sin(radians(angle))*20;
      } else if (back) {
        vector.z += cos(radians(angle))*20;
        vector.x -= sin(radians(angle))*20;
      } else if (left) {
        angle -= 2;
      } else if (right) {
        angle += 2;
      }
    }

<br>La función **rotatePerson()** es la encargada de indicar la vista del usuario a la función **camera(x1,y1,z1,x2,y2,z2,x3,y3,z3)**: 

    // Rotation
    PVector rotatePerson() {
      PVector p = new PVector(sin(radians(angle))*(width*1000), 
                              cos(radians(angle))*(-width*1000));
      return p;
    }

<br>La función **update()** actualiza el ángulo en el que el usuario está girado:
    
    // Update angle
    void updateAngle() {
      if (angle > 360) angle = 0;
    }
    

<br>Finalmente, se llama a la función **resetPosition()** cuando el usuario decide reestablecer su posición inicial.
    
    // Reset position
    void resetPosition() {
      vector = new PVector(0, 0, 0);
    }    
 
<br>A continuación, se muestra el resultado final mediante un gif animado: 

![](/My-Processing-Book/images/office_scene/office-scene-demo.gif  "Ejecución del código en Processing")

## Descargar código en Processing 
Para descargar el código en Processing, acceda a: <a href="https://downgit.github.io/#/home?url=https://github.com/Prashant-JT/My-Processing-Book/tree/master/projects/office_scene">Descargar código en Processing</a> o acceda a la carpeta del repositorio del proyecto en: <a href="https://github.com/Prashant-JT/My-Processing-Book/tree/master/projects/office_scene">Repositorio del proyecto</a>

---

## Referencias

[Guión de prácticas](https://ncvt-aep.ulpgc.es/cv/ulpgctp21/pluginfile.php/412240/mod_resource/content/37/CIU_Pr_cticas.pdf)

[Página de Processing](https://processing.org/examples/)

[Creación del enlace de descarga](https://downgit.github.io/#/home)

[Modelo 3D del cohete](https://clara.io/)
