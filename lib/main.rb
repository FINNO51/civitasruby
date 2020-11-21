# encoding:utf-8
require_relative 'civitas.rb'
require 'pry'

include Civitas

class Main
  
  def self.main()
  nombres = Array.new()
  Dado.instance.debug(true)
  
  nombres.push("Jugador1")
  nombres.push("Jugador2")
  nombres.push("Jugador3")
  
  juego = Civitas_juego.new(nombres)
  vista = Vista_textual.new
  
  controlador = Controlador.new(juego, vista)
  controlador.juega()
  end
  
  
end
Main.main()