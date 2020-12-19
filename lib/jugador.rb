# encoding:utf-8

module Civitas
  class Jugador
    
    attr_reader :CASAS_POR_HOTEL
    attr_reader :num_casilla_actual
    attr_reader :puede_comprar
    attr_reader :salvoconducto
      
    def initialize()

      @@CASAS_MAX = 4
      @@CASAS_POR_HOTEL = 4
      @@HOTELES_MAX = 4
      @@PASO_POR_SALIDA = 1000
      @@PRECIO_LIBERTAD = 200
      @encarcelado
      
      @@SALDO_INICIAL = 7500
      @nombre
      @num_casilla_actual=0
      @propiedades #array
      @puede_comprar
      @saldo
      @salvoconducto
      
    end
    
    def new_jugador(nombre)
      @nombre = nombre
      @propiedades = Array.new
      @saldo = @@SALDO_INICIAL
    end
    
    def new_jugador_copia(jugador)
      
      @nombre = jugador.nombre
      @num_casilla_actual = jugador.num_casilla_actual
      @propiedades = jugador.propiedades
      @puede_comprar = jugador.puede_comprar
      @saldo = jugador.saldo
      @salvoconducto = jugador.salvoconducto
      @encarcelado = jugador.is_encarcelado()
    end
    
    def cancelar_hipoteca(ip)
      
      result = false
      
      if !is_encarcelado() and existe_la_propiedad(ip) then
        
        if existe_la_propiedad(ip) and puedo_gastar(@propiedades[ip].importe_cancelar_hipoteca()) then
          
          result = @propiedades[ip].cancelar_hipoteca(self)
          
          if result then  
            Diario.instance.ocurre_evento("El jugador #{@nombre} cancela la hipoteca de la propiedad #{ip}")
            
          end
        end  
      end
      
      return result
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

      result = false;
      
      if !is_encarcelado() && puede_comprar() && puedo_gastar(titulo.precio_compra) then
        
        result = titulo.comprar(self)
        
        if result then
          
          @propiedades.push(titulo)
          Diario.instance.ocurre_evento("El jugador #{@nombre} compra la pripiedad #{titulo.nombre}")
          
        end
        
      end
      
    end
    
    def construir_casa(ip)
      
      result = false
      
      if !is_encarcelado and existe_la_propiedad(ip) then
        
      propiedad = @propiedades[ip]
      
        if (puedo_edificar_casa(propiedad)) then
          
          result = propiedad.construir_casa(self)
          Diario.instance.ocurre_evento("El jugador #{@nombre} construye una casa en la propiedad #{ip}")
        end
      end
      
      return result
      
    end
    
    def construir_hotel(ip)
      
      result = false
      
      
      if !is_encarcelado and existe_la_propiedad(ip) then
        
        propiedad = @propiedades[ip]
      
        if (puedo_edificar_hotel(propiedad)) then
          
          result = propiedad.construir_hotel(self)
          propiedad.derruir_casas(@@CASAS_POR_HOTEL, self)
          Diario.instance.ocurre_evento("El jugador #{@nombre} construye un hotel en la propiedad #{ip}")
        end
      end
      
      return result
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
      return is_encarcelado()
    end
    
    def hipotecar(ip)
      
      result = false
      
      if !is_encarcelado() then
        
        if existe_la_propiedad(ip) then
          
          result = propiedades[ip].hipotecar(self) 
        end
        
        if result then
          
          Diario.instance.ocurre_evento("El jugador #{@nombre} hipoteca la propiedad #{ip}")
        end
      end
      
      return result
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
      modificar_saldo( -1*cantidad )
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
      return @puede_comprar
    end
    
    def recibe(cantidad)
      recibe = !is_encarcelado()
      if recibe
        then recibe = modificar_saldo(cantidad) end
      
      return recibe
    end
    
    def salir_carcel_pagando()
      sale = is_encarcelado() && puede_salir_carcel_pagando()
      if sale then
        paga(@@PRECIO_LIBERTAD)
        @encarcelado = false
        Diario.instance.ocurre_evento("#{@nombre} sale de la cárcel pagando.\n")
      end
      
      return sale
    end
    
    def salir_carcel_tirando()
      sale = is_encarcelado() && Dado.instance.salgo_de_la_carcel()
      if sale
        then @encarcelado = false
        Diario.instance.ocurre_evento("#{@nombre} sale de la cárcel tirando el dado.\n")
      end
      
      return sale
    end
    
    def tiene_algo_que_gestionar()
      tiene = true
      if @propiedades.length() == 0
        then tiene = false end
      
      return tiene
    end
    
    def tiene_salvoconducto()
      
      return @salvoconducto != nil
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
    
    attr_reader :PRECIO_LIBERTAD
    attr_reader :PASO_POR_SALIDA
    
    def get_casas_max()
      return @@CASAS_MAX
    end
    
    def get_hoteles_max()
      return @@HOTELES_MAX
    end
    
    def existe_la_propiedad(ip)

      return ip < @propiedades.length()
    end
    
    def perder_salvoconducto()
      @salvoconducto.usada()
      @salvoconducto = nil
    end
    
    def puede_salir_carcel_pagando()
      return @saldo >= @@PRECIO_LIBERTAD
    end
    
    def puedo_edificar_casa(propiedad)
      
      return puedo_gastar(propiedad.precio_edificar) && propiedad.num_casas < get_casas_max()
      
    end
    
    def puedo_edificar_hotel(propiedad)
      
      return puedo_gastar(propiedad.precio_edificar) && propiedad.num_casas == 4 && propiedad.num_hoteles < get_hoteles_max()
    end
    
    def puedo_gastar(precio)
      puedo = !is_encarcelado()
      if puedo && @saldo < precio
        then puedo = false end
      puedo
    end
    
    public
    
    attr_reader :nombre
    attr_reader :propiedades
    attr_reader :saldo
    
    protected
    
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
      puts @nombre, "\n"

      puts"        Casilla actual: #{@num_casilla_actual}
        Saldo: #{@saldo}
        Encarcelado: #{@encarcelado}
        Número de propiedades: #{@propiedades.length()}
        Puede comprar: #{@puede_comprar}"
      if tiene_salvoconducto()
        then puts "        Tiene salvoconducto: Sí\n"
      else puts "        Tiene salvoconducto: No\n"
      end
    end
    
  end
end