# encoding:utf-8

module Civitas
  class Sorpresa_Especulador < Sorpresa
    def initialize(valor)
      super("SE CONVIERTE EN ESPECULADOR")
      @valor = valor
    end
    
    def aplicar_a_jugador(actual, todos)
      if jugador_correcto(actual, todos) then
        informe(actual, todos)
        nuevo = Jugador_Especulador.nuevo_especulador(todos[actual], @valor)
        todos[actual] = nuevo
      end
    end
  end
end