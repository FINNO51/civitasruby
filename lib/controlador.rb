module Civitas
  class Controlador
    
    private
    
    @juego
    @vista
    
    public
    
    def initialize(juego, vista)
      
      @juego = juego
      @vista = vista
      
    end
    
    def juega()
      
      final = false
      
      @vista.set_civitas_juego(@juego)
      
      while !final do

        @vista.actualizarVista()
        @vista.pausa()
        siguiente_op = @juego.siguiente_paso()
        puts "---------------------------------------"
        @vista.mostrarSiguienteOperacion(siguiente_op)
        puts "---------------------------------------"

        
        if siguiente_op != Operaciones_juego::PASAR_TURNO then

          while Diario.instance.eventos_pendientes() do
            puts Diario.instance.leer_evento()
          end
        end
        
        if !final then
          
          case siguiente_op
       
          when Operaciones_juego::COMPRAR

            
            respuesta = @vista.comprar()
            
            if respuesta == Lista_respuestas[0] then
              @juego.comprar()

            end
            @juego.siguiente_paso_completado(siguiente_op)
            
            
           
          when Operaciones_juego::GESTIONAR
            
            @vista.gestionar()
            gestion = @vista.i_gestion
            propiedad = @vista.i_propiedad
            case gestion
              
            when 0
              @juego.vender(propiedad)
            when 1
              @juego.hipotecar(propiedad)
            when 2
              @juego.cancelar_hipoteca(propiedad)
            when 3
              @juego.construir_casa(propiedad)
            when 4
              @juego.construir_hotel(propiedad)
            when 5
              @juego.siguiente_paso_completado(siguiente_op)
            end
             
          when Operaciones_juego::SALIR_CARCEL
            
            if @vista.salir_carcel() == Salidas_carcel::PAGANDO then
              @juego.salir_carcel_pagando
            else
              @juego.salir_carcel_tirando
            end
            @juego.siguiente_paso_completado(siguiente_op)
              
          end
          
        else
          lista = juego.ranking()
          puts "Ranking:\n"
          for i in 0..lista.length()
            puts lista[i]+"\n"
          end
          
        end
        
      end
      
    end
    
  end
end
