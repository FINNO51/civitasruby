# encoding:utf-8

module Civitas
  class Casilla_Calle < Casilla
    
    attr_reader :titulo_propiedad
    
    def initialize(titulo)
      super (titulo.nombre)
      @titulo_propiedad = titulo
    end

    def recibe_jugador(iactual, todos)

      if jugador_correcto(iactual, todos) then

         informe(iactual, todos)
         jugador = todos[iactual]

         if !@titulo_propiedad.tiene_propietario() then
           jugador.puede_comprar_casilla()

         else
           @titulo_propiedad.tramitar_alquiler(jugador)

         end
       end
    end

    def to_string()
      puts " Tipo: Calle"
      puts " Nombre: #{@nombre}"
      puts @titulo_propiedad.to_string()
    end
  end
end