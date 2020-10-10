# encoding:utf-8

module Civitas
 class MazoSorpresas
   
   
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
       sorpresas.push(s)       
     end
   end
   
   def sorpresa_siguiente()
     
     if (!@barajada or (@usadas == @sorpresas.length())) and !@debug
       @usadas = 0
       @barajada = true
       
     end
     
     @usadas += 1
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
       
       Diario.instance.ocurre_evento("Carta inhabilitada")
     end
     
     
   end

 end
end
