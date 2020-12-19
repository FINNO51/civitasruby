# encoding:utf-8

module Civitas
  
 class Tablero
   
  def initialize (n=0)
    if n >= 1 then
      @num_casilla_carcel = n
    else
      @num_casilla_carcel = 1
    end 
     
    @casillas = Array.new
    @casillas.push(Casilla.new("Salida"))
    @por_salida = 0
    @tiene_juez = false
  end
  
  def correcto()
    
    if @casillas.length() > @num_casilla_carcel then
      b = true
    else
      b = false
    end
    
    return b
  end
  
  def _correcto(num_casilla)
    
    if correcto() and num_casilla < @casillas.length() then
      b = true
    else
      b = false
    end
    
    return b
  end
  
  public
  
  attr_reader :num_casilla_carcel
  attr_reader :casillas #creado para probar la clase
  attr_reader :tiene_juez #idem
  
  def get_por_salida()
    
    n = @por_salida
    
    if @por_salida > 0 then
      @por_salida -= 1
    end
    
    return n
  end
  
  def añade_casilla(nueva_casilla)
    
    if @num_casilla_carcel == @casillas.length() then
      @casillas.push(Casilla.new("CARCEL"))
    end
    
    @casillas.push(nueva_casilla)
    
    if @num_casilla_carcel == @casillas.length() then
      @casillas.push(Casilla.new("Carcel"))
    end
  end
  
  def añade_juez()
    
    if !@tiene_juez then
      @casillas.push(Casilla_Juez.new(@num_casilla_carcel, "Juez"))
      @tiene_juez = true
    end
  end
  
  def casilla(n)

    s_casilla = nil
    
    if _correcto(n) then
      s_casilla = @casillas[n]
    end
    
    return s_casilla
  end
  
  def nueva_posicion(actual, tirada)
    
    if !correcto() then
      n = -1
      
    else
      n = (actual + tirada)%@casillas.length()
      
      if n != actual + tirada then
        
        @por_salida += 1
      end
    end
    
    return n
  end
  
  def calcular_tirada(origen, destino)
    
    tirada = destino - origen
    
    if tirada < 0 then
      tirada += @casillas.length()
    end
    
    return tirada
  end
  
 end
end
