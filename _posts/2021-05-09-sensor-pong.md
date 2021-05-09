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

El diseño y configuración ha sido el que se puede observar en la siguiente figura. Se adjunta el <a href=" https://www.tinkercad.com/things/cknacAsoMJE">enlace de la configuración en Tinkercad</a> para visualizar la simulación y modificar el código si se desea.

![](/My-Processing-Book/images/sensor_pong/sensor-pong-tinkercard.PNG "Diseño y configuración del Arduino en Tinkercad")

## Código implementado

A continuación se describe el trabajo realizado. Se crean e inicializan las variables necesarias, como la frequencia mínima, máxima y normal la cual se establecen a 600, 60 y 250 respectivamente. Se inicializan las variables *jump* (incremento), *value* (valor en radianes del seno con rango entre -PI/2 y PI/2) y *senFreq* (resultado del seno con rango entre -1 y 1). 

    Serial arduino;
    String value = "0";

<br>En la función **setup()** se habilita el monitor serie y se establece el led incorporado en el Arduino como salida.
    
    void setup() {
      ...
      // Arduino port
      String portName = Serial.list()[0];
      arduino = new Serial(this, portName, 9600);
      ...
    }

<br>En la función **loop()** se calcula el seno de la variable *value* y se actualiza la variable. A continuación, se comprueba que esta variable esté en el rango -PI/2 y PI/2. Se cambia la frecuencia del parpadeo según el valor del seno calculado llamando la función **blinkLed()**.

    void draw() {
      if (start) {
        ...
        paddle.move(getSensorDistance());
        ...
      } else {
        ...
      }
    }
    
<br>En la función **getSensorDistance()** se habilita el monitor serie y se establece el led incorporado en el Arduino como salida.
    
    float getSensorDistance() {
      if (arduino.available() > 0) {
        value = arduino.readStringUntil('\n');
      }

      return (value != null) ? float(value) : -1;
    }
    
<br>La Clase *Paddle* se encarga de encender y apagar el led acorde a una frecuencia que es pasada como parámetro. 
    
    private float minDistance;
    private float maxDistance;
    private float posRemapped;
    
    public Paddle() {
      ...
      this.minDistance = 7.0;
      this.maxDistance = 30.0;
    }
      
<br>La función **move(distance)** se encarga de encender y apagar el led acorde a una frecuencia que es pasada como parámetro. 

    void move(float distance) {
      ...
      if (distance == -1) return;    
      if (distance > maxDistance) distance = maxDistance;
      if (distance < minDistance) distance = minDistance;
    
      // Map player 2 position 
      posRemapped = map(distance, minDistance, maxDistance, 0, height-89);
      this.posy2 = posRemapped;
    }

<br>La función **setup(freq)** se encarga de encender y apagar el led acorde a una frecuencia que es pasada como parámetro. 
      
    int IR_SENSOR = 0; // Sensor connected to the analog A0
    int sensorResult = 0; // Sensor result
    float sensorDistance = 0; // Calculated value

    void setup() {
      // Setup communication with serial monitor
      Serial.begin(9600);
    }

<br>La función **loop()** se encarga de encender y apagar el led acorde a una frecuencia que es pasada como parámetro. 

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

| ![](/My-Processing-Book/images/blink_led/blink-led-serial-demo.gif "Salida del monitor serie") |
| ![](https://media.giphy.com/media/xx9DkkDZIqvtpPQFNa/giphy.gif "Prueba del código en vivo") |


## Descargar código en Arduino
Para descargar el código en Arduino, acceda a: <a href="https://downgit.github.io/#/home?url=https://github.com/Prashant-JT/My-Processing-Book/tree/master/projects/blink_led">Descargar código en Arduino</a> o acceda a la carpeta del repositorio del proyecto en: <a href="https://github.com/Prashant-JT/My-Processing-Book/tree/master/projects/blink_led">Repositorio del proyecto</a>

<a href="https://josemap-99.github.io/2021/05/08/blink_led.html"><b>Repositorio del proyecto de José María Amusquívar Poppe</b></a>

<a href="#"><b>Repositorio del proyecto de Fabián Alfonso Beirutti Pérez</b></a>

---

## Referencias

[Guión de prácticas](https://ncvt-aep.ulpgc.es/cv/ulpgctp21/pluginfile.php/412240/mod_resource/content/37/CIU_Pr_cticas.pdf)

[Página de Arduino](https://www.arduino.cc/)

[Creación del enlace de descarga](https://downgit.github.io/#/home)
