# Contribuyendo a Reporte Ciudadano

El [issue tracker](https://github.com/CodeandoMexico/reporte-ciudadano/issues)
es el canal por el cual nos comunicamos para dar a conocer los [bugs](#reportando-bugs-dentro-de-reporte-ciudadano)
de la plataforma, subir [pull requests](#pull-requests) y
proponer [nuevas funcionalidades](#nuevas-funcionalidades). El mantener la
comunicación por este medio nos ayuda a que toda nuestra comunidad pueda
participar dentro de las discusiones y que el crecimiento de nuestra
plataforma se de de una manera transparente.

## Bugs

Para reportar fallas dentro de nuestra plataforma se debe de crear un [nuevo issue](https://github.com/CodeandoMexico/reporte-ciudadano/issues/new) dentro de nuestro [issue tracker](https://github.com/CodeandoMexico/reporte-ciudadano/issues). Te presentamos unos tips para reportar estas fallas de la plataforma:

- Verificar que el problema no se haya arreglado ya, descargando el código que
se encuentra dentro del branch de `master` y tratando de reproducir la falla.

- Agregar fotografías del error si es posible.

- Describir detalladamente cual era el comportamiento esperado y que fue
lo que en realidad sucedió.

- Agregar informción valiosa como explorador usado, sistema operativo, versión
de la plataforma, pasos para reproducir el error.

**Nota**: Es importamente redactar la falla de manera muy detallada para que sea fácil para otros reproducir el problema y así se busque una solución al problema.

## Nuevas funcionalidades

Las ideas nuevas son bienvenidas al proyecto. Si deseas compartir nuevas ideas
con nosotros puedes detallar cual sería la funcionalidad y podemos discutirlo.
Es importante tomar en cuenta que las funcionalidades deben de ser generales
para que otras instancias puedan hacer uso de ellas de la mejor manera.

## Pull requests

La mejor manera de ayudarnos es por medio de código. Los pasos para aportar al proyecto son los siguientes:

1. Crea un [fork](http://help.github.com/fork-a-repo/) del proyecto, clónalo
a tu computadora y configura los remotos:

   ```bash
   # Clonando el repositorio a mi directorio actual
   git clone https://github.com/<tu-nombre-usuario>/reporte-ciudadano.git

   # Ir al directorio
   cd reporte-ciudadano

   # Crear un remote nuevo apuntando al repositorio original
   git remote add upstream https://github.com/CodeandoMexico/reporte-ciudadano.git
   ```

2. Si ya existe un clon en tu computadora asegúrate de que este actualizado:

   ```bash
   git checkout master
   git pull upstream master
   ```

3. Crea un branch para tu funcionalidad:
   ```bash
   git checkout -b <nombre-del-branch>
   ```

4. Utiliza [rebase interactive](https://help.github.com/articles/interactive-rebase)
para compactar tus commits antes de hacerlos públicos. Si existe un issue
relacionado favor de ligarlo en el mensaje del commit. Algunos tips sobre como redactar un buen mensaje de commit los puedes encontrar en este [post](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html) de Tim Pope.

5. Realiza un merge (o rebase) local al branch de `master` en nuestro repositorio.

   ```bash
   git pull [--rebase] upstream master
   ```

6. Empuja tus cambios a tu fork:

   ```bash
   git push origin <topic-branch-name>
   ```

7. [Abre un Pull Request](https://help.github.com/articles/using-pull-requests/)
con el título y descripción necesaria. Nota: El PR debe de estar echo hacia
`master`.

### Licencia

Creado por [Codeando México](https://github.com/CodeandoMexico?tab=members), 2013 - 2014.

Disponible bajo la licencia GNU Affero General Public License (AGPL) v3.0. Ver el documento [LICENSE](/LICENSE) para más información.
