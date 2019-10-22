class Estudiante {

	var aprobaciones = []
	var carreras = []

	method registrarAprobacion(materia, nota) {
		if (not aprobaciones.any({ aprob => aprob.materia() == materia})) {
			aprobaciones.add(new Aprobacion(nota = nota, materia = materia))
		} else {
			self.error("Ya está aprobada")
		}
	}

	method materiasDeLasCarrerasInscripto() {
		return carreras.flatMap({ car => car.materias() })
	}

	method inscribirseACarrera(carrera) {
		carreras.add(carrera)
	}

	method estaAprobada(materia) {
		return aprobaciones.any({ aprob => aprob.materia() == materia })
	}

	method cantMateriasAprobadas() {
		return aprobaciones.size()
	}

	method promedio() {
		return aprobaciones.sum({ aprob => aprob.nota() }) / self.cantMateriasAprobadas()
	}

	method puedeInscribirse(materia) {
		return self.materiasDeLasCarrerasInscripto().contains(materia) and not self.estaAprobada(materia) and not materia.estudiantesInscriptos().contains(self) and not materia.listaDeEspera().contains(self) and materia.requisitos().all({ mat => self.estaAprobada(mat) })
	}

	method inscribirseA(materia) {
		if (self.puedeInscribirse(materia)) {
			materia.inscribirEstudiante(self)
		} else {
			self.error("No se pudo inscribir")
		}
	}

	method materiasInscripto() {
		return self.materiasDeLasCarrerasInscripto().filter({ materia => materia.estudiantesInscriptos().contains(self) })
	}

	method todasLasMaterias() {
		return carreras.map({ carrera => carrera.materias() }).flatten()
	}

	method puedeCursar(materia) {
		return self.materiaEstaEnCarrerasQueEstoyCursando(materia) and not self.tieneAprobada(materia) and not self.estaInscripto(materia) and self.tieneTodosLosRequisitos(materia)
	}

	method inscribir(materia) {
		if (not self.puedeCursar(materia)) {
			self.error("no puedo cursar")
		}
		materia.anotar(self)
	}

	method tieneTodosLosRequisitos(materia) {
		return materia.requisitos().all({ req => self.tieneAprobada(req) })
	}

	method materiaEstaEnCarrerasQueEstoyCursando(materia) {
		return self.todasLasMaterias().contains(materia)
	}

	method tieneAprobada(materia) {
		return aprobaciones.any({ matApr => matApr.materia() == materia })
	}

	method tieneAprobada_variante(materia) {
		var matAprobadas = aprobaciones.map({ apr => apr.materia() })
		return matAprobadas.contains(materia)
	}

	method estaInscripto(materia) {
		return materia.inscriptos().contains(self)
	}

}

class Materia {

	var property requisitos = []
	var property estudiantesInscriptos = []
	var property listaDeEspera = []
	var property cantidadMaximaDeEstudiantes

	method correlativa(materia) {
		requisitos.add(materia)
	}

	method inscribirEstudiante(estudiante) {
		if (estudiantesInscriptos.size() <= cantidadMaximaDeEstudiantes) {
			estudiantesInscriptos.add(estudiante)
		} else {
			listaDeEspera.add(estudiante)
		}
	}

	method darDeBaja(estudiante) {
		estudiantesInscriptos.remove(estudiante)
		if (not listaDeEspera.isEmpty()) {
			estudiantesInscriptos.add(listaDeEspera.head())
			listaDeEspera.remove(listaDeEspera.head())
		}
	}

}

class Aprobacion {

	var property nota
	var property materia

}

class Carrera {

	var property materias = []

	method registrar(materia) {
		materias.add(materia)
	}

}

