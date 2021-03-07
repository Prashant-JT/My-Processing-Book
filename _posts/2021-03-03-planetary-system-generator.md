# Generador de sistema planetario
> Realizado por Prashant Jeswani Tejwani

Índice del contenido:

1. TOC
{:toc}

## Introducción
Se implementa un prototipo que genera un sistema planetario en movimiento que incluye una estrella, varios planetas y lunas, integrando primitivas 3D, texto e imágenes. Se ha añadido la posibilidad de añadir o eliminar planetas al sistema planetario. A continuación:

* Se describe el trabajo realizado argumentando las decisiones adoptadas para la solución propuesta
* Se incluye las referencias y herramientas utilizadas
* Se muestra el resultado con un gif animado
* Se implementa el código en p5.js con el fin de poder ejecutarse en un navegador

## Diseño 

El diseño ha sido el que se puede observar en la siguiente figura. Un lienzo con un fondo de imagen del espacio en el cual se sitúa un sol en el centro, con planetas que giran entorno su órbita. Estos planetas pueden tener a su vez lunas que giran en una órbita alrededor de ellas. Cada planeta o luna tiene una textura aleatoria.

![](/My-Processing-Book/images/planetary_system_generator/planetary_system_generator.PNG "Diseño del programa en Processing")

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

<br>En la función **draw()** se redimiensiona la imagen de fondo en el caso de que el usuario haya decidido verlo en pantalla completa en Processing. Se establece la imagen de fondo con la función **background(b)**, la función **lights()** establece una luz ambiental, una luz direccional con una atenuación. Los valores predeterminados son ambientLight (128, 128, 128) y directionalLight (128, 128, 128, 0, 0, -1), lightFalloff (1, 0, 0) y lightSpecular (0, 0, 0). A continuación, se invoca a las funciones **show()** y **orbit()** de la clase *Planet* y finalmente se llama a la función **help()** la cual imprime en el lado superior izquierdo una pequeña ayuda de los controles que dispone el usuario para añadir, eliminar planetas y mover la cámara.

    void draw() {
      space.resize(width, height);
      background(space);
      lights();
      sun.show();
      sun.orbit();
      help();
    }
    
<br>

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

<br>Para que el código sea más legible y fácil de entender, se han implementado distintas funciones que realizarán una serie de acciones con el fin de que el programa se ejecute correctamente. Cuando el usuario presione la tecla 'd' para dibujar, se invocará al método **drawFigure()**. Esta función se encarga de calcular las respectivas transformaciones de coordenadas en un bucle que se ejecuta 360 veces para cada vértice (estos puntos se irán almacenando en el array *solid* como un array, es decir, *solid* será un array de arrays).

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
    
<br>En el bucle anterior, se llama la función **translatePoints(PVector point, float theta)** para la rotación de los puntos de dicho perfil y obtener los vértices 3D de la malla del objeto:
    
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
    
Para la tranformación de las coordenadas se han hecho uso de las siguientes fórmulas:
![](/My-Processing-Book/images/solid_of_revolution/tranformation.PNG  "Transformaciones de las coordenadas X,Y,Z")

<br>A continuación se llama la función **drawSolidRevolution(ArrayList a)** que se encarga de dibujar el sólido de revolución. También es la responsable de rellenar la figura con triángulos, para ello, se genera un PShape para cada triángulo generado. Finalmente, para construir la figura final, se utiliza el *figureSolid* creado en la función anterior determinado como *GROUP*, cuya finalidad es reunir todas las figuras generadas y mostrarlas como una misma (para adjuntar una figura se emplea la función *addChild()*). 

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
    
<br>La función **minMaxY()** se encarga de devolver en un array de tamaño dos con los vértices máximos y mínimos de la coordenada Y con el fin de transladar el ratón en el centro del sólido de revolución (vea el método **draw()**).

    float[] minMaxY() {
      float maxY = 0;
      float minY = 0;
      for (PVector point : points) {
        if (point.y > maxY) maxY = point.y;
        if (point.y < minY) minY = point.y;
      }
      return new float[] {minY, maxY};
    }

<br>La función **clearPoints()** elimina todos los vértices del usuario con el fin de que se pueda crear nuevos sólidos de revolución. Esta función se invocará cuando el usuario presione la tecla 'c' para limpiar la pantalla (la función se llamará en el método **keyPressed()** cuando se presione la tecla correspondiente).

    // Clear all points of the figure
    void clearPoints() {
      points.clear();
    }

<br>La finalidad de la función **controlsMessage()** es mostrar los controles del programa. Cabe destacar que tanto el clic izquierdo como el derecho del ratón pueden ser empleados para crear un nuevo vértice en Processing (en el caso de p5.js solo el clic izquierdo).

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

<br>La función **mousePressed()** se encarga de detectar las coordenadas del nuevo vértice que ha elegido el usuario en la parte derecha del lienzo. Este se añadirá al vector de los puntos que almacena los vértices elegidos anteriormente:

    // Detect when user clicks to create a new vertex
    void mousePressed() {
      if (mouseX >= width/2 && !drawFigure) {
        points.add(new PVector(mouseX, mouseY));
      }
    }
   
<br>La función **keyPressed()** chequea los distintos tipos de controles. Los controles establecidos son los siguientes:
    * Tecla 'c' para limpiar la pantalla y crear una nueva figura. Para ello se establece la variable booleana a falso y se invoca al método **clearPoints()** para eliminar todos los vértices.
    * Tecla 'x' para eliminar el último vertice creado, cuando el usuario está creando los vértices de la figura. Para ello lo único que se debe hacer es eliminar el último vértice de la lista de puntos/vértices.
    * Tecla 'd' para cerrar la figura, calcular y mostrar el sólido de revolución. Para ello se establece la variable booleana a verdadero y se invoca al método **drawFigure()** explicado anteriormente.

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
    
<br>A continuación, se muestra un ejemplo con su resultado final mediante un gif animado: 

![](/My-Processing-Book/images/planetary_system_generator/planetary-system-generator-demo.gif  "Ejecución del código en Processing")

## Descargar código en Processing 
Para la correcta ejecución en Processing, es necesario instalar la librería PeasyCam (del autor Jonathan Feinberg). Esto se puede hacer de la siguiente manera:

![](/My-Processing-Book/images/planetary_system_generator/peasy-cam-lib.gif  "Instalación de la librería PeasyCam en Processing")

Para descargar el código en Processing, acceda a: <a href="https://downgit.github.io/#/home?url=https://github.com/Prashant-JT/My-Processing-Book/tree/master/projects/planetary_system_generator">Descargar código en Processing</a> o acceda a la carpeta del repositorio del proyecto en: <a href="https://github.com/Prashant-JT/My-Processing-Book/tree/master/projects/planetary_system_generator">Repositorio del proyecto</a>

---


## Ver demo 

Se ha implementado el código a p5.js con el fin de poder probarlo en un navegador. Para ello se han tenido que modificar algunos aspectos como el tamaño de letra, tipos de variables, entre otros:
{% include info.html text="Para probarlo debe abrir el enlace en un navegador. No se podrá ejecutar en dispositivos móviles" %}

| **Ver demo** | <a href="https://editor.p5js.org/Prashant-JT/full/XKp-ISITk">Dale click para ver demo</a> |

## Referencias

[Guión de prácticas](https://ncvt-aep.ulpgc.es/cv/ulpgctp21/pluginfile.php/412240/mod_resource/content/37/CIU_Pr_cticas.pdf)

[Página de Processing](https://processing.org/examples/)

[Creación del enlace de descarga](https://downgit.github.io/#/home)
