# encoding:utf-8
require_relative "civitas.rb"

include Civitas
class TestP1
  
  def initialize
    
  end
  
  
  def self.main()
    
    
    #1. Llamada a quien_empieza() 100 veces
    puts "[1]Prueba de metodo quien_empieza()----"
    
    list = Array.new(4)
    
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
    puts "---------------------------------------"
    
    
    #2. Prueba del modo debug
    puts "[2] Prueba del modo debug -------------"
    
    Dado.instance.debug = true
    
    for i in 0..5
      puts Dado.instance.tirar()
    end
    
     Dado.instance.debug = false
    
    for i in 0..5
      puts Dado.instance.tirar()
    end
    puts "---------------------------------------"
    
    
    #3. Prueba de ultimo_resultado y salgo_de_la_carcel
    puts "[3] Prueba de otros metodos de dado----"
    
    puts Dado.instance.ultimo_resultado()
    puts Dado.instance.salgo_de_la_carcel()
    
    puts "---------------------------------------"
    
    #4. Mostrar un tipo de cada enumerado
    puts "[4] Mostrar enumerados-----------------"
    
    include Operaciones_juego
    include Tipo_casilla
    include Tipo_sorpresa
    
    puts AVANZAR
    puts CALLE
    puts IR_CARCEL
    
    puts "---------------------------------------"
   
    
    #5. Crear un MazoSorpresas y hacer las pruebas especificadas
    puts "[5]Prueba de MazoSorpresas-------------"
    
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
    
    puts "---------------------------------------"
    
    #6. Prueba clase tablero
    puts "[6] Prueba clase tablero---------------"
    
    tab = Tablero.new(10)
    puts tab.casillas.length()
    puts tab.get_por_salida()
    tab.añade_casilla(Casilla.new("Prueba"))
    puts tab.casillas.length()
    
    if tab.casilla(5) == nil then
      puts "Valor nulo al intentar acceder a casilla inexistente"
    end
    
    for i in 0..17
      tab.añade_casilla(Casilla.new("Prueba"))
    end
    puts tab.casillas.length()
    
    puts tab.calcular_tirada(3,15)
    puts tab.calcular_tirada(15,4)
    puts tab.nueva_posicion(18, Dado.instance.tirar())
    
    tab_erroneo = Tablero.new(10)
    puts tab_erroneo.nueva_posicion(0, 5)
    
    puts "---------------------------------------"
    
  end
end
  
TestP1.main() 
