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

El diseño ha sido el que se puede observar en la siguiente figura. Un lienzo con un fondo de imagen del espacio en el cual se sitúa un sol en el centro, con planetas que giran entorno su órbita. Estos planetas pueden tener a su vez lunas que giran en una órbita alrededor de ellas. Cada planeta o luna tiene una textura aleatoria. Se sitúa el cohete en el espacio situando los controles del usuario en la parte superior izquierda.

![](/My-Processing-Book/images/planetary_system_generator_rocket/planetary_system_generator_rocket.PNG "Diseño del programa en Processing")

## Código implementado

A continuación se describe el trabajo realizado. Primeramente, se crean e inicializan las variables necesarias para el sol y sus planetas que se irán explicando a medida que se avance. En la función **setup()** se establece el tamaño de la ventana a 800x600 píxeles, se cargan 8 texturas distintas de planetas en un array que contiene elementos de tipo *PImage* y se carga la imagen de fondo para establecerla más adelante. A continuación se crea el sol mediante la clase *Planet* al cual se le pasarán como parámetros al constructor: el radio del planeta, la distancia al sol, la órbita y su textura. Se crean inicialmente 6 planetas alrededor del sol y se inicializa la variable *PeasyCam* con el fin de que el usuario se capaz de mover y hacer zoom, para ello es necesario instalar la librería que se explica en la sección de *Descargar código en Processing*.

    import peasy.*;

    Planet sun;
    PeasyCam cam;
    PImage sunTexture;
    PImage space;
    PImage[] textures = new PImage[8];

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
      cam = new PeasyCam(this, 500);
    }

<br>En la función **draw()** se redimiensiona la imagen de fondo en el caso de que el usuario haya decidido verlo en pantalla completa en Processing. Se establece la imagen de fondo con la función **background(b)**, la función **lights()** establece una luz ambiental, una luz direccional con una atenuación. Los valores predeterminados son ambientLight (128, 128, 128) y directionalLight (128, 128, 128, 0, 0, -1), lightFalloff (1, 0, 0) y lightSpecular (0, 0, 0). A continuación, se invoca a las funciones **show()** y **orbit()** de la clase *Planet*.

    void draw() {
      space.resize(width, height);
      background(space);
      lights();
      sun.show();
      sun.orbit();
      help();
    }
    
<br>Finalmente se llama a la función **help()** la cual imprime en el lado superior izquierdo una pequeña ayuda de los controles que dispone el usuario para añadir y eliminar planetas, además de poder mover la cámara.

    void help() {
      fill(255);
      textFont(createFont("Georgia", 14));
      text("Press '+' to add planets", -(width/2)+20, -(height/2)+30);
      text("Press '-' to remove planets", -(width/2)+20, -(height/2)+50);
      text("Move & zoom camera view with mouse", -(width/2)+20, -(height/2)+70);
      text("© Prashant Jeswani Tejwani", -(width/2)+20, -(height/2)+100);
    }

<br>Para añadir y eliminar planetas el usuario debe presionar las teclas '+' para añadir y '-' para eliminar el último. Esto se captura mediante la función **keyPressed()**. Dependiendo de la tecla pulsada, se añadirá o eliminará un planeta (con sus respectivas lunas que giran a su alrededor):

    void keyPressed() {
      if (key == '+') {
        sun.addPlanet();
      } else if (key == '-') {
        sun.removePlanet();
      }
    }

<br>Respecto la clase *Planet*, este contiene atributos como el radio, ángulo, distancia al sol, un array de planetas (que representarán las lunas de cada planeta), velocidad de órbita, un vector y una figura PShape con el fin de poder representar un planeta con sus respectivas lunas (si las tiene).

    class Planet {
      float radius;
      float angle;
      float distance;
      ArrayList<Planet> planets;
      float orbitSpeed;
      PVector vector;
      PShape globe;
      
<br>En el constructor se inicializan dichos atributos con un ángulo de giro aleatorio entre 0-2π y se crea la figura con su textura:
      
      Planet(float r, float d, float o, PImage img) {
        planets = new ArrayList<Planet>();
        vector = PVector.random3D();
        radius = r;
        distance = d;
        vector.mult(distance);
        angle = random(TWO_PI);
        orbitSpeed = o;

        noStroke();
        noFill();
        globe = createShape(SPHERE, radius);
        globe.setTexture(img);
      }
    
<br>La función **orbit()** es la encargada de recalcular la órbita que siguen los planetas (junto a sus lunas) mediante el ángulo y la velocidad a la que giran alrededor del sol llamando a la función recursivamente:
    
    void orbit() {
        angle = angle + orbitSpeed;
        if (planets != null) {
          for (int i = 0; i < planets.size(); i++) {
            planets.get(i).orbit();
          }
        }
    }

<br>A continuación, la función **spawnMoons(int total, int level)** que se encarga de crear los planetas y sus lunas (que se añaden al array de *planets*) con un radio aleatorio (según el número de niveles de lunas), una distancia al sol según su radio, una velocidad de órbita entre -0.02 y 0.02 y se elige una textura aleatoria de las 8 posibles existentes. Finalmente, se crean sus respectivas lunas con llamadas recursivas:

    void spawnMoons(int total, int level) {   
        for (int i = 0; i < total; i++) {
          float r = radius/(level*2); // planet radius
          float d = random((radius+r), (radius+r)*4); // distance to sun
          float o = random(-0.02, 0.02); // velocity
          int index = int(random(0, textures.length)); // random texture
          planets.add(new Planet (r, d, o, textures[index]));
          if (level < 3) { // number of moons
            int num = int(random(0, 3));
            planets.get(i).spawnMoons(num, level+1);
          }
        }
    }
    
<br>Las funciones **addPlanet()** y **removePlanet()** son las encargadas de añadir y eliminar planetas con sus respectivas lunas cuando el usuario presione alguno de los controles establecidos (vea el método **keyPressed()**).

    void addPlanet() {
        this.spawnMoons(1,1);
      }

    void removePlanet() {
        if(planets.size() > 0)
        planets.remove(planets.get(planets.size()-1));
    }

<br>La función **show()** muestra los planetas con sus respectivas lunas (con la función **shape(s)**) utilizando las funciones **pushMatrix()** y **popMatrix()** junto a **rotate()** y **translate()**. Para que cada planeta y luna gire sobre sí mismo y alrededor del sol (y alrededor de su planeta en el caso de una luna), se ha optado por crear un vector arbitrario, calcular su vector perpendicular (mediante el método **cross(v)**). La idea se puede captar mejor visualmente en el siguiente gif:

    void show() {
        pushMatrix();
        noStroke();
        fill(255);

        // Create perpendicular vector to orbit and rotate planets 
        PVector v = new PVector(1, 0, 1);
        PVector p = vector.cross(v);
        rotate(angle, p.x, p.y, p.z);

        translate(vector.x, vector.y, vector.z);
        shape(globe);

        // Draw moons of planets
        if (planets != null) {
          for (int i = 0; i < planets.size(); i++) {
            planets.get(i).show();
          }
        }
        popMatrix();
      }
    }
    
<br>A continuación, se muestra el resultado final mediante un gif animado, se muestra el estado inicial del programa y se añaden y eliminan planetas para mostrar su correcto funcionamiento: 

![](/My-Processing-Book/images/planetary_system_generator_rocket/planetary-system-generator-rocket-demo.gif  "Ejecución del código en Processing")

## Descargar código en Processing 
Para descargar el código en Processing, acceda a: <a href="https://downgit.github.io/#/home?url=https://github.com/Prashant-JT/My-Processing-Book/tree/master/projects/planetary_system_generator_rocket">Descargar código en Processing</a> o acceda a la carpeta del repositorio del proyecto en: <a href="https://github.com/Prashant-JT/My-Processing-Book/tree/master/projects/planetary_system_generator_rocket">Repositorio del proyecto</a>

---


## Ver demo 

Se ha implementado el código a p5.js con el fin de poder probarlo en un navegador. Para ello se han tenido que modificar algunos aspectos como el tamaño de letra, tipos de variables, entre otros:
{% include info.html text="Para probarlo debe abrir el enlace en un navegador. No se podrá ejecutar en dispositivos móviles" %}
{% include info.html text="En el caso de p5.js se ha decidido eliminar la imagen de fondo debido a un error. Además al añadir nuevos planetas, solo se añaden planetas (sin lunas) aunque en el estado inicial si hay planetas con lunas. Esto no ocurre con el código implementado en Processing." %}

| **Ver demo** | <a href="https://editor.p5js.org/Prashant-JT/full/lujUj9Jyn">Dale click para ver demo</a> |

## Referencias

[Guión de prácticas](https://ncvt-aep.ulpgc.es/cv/ulpgctp21/pluginfile.php/412240/mod_resource/content/37/CIU_Pr_cticas.pdf)

[Página de Processing](https://processing.org/examples/)

[Creación del enlace de descarga](https://downgit.github.io/#/home)
