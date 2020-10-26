# encoding:utf-8

module Civitas
  class Sorpresa
    def initialize(tipo, valor, tablero, mazo, texto)
      @mazo = mazo
      @tablero = tablero
      @texto = texto
      @tipo = tipo
      @valor = valor
    end
    
    def self.new_sorpresa_ir_a_carcel(tipo, tablero)
      init()
      new(tipo, -1, tablero, nil, nil)
      
    end
    
    def self.new_sorpresa_ir_a_casilla(tipo, tablero, valor, texto)
      init()
      new(tipo, valor, tablero, nil, texto)
    end
    
    def self.new_sorpresa_salir_carcel(tipo, mazo)
      init()
      new(tipo, -1, nil, mazo, nil)
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
        when IRACASILLA
          aplicar_a_jugador_ir_a_casilla(actual, todos)
        when IRACARCEL
          aplicar_a_jugador_ir_carcel(actual, todos)
        when PAGARCOBRAR
          aplicar_a_jugador_pagar_cobrar(actual, todos)
        when PORCASAHOTEL
          aplicar_a_jugador_por_casa_hotel(actual, todos)
        when PORJUGADOR
          aplicar_a_jugador_por_jugador(actual, todos)
        when SALIRCARCEL
          aplicar_a_jugador_salir_carcel(actual, todos)
        end
      end
    end
    
    def salir_del_mazo()
      if @tipo == SALIRCARCEL
        then @mazo.inhabilitar_carta_especial(self)
      end
    end
    
    def usada()
      if @tipo == SALIRCARCEL
        then @mazo.habilitar_carta_especial(self)
      end
    end
    
    private
    
    def aplicar_a_jugador_ir_a_casilla(actual, todos)
      casilla_actual = todos[actual-1].num_casilla_actual
      tirada = calcular_tirada(casilla_actual, @valor)
      nueva_posicion(casilla_actual, tirada)
      todos[actual-1].mover_a_casilla(@valor)
      @tablero.casilla(@valor).recibe_jugador(actual, todos)
    end
    
    def aplicar_a_jugador_ir_carcel(actual, todos)
      todos[actual-1].encarcelar(@tablero.num_casilla_carcel)
    end
    
    def aplicar_a_jugador_pagar_cobrar(actual, todos)
      todos[actual-1].modificar_saldo(@valor)
    end
    
    def aplicar_a_jugador_por_casa_hotel(actual, todos)
      todos[actual-1].modificar_saldo(@valor*todos[actual-1].cantidad_casas_hoteles())
    end
    
    def aplicar_a_jugador_por_jugador(actual, todos)
      pago = Sorpresa.new_sorpresa_otras(PAGARCOBRAR, -@valor, @texto)
      cobro = Sorpresa.new_sorpresa_otras(PAGARCOBRAR, @valor*todos.length()-1, @texto)
      i=1
      while i < todos.length()
        if i != actual
          then pago.aplicar_a_jugador(i, todos)
        end
      end
      cobro.aplicar_a_jugador(actual, todos)
    end
    
    def aplicar_a_jugador_salir_carcel(actual, todos)
      en_uso = false
      i=1
      while i < todos.length()
        if i != actual
          then if todos[i-1].tiene_salvoconducto
            then en_uso = true
          end
        end
      end
      if !en_uso
        then todos[actual-1].obtener_salvoconducto
        salir_del_mazo()
      end
    end
    
    def informe(actual, todos)
      Diario.instance.ocurre_evento("Sorpresa aplicada a #{todos[actual-1].nombre}.\n")
    end
    
    def init()
      @valor = -1
      @mazo = nil
      @tablero = nil
    end
    
    public
    
    
    def jugador_correcto(actual, todos)
      es_correcto = false
      if actual>=1 && actual<=todos.length
        then es_correcto = true end
      es_correcto
    end
    
    def to_string()
      @texto
    end
  end
end
