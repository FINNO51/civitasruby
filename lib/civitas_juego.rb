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
      @mazo.al_mazo(Sorpresa.new_sorpresa_ir_a_carcel(IR_CARCEL, tablero))
      @mazo.al_mazo(Sorpresa.new_sorpresa_ir_a_casilla(IR_CASILLA, tablero, tablero.num_casilla_carcel, "Ir a la casilla de cárcel."))
      @mazo.al_mazo(Sorpresa.new_sorpresa_ir_a_casilla(IR_CASILLA, tablero, 0, "Ir a la salida"))
      @mazo.al_mazo(Sorpresa.new_sorpresa_ir_a_casilla(IR_CASILLA, tablero, 15, "Ir al parking"))
      @mazo.al_mazo(Sorpresa.new_sorpresa_salir_carcel(SALIR_CARCEL, @mazo))
      @mazo.al_mazo(Sorpresa.new_sorpresa_otras(PAGAR_COBRAR, -200, "Pagas 200"))
      @mazo.al_mazo(Sorpresa.new_sorpresa_otras(PAGAR_COBRAR, 200, "Cobras 200"))
      @mazo.al_mazo(Sorpresa.new_sorpresa_otras(POR_CASA_HOTEL, -200, "Pagas por propiedades"))
      @mazo.al_mazo(Sorpresa.new_sorpresa_otras(POR_CASA_HOTEL, 200, "Cobras por propiedades"))
      @mazo.al_mazo(Sorpresa.new_sorpresa_otras(POR_JUGADOR, -200, "Pagas al resto de jugadores"))
      @mazo.al_mazo(Sorpresa.new_sorpresa_otras(POR_JUGADOR, 200, "Cobras del resto de jugadores"))
    end
    
    def inicializar_tablero(mazo)
      @tablero.añade_casilla(Casilla.new_casilla_calle(Titulo_propiedad.new("Calle1", 10, 10, 10, 10, 10)))
      @tablero.añade_casilla(Casilla.new_casilla_sorpresa(mazo, "Sorpresa1"))
      @tablero.añade_casilla(Casilla.new_casilla_calle(Titulo_propiedad.new("Calle2", 10, 10, 10, 10, 10)))
      @tablero.añade_casilla(Casilla.new_casilla_calle(Titulo_propiedad.new("Calle3", 10, 10, 10, 10, 10)))
      @tablero.añade_casilla(Casilla.new_casilla_impuesto(200, "Impuesto"))
      @tablero.añade_casilla(Casilla.new_casilla_calle(Titulo_propiedad.new("Calle4", 10, 10, 10, 10, 10)))
      @tablero.añade_casilla(Casilla.new_casilla_calle(Titulo_propiedad.new("Calle5", 10, 10, 10, 10, 10)))
      @tablero.añade_casilla(Casilla.new_casilla_sorpresa(mazo, "Sorpresa2"))
      @tablero.añade_casilla(Casilla.new_casilla_calle(Titulo_propiedad.new("Calle6", 10, 10, 10, 10, 10)))
      @tablero.añade_casilla(Casilla.new_casilla_calle(Titulo_propiedad.new("Calle7", 10, 10, 10, 10, 10)))
      @tablero.añade_casilla(Casilla.new_casilla_sorpresa(mazo, "Sorpresa3"))
      @tablero.añade_casilla(Casilla.new_casilla_calle(Titulo_propiedad.new("Calle8", 10, 10, 10, 10, 10)))
      @tablero.añade_casilla(Casilla.new_casilla_descanso("Parking"))
      @tablero.añade_casilla(Casilla.new_casilla_calle(Titulo_propiedad.new("Calle9", 10, 10, 10, 10, 10)))
      @tablero.añade_casilla(Casilla.new_casilla_calle(Titulo_propiedad.new("Calle10", 10, 10, 10, 10, 10)))
      @tablero.añade_casilla(Casilla.new_casilla_juez(@tablero.num_casilla_carcel, "Juez"))
      @tablero.añade_casilla(Casilla.new_casilla_calle(Titulo_propiedad.new("Calle11", 10, 10, 10, 10, 10)))
      @tablero.añade_casilla(Casilla.new_casilla_calle(Titulo_propiedad.new("Calle12", 10, 10, 10, 10, 10)))

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
