# encoding:utf-8

module Civitas  
  class Civitas_juego
    
    public
    
    def initialize(nombres)
      @jugadores = Array.new
      i = 0
      nombres.length.times {
        @jugadores[i] = Jugador.new_jugador(nombres[i])
        i += 1
        }
      
      @indice_jugador_actual = Dado.instance.quien_empieza(@jugadores.length)
      @mazo
      @tablero = Tablero.new(n)
      @estado = @gestor_estados.estado_inicial
      @gestor_estados
    end
    
    def cancelar_hipoteca(ip)
      jugador_actual().cancelar_hipoteca(ip)
    end
    
    def comprar()
      
    end
    
    def construir_casa(ip)
      jugador_actual().construir_casa(ip)
    end
    
    def construir_hotel(ip)
      jugador_actual().construir_hotel(ip)
    end
    
    def final_del_juego(ip)
      final = false
      i = 0
      @jugadores.length.times { 
        if @jugadores[i].en_bancarrota()
          then final = true end
        i += 1
      }
      final
    end
    
    def casilla_actual()
      jugador_actual().num_casilla_actual
    end
    
    def jugador_actual()
      @jugadores[@indice_jugador_actual]
    end
    
    def hipotecar(ip)
      jugador_actual().hipotecar(ip)
    end
    
    def info_jugador_texto()
      jugador_actual().to_string
    end
    
    def salir_carcel_pagando()
      jugador_actual().salir_carcel_pagando()
    end
    
    def salir_carcel_tirando()
      jugador_actual().salir_carcel_tirando()
    end
    
    def siguiente_paso()
     
    end
    
    def siguiente_paso_completado(operacion)
      @gestor_estados.siguiente_estado(@jugadores[@indice_jugador_actual], @estado, operacion)
    end
    
    def vender(ip)
      jugador_actual().vender(ip)
    end
    
    private
    
    def avanza_jugador()
      
    end
    
    def contabilizar_pasos_por_salida(jugador_actual)
      while @tablero.get_por_salida != 0
        jugador_actual.pasa_por_salida
      end
    end
    
    def inicializar_mazo_sorpresas(tablero)
      
    end
    
    def inicializar_tablero(mazo)
      
    end
    
    def pasar_turno()
      @indice_jugador_actual += 1
      if @indice_jugador_actual == @jugadores.length
        then @indice_jugador_actual = 0 end
    end
    
    def ranking()
      ranking = @jugadores
      ranking.sort { |a, b| a.compare_to(b) }
    end
    
  end
end
