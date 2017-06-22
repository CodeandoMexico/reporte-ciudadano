## Evalúa tu trámite Puebla

[Licencia](/LICENSE)

### Desarrollo
Si usas Docker, puedes correr `make` para tener todo listo:
- App: `localhost:3000`
- Database: `localhost:5432`

Para cambiar los puertos, recuerda que puedes modificar el
`docker-compose.override.yml`

### Deploy
En nuestro `Makefile` tenemos especificado un target `deploy`.

Para correr el target, es necesario tener un
`docker-compose.production.yml` que describe los servicios que
se usarán en producción, también es necesario un `.env.production`
que contiene las variables de ambiente:

```bash
HOST=user@hostname \
HOST_DIR=/var/www/app \
make deploy
```

Pasos:
- Construir la imagen de la aplicación
- Subirla a un registro
- Bajar la imagen en el _host_ donde se quiera correr la aplicación
- Levantar los servicios correspondientes
- Hacer un setup de la base de datos

#### Dependencias
- Bash
- SSH
- Docker >= 17.01.0-ce
- docker-compose >= 1.11.2

#### Si es una instalación nueva
Asegurate de los prerrequisitos anteriores y utiliza el comando:

`knife solo bootstrap usuario@dominio`

Para más información de la implementación de estos scripts de deploy ver: [knife-solo](https://matschaffer.github.io/knife-solo/)

### ¿Dudas?

Escríbenos a <equipo@codeandomexico.org>.

### Equipo

El proyecto ha sido iniciado por [Codeando México](https://github.com/CodeandoMexico?tab=members).
El core team:
- [Eddie Ruvalcaba](https://github.com/eddie-ruva)
- [Juan Pablo Escobar](https://github.com/juanpabloe)
- [Abraham Kuri](https://github.com/kurenn)
- [Noé Domínguez](https://github.com/poguez)
- [Abi Sosa](https://github.com/abisosa)
- [Miguel Morán](https://github.com/mikesaurio)

### Licencia

Creado por [Codeando México](https://github.com/CodeandoMexico?tab=members), 2013 - 2015.
Disponible bajo la licencia GNU Affero General Public License (AGPL) v3.0. Ver el documento [LICENSE](/LICENSE) para más información.


### Testing

Asegúrate de instalar geckodriver y exportar el PATH en tu entorno.


### Migración de dependencias, unidades administrativas y cis a base de datos

Si estás usando rake db:seed todo está bien, el archivo `seeds.rb` invoca a la tarea encargada de migrar

Si deseas hacer la migración manual ejecuta:

```
$ bundle exec rake organisations:migrate
```
