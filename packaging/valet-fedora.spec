# Version se pasa desde el Makefile: rpmbuild -D "app_version X.Y.Z"
# Fallback a 0.0.0 si se construye manualmente sin -D
%{!?app_version: %global app_version 0.0.0}

Name:           valet-fedora
Version:        %{app_version}
Release:        1%{?dist}
Summary:        Laravel Valet local development environment for Fedora

License:        MIT
URL:            https://github.com/usuario/valet-fedora
Source0:        %{name}-%{version}.tar.gz

BuildArch:      noarch

# Servidor web
Requires:       nginx

# PHP — acepta sistema o Remi
Requires:       php-cli
Requires:       php-fpm

# DNS wildcard via NetworkManager
Requires:       dnsmasq

# Herramientas de sistema
Requires:       openssl
Requires:       acl
Requires:       bind-utils
Requires:       git-core
Requires:       policycoreutils-python-utils

# Composer: recomendado (puede estar en /usr/local/bin si se instaló manualmente)
Recommends:     composer

%description
Puerto de Laravel Valet para Fedora/Linux.

Proporciona un entorno de desarrollo local con:
 - nginx como servidor web con wildcard por directorio
 - PHP-FPM configurable por proyecto (compatible con versiones Remi)
 - dnsmasq integrado en NetworkManager para DNS wildcard (*.test)
 - PHP shim en ~/.local/bin para detección automática de versión en IDEs
 - Soporte completo de SELinux en modo Enforcing

Uso tras la instalación:
  valet install          Configura el entorno para el usuario actual
  valet park ~/Projects  Parquea una carpeta de proyectos
  valet list             Lista los sitios activos

%prep
%autosetup

%check
bash -n valet

%install
install -Dm755 valet        %{buildroot}%{_bindir}/valet
install -Dm644 LICENSE      %{buildroot}%{_licensedir}/%{name}/LICENSE

%files
%license LICENSE
%{_bindir}/valet

%post
echo ""
echo "valet-fedora %{version} instalado."
echo "Ejecuta como tu usuario: valet install"
echo ""

%preun
if [ $1 -eq 0 ]; then
    echo ""
    echo "AVISO: Ejecuta 'valet uninstall' antes de eliminar el paquete"
    echo "       para restaurar la configuración del sistema."
    echo ""
fi

%changelog
* Wed Mar 18 2026 Wilbert <wilbert@fedora> - 1.0.0-1
- Release inicial
