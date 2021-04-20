# ml5.js: Detección de mascarilla
> Realizado por Prashant Jeswani Tejwani

Índice del contenido:

1. TOC
{:toc}

## Introducción
**Reto: implementar un código de programación creativa de menos de 1024 caracteres en p5.js.**
Se implementa un programa (en 976 bytes) el cual es capaz de obtener un conjunto de datos mediante la cámara, entrenar una red neuronal que sea capaz de clasificar y detectar si el usuario tiene una mascarilla puesta o no usando la librería **ml5.js**. A continuación:

* Se describe el trabajo realizado argumentando las decisiones adoptadas para la solución propuesta
* Se incluye las referencias y herramientas utilizadas
* Se muestra cómo ejecutar correctamente el programa paso a paso

## Diseño 

El diseño ha sido el que se puede observar en la siguiente figura. En la parte superior de la página se muestra las instrucciones paso a paso para el usuario. Más abajo se muestra el programa el cual necesita acceso a la cámara del usuario y en la parte inferior izquierda del lienzo se muestra el número de imágenes que se ha tomado de momento para cada clase:

![](/My-Processing-Book/images/mask_detection/mask_detection.PNG "Instrucciones para ejecutar el programa y diseño del programa")

## Código implementado

A continuación se describe el trabajo realizado. Se crean e inicializan las variables necesarias que se irán explicando a medida que se avance. 

    let video;
    let r=false;
    let NN;
    let label='';
    let mask=0;
    let noMask=0;

<br>Se incluye la librería ml5.js en el fichero index.html:

    <script src="https://unpkg.com/ml5@latest/dist/ml5.min.js"></script>

<br>En la función **setup()** se inicializan las variables definidas anteriormente, se captura el video desde la webcam mostrándolo en el lienzo. Se crea el modelo de la red neuronal utilizando una red neuronal convolucional para clasificación de imágenes. Para ello se establece el tamaño de entrada que espera la red, el tipo de clasificación de la red (*task:"imageClassification"*) y se establece *debug:true* para que al entrenarse, se muestre al usuario la arquitectura que se está utilizando y la función de pérdida a medida que avanza el entrenamiento. A continuación se crea la red neuronal con las opciones comentadas anteriormente mediante la función **ml5.neuralNetwork(options)**.

    function setup(){
      createCanvas(500,400);
      video=createCapture(VIDEO,vR);
      video.size(64,64);
      video.hide();
      let m={inputs: [64, 64, 4],task:'imageClassification',debug:true};
      NN=ml5.neuralNetwork(m);
    }
    
<br>En la función **createCapture()** se pasa como parámetro la función **vR()** para comprobar si la webcam está preparada para ser usada, si esta es llamada por la función **createCapture()** quiere decir que se ha podido acceder a la webcam por lo que se establece el booleano a verdadero:
    
    function vR(){r=true;}

<br>En la función **draw()** se muestra la imagen de la webcam y el número de imágenes que se han tomado para cada clase: 

    function draw(){
      background(0);
      if(r)image(video,0,0,width,height);
      textSize(64);
      textAlign(CENTER,CENTER);
      fill(255);
      text(label,width/2,height/2);
      textSize(16);
      text("Mask dataset: "+mask,70,height-60);
      text("No mask dataset: "+noMask,82,height-30);
    }

<br>Para la creación del conjunto de datos, se ha establecido que al pulsar la tecla 'm' se recoge una captura de un ejemplo con mascarilla y al pulsar la tecla 'n' un ejemplo sin mascarilla. Al pulsar la tecla 't' se normaliza los datos y se entrena la red neuronal para 50 épocas. Esto se recoge en la función **keyPressed()** la cual va añadiendo ejemplos mediante la función **add(label)** con las etiquetas 'Nice mask!' (al pulsar 'm') y 'No mask!' (al pulsar 'n'), creando así dos clases. 

    function keyPressed(){
      if(key=='t'){
        NN.normalizeData();
        NN.train({epochs: 50},classifyV);
      }
      if(key=='m'){
        add('Nice mask!');
        mask++;
      }
      if(key=='n'){
        add('No mask!');
        noMask++;
      }
    }


<br>La función **add(l)** comentada anteriormente, se encarga de añadir un ejemplo de la clase/etiqueta que se le pasa por parámetro mediante la función de *ml5.js* llamada **addData(in, out)**.

    function add(l){NN.addData({image: video},{l});}

<br>Respecto al entrenamiento de la red, se utiliza la función de *ml5.js* llamada **train(epochs, callFunction)** la cual se le pasa el número de épocas y una función de *callback* para saber cuando ha terminado el entrenamiento. Esta función se ha denominado **classifyV()** la cual simplemente llama a la función **classify(in, result)** la cual realiza la clasificación. Esta función, también tiene como segundo parámetro una función *callback* la cual se ha implementado para el manejo de errores (función **res(error, result)**).

    function classifyV(){NN.classify({image:video},res);}
    
    function res(e,r){
      if(!e){
        label=r[0].label;
        classifyV();
      }
    }

Finalmente, se han añadido las instrucciones paso a paso en el archivo index.html de guía para el usuario.

## Cómo ejecutar el programa
A continuación, se muestra cómo ejecutar correctamente el programa siguiendo los pasos descritos.

### Creación del conjunto de datos
Primeramente, se debe dar permiso para el acceso a la webcam y hacer click sobre el lienzo. Luego, cree el conjunto de datos moviendo su cara en diferentes lugares del canvas (hacia atrás, adelante, izquierda y derecha) y en distintos ángulos. 
* Póngase la mascarilla y presione 'm' para agregar ejemplos con mascarilla.
* Quítese la mascarilla y presione 'n' para agregar ejemplos sin mascarilla.
* **Nota:** Intente agregar tantos ejemplos como pueda para que la red neuronal tenga suficientes datos para el entrenamiento. 

**IMPORTANTE:** debe haber números de ejemplos parecidos para cada clase para no crear un conjunto de datos desbalanceado (normalmente unos 100 para cada clase son suficientes, aunque no es un número fijo ya que depende mucho de la calidad de la cámara, luminosidad de la sala...).

| ![](/My-Processing-Book/images/mask_detection/mask-dataset-demo.gif "Creación del conjunto de datos con mascarilla") | ![](/My-Processing-Book/images/mask_detection/no-mask-dataset-demo.gif "Creación del conjunto de datos sin mascarilla") |

### Entrenamiento de la red neuronal
Una vez que haya creado el conunto de datos, presione 't' para entrenar su red neuronal. La red neuronal comenzará a entrenarse y podrás visualizar la función de pérdida (que debe ir disminuyendo). La arquitectura usada es la que viene por defecto, la cual es la siguiente:


![](/My-Processing-Book/images/mask_detection/model_architecture.PNG "Arquitectura de la red neuronal")

**Nota:** Dependiendo del navegador, al iniciar el entrenamiento, el navegador puede bloquearse o avisar que hay una tarea que está relentizando el navegador (**presione 'Esperar'**). Esto depende también del tamaño de datos de entrada que se está pasando, por lo que espere pacientemente. 

| ![](/My-Processing-Book/images/mask_detection/firefox_warning.PNG "Bloqueo del navegador Firefox") | ![](/My-Processing-Book/images/mask_detection/chrome_warning.PNG "Bloqueo del navegador Chrome") |

El entrenamiento puede llevar un tiempo. Una vez que esté entrenada (50 épocas), haga clic en el botón 'Hide'.

![](/My-Processing-Book/images/mask_detection/model_architecture.PNG "Entrenamiento de la red neuronal")


### Pruebas con la red neuronal
¡Pon a prueba tu red neuronal!

Nota: Si no clasifica correctamente, es probable que necesite más ejemplos o los ejemplos tomados no son suficientemente variados. Puede reiniciar el programa para crear una nueva red neuronal actualizando el navegador. 


![](/My-Processing-Book/images/mask_detection/model_architecture.PNG "Pruebas con la red neuronal")


## Descargar código en p5.js
Para descargar el código en p5.js, acceda a: <a href="https://downgit.github.io/#/home?url=https://github.com/Prashant-JT/My-Processing-Book/tree/master/projects/mask_detection">Descargar código en p5.js</a> o acceda a la carpeta del repositorio del proyecto en: <a href="https://github.com/Prashant-JT/My-Processing-Book/tree/master/projects/mask_detection">Repositorio del proyecto</a>

---

## Probar demo 
{% include info.html text="Para probar debe abrir el enlace en un navegador. No se podrá ejecutar en dispositivos móviles" %}

| **Probar demo** | <a href="https://editor.p5js.org/Prashant-JT/full/A83fz2GLg">Dale click para probar demo</a> |

## Referencias

[Guión de prácticas](https://ncvt-aep.ulpgc.es/cv/ulpgctp21/pluginfile.php/412240/mod_resource/content/37/CIU_Pr_cticas.pdf)

[Página de p5.js](https://p5js.org/es/)

[Creación del enlace de descarga](https://downgit.github.io/#/home)

[Página de ml5.js](https://ml5js.org/)
