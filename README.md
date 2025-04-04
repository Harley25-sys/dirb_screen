# HERRAMIENTA DIRB_SCREEN

#### Script Bash para reconocimiento visual y fingerprinting de tecnologías en rutas descubiertas con herramientas como **Gobuster** y **WhatWeb**.  
#### Genera capturas automáticas con **Chromium** y detecta tecnologías, mostrando un resumen con colores en consola y exportando un log limpio en `.txt`.

---

## 🧑‍💻 Autor

- 🧑‍💻 **wintxx**
- 🌐 [GitHub: Jean25-sys](https://github.com/Jean25-sys/)
---

## USO
### 1 PASO: Clonar el script o copiar
```ruby
wget https://github.com/Jean25-sys/dirb_screen/
```
Asignarle permisos de ejecución
```ruby
chmod +x dirb_screen.sh
```

### 2 PASO: Enumerar con Dirbuster
Cuando hacemos una enumeración con Dirbuster obtenemos lo siguiente
```ruby
gobuster dir -u http://172.17.0.2/wordpress/ -w /usr/share/seclists/Discovery/Web-Content/directory-list-lowercase-2.3-medium.txt -x html,txt,php,xml,csva,txt,html -t 20 -b 500,502,404 > resultados.txt
```
![dirb](https://github.com/Jean25-sys/dirb_screen/blob/main/images/dirb.png)

 lo exportamos en `.txt` y realizamos una limpieza sencilla con awk
  
![no clear](https://github.com/Jean25-sys/dirb_screen/blob/main/images/no_clear.png)

### 3 PASO: Hacer Limpieza de la ruta de los directorios con *AWK*
```ruby
awk '{print "http://172.17.0.2/wordpress"$1}' resultados.txt > result_limpios.txt
```
> ![+] Ustedes pongan la URL a la que ustedes le hayan aplicado la enumeracion con Dirbuster, esto es un ejemplo

![clear](https://github.com/Jean25-sys/dirb_screen/blob/main/images/clean.png)

### 4 PASO: Pasarle la ruta de directorios limpios al *Script*

```ruby
./dirb_screen.sh result_limpios.txt
```
## RESULTADOS
Podemos observar que Captura el Screenshot a los directorios que ha enumerado `Gobuster` y además nos muestra algo parecido a un log, utilizando `WhatWeb` para mostrar las tecnologías que estan corriendo por detrás
- **URL**
- **Código HTTP**
- **Captura**
- **Fecha**
- **Tecnologías**
![script_ejecution](https://github.com/Jean25-sys/dirb_screen/blob/main/images/script_ejecution.png)

Podemos ver que ignora a los códigos `HTTP: 403, 404, 405` porque son códigos que no nos interesan
## EXPORTA
- 1 CARPETA `./capturas_web` en el directorio donde se está trabajando que contiene las capturas de cada URL:
![captures](https://github.com/Jean25-sys/dirb_screen/blob/main/images/captures.png)
![one_capture](https://github.com/Jean25-sys/dirb_screen/blob/main/images/one_capture.png)

- UN `resumen.txt` QUE CONTIENE LA INFORMACIÓN QUE IMPRIME POR CONSOLA SI QUEREMOS ECHAR UN VISTAZO MAS A DETALLE
```ruby
batcat -l java resumen_web.txt
```
![resumen](https://github.com/Jean25-sys/dirb_screen/blob/main/images/resumen_.png)


# GRACIAS
