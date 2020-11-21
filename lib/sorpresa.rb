# encoding:utf-8

module Civitas
  class Sorpresa
    attr_reader :texto
    def initialize(tipo, valor, tablero, mazo, texto)
      @mazo = mazo
      @tablero = tablero
      @texto = texto
      @tipo = tipo
      @valor = valor
    end
    
    def self.new_sorpresa_ir_a_carcel(tipo, tablero)
      init()
      new(tipo, -1, tablero, nil, "A LA CARCEL")
      
    end
    
    def self.new_sorpresa_ir_a_casilla(tipo, tablero, valor, texto)
      init()
      new(tipo, valor, tablero, nil, texto)
    end
    
    def self.new_sorpresa_salir_carcel(tipo, mazo)
      init()
      new(tipo, -1, nil, mazo, "SALIR DE LA CARCEL")
    end
    
    def self.new_sorpresa_otras(tipo, valor, texto)
      init()
      new(tipo, valor, nil, nil, texto)
    end
    
    private_class_method :new
    
    def aplicar_a_jugador(actual, todos)
      if jugador_correcto(actual, todos) then
        informe(actual, todos)
        case @tipo
        when Tipo_sorpresa::IR_CASILLA
          aplicar_a_jugador_ir_a_casilla(actual, todos)
        when Tipo_sorpresa::IR_CARCEL
          aplicar_a_jugador_ir_carcel(actual, todos)
        when Tipo_sorpresa::PAGAR_COBRAR
          aplicar_a_jugador_pagar_cobrar(actual, todos)
        when Tipo_sorpresa::POR_CASA_HOTEL
          aplicar_a_jugador_por_casa_hotel(actual, todos)
        when Tipo_sorpresa::POR_JUGADOR
          aplicar_a_jugador_por_jugador(actual, todos)
        when Tipo_sorpresa::SALIR_CARCEL
          aplicar_a_jugador_salir_carcel(actual, todos)
        end
      end
    end
    
    def salir_del_mazo()
      if @tipo == Tipo_sorpresa::SALIR_CARCEL
        then @mazo.inhabilitar_carta_especial(self)
      end
    end
    
    def usada()
      if @tipo == Tipo_sorpresa::SALIR_CARCEL
        then @mazo.habilitar_carta_especial(self)
      end
    end
    
    private
    
    def aplicar_a_jugador_ir_a_casilla(actual, todos)

      casilla_actual = todos[actual].num_casilla_actual
      tirada = @tablero.calcular_tirada(casilla_actual, @valor)
      pos = @tablero.nueva_posicion(casilla_actual, tirada)
      todos[actual].mover_a_casilla(pos)
      @tablero.casilla(pos).recibe_jugador(actual, todos)
    end
    
    def aplicar_a_jugador_ir_carcel(actual, todos)
      todos[actual].encarcelar(@tablero.num_casilla_carcel)
    end
    
    def aplicar_a_jugador_pagar_cobrar(actual, todos)
      todos[actual].modificar_saldo(@valor)
    end
    
    def aplicar_a_jugador_por_casa_hotel(actual, todos)
      todos[actual].modificar_saldo(@valor*todos[actual].cantidad_casas_hoteles())
    end
    
    def aplicar_a_jugador_por_jugador(actual, todos)
      pago = Sorpresa.new_sorpresa_otras(Tipo_sorpresa::PAGAR_COBRAR, -@valor, @texto)
      cobro = Sorpresa.new_sorpresa_otras(Tipo_sorpresa::PAGAR_COBRAR, @valor*(todos.length()-1), @texto)
      i=0
      while i < todos.length()
        if i != actual
          then pago.aplicar_a_jugador(i, todos)
        end
        i = i+1
      end
      cobro.aplicar_a_jugador(actual, todos)
    end
    
    def aplicar_a_jugador_salir_carcel(actual, todos)
      
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
    
    def informe(actual, todos)

      Diario.instance.ocurre_evento("Sorpresa #{@texto} aplicada a #{todos[actual].nombre}.\n")
    end
    
    def self.init()
      @valor = -1
      @mazo = nil
      @tablero = nil
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
