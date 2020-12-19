# encoding:utf-8

module Civitas
  class Casilla_Impuesto < Casilla
    def initialize(cantidad, nombre)
      super (nombre)
      @importe = cantidad
    end

    def recibe_jugador(iactual, todos)
       if jugador_correcto(iactual, todos)
         then informe(iactual, todos)
         todos[iactual].paga_impuesto(@importe)
       end
    end

    def to_string()
      puts " Tipo: Impuesto"
      puts " Nombre: #{@nombre}"
      puts " Importe: #{@importe}"
    end
  end
end
