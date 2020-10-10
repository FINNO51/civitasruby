# encoding:utf-8
require 'singleton'

module Civitas
  class Dado
    include Singleton
    
    def initialize
      @random = Random.new()
      @ultimo_resultado
      @debug = false
      
      @@salida_carcel = 5
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
      
      salir = false
      tirada = tirar()
      
      if tirada == @@salida_carcel then
        salir = true
      end
      
      return salir
    end
    
    def debug(deb)
      
      @debug = deb
      
      Diario.instance.ocurre_evento("Modo debug activado")
      
    end
    
    def quien_empieza(n)
      
      return rand(n)
    end

  end
end
