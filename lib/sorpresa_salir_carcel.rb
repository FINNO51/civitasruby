# encoding:utf-8

module Civitas
  class Sorpresa_Salir_Carcel < Sorpresa
    def initialize(mazo)
      super("SALIR DE LA CARCEL")
      @mazo = mazo
    end
    
    def salir_del_mazo()
      @mazo.inhabilitar_carta_especial(self)
    end
    
    def usada()
      @mazo.habilitar_carta_especial(self)
    end
    
    def aplicar_a_jugador(actual, todos)
      
      if jugador_correcto(actual, todos)
        
        informe(actual, todos)
        tiene_sc = false
        
        for i in 0..todos.size-1 do
          
          if todos[actual].tiene_salvoconducto() then
            tiene_sc = true
          end
        end
        
        if !tiene_sc then
          todos[actual].obtener_salvoconducto(self)
          salir_del_mazo()
        end
        
      end
      
    end
  end
end