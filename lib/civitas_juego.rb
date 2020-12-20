# encoding:utf-8

module Civitas  
  class Civitas_juego
    
    public
    
    def initialize(nombres)
      @jugadores = Array.new
      
      for i in 0..nombres.length-1
        j = Jugador.new
        j.new_jugador(nombres[i])
        @jugadores.push(j)
      end
        
      
      @indice_jugador_actual = Dado.instance.quien_empieza(@jugadores.length())
      @mazo = Mazo_sorpresas.new
      @tablero = Tablero.new(10)
      @gestor_estados = Gestor_estados.new()
      @estado = @gestor_estados.estado_inicial
      
      inicializar_tablero(@mazo)
      inicializar_mazo_sorpresas(@tablero)
    end
    
    def cancelar_hipoteca(ip)
      jugador_actual().cancelar_hipoteca(ip)
    end
    
    def comprar()
      casilla = @tablero.casilla(jugador_actual().num_casilla_actual)
      titulo = casilla.titulo_propiedad
      return jugador_actual().comprar(titulo)
    end
    
    def construir_casa(ip)
      jugador_actual().construir_casa(ip)
    end
    
    def construir_hotel(ip)
      jugador_actual().construir_hotel(ip)
    end
    
    def final_del_juego()
      final = false
      i = 0
      @jugadores.length.times { 
        if @jugadores[i].en_bancarrota()
          then final = true end
        i += 1
      }
      return final
    end
    
    def casilla_actual()
      return @tablero.casilla(jugador_actual().num_casilla_actual)
    end
    
    def jugador_actual()
      @jugadores[@indice_jugador_actual]
    end
    
    def hipotecar(ip)
      jugador_actual().hipotecar(ip)
    end
    
    def info_jugador_texto()
      jugador_actual().to_string()
    end
    
    def salir_carcel_pagando()
      jugador_actual().salir_carcel_pagando()
    end
    
    def salir_carcel_tirando()
      jugador_actual().salir_carcel_tirando()
    end
    
    def siguiente_paso()

      operacion = @gestor_estados.operaciones_permitidas(jugador_actual(), @estado)
      
      if operacion == Operaciones_juego::PASAR_TURNO then
        
        pasar_turno()
        siguiente_paso_completado(operacion)
        
      elsif operacion == Operaciones_juego::AVANZAR then
        
        avanza_jugador()
        siguiente_paso_completado(operacion)
        
      end
      
      return operacion
    end
    
    def siguiente_paso_completado(operacion)
      @estado = @gestor_estados.siguiente_estado(jugador_actual(), @estado, operacion)
    end
    
    def vender(ip)
      jugador_actual().vender(ip)
    end
    
    private
    
    def avanza_jugador()
      tirada = Dado.instance.tirar()
      Diario.instance.ocurre_evento("El dado ha sacado: #{tirada}")
      nueva_pos = @tablero.nueva_posicion(jugador_actual().num_casilla_actual, tirada)
      nueva_casilla = @tablero.casilla(nueva_pos)
      
      contabilizar_pasos_por_salida(jugador_actual())
      
      jugador_actual().mover_a_casilla(nueva_pos)
      
      nueva_casilla.recibe_jugador(@indice_jugador_actual, @jugadores)
      
      contabilizar_pasos_por_salida(jugador_actual())
      
    end
    
    def contabilizar_pasos_por_salida(jugador_actual)
      while @tablero.get_por_salida != 0
        jugador_actual.pasa_por_salida
      end
    end
    
    def inicializar_mazo_sorpresas(tablero)
      @mazo.al_mazo(Sorpresa_Ir_Carcel.new(tablero))
      @mazo.al_mazo(Sorpresa_Ir_Casilla.new(tablero, tablero.num_casilla_carcel, "Ir a la casilla de cárcel."))
      @mazo.al_mazo(Sorpresa_Ir_Casilla.new(tablero, 0, "Ir a la salida"))
      @mazo.al_mazo(Sorpresa_Ir_Casilla.new(tablero, 15, "Ir al parking"))
      @mazo.al_mazo(Sorpresa_Salir_Carcel.new(@mazo))
      @mazo.al_mazo(Sorpresa_Pagar_Cobrar.new(-200, "Pagas 200"))
      @mazo.al_mazo(Sorpresa_Pagar_Cobrar.new(200, "Cobras 200"))
      @mazo.al_mazo(Sorpresa_Por_Casa_Hotel.new(-200, "Pagas por propiedades"))
      @mazo.al_mazo(Sorpresa_Por_Casa_Hotel.new(200, "Cobras por propiedades"))
      @mazo.al_mazo(Sorpresa_Por_Jugador.new(-200, "Pagas al resto de jugadores"))
      @mazo.al_mazo(Sorpresa_Por_Jugador.new(200, "Cobras del resto de jugadores"))
      @mazo.al_mazo(Sorpresa_Especulador.new(200))
    end
    
    def inicializar_tablero(mazo)
      @tablero.añade_casilla(Casilla_Calle.new(Titulo_propiedad.new("Calle1", 10, 10, 10, 10, 10)))
      @tablero.añade_casilla(Casilla_Sorpresa.new(mazo, "Sorpresa1"))
      @tablero.añade_casilla(Casilla_Calle.new(Titulo_propiedad.new("Calle2", 10, 10, 10, 10, 10)))
      @tablero.añade_casilla(Casilla_Calle.new(Titulo_propiedad.new("Calle3", 10, 10, 10, 10, 10)))
      @tablero.añade_casilla(Casilla_Impuesto.new(200, "Impuesto"))
      @tablero.añade_casilla(Casilla_Calle.new(Titulo_propiedad.new("Calle4", 10, 10, 10, 10, 10)))
      @tablero.añade_casilla(Casilla_Calle.new(Titulo_propiedad.new("Calle5", 10, 10, 10, 10, 10)))
      @tablero.añade_casilla(Casilla_Sorpresa.new(mazo, "Sorpresa2"))
      @tablero.añade_casilla(Casilla_Calle.new(Titulo_propiedad.new("Calle6", 10, 10, 10, 10, 10)))
      @tablero.añade_casilla(Casilla_Calle.new(Titulo_propiedad.new("Calle7", 10, 10, 10, 10, 10)))
      @tablero.añade_casilla(Casilla_Sorpresa.new(mazo, "Sorpresa3"))
      @tablero.añade_casilla(Casilla_Calle.new(Titulo_propiedad.new("Calle8", 10, 10, 10, 10, 10)))
      @tablero.añade_casilla(Casilla.new("Parking"))
      @tablero.añade_casilla(Casilla_Calle.new(Titulo_propiedad.new("Calle9", 10, 10, 10, 10, 10)))
      @tablero.añade_casilla(Casilla_Calle.new(Titulo_propiedad.new("Calle10", 10, 10, 10, 10, 10)))
      @tablero.añade_casilla(Casilla_Juez.new(@tablero.num_casilla_carcel, "Juez"))
      @tablero.añade_casilla(Casilla_Calle.new(Titulo_propiedad.new("Calle11", 10, 10, 10, 10, 10)))
      @tablero.añade_casilla(Casilla_Calle.new(Titulo_propiedad.new("Calle12", 10, 10, 10, 10, 10)))

    end
    
    def pasar_turno()
      @indice_jugador_actual = (@indice_jugador_actual+1)%@jugadores.length
    end
    
    def ranking()
      ranking = @jugadores
      ranking.sort { |a, b| a.compare_to(b) }
    end
    
  end
end
