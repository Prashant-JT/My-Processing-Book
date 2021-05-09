# Sensor pong (Processing y Arduino)
> Realizado por José María Amusquívar Poppe, Fabián Alfonso Beirutti Pérez y Prashant Jeswani Tejwani

Índice del contenido:

1. TOC
{:toc}

## Introducción
Se programa una interfaz que utiliza la información de distancia suministrada por el sensor Sharp GP2D12, leída a través del Arduino, para controlar el movimiento de la pala del Jugador 2 en el juego Pong implementado con Processing. Se ha reutilizado y refactorizado en clases el código del [juego multijugador](https://prashant-jt.github.io/My-Processing-Book/2021/02/09/pong.html) implementado anteriormente. A continuación:

* Se describe el trabajo realizado argumentando las decisiones adoptadas para la solución propuesta
* Se incluye las referencias y herramientas utilizadas
* Se muestra el resultado con un gif animado

## Diseño y configuración 

El diseño y configuración ha sido el que se puede observar en la siguiente figura. Se adjunta el <a href="https://www.tinkercad.com/things/e77wAqxA3kJ">enlace de la configuración en Tinkercad</a> para visualizar las conexiones del Arduino. El conexionado de cada cable del sensor de distancia a las señales que correspondan en la tarjeta es el siguiente: rojo = 5v, negro = GND y amarillo = A0.

![](/My-Processing-Book/images/sensor_pong/sensor-pong-tinkercard.PNG "Diseño y configuración del Arduino en Tinkercad")

## Código implementado

A continuación se describe el trabajo realizado. Respecto el código de Processing, se crean e inicializan las variables necesarias para el correcto funcionamiento y establecimiento de la conexión con Arduino.

    Serial arduino;
    String value = "0";

<br>En la función **setup()** se obtiene una lista de todos los puertos serie disponibles y se escoge el puerto adecuado. A continuación, se crea objeto *Serial* para leer los datos que son enviados desde Arduino a través de la función **Serial.println(msg)** (véase la función **loop()** del programa en Arduino).

**Nota:** Se deberá escoger el mismo puerto que se esté utilizando en Arduino (en nuestro caso es el primero de la lista).

    void setup() {
      ...
      // Arduino port
      String portName = Serial.list()[0];
      arduino = new Serial(this, portName, 9600);
      ...
    }

<br>En la función **draw()** se llama la función **move()** de la clase *Paddle* para el movimiento de las palas de los jugadores. Como el movimiento de la pala del el jugador 2 se realiza mediante el sensor, se pasa como parámetro la distancia mediante la función **getSensorDistance()**.

    void draw() {
      if (start) {
        ...
        paddle.move(getSensorDistance());
        ...
      } else {
        ...
      }
    }
    
<br>La función **getSensorDistance()** devuelve la distancia en cm obtenida de Arduino, en el caso de que el valor sea nulo se devuelve -1.
    
    float getSensorDistance() {
      if (arduino.available() > 0) {
        value = arduino.readStringUntil('\n');
      }

      return (value != null) ? float(value) : -1;
    }
    
<br>La Clase *Paddle* representa las palas de ambos jugadores. Para el jugador 2 se inicializan las variables para establecer un rango mínimo y máximo de distancia.  
    
    ...
    private float minDistance;
    private float maxDistance;
    private float posRemapped;
    
    public Paddle() {
      ...
      this.minDistance = 7.0;
      this.maxDistance = 30.0;
    }
      
<br>La función **move(distance)** se encarga mover las palas de ambos jugadores. Para el movimiento de pala del jugador 2, la variable *posRemapped* mapea la distancia obtenida de la mano entre 0 y la parte inferior del tablero de juego.

    void move(float distance) {
      ...
      if (distance == -1) return;    
      if (distance > maxDistance) distance = maxDistance;
      if (distance < minDistance) distance = minDistance;
    
      // Map player 2 position 
      posRemapped = map(distance, minDistance, maxDistance, 0, height-89);
      this.posy2 = posRemapped;
    }

<br>Respecto el código de Arduino, se inicializan las variables que almacenarán los resultado obtenidos del sensor de distancia, conectando el sensor en el pin analógico A0. En la función **setup()** se abre el monitor de serie para visualizar la distancia que se obtiene. 
      
    int IR_SENSOR = 0; // Sensor connected to the analog A0
    int sensorResult = 0; // Sensor result
    float sensorDistance = 0; // Calculated value

    void setup() {
      // Setup communication with serial monitor
      Serial.begin(9600);
    }

<br>La función **loop()** se encarga de leer el valor del sensor y convertirlo en centímetros el cual se manda a Processing. [^1]

    void loop() {
      // Read the value from the ir sensor
      sensorResult = analogRead(IR_SENSOR);
      // Calculate distance in cm
      sensorDistance = (6787.0 / (sensorResult - 3.0)) - 4.0;
      // Send distance to Processing
      Serial.println(sensorDistance);
      delay(200); // Wait
    } 
      
<br>A continuación, se muestra el resultado final mediante un gif animado: 

| ![](/My-Processing-Book/images/sensor_pong/sensor-pong-canvas-demo.gif "Pong en Processing") | ![](/My-Processing-Book/images/sensor_pong/sensor-pong-demo.gif "Prueba del código en vivo del jugador 2") |


## Descargar código en Arduino
Para descargar el código en Arduino, acceda a: <a href="https://downgit.github.io/#/home?url=https://github.com/Prashant-JT/My-Processing-Book/tree/master/projects/sensor_pong">Descargar código en Arduino</a> o acceda a la carpeta del repositorio del proyecto en: <a href="https://github.com/Prashant-JT/My-Processing-Book/tree/master/projects/sensor_pong">Repositorio del proyecto</a>

<a href="https://josemap-99.github.io/2021/05/08/blink_led.html"><b>Repositorio del proyecto de José María Amusquívar Poppe</b></a>

<a href="#"><b>Repositorio del proyecto de Fabián Alfonso Beirutti Pérez</b></a>

---

## Referencias

[Guión de prácticas](https://ncvt-aep.ulpgc.es/cv/ulpgctp21/pluginfile.php/412240/mod_resource/content/37/CIU_Pr_cticas.pdf)

[Página de Arduino](https://www.arduino.cc/)

[Creación del enlace de descarga](https://downgit.github.io/#/home)
