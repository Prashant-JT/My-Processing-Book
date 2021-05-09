# Sensor pong (Processing y Arduino)
> Realizado por José María Amusquívar Poppe, Fabián Alfonso Beirutti Pérez y Prashant Jeswani Tejwani

Índice del contenido:

1. TOC
{:toc}

## Introducción
Se programa una interfaz que utiliza la información de distancia suministrada por el sensor Sharp GP2D12, leída a través del Arduino, para controlar el movimiento de la pala del Jugador 2 en el juego Pong implementado con Processing. Se ha reutilizado y refactorizado en clases el código del juego multijugador implementado anteriormente ([código](https://prashant-jt.github.io/My-Processing-Book/2021/02/09/pong.html)).A continuación:

* Se describe el trabajo realizado argumentando las decisiones adoptadas para la solución propuesta
* Se incluye las referencias y herramientas utilizadas
* Se muestra el resultado con un gif animado

## Diseño y configuración 

El diseño y configuración ha sido el que se puede observar en la siguiente figura. Se adjunta el <a href=" https://www.tinkercad.com/things/cknacAsoMJE">enlace de la configuración en Tinkercad</a> para visualizar la simulación y modificar el código si se desea.

![](/My-Processing-Book/images/blink_led/blink-led-tinkercad-demo.gif "Diseño, configuración y simulación del Arduino en Tinkercad")

## Código implementado

A continuación se describe el trabajo realizado. Se crean e inicializan las variables necesarias, como la frequencia mínima, máxima y normal la cual se establecen a 600, 60 y 250 respectivamente. Se inicializan las variables *jump* (incremento), *value* (valor en radianes del seno con rango entre -PI/2 y PI/2) y *senFreq* (resultado del seno con rango entre -1 y 1). 

    // En milisegundos
    const float threshold = 0.75;
    const int freqMax = 60;
    const int freqMin = 600;
    const int freqNormal = 250;
    
    float jump = 0.1;
    float value = 0;
    float senFreq = 0;

<br>En la función **setup()** se habilita el monitor serie y se establece el led incorporado en el Arduino como salida.
    
    void setup() {  
      Serial.begin(9600);
      pinMode(LED_BUILTIN, OUTPUT);
    }

<br>En la función **loop()** se calcula el seno de la variable *value* y se actualiza la variable. A continuación, se comprueba que esta variable esté en el rango -PI/2 y PI/2. Se cambia la frecuencia del parpadeo según el valor del seno calculado llamando la función **blinkLed()**.

    void loop() {
      senFreq = sin(value);
      value += jump;

      if (value >= PI/2 || value <= -PI/2) jump = -jump;

      Serial.println(senFreq);

      if (senFreq > threshold) {
        blinkLed(freqMax);
      } else if (senFreq < -threshold) {
        blinkLed(freqMin);                       
      } else {
        blinkLed(freqNormal);
      }
    }
    
<br>La función **blinkLed(freq)** se encarga de encender y apagar el led acorde a una frecuencia que es pasada como parámetro. 
      
    void blinkLed (int freq) {
      digitalWrite(LED_BUILTIN, HIGH);  
      delay(freq);
      digitalWrite(LED_BUILTIN, LOW);    
      delay(freq);  
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
