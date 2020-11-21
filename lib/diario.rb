require 'singleton'
module Civitas
  class Diario
    include Singleton

    def initialize
      @eventos = []
    end

    def ocurre_evento(e)
      @eventos << e
    end

    def eventos_pendientes
      return (@eventos.length > 0)
    end

    def leer_evento
      return @eventos.shift
    end

  end
end
