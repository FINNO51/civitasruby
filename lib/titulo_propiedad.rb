# encoding:utf-8

module Civitas
  class Titulo_propiedad
    
    attr_reader :nombre
    attr_reader :num_casas
    attr_reader :num_hoteles
    attr_reader :precio_compra
    attr_reader :precio_edificar
    attr_reader :propietario
    attr_reader :num_casas
    attr_reader :num_hoteles
    
    def initialize(nombre, alquiler, revalorizacion, hipoteca, compra, edificar)

      @@factor_intereses_hipoteca = 1.1
      @alquiler_base = alquiler
      @factor_revalorizacion = revalorizacion
      @hipoteca_base = hipoteca
      @hipotecado = false
      @nombre = nombre
      @num_casas = 0
      @num_hoteles = 0
      @precio_compra = compra
      @precio_edificar = edificar
      @propietario = nil
    
    end
    
    def actualizar_propietario_por_conversion(jugador)
      @propietario = jugador
    end
    
    def cancelar_hipoteca(jugador)
      
      result = false
      
      if hipotecado and es_este_el_propietario(jugador) then
        
        jugador.paga(importe_cancelar_hipoteca())
        @hipotecado = false
        result = true
      end
      
      return result
    end
    
    def cantidad_casas_hoteles()
      @num_casas+@num_hoteles
    end
    
    def comprar(jugador)
      
      result = false
      
      if !tiene_propietario() then
        
        result = true
        jugador.paga(@precio_compra)
        actualizar_propietario_por_conversion(jugador)
      end
      
      return result
    end
    
    def construir_casa(jugador)
      
      result = false
      
      if es_este_el_propietario(jugador) then
        
        jugador.paga(precio_edificar)
        @num_casas += 1
        result = true
      end
      
      return result
      
    end
    
    def construir_hotel(jugador)
      
      result = false
      
      if es_este_el_propietario(jugador) then
        
        jugador.paga(precio_edificar)
        @num_hoteles += 1
        result = true
      end
      
      return result
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
      
      salida = false
      
      if !hipotecado and es_este_el_propietario(jugador) then
        
        propietario.recibe(importe_hipoteca())
        @hipotecado = true
        salida = true
      end
      
      return salida
    end
    
    def tiene_propietario()
      @propietario != nil
    end
    
    def tramitar_alquiler(jugador)
      if tiene_propietario() && !es_este_el_propietario(jugador) then 
        
        precio = precio_alquiler()
        jugador.paga_alquiler(precio)
        @propietario.recibe(precio)
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
      
      return @propietario == jugador
    end
    
    def importe_hipoteca()
      @hipoteca_base*(1+(@num_casas*0.5)+(@num_hoteles*2.5))
    end
    
    def precio_alquiler()
      precio = 0
      if !propietario_encarcelado() && !hipotecado
        then precio = @alquiler_base*(1+(@num_casas*0.5)+(@num_hoteles*2.5)) 
      end
      return precio
    end
    
    def precio_venta()
      @precio_compra+(@num_casas+5*@num_hoteles)*@precio_edificar*@factor_revalorizacion
    end
    
    def propietario_encarcelado()
      encarcelado = true
      if !@propietario.is_encarcelado || @propietario == nil
        then encarcelado = false 
      end
    end
    
    public
    
    def hipotecado()
      return @hipotecado
    end
    
    def to_string()
      puts "      Alquiler base: #{@alquiler_base}
      Factor intereses hipoteca: #{@@factor_intereses_hipoteca}
      Factor revalorización: #{@factor_revalorizacion}
      Hipoteca base: #{@hipoteca_base}
      Hipotecado: #{@hipotecado}
      Número casas: #{@num_casas}
      Número hoteles: #{@num_hoteles}
      Precio compra: #{@precio_compra}
      Precio edificar: #{@precio_edificar}
      Propietario: #{@propietario}\n"
    end
  end
end
