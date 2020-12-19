# encoding:utf-8

module Civitas
  class Sorpresa_Ir_Carcel < Sorpresa
    def initialize(tablero)
      super("A LA CARCEL")
      @tablero = tablero
    end
    
    def aplicar_a_jugador(actual, todos)
      if jugador_correcto(actual, todos)
        informe(actual, todos)
        todos[actual].encarcelar(@tablero.num_casilla_carcel)
      end
    end
  end
end