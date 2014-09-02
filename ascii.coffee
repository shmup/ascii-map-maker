class AsciiMap
  constructor: (@c) ->
    @ctx = @c.getContext("2d")

  set_character: (e) -> document.canvas_character = String.fromCharCode(e.which)
  get_character: () -> document.canvas_character or "+"

  write: (e) =>
    if not e.which then return
    @ctx.font = "18px Source Code Pro"
    console.log e
    offsetX = if e.offsetX then e.offsetX else e.layerX
    offsetY = if e.offsetY then e.offsetY else e.layerY
    console.log Math.floor(offsetX/document.cell_size)
    console.log Math.floor(offsetY/document.cell_size)
    x = Math.floor(offsetX/document.cell_size)*document.cell_size
    y = Math.floor(offsetY/document.cell_size)*document.cell_size
    # console.log "x: #{x}"
    # console.log "y: #{y}"
    character = @get_character()
    @ctx.clearRect(x+1, y+1, document.cell_size-1, document.cell_size-1)
    @ctx.fillText(character, x+5, y+document.cell_size-4)
    document.storage.save(x, y, character)
    

  draw: (width=0, height=0, cell_size) ->
    document.cell_size = cell_size
    
    @c.addEventListener('click', @write)
    @c.addEventListener('mousemove', @write)

    document.addEventListener('keypress', @set_character)

    x = 0.5
    y = 0.5
    w = width * cell_size + 1
    h = height * cell_size + 1

    @c.width = w
    @c.height = h

    while x < w
      @ctx.moveTo(x, 0)
      @ctx.lineTo(x, h)
      x += cell_size

    while y < h
      @ctx.moveTo(0, y)
      @ctx.lineTo(w, y)
      y += cell_size

    @ctx.strokeStyle = "#ddd"
    @ctx.stroke()

class document.MapStorage
  constructor: (@db_name, @width, @height) ->
    @map = localStorage.getItem(@db_name) or @build_map()

  @build_map: () ->
    arr = new Array(@height)
    arr[i] = new Array(@width) for i in arr
    arr

  save: (x, y, character) ->
    data =
      x: x,
      y: y,
      c: character
    localStorage.setItem(@db_name, JSON.stringify(data))
    # if @map == null
    #   arr = new Array(@height)
    #   arr[i] = new Array(@width) for i in arr
    #   localStorage.setItem(@db_name


ascii_map = new AsciiMap document.getElementById("c")
ascii_map.draw(100, 100, 20)
#
document.storage = new document.MapStorage("map", 20, 30)
