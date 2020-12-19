# encoding:utf-8

module Civitas
  class Sorpresa_Por_Jugador < Sorpresa
    def initialize(valor, texto)
      super(texto)
      @valor = valor
    end
    
    def aplicar_a_jugador(actual, todos)
      if jugador_correcto(actual, todos)
        informe(actual, todos)
        pago = Sorpresa_Pagar_Cobrar.new(-@valor, @texto)
        cobro = Sorpresa_Pagar_Cobrar.new(@valor*(todos.length()-1), @texto)
        i=0
        while i < todos.length()
          if i != actual
            then pago.aplicar_a_jugador(i, todos)
          end
          i = i+1
        end
        cobro.aplicar_a_jugador(actual, todos)
      end
    end
  end
end