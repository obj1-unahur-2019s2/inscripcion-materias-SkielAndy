
class Estudiante{
	var aprobaciones= []
	var carreras=[]
	var inscripciones=[]
	method registrarAprobacion(materia,nota){
		if(not aprobaciones.any({aprob=>aprob.materia()==materia}) ){
			aprobaciones.add(new Aprobacion(nota=nota,materia=materia))
		}
		else{self.error("Ya esta aprobada")}	
	}
	method materiasDeLasCarrerasInscripto(){
		return carreras.flatMap({car=>car.materias()})
	}
	method materiasAprobadas(){
		return aprobaciones.map({aprob=>aprob.materia()})
	}
	method cantDeMateriasAprobadas(){
		return self.materiasAprobadas().size()
	}
	method promedio(){
		var notas=aprobaciones.map({aprob=>aprob.nota()})
		return notas.sum() / self.cantDeMateriasAprobadas()
	}
	method estaEnSuCarrera(materia){
		return self.materiasDeLasCarrerasInscripto().contains(materia)
	}
	method aprobo(materia){
		return self.materiasAprobadas().contains(materia)
	}	
	method noEstaInscripto(materia){
		return not inscripciones.contains(materia)
	}
	method mapDeRequisitos(materia){
		return materia.requisitos()
	}
	method cumpleLosRequisitos(materia){
		return self.mapDeRequisitos(materia).all({
			e=> e.aprobo(materia)})
	}
	method puedeInscribirseA(materia){
		return self.estaEnSuCarrera(materia) and
			not self.aprobo(materia) and self.noEstaInscripto(materia) and 
			self.cumpleLosRequisitos(materia)
	}
	method cupoOLista(materia,estudiante){
		if (materia.cupos().size() <30){
			materia.cupos().add(estudiante)
			inscripciones.add(materia)
		}else{
			materia.listaDeEspera().add(estudiante)
		}
	}
	method incribirA_A(estudiante,materia){
		if (self.puedeInscribirseA(materia)){
			self.cupoOLista(materia,estudiante)
		}else{self.error("No se cumplen las condiciones")}
	}
	
}

class Aprobacion{
//se necesita la clase aprobacion porque exite una relacion de muchos a muchos
	var property nota
	var property materia
}
class Materia{
	var property requisitos=[]//guarda una lista de materias
	var property cupos=[]
	var property listaDeEspera=[]
	
	method enQueListaEsta(estudiante,materia){
		if (materia.cupos().contains(estudiante)){
			materia.cupos().remove(estudiante)
			if (not materia.listaDeEspera().isEmpty()){
				materia.cupos().add(materia.listaDeEspera().first())
				materia.listaDeEspera().remove(materia.listaDeEspera().first())
			}
		}else{
			materia.listaDeEspera().remove(estudiante)
		}
	}
	method darDeBaja(materia,estudiante){
	    if(not estudiante.noEstaInscripto()){
	    	self.enQueListaEsta(estudiante, materia)
	    }else{
	    	self.error("no esta inscripto en la materia")
	    }
	}
	method resultadosDeInscripcion(materia){
		return materia.cupos() + materia.listaDeEspera()
	}
}
