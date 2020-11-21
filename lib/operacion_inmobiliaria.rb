module Civitas

 class Operacion_inmobiliaria
   
   public
   attr_reader :num_propiedad
   attr_reader :gestion
   
   def initialize(gest, ip)
     
     @gestion = gest
     @num_propiedad = ip
    
   end
 end
end
