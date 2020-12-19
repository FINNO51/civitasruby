# encoding:utf-8

module Civitas
  class Sorpresa_Por_Casa_Hotel < Sorpresa
    def initialize(valor, texto)
      super(texto)
      @valor = valor
    end
    
    def aplicar_a_jugador(actual, todos)
      if jugador_correcto(actual, todos)
        informe(actual, todos)
        todos[actual].modificar_saldo(@valor*todos[actual].cantidad_casas_hoteles())
      end
    end
  end
end