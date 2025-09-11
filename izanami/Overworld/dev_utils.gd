extends Node

#@export_flags('Grid:2', 'Image:4', 'Height Map:8') var outputs: int
@export var texture: Texture2D
@export var noise: Noise
@export var texture_display: TextureRect
@export var map_layers: Node2D

@export_dir var folder_location: String = "user://"
@export var r_cord: Vector2i
@export var g_cord: Vector2i
@export var b_cord: Vector2i

@export var walls_terrain_set: int
@export var walls_terrain: int
@export var water_terrain_set: int
@export var water_terrain: int
@export var floor_terrain_set: int
@export var floor_terrain: int

@export var wall_steps: int
@export var noise_multiplier: float
@export var max_passes: int = 1

var final_noise_texture: Texture2D

# Colour data
const COLOR_MAX: int = 255
const ALPHA_MAX: int = 255
const RESOLUTION: int = 1
const FORMATS = [
	"FORMAT_L8",
	"FORMAT_LA8",
	"FORMAT_R8",
	"FORMAT_RG8",
	"FORMAT_RGB8",
	"FORMAT_RGBA8",
	"FORMAT_RGBA4444",
	"FORMAT_RGB565",
	"FORMAT_RF",
	"FORMAT_RGF",
	"FORMAT_RGBF",
	"FORMAT_RGBAF",
	"FORMAT_RH",
	"FORMAT_RGH",
	"FORMAT_RGBH",
	"FORMAT_RGBAH",
	"FORMAT_RGBE9995",
	"FORMAT_DXT1",
	"FORMAT_DXT3",
	"FORMAT_DXT5",
	"FORMAT_RGTC_R",
	"FORMAT_RGTC_RG",
	"FORMAT_BPTC_RGBA",
	"FORMAT_BPTC_RGBF",
	"FORMAT_BPTC_RGBFU",
	"FORMAT_ETC",
	"FORMAT_ETC2_R11",
	"FORMAT_ETC2_R11S",
	"FORMAT_ETC2_RG11",
	"FORMAT_ETC2_RG11S",
	"FORMAT_ETC2_RGB8",
	"FORMAT_ETC2_RGBA8",
	"FORMAT_ETC2_RGB8A1",
	"FORMAT_ETC2_RA_AS_RG",
	"FORMAT_DXT5_RA_AS_RG",
	"FORMAT_ASTC_4x4",
	"FORMAT_ASTC_4x4_HDR",
	"FORMAT_ASTC_8x8",
	"FORMAT_ASTC_8x8_HDR",
	"FORMAT_MAX",
]

# SOURCE IMAGE DATA
var image: Image
var height: int:
	get(): return image.get_height()
var width: int:
	get(): return image.get_width()
var size: int:
	get(): return image.get_data_size()
var image_data: PackedByteArray
var chunk_size: int = 3:
	get(): return size / (width * height)

# NOISE DATA
var noise_image: Image
var noise_data: PackedByteArray

# OUTPUTS
var calculated_image_data: Array
var pixel_data: String = ''
var grid: Array

#var grid = [
	#[0, 0, 0, 0],
	#[0, 0, 0, 0],
	#[0, 0, 0, 0],
	#[0, 0, 0, 0],
#]
#var packed_grid = [
	#[[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]],
	#[[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]],
	#[[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]],
	#[[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]],
#]

func _ready() -> void:
	_parse_variables()
	decode_map_data()
	parse_image_data()
	draw_result_image(false)
	encode_calculated_data()

	#pass

func _parse_variables():
	image = texture.get_image()
	image.shrink_x2()
	image.shrink_x2()
	#image.shrink_x2()
	image_data = image.get_data()

	#grid = create_2d_grid(width, height)
	noise_image = noise.get_image(width, height)
	if chunk_size >= 4: noise_image.convert(Image.FORMAT_LA8)
	noise_data = noise_image.get_data()



#region Parse Source Image
func decode_map_data():
	print('Height: ', height)
	print('Width: ', width)
	print('Size: ', size)
	#print(image_data.slice(0, 50))
	print('Format: ', FORMATS[image.get_format()])
	print('Data Chunk size: ', chunk_size)
	print('Sample Data ', image_data.slice(0, 50))
	print('Noise Format: ', FORMATS[noise_image.get_format()])
	print('Noise Data Chunk size: ', noise_data.size()/ (width * height))
	print('Noise Sample Data ', noise_data.slice(0, 50))

func parse_image_data():
	for i in range(0, size, chunk_size):
		var data := [image_data[i], image_data[i+1], image_data[i+2]]
		if chunk_size >= 4: data.append(image_data[i+3])

		parse_image_pixel_date(data)

		#draw_grid_cell(
			#get_index_coords(i / chunk_size),
			#data
		#)

		#draw_tilemap_cell_elevation(
			#get_index_coords(i / chunk_size),
			#data
		#)

	#print_image_using_strings()


func get_index_coords(index: int):
	return Vector2i(index % width, index / width)

func draw_grid_cell(coords: Vector2i, data: Array):
	grid[coords.y][coords.x] = snappedf(get_pixel_value(data) * 10, 0.1)

func parse_image_pixel_date(data: Array):
	calculated_image_data.append(snappedf(get_pixel_value(data), 0.1))
	if chunk_size >= 4: calculated_image_data.append(data[3] / ALPHA_MAX)

func get_pixel_value(data: Array) -> float:
	var pixel_vector: Vector3i = Vector3i(data[1], data[0], data[2]) #Format GRB because of how vector defaults work
	var value: float
	match  pixel_vector.max_axis_index():
		0: value = 0
		1: value = (pixel_vector.y - pixel_vector.x)
		2: value = (pixel_vector.x - pixel_vector.z)

	if data.size() >= 4:
		value *= data[3] / ALPHA_MAX
	return value
	#return (value / COLOR_MAX)
#endregion

#region Interpose map data with noise
func draw_result_image(show: bool):
	for i in calculated_image_data.size():
		calculated_image_data[i] *= float(noise_data[i]) * noise_multiplier
		if calculated_image_data[i] < 0:
			calculated_image_data[i] = - COLOR_MAX
		else:
			calculated_image_data[i] = snapped(calculated_image_data[i], wall_steps)

	print('Calculated Data: ', format_data((calculated_image_data), 1).slice(0, 50))
	print('MAX: ', calculated_image_data.max(), 'MIN: ', calculated_image_data.min())

	if show:
		var data_image = Image.create_from_data(width, height, false, Image.FORMAT_L8, calculated_image_data)
		#noise.get_image(width, height)
		final_noise_texture = ImageTexture.create_from_image(data_image)
		texture_display.texture = final_noise_texture
		texture_display.show()


func format_data(data: Array, format: int):
	var new_array := []
	for i in range(0, data.size(), format):
		new_array.append(data[i])
		for j in (format - 1):
			new_array.append(data[i + j])
	return new_array
#endregion

#region Draw tile map from Noise
func encode_calculated_data():
	var tiles := []
	for i in range(0, calculated_image_data.size(), 1):
		tiles.append([
			get_index_coords(i ),
			calculated_image_data[i]
		])

	print('Tiles: ', tiles.slice(0, 500))
	convert_calculated_data_to_tilemap(tiles)

func convert_calculated_data_to_tilemap(tiles: Array):
	var walls: Dictionary[int, Array]
	var water: Array
	var floor_tiles: Array
	for i in tiles:
		var data = i[1]
		if data >= 0 and data <= wall_steps:
			floor_tiles.append(i[0])
		if data > wall_steps:
			_generate_walls_layered(walls, i[0], data)
		if data < 0:
			water.append(i[0])

	print('Walls:')
	for i in walls:
		print(i, ': ', walls[i].slice(0, 50))

	var count := 0
	var ignore_empty := false
	while count < max_passes:
		count += 1
		for i in walls:
			_render_walls(walls[i], map_layers.get_child(i), ignore_empty)

		_render_water(water, ignore_empty)
		_render_floor(floor_tiles, ignore_empty)

		print('Rendered: ', count)
		print('Ignore: ', ignore_empty)

		for i in walls:
			walls[i].reverse()
		water.reverse()
		floor_tiles.reverse()

		ignore_empty = true


func _generate_walls_layered(store_array: Dictionary, coord: Vector2i, noise_value: int):
	var layer = 0
	var count = 2
	while layer <= 255 and layer <= noise_value and count < map_layers.get_child_count():
		store_array.get_or_add(count, []).append(coord)
		layer += wall_steps
		count += 1

func _render_walls(tiles: Array, layer: TileMapLayer, ignore_empty: bool):
	layer.set_cells_terrain_connect(tiles, walls_terrain_set, walls_terrain, ignore_empty)

func _render_water(tiles: Array, ignore_empty: bool):
	map_layers.get_child(1).set_cells_terrain_connect(tiles, water_terrain_set, water_terrain, ignore_empty)

func _render_floor(tiles: Array, ignore_empty: bool):
	map_layers.get_child(0).set_cells_terrain_connect(tiles, floor_terrain_set, floor_terrain, ignore_empty)
#endregion


func create_2d_grid(w: int, h: int) -> Array:
	var _grid := []

	for i in h:
		var row := []
		row.resize(w)
		row.fill(1)
		_grid.append(row)

	return _grid


func draw_tilemap_cell_elevation(coords: Vector2i, data: Array):
	match data.find(data.max()):
		0: map_layers.get_child(0).set_cell(coords, 1, r_cord)
		1: map_layers.get_child(0).set_cell(coords, 1, g_cord)
		2: map_layers.get_child(0).set_cell(coords, 1, b_cord)

func print_max(data: Array):
	match data.find(data.max()):
		1: return 'r'
		2: return 'g'
		3: return 'b'

func save_pattern():
	for i in map_layers.get_children():
		var file_location = folder_location + "map_layer_%d_set.tres" % [i.get_index()]
		var pattern: TileMapPattern = i.get_pattern(i.get_used_cells())
		i.tile_set.add_pattern(pattern)
		print(ResourceSaver.save(i.tile_set, file_location))
		print('Added map_layer_%d' % [i.get_index()])


func print_image_using_strings():
	for j in range(0, height * chunk_size, chunk_size):
		for i in range(0, width * chunk_size, chunk_size):
			convert_pixel_to_string(
				image_data[(j * width) + i + 0],
				image_data[(j * width) + i + 1],
				image_data[(j * width) + i + 2],
				image_data[(j * width) + i + 3],
			)
		print_rich(pixel_data)
		pixel_data = ''

func convert_pixel_to_string(r: int, g: int, b: int, a: int):
	if chunk_size < 4: a = COLOR_MAX
	var value: String = '#' + Color.from_rgba8(r, g, b, a).to_html()
	#print(value)
	pixel_data += "[color=%s].[/color]" % [value]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('test'):
		save_pattern()
