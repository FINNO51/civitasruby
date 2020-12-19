# encoding:utf-8

module Civitas
  class Casilla_Sorpresa < Casilla
    def initialize(mazo, nombre)
      super(nombre)
      @mazo = mazo
    end

    def recibe_jugador(iactual, todos)

       if jugador_correcto(iactual, todos)
         @sorpresa = @mazo.siguiente()
         informe(iactual, todos)
         @sorpresa.aplicar_a_jugador(iactual, todos)
       end

    end

    def to_string()
      puts " Tipo: #{@tipo}"
      puts " Nombre: #{@nombre}"
      puts " Sorpresa"
      @sorpresa.to_string()
    end
  end
end