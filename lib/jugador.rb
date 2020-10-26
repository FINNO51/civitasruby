# encoding:utf-8

module Civitas
  class Jugador
    
    attr_reader :CASAS_POR_HOTEL
    attr_reader :num_casilla_actual
    attr_reader :puede_comprar
      
    def initialize()
      
      protected
      @@CASAS_MAX = 4
      @@CASAS_POR_HOTEL = 4
      @@HOTELES_MAX = 4
      @@PASO_POR_SALIDA = 1000
      @@PRECIO_LIBERTAD = 200
      @encarcelado
      
      private
      @@SALDO_INICIAL = 7500
      @nombre
      @num_casilla_actual
      @propiedades #array
      @puede_comprar
      @saldo
      @salvoconducto
      
    end
    
    def self.new_jugador(nombre)
      @nombre = nombre
      @propiedades = Array.new
    end
    
    def cancelar_hipoteca(ip)
      
    end
    
    def cantidad_casas_hoteles()
      cantidad = 0
      i = 0
      @propiedades.length().times { 
         cantidad += @propiedades[i].cantidad_casas_hoteles()
         i += 1}
      cantidad
    end
    
    def comprar(titulo)
 #     paga = !is_encarcelado() && titulo.precio_compra <= @saldo
 #     if paga
 #       then paga = paga(cantidad) 
 #       @propiedades.push(titulo)
 #     end
 #     paga
    end
    
    def contruir_casa(ip)
      
    end
    
    def construir_hotel(ip)
      
    end
    
    def en_bancarrota()
      bancarrota = false
      if @saldo <= 0
        then bancarrota = true end
      bancarrota
    end
    
    def encarcelar(num_casilla_carcel)
      if debe_ser_encarcelado()
        then mover_a_casilla(num_casilla_carcel)
        @encarcelado = true
        Diario.instance.ocurre_evento("#{@nombre} ha sido encarcelado.\n")
      end
      @encarcelado
    end
    
    def hipotecar(ip)
      
    end
    
    def modificar_saldo(cantidad)
      @saldo += cantidad
      Diario.instance.ocurre_evento("Saldo de #{@nombre} modificado en #{cantidad}.\n")
      true
    end
    
    def mover_a_casilla(num_casilla)
      mueve = !is_encarcelado()
      if mueve
        then @num_casilla_actual = num_casilla
        @puede_comprar = false
        Diario.instance.ocurre_evento("#{@nombre} se mueve a la casilla #{num_casilla}.\n")
      end
      mueve
    end
    
    def obtener_salvoconducto(s)
      obtiene = !is_encarcelado()
      if obtiene
        then @salvoconducto = s end
    end
    
    def paga(cantidad)
      modificar_saldo(cantidad*-1)
    end
    
    def paga_alquiler(cantidad)
      paga = !is_encarcelado()
      if paga
        then paga = paga(cantidad) end
      paga
    end
    
    def paga_impuesto(cantidad)
      paga = !is_encarcelado()
      if paga
        then paga = paga(cantidad) end
      paga
    end
    
    def pasa_por_salida()
      modificar_saldo(@@PASO_POR_SALIDA)
      Diario.instance.ocurre_evento("#{@nombre} pasa por salida.\n")
      true
    end
    
    def puede_comprar_casilla()
      @puede_comprar = !is_encarcelado()
      @puede_comprar
    end
    
    def recibe(cantidad)
      recibe = !is_encarcelado()
      if recibe
        then recibe = modificar_saldo(cantidad) end
      recibe
    end
    
    def salir_carcel_pagando()
      sale = is_encarcelado() && puede_salir_carcel_pagando()
      if sale 
        then paga(@@PRECIO_LIBERTAD)
        @encarcelado = false
        Diario.instance.ocurre_evento("#{@nombre} sale de la cárcel pagando.\n")
      end
      sale
    end
    
    def salir_carcel_tirando()
      sale = is_encarcelado() && Dado.instance.salgo_de_la_carcel()
      if sale
        then @encarcelado = false
        Diario.instance.ocurre_evento("#{@nombre} sale de la cárcel tirando el dado.\n")
      end
      sale
    end
    
    def tiene_algo_que_gestionar()
      tiene = true
      if @propiedades.length() == 0
        then tiene = false end
      tiene
    end
    
    def tiene_salvoconducto()
      tiene = false
      if @salvoconducto != nil
        then tiene = true end
      tiene
    end
    
    def vender(ip)
      puede = !is_encarcelado()
      if puede && existe_la_propiedad(ip)
        then puede = @propiedades[ip].vender(self)
        if puede
          Diario.instance.ocurre_evento("Se ha vendido la propiedad #{@propiedades[ip].nombre}.\n")
          @propiedades.delete_at(ip)
        end
      end
      puede
    end
    
    private
    
    attr_reader :CASAS_MAX
    attr_reader :HOTELES_MAX
    attr_reader :PRECIO_LIBERTAD
    attr_reader :PASO_POR_SALIDA
    
    def existe_la_propiedad(ip)
      ip < @propiedades.length
    end
    
    def perder_salvoconducto()
      @salvoconducto.usada()
      @salvoconducto = nil
    end
    
    def puede_salir_carcel_pagando()
      @saldo >= @@PRECIO_LIBERTAD
    end
    
    def puedo_edificar_casa(propiedad)
      !is_encarcelado && 
      propiedad.num_casas < @@CASAS_MAX &&
      propiedad.precio_edificar <= @saldo
    end
    
    def puedo_edificar_hotel(propiedad)
      !is_encarcelado &&
      propiedad.num_hoteles < @@HOTELES_MAX &&
      propiedad.num_casas == @@CASAS_MAX &&
      propiedad.precio_edificar <= @saldo
    end
    
    def puedo_gastar(precio)
      puedo = !is_encarcelado()
      if puedo && @saldo < precio
        then puedo = false end
      puedo
    end
    
    protected
    
    attr_reader :nombre
    attr_reader :propiedades
    attr_reader :saldo
     
    def self.new_jugador_copia(jugador)
      @nombre = jugador.nombre
      @num_casilla_actual = jugador.num_casilla_actual
      @propiedades = jugador.propiedades
      @puede_comprar = jugador.puede_comprar
      @saldo = jugador.saldo
      @salvoconducto = jugador.salvoconducto
      @encarcelado = jugador.encarcelado
    end
    
    def debe_ser_encarcelado()
      debe = !is_encarcelado()
      if debe && tiene_salvoconducto()
        then perder_salvoconducto()
        Diario.instance.ocurre_evento("#{@nombre} se libra de la cárcel.\n")
        debe = false
      end
      debe
    end
    
    public
    
    def compare_to(jugador)
      @saldo <=> jugador.saldo
    end
    
    def is_encarcelado()
      @encarcelado
    end
    
    def to_string()
      puts "Nombre: #{@nombre}\n
            Casilla actual: #{@num_casilla_actual}\n
            Saldo: #{@saldo}\n
            Encarcelado: #{@encarcelado}\n
            Número de propiedades: #{@propiedades.length()}\n
            Puede comprar: #{@puede_comprar}\n"
      if salvoconducto != nil
        then puts "Tiene salvoconducto: Sí\n"
      else puts "Tiene salvoconducto: No\n"
      end
    end
    
  end
end