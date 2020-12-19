# encoding:utf-8

module Civitas
  class Jugador_Especulador < Jugador
    attr_accessor :fianza
    def initialize
      super
      @@factor_especulador = 2
      @fianza
    end
    
    #private_class_method :new
    
    def self.nuevo_especulador(jugador, fianza)
      nuevo = Jugador_Especulador.new
      nuevo.new_jugador_copia(jugador)
      nuevo.fianza = fianza
      i = 0
      while i < nuevo.propiedades.length
        nuevo.propiedades[i].actualizar_propietario_por_conversion(nuevo)
        i = i+1
      end
      return nuevo
    end
    
    public
    
    def get_casas_max()
      return @@CASAS_MAX * @@factor_especulador
    end
    
    def get_hoteles_max()
      return @@HOTELES_MAX * @@factor_especulador
    end
    
    def debe_ser_encarcelado()
      debe = super
      if debe && (@saldo > @fianza)
        then paga(@fianza)
        Diario.instance.ocurre_evento("#{@nombre} se libra de la cárcel.\n")
        debe = false
      end
      debe
    end
    
    def paga_impuesto(cantidad)
      paga = !is_encarcelado()
      if paga
        then paga = paga(cantidad/@@factor_especulador) end
      paga
    end
    
    def to_string()
      super
      puts "        Este jugador es un ESPECULADOR"
    end
  end
end