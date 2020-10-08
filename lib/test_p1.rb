require_relative "civitas.rb"

include Civitas
module Civitas
class TestP1
  def initialize
    
  end
  
  
  def self.main()
    list = Array.new(4)
    #_dado = Dado.instance

    
    for i in 0..3
      list[i] = 0
    end
    
    for j in 1..100
      n = Dado.instance.quien_empieza(4)
      
      case n
      when 0
        list[0] += 1
      when 1
        list[1] += 1
      when 2
        list[2] += 1
      when 3
        list[3] += 1
      end
    end
    
    for k in 0..3
      puts list[k]
    end
    
    # Los valores pseudoaleatorios estan correctamente distribuidos
    
    Dado.instance.debug = true
    
    for i in 0..5
      puts Dado.instance.tirar()
    end
    
     Dado.instance.debug = false
    
    for i in 0..5
      puts Dado.instance.tirar()
    end
    
    # El modo debug funciona correctamente
    
    puts Dado.instance.ultimo_resultado()
    puts Dado.instance.salgo_de_la_carcel()
    
    #Ambos metodos funcionan
    s1 = "Sorpresa 1"
    s2 = "Sorpresa 2"
    mazo = MazoSorpresas.new()
    
    mazo.al_mazo(s1)
    mazo.al_mazo(s2)
    
    puts mazo.sorpresas.length()
    
    mazo.inhabilitar_carta_especial(s1)
    
    puts mazo.sorpresas.length()
    
    mazo.habilitar_carta_especial(s1)
    
    puts mazo.sorpresas.length
    
    puts Diario.instance.leer_evento()
    puts Diario.instance.eventos_pendientes()
    puts Diario.instance.ocurre_evento("Evento de prueba")
    
    #La clase Diario funciona correctamete
    
    tab = Tablero.new(10)
    puts tab.casillas.length()
    puts tab.por_salida()
    tab.aniade_casilla(Casilla.new("Prueba"))
    puts tab.casillas.length()
    
    puts "juez:"
    puts tab.tiene_juez()
    tab.aniade_juez()
    puts tab.tiene_juez()
    
    
    
    
    
  end
end
  
  TestP1.main()
  
end
