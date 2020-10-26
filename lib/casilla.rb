# encoding:utf-8

module Civitas
 class Casilla
  
   attr_reader :nombre
   attr_reader :titulo_propiedad
  
   def initialize(tipo, nombre, titulo, cantidad, num_casilla_carcel, mazo)
     @@carcel = num_casilla_carcel
     @importe = cantidad
     @mazo = mazo
     @nombre = nombre
     @sorpresa = nil
     @tipo = tipo
     @titulo_propiedad = titulo 
    
   end
   
   def self.new_casilla_descanso(nombre)
     init()
     new(DESCANSO, nombre, nil, -1, -1, nil)
   end
   
   def self.new_casilla_calle(titulo)
     init()
     new(CALLE, titulo.nombre, titulo, -1, -1, nil)
   end
   
   def self.new_casilla_impuesto(cantidad, nombre)
     init()
     new(IMPUESTO, nombre, nil, cantidad, -1, nil)
   end
   
   def self.new_casilla_juez(num_casilla_carcel, nombre)
     init()
     new(JUEZ, nombre, nil, -1, num_casilla_carcel, nil)
   end
   
   def self.new_casilla_sorpresa(mazo, nombre)
     init()
     new(SORPRESA, nombre, nil, -1, -1, mazo)
   end
   
   private_class_method :new
   
   def recibe_jugador(iactual, todos)
     
   end
   
   private
   
   def informe(iactual, todos)
     Diario.instance.ocurre_evento("#{todos[actual-1].nombre} ha caído en la casilla:\n"+to_string())
   end
   
   def init()
     @@carcel = -1
     @importe = -1
     @mazo = nil
     @nombre = nil
     @sorpresa = nil
     @tipo = nil
     @titulo_propiedad = nil
   end
   
   def recibe_jugador_calle(iactual, todos)
     
   end
   
   def recibe_jugador_impuesto(iactual, todos)
     if jugador_correcto(iactual, todos)
       then informe(iactual, todos)
       todos[actual-1].paga_impuesto(@valor)
     end
   end
   
   def recibe_jugador_juez(iactual, todos)
     if jugador_correcto(iactual, todos)
       then informe(iactual, todos)
       todos[actual-1].encarcelar()
     end
   end
   
   def recibe_jugador_sorpresa(iactual, todos)
     
   end
   
   public
   
   def jugador_correcto(iactual, todos)
     es_correcto = false
      if iactual>=1 && iactual<=todos.length
        then es_correcto = true end
      es_correcto
   end
   
   def to_string()
     puts "Tipo: #{@tipo}\n
           Nombre: #{@nombre}\n0"
     case @tipo
     when JUEZ
       puts "Casilla de cárcel: #{@@carcel}\n"
     when IMPUESTO
       puts "Importe: #{@importe}\n"
     when SORPRESA
       puts "Sorpresa: "
       puts @sorpresa.to_string()
       puts"\n"
     when CALLE
       puts @titulo_propiedad.to_string()
       puts "\n"
     end
   end
   
 end
end
