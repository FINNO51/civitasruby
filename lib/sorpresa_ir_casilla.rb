#encoding:utf-8

module Civitas
  class Sorpresa_Ir_Casilla < Sorpresa
    def initialize(tablero, valor, texto)
      super(texto)
      @tablero = tablero
      @valor = valor
    end
    
    def aplicar_a_jugador(actual, todos)
      if jugador_correcto(actual, todos)
        
        informe(actual, todos)
        casilla_actual = todos[actual].num_casilla_actual
        tirada = @tablero.calcular_tirada(casilla_actual, @valor)
        pos = @tablero.nueva_posicion(casilla_actual, tirada)
        todos[actual].mover_a_casilla(pos)
        @tablero.casilla(pos).recibe_jugador(actual, todos)
        
      end
    end
  end
end