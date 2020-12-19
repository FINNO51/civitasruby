# encoding:utf-8

module Civitas
  class Sorpresa
    attr_reader :texto
    def initialize(texto)
      @texto = texto
    end
    
    private

    def informe(actual, todos)

      Diario.instance.ocurre_evento("Sorpresa #{@texto} aplicada a #{todos[actual].nombre}.\n")
    end
    
    public
    
    
    def jugador_correcto(actual, todos)
      
      return actual < todos.size()
    end
    
    def to_string()
      @texto
    end
  end
end
