# encoding:utf-8
require 'singleton'

module Civitas
  class Dado
    include Singleton
    
    def initialize
      @random = Random.new()
      @ultimo_resultado
      @debug = false
      
      @@SALIDA_CARCEL = 5
    end
    
    public
    
    attr_reader :ultimo_resultado
    attr_accessor :debug
    
    def tirar()
      
      n = 1
      if !@debug then
        
        @ultimo_resultado = rand(6)+1
        n = @ultimo_resultado
      end
      
      return n
    end
    
    def salgo_de_la_carcel()
      
      tirada = tirar()
      salir = false
      
      if tirada == @@SALIDA_CARCEL then
        salir = true
      end
      
      return salir
    end
    
    def debug(deb)
      
      if (deb) then
        Diario.instance.ocurre_evento("Modo debug activado")
        @debug = true
      
      else
        Diario.instance.ocurre_evento("Modo debug desactivado")
        @debug = fasle
      end
    end
    
    def quien_empieza(n)
      
      return rand(n)
    end

  end
end
