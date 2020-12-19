# encoding:utf-8

module Civitas
  class Casilla_Juez < Casilla
    def initialize(num_casilla_carcel, nombre)
      super(nombre)
      @@carcel = num_casilla_carcel
    end

    def recibe_jugador(iactual, todos)
       if jugador_correcto(iactual, todos)
         then informe(iactual, todos)
         todos[iactual].encarcelar(@@carcel)
       end
    end

    def to_string()
      puts " Tipo: Juez"
      puts " Nombre: #{@nombre}"
      puts " Casilla de cárcel: #{@@carcel}"
    end
  end
end
