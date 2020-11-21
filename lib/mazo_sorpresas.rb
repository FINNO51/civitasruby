# encoding:utf-8

module Civitas
 class Mazo_sorpresas
   
   
   def initialize (deb = false)
     
     @sorpresas #array
     @barajada
     @usadas
     @debug = deb
     @cartas_especiales #array
     @ultima_sorpresa
     
     if @debug then
       Diario.instance.ocurre_evento("Debug activado")
     end
     
     init()
   end
   
   private
   
   def init()
     @sorpresas = Array.new
     @cartas_especiales = Array.new
     @barajadas = false
     @usadas = 0
   end
   
   public
   
   attr_reader :sorpresas #creado con el proposito de probar la clase
   attr_reader :cartas_especiales #idem
   
   def al_mazo(s)
     
     if !@barajada then
       @sorpresas.push(s)       
     end
   end
   
   def to_string()
     
     i = 0
     
     for i in 0..@sorpresas.length do
       
       puts @sorpresas[i].texto
       i += 1
     end
     
   end
   
   def siguiente()
     
     if ((!@barajada || (@usadas == @sorpresas.length())) && !@debug) then
       #binding.pry
       @sorpresas = @sorpresas.shuffle()
       @usadas = 0
       @barajada = true
       
     end
     @usadas += 1
     @ultima_sorpresa = @sorpresas[0]
     @sorpresas.delete_at(0)
     @sorpresas.push(@ultima_sorpresa)
     
     return @ultima_sorpresa
     
   end
   
   def inhabilitar_carta_especial(sorpresa)
     
     if (@sorpresas.include?(sorpresa)) then
       
       @sorpresas.delete(sorpresa)
       @cartas_especiales.push(sorpresa)
       
       Diario.instance.ocurre_evento("Carta inhabilitada")
     end
     
   end
   
   def habilitar_carta_especial(sorpresa)
     
     if (@cartas_especiales.include?(sorpresa)) then
       
       @cartas_especiales.delete(sorpresa)
       @sorpresas.push(sorpresa)
       
       Diario.instance.ocurre_evento("Carta habilitada")
     end
     
   end

 end
end
