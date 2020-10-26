# encoding:utf-8

module Civitas
  class Titulo_propiedad
    
    attr_reader :nombre
    attr_reader :num_casas
    attr_reader :num_hoteles
    attr_reader :precio_compra
    attr_reader :precio_edificar
    attr_reader :propietario
    
    def initialize(nombre, alquiler, revalorizacion, hipoteca, compra, edificar)

      @@factor_intereses_hipoteca = 1.1
      @alquiler_base = alquiler
      @factor_revalorizacion = revalorizacion
      @hipoteca_base = hipoteca
      @hipotecado
      @nombre = nombre
      @num_casas
      @num_hoteles
      @precio_compra = compra
      @precio_edificar = edificar
      @propietario = nil
    
    end
    
    def actualizar_propietario_por_conversion(jugador)
      @propietario = jugador
    end
    
    def cancelar_hipoteca()
      
    end
    
    def cantidad_casas_hoteles()
      @num_casas+@num_hoteles
    end
    
    def comprar(jugador)
      
    end
    
    def construir_casa(jugador)
      
    end
    
    def construir_hotel(jugador)
      
    end
    
    def derruir_casas(n, jugador)
      derruido = false
      if jugador = @propietario && @num_casas >= n
        then @num_casas -= n
        derruido = true
      end
      return derruido
    end
    
    def importe_cancelar_hipoteca()
      importe_hipoteca()*@@factor_intereses_hipoteca
    end
    
    def hipotecar(jugador)
      
    end
    
    def tiene_propietario()
      @propietario != nil
    end
    
    def tramitar_alquiler(jugador)
      if @propietario != jugador && @propietario != nil
        then jugador.paga_alquiler(@precio_alquiler)
        @propietario.recibe(@precio_alquiler)
      end
    end
    
    def vender(jugador)
      vendido = false
      if jugador == @propietario && !hipotecado
        then @propietario.recibe(precio_venta())
        @propietario = nil
        @num_casas = 0
        @num_hoteles = 0
        vendido = true
      end
      return vendido
    end
    
    private
    
    def es_este_el_propietario(jugador)
      @propietario == jugador
    end
    
    def importe_hipoteca()
      @hipoteca_base*(1+(@num_casas*0.5)+(@num_hoteles*2.5))
    end
    
    def precio_alquiler()
      precio = 0
      if !propietario_encarcelado() && !hipotecado
        then precio = @alquiler_base*(1+(@num_casas*0.5)+(@num_hoteles*2.5)) end
      return precio
    end
    
    def precio_venta()
      @precio_compra+(@num_casas+5*@num_hoteles)*@precio_edificar*@factor_revalorizacion
    end
    
    def propietario_encarcelado()
      encarcelado = true
      if !propietario.encarcelado || propietario == nil
        then encarcelado = false end
    end
    
    public
    
    def hipotecado()
      @hipotecado
    end
    
    def to_string()
      puts "Alquiler base: #{@alquiler_base}\n
      Factor intereses hipoteca: #{@@factor_intereses_hipoteca}\n
      Factor revalorización: #{@factor_revalorizacion}\n
      Hipoteca base: #{@hipoteca_base}\n
      Hipotecado: #{@hipotecado}\n
      Nombre: #{@nombre}\n
      Número casas: #{@num_casas}\n
      Número hoteles: #{@num_hoteles}\n
      Precio compra: #{@precio_compra}\n
      Precio edificar: #{@precio_edificar}\n
      Propietario: #{@propietario}\n"
    end
  end
end
