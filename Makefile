NAME    := valet-fedora
VERSION := $(shell cat VERSION)
SPEC    := packaging/$(NAME).spec
TARBALL := $(NAME)-$(VERSION).tar.gz

RPMBUILD_DIR := $(HOME)/rpmbuild
SOURCES_DIR  := $(RPMBUILD_DIR)/SOURCES
SPECS_DIR    := $(RPMBUILD_DIR)/SPECS
RPMS_DIR     := $(RPMBUILD_DIR)/RPMS
SRPMS_DIR    := $(RPMBUILD_DIR)/SRPMS

.PHONY: all rpm srpm lint install-dev clean help

all: rpm

## Construye el RPM binario
rpm: $(SOURCES_DIR)/$(TARBALL)
	rpmbuild -bb -D "app_version $(VERSION)" $(SPEC)
	@echo ""
	@echo "RPM generado en: $(RPMS_DIR)/noarch/$(NAME)-$(VERSION)-1*.rpm"

## Construye el SRPM (para subir a Copr)
srpm: $(SOURCES_DIR)/$(TARBALL)
	rpmbuild -bs -D "app_version $(VERSION)" $(SPEC)
	@echo ""
	@echo "SRPM generado en: $(SRPMS_DIR)/$(NAME)-$(VERSION)-1*.src.rpm"

## Valida el spec con rpmlint
lint:
	rpmlint $(SPEC)

## Instala desde source para desarrollo (equivale a ./install.sh)
install-dev:
	bash install.sh

## Crea el tarball y lo copia a ~/rpmbuild/SOURCES
$(SOURCES_DIR)/$(TARBALL): $(SOURCES_DIR)
	git archive --prefix=$(NAME)-$(VERSION)/ HEAD \
	  | gzip > $(SOURCES_DIR)/$(TARBALL)
	@echo "Tarball: $(SOURCES_DIR)/$(TARBALL)"

## Crea la estructura de rpmbuild si no existe
$(SOURCES_DIR):
	rpmdev-setuptree

## Limpia artefactos de build
clean:
	rm -f $(SOURCES_DIR)/$(NAME)-*.tar.gz
	rm -rf $(RPMBUILD_DIR)/BUILD/$(NAME)-*
	@echo "Limpiado"

help:
	@echo "Targets disponibles:"
	@echo "  make rpm         Construye el RPM binario"
	@echo "  make srpm        Construye el SRPM para Copr"
	@echo "  make lint        Valida el spec con rpmlint"
	@echo "  make install-dev Instala desde source (desarrollo)"
	@echo "  make clean       Elimina artefactos de build"
	@echo ""
	@echo "Versión actual: $(VERSION)"
