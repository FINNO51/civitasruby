# encoding:utf-8

module Civitas
 class Casilla
  
   attr_reader :nombre
   attr_reader :titulo_propiedad
  
   def initialize(tipo, nombre, titulo, cantidad, num_casilla_carcel, mazo)
     if num_casilla_carcel != -1 then
      @@carcel = num_casilla_carcel
     end
     @importe = cantidad
     @mazo = mazo
     @nombre = nombre
     @sorpresa = nil
     @tipo = tipo
     @titulo_propiedad = titulo 
    
   end
   
   def self.new_casilla_descanso(nombre)
     self.init()
     new(Tipo_casilla::DESCANSO, nombre, nil, -1, -1, nil)
   end
   
   def self.new_casilla_calle(titulo)
     self.init()
     new(Tipo_casilla::CALLE, titulo.nombre, titulo, -1, -1, nil)
   end
   
   def self.new_casilla_impuesto(cantidad, nombre)
     self.init()
     new(Tipo_casilla::IMPUESTO, nombre, nil, cantidad, -1, nil)
   end
   
   def self.new_casilla_juez(num_casilla_carcel, nombre)
     self.init()
     new(Tipo_casilla::JUEZ, nombre, nil, -1, num_casilla_carcel, nil)
   end
   
   def self.new_casilla_sorpresa(mazo, nombre)
     self.init()
     new(Tipo_casilla::SORPRESA, nombre, nil, -1, -1, mazo)
   end
   
   # private_class_method :new
   
   def recibe_jugador(iactual, todos)
     
     case @tipo
       
     when Tipo_casilla::CALLE
       recibe_jugador_calle(iactual, todos)
     when Tipo_casilla::IMPUESTO
       recibe_jugador_impuesto(iactual, todos)
     when Tipo_casilla::JUEZ
       recibe_jugador_juez(iactual, todos)
     when Tipo_casilla::SORPRESA
       recibe_jugador_sorpresa(iactual, todos)
     when Tipo_casilla::DESCANSO
       informe(iactual, todos)
     end
     
   end
   
   private
   
   def informe(iactual, todos)
     Diario.instance.ocurre_evento("#{todos[iactual].nombre} ha caído en la casilla:\n"+self.nombre) #Pablo: cambio todos[iactual-1].nombre por el -1?
   end
   
   def self.init()
     @importe = -1
     @mazo = nil
     @nombre = nil
     @sorpresa = nil
     @tipo = nil
     @titulo_propiedad = nil
   end
   
   def recibe_jugador_calle(iactual, todos)
     
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
   
   def recibe_jugador_impuesto(iactual, todos)
     if jugador_correcto(iactual, todos)
       then informe(iactual, todos)
       todos[iactual].paga_impuesto(@importe)
     end
   end
   
   def recibe_jugador_juez(iactual, todos)
     if jugador_correcto(iactual, todos)
       then informe(iactual, todos)
       todos[iactual].encarcelar(@@carcel)
     end
   end
   
   def recibe_jugador_sorpresa(iactual, todos)
     
     if jugador_correcto(iactual, todos)
       @sorpresa = @mazo.siguiente()
       informe(iactual, todos)
       @sorpresa.aplicar_a_jugador(iactual, todos)
     end
     
   end
   
   public
   
   def jugador_correcto(iactual, todos)
     
     return iactual < todos.size()
   end
   
   def to_string()
     puts " Tipo: #{@tipo}"
     puts " Nombre: #{@nombre}"
     case @tipo
     when Tipo_casilla::JUEZ
       puts " Casilla de cárcel: #{@@carcel}"
     when Tipo_casilla::IMPUESTO
       puts " Importe: #{@importe}"
     when Tipo_casilla::SORPRESA
       puts " Sorpresa"
       @sorpresa.to_string()
       #puts @sorpresa.to_string()
     when Tipo_casilla::CALLE
       puts @titulo_propiedad.to_string()
     end
   end
   
 end
end
