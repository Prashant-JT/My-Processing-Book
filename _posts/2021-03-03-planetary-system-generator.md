# Generador de sistema planetario
> Realizado por Prashant Jeswani Tejwani

Índice del contenido:

1. TOC
{:toc}

## Introducción
Se implementa un prototipo que genera un sistema planetario en movimiento que incluye una estrella, varios planetas y lunas, integrando primitivas 3D, texto e imágenes. A continuación:

* Se describe el trabajo realizado argumentando las decisiones adoptadas para la solución propuesta
* Se incluye las referencias y herramientas utilizadas
* Se muestra el resultado con un gif animado
* Se implementa el código en p5.js con el fin de poder ejecutarse en un navegador

## Diseño 

El diseño ha sido el que se puede observar en la siguiente figura. Un lienzo con fondo negro dividido en dos por una línea blanca central, el usuario dibuja los vértices que desee en la parte derecha del lienzo con el fin de crear un sólido de revolución:

![](/My-Processing-Book/images/planetary_system_generator/planetary_system_generator.PNG "Diseño del programa en Processing")

## Código implementado

A continuación se describe el trabajo realizado. Primeramente, se crean e inicializan las variables necesarias para el control de los vértices del usuario que se irán explicando a medida que se avance en la explicación del código. En la función **setup()** se establece el tamaño de la ventana a 800x700 píxeles, se establecen los colores y se inicializa un *ArrayList* que irá almacenando los vértices elegidos por el usuario con elementos de tipo *PVector*:

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

<br>En la función **draw()** se dibuja la línea central y se muestran los controles en la parte inferior izquierda. La variable booleana *drawFigure* se establecerá a verdadero cuando el usuario desee crear el sólido de revolución con los puntos escogidos, mientras tanto el usuario podrá seguir escogiendo nuevos vértices de su figura. Estos vértices son dibujados mediante la función **ellipse(x,y,r,r)** y las aristas de la figura mediante **line(x1,y1,x2,y2)**. Cuando se muestre el sólido de revolución, se transladará la posición del ratón al centro de la figura con el fin de que el usuario sea capaz de mover la figura. Para ello se hace uso de la función 
**minMaxY()** que se explicará más adelante.

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

![](/My-Processing-Book/images/planetary_system_generator/peasy-cam-lib.gif   "Instalación de la librería PeasyCam en Processing")

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
