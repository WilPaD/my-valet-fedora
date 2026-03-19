# valet-fedora

Puerto de [Laravel Valet](https://laravel.com/docs/valet) para Fedora/Linux.

Entorno de desarrollo local con nginx, PHP-FPM, dnsmasq (via NetworkManager) y soporte completo de SELinux.

## Requisitos

```bash
sudo dnf install nginx php-fpm php-cli dnsmasq openssl acl bind-utils git \
                 policycoreutils-python-utils composer
```

## Instalación rápida (desde source)

```bash
git clone git@github.com:WilPaD/my-valet-fedora.git
cd my-valet-fedora
./install.sh
valet install
```

## Instalación desde RPM (build local)

### Prerequisitos

```bash
sudo dnf install rpm-build rpmdevtools rpmlint
```

### Construir e instalar

```bash
# 1. Clona el repositorio
git clone git@github.com:WilPaD/my-valet-fedora.git
cd my-valet-fedora

# 2. Construye el RPM
make rpm

# 3. Instala el RPM generado
sudo dnf install ~/rpmbuild/RPMS/noarch/valet-fedora-$(cat VERSION)-1.*.noarch.rpm

# 4. Configura el entorno (una vez por usuario)
valet install
```

### Otros targets disponibles

| Comando | Descripción |
|---|---|
| `make rpm` | Construye el RPM binario |
| `make srpm` | Construye el SRPM (para Copr) |
| `make lint` | Valida el spec con rpmlint |
| `make install-dev` | Instalación desde source para desarrollo |
| `make clean` | Limpia artefactos de build |

## Uso básico

```bash
valet install                        # Configura nginx, PHP-FPM y DNS
valet park ~/Proyectos               # Cada subcarpeta = un sitio .test
valet list                           # Lista los sitios activos
valet version                        # Muestra la versión instalada
```

## Comandos

### Sitios
```bash
valet park [ruta]                    # Parquea una carpeta
valet forget [ruta]                  # Elimina un parqueo
valet link [nombre]                  # Enlaza el directorio actual
valet unlink [nombre]                # Elimina un enlace
valet new [nombre]                   # Crea un proyecto Laravel nuevo
valet list                           # Lista todos los sitios
```

### PHP
```bash
valet use php@8.2                    # Cambia PHP global
valet use php@8.2 --site=mi-app     # Cambia PHP de un sitio
valet use system                     # Restaura PHP del sistema
valet xdebug on                      # Activa Xdebug (puerto 9003)
```

### HTTPS
```bash
valet secure mi-app                  # Habilita HTTPS con cert autofirmado
valet unsecure mi-app                # Deshabilita HTTPS
```

### Diagnóstico
```bash
valet diagnose                       # Reporte de estado del sistema
valet which                          # PHP activo en el directorio actual
```

## PHP shim

`valet install` instala un shim en `~/.local/bin/php` que detecta automáticamente
la versión de PHP según el archivo `.php-version` del proyecto. Funciona con
VS Code, Zed, JetBrains y cualquier herramienta que invoque `php` desde el
directorio del proyecto.

```bash
# El shim resuelve en este orden:
# 1. .php-version en el proyecto (o directorio padre)
# 2. ~/.config/valet/default-php (valet use global)
# 3. /usr/bin/php (sistema)
```

## Licencia

MIT
