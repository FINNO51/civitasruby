#encoding:utf-8
require_relative 'operaciones_juego'
require 'io/console'

module Civitas

  class Vista_textual
    
    attr_reader :i_gestion
    attr_reader :i_propiedad
    
    private
    
    @i_gestion
    @i_propiedad
    
    public
    
    def initialize()
      @i_gestion = -1
      @i_propiedad = -1
    end

    def mostrar_estado(estado)
      puts estado
    end

    
    def pausa
      print "Pulsa una tecla"
      STDIN.getch
      print "\n"
    end

    def lee_entero(max,msg1,msg2)
      ok = false
      begin
        print msg1
        cadena = gets.chomp
        begin
          if (cadena =~ /\A\d+\Z/)
            numero = cadena.to_i
            ok = true
          else
            raise IOError
          end
        rescue IOError
          puts msg2
        end
        if (ok)
          if (numero >= max)
            ok = false
          end
        end
      end while (!ok)

      return numero
    end



    def menu(titulo,lista)

      tab = "  "
      puts titulo
      index = 0
      lista.each { |l|
        puts tab+index.to_s+"-"+l.to_s
        index += 1
      }

      opcion = lee_entero(lista.length,
                          "\n"+tab+"Elige una opción: ",
                          tab+"Valor erróneo")
      return opcion
    end

    
    def comprar
      
      return Lista_respuestas[menu("Quieres comprar la calle #{@juegoModel.casilla_actual.to_string()}?", Lista_respuestas)]
      
    end

    def gestionar
      
      @i_gestion = menu("Elige gestion inmobiliaria\n",Lista_gestiones_inmobiliarias)
      if @i_gestion != 5 then
        @i_propiedad = menu("Elige una propiedad\n", @juegoModel.jugador_actual.propiedades)
      end
      
    end

    def mostrarSiguienteOperacion(operacion)
      puts "Siguiente operacion: ", operacion
    end

    def mostrarEventos
      while Diario.instance.eventos_pendientes do
        puts Diario.instance.leer_evento()
      end
    end

    def set_civitas_juego(civitas)
         @juegoModel=civitas
         # self.actualizarVista
    end

    def actualizarVista
      #system "clear"
      puts "Jugador:"
      puts @juegoModel.info_jugador_texto()
      puts "Casilla:"
      puts @juegoModel.casilla_actual.to_string()
    end
    
    def salir_carcel
      
      return Lista_salidas_carcel[menu("¿Cómo quieres salir de la carcel?",Lista_salidas_carcel)]
    end

  end

end
