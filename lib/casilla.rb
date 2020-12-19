# encoding:utf-8

module Civitas
 class Casilla
  
   attr_reader :nombre
  
   def initialize(nombre)
     @nombre = nombre
   end
   
   def recibe_jugador(iactual, todos)
      informe(iactual, todos)
   end
   
   private
   
   def informe(iactual, todos)
     Diario.instance.ocurre_evento("#{todos[iactual].nombre} ha caído en la casilla:\n"+self.nombre) #Pablo: cambio todos[iactual-1].nombre por el -1?
   end
   
   public
   
   def jugador_correcto(iactual, todos)
     
     return iactual < todos.size()
   end
   
   def to_string()
     puts " Tipo: Descanso"
     puts " Nombre: #{@nombre}"
   end
   
 end
end
