class Rutina {

    method caloriasQueQuema(tiempo) {
        return 100 * (tiempo - self.descanso(tiempo)) * self.intensidad()
    }

    method descanso(tiempo) 
    method intensidad()
}

class Running inherits Rutina {

    const intensidad 

    override method intensidad() {
        return intensidad
    }

    override method descanso(tiempo) {
        return if (tiempo > 20) {
            5
        } else {
            2
        }
    }
}

class Maraton inherits Running {
    
    override method caloriasQueQuema(tiempo) {
        return super(tiempo) * 2
    }
}

class Remo inherits Rutina {

    override method intensidad() {
        return 1.3
    }

    override method descanso(tiempo) {
        return tiempo / 5

    }
    
}

class RemoDeCompeticion inherits Remo {

    override method intensidad() {
        return 1.7
    }

    override method descanso(tiempo) {
        return (super(tiempo) - 3).max(2)
    }
    
}

class Persona {

    var property peso
    
    method hacerRutina(rutina) {
        self.validarRutina(rutina)
        peso = peso - self.pesoQuePierde(rutina) 
    }

//Cuidado, no siempre pueden hacer una rutina, cada tipo de persona tiene su regla
    method validarRutina(rutina) {
        if (not self.puedeRealizar(rutina)) {
            self.error("No puede realizar la rutina en cuestion")
        }
    }

    method puedeRealizar(rutina)

    method pesoQuePierde(rutina) {
        return self.caloriasQueGasta(rutina) / self.kilosPorCaloriaQuePierde()
    }

    method caloriasQueGasta(rutina) {
        return rutina.caloriasQueQuema(self.tiempo())
    }

    method kilosPorCaloriaQuePierde() 

// El tiempo que ejercitan una rutina depende del tipo de persona en cuestión
    method tiempo()    
}

class Sedentaria inherits Persona {

// El tiempo que ejercita una rutina se establece para cada persona sedentaria
    var property tiempo

    override method kilosPorCaloriaQuePierde() {
        return 7000
    }

//  solo aplican una rutina si su peso es mayor a 50
    override method puedeRealizar(rutina) {
        return self.peso() > 50 
    }
}

class Atleta inherits Persona {
    
    override method pesoQuePierde(rutina) {
        return super(rutina) - 1
    }
    
    override method kilosPorCaloriaQuePierde() {
        return 8000
    }

    override method tiempo() {
        return 90
    }

    override method puedeRealizar(rutina) {
        return rutina.caloriasQueQuema(self.tiempo()) > 10000
    }
}

class Club {
    
    const predios = #{}

// El mejor predio de un club para una persona: Es el predio que más calorías le 
// haría quemar a esa persona si ésta practicara todas las rutinas una vez.
    method mejorPredio(persona) {
        return predios.max({predio => predio.caloriasDeTodasLasRutinas(persona)}) // Ellos caloriasDeCircuito(persona)
    }

// Los predios tranquis de un club para una persona:  
// una rutina que le hace gastar menos de 500 calorias a la persona
// De un **predio** se conoce las rutinas que se pueden practicar
    method prediosMasTranqui(persona){
        return predios.filter({predio => predio.esTranquilo(persona)}) 
    }

// Las rutinas más exigentes del club para una persona: Es el conjunto
// formado por la rutina más exigente de cada predio para esa persona. La rutina más 
// exigente es la que más calorías le hace quemar a esa persona
    method rutinasExigentes(persona){
		return predios.map({predio => predio.rutinaMasExigente(persona)}).asSet()
	} 
}

class Predio {

// De un **predio** se conoce las rutinas que se pueden practicar
	const rutinas = #{}

	method caloriasDeTodasLasRutinas(persona) {
		return rutinas.sum({ rutina => persona.caloriasQueGasta(rutina) })
	}

	method esTranquilo(persona) {
		return rutinas.any({ rutina => persona.caloriasQueGasta(rutina) < 500 })
	}

	method rutinaMasExigente(persona){
		return rutinas.max({rutina => persona.caloriasQueGasta(rutina)})
	}

}
