@icon('SpriteStack2DIcon.png')
@tool
extends Node2D
class_name SpriteStack2D

##Forces the sprite to always stack in the direction of the camera center
var always_face_to_camera : bool = false:
	set(value):
		always_face_to_camera = value
		notify_property_list_changed()
		queue_redraw()

##Limits the offset during the stacking
var offset_limit : float = 50.0:
	set(value):
		offset_limit = value
		queue_redraw()

##Changes the scale at which the offset stacks with the center of the screen
var offset_scale: float = 0.07:
	set(value):
		offset_scale = clamp( value , 0, 1 )
		queue_redraw()

## Uses the last drawn sprite as the center istead of the first one
var use_bottom_sprite_as_center : bool = true :
	set(value):
		use_bottom_sprite_as_center = value
		queue_redraw()

##Offset of the sprite
var center_offset : Vector2 = Vector2.ZERO :
	set(value):
		center_offset = value
		queue_redraw()

##Offset at which the textures are stacked
var stack_offset : Vector2 = Vector2.DOWN :
	set(value):
		stack_offset = value
		queue_redraw()
		

##Textures that will be stacked
var textures : Array[Texture] = []:
	set(value):
		textures = value
		queue_redraw()

func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		queue_redraw()
		

var texture_count : int = textures.size() - 1

var camera : Camera2D

func _draw() -> void:
	camera = get_viewport().get_camera_2d()
	texture_count = textures.size()
	
	if always_face_to_camera and !Engine.is_editor_hint():
		stack_offset = ( ( camera.get_screen_center_position() - global_position ) * offset_scale ).limit_length( offset_limit )
	
	if use_bottom_sprite_as_center:
		for texture : int in range( 0 , texture_count - 1 ):
			if textures[ texture ]:
				var in_between : Vector2 = stack_offset / texture_count
				draw_texture( textures[ texture ] , Vector2( center_offset.x , 0 ) - ( textures[ texture ].get_size() / 2 ) + ( -in_between * (texture + center_offset.y) ).rotated( -global_rotation ) )
	else:
		for texture : int in range( texture_count - 1, -1, -1 ):
			if textures[ texture ]:
				var in_between : Vector2 = stack_offset / texture_count
				draw_texture( textures[ texture ] , Vector2( center_offset.x , 0 ) - ( textures[ texture ].get_size() / 2 ) + ( in_between * (texture + center_offset.y) ).rotated( -global_rotation ) )
	

func _get_property_list() -> Array[Dictionary]:
	var property_list : Array[Dictionary] = []
	
	property_list.append(
		{
			"name": "use_bottom_sprite_as_center",
			"type": TYPE_BOOL
		})
	
	property_list.append(
		{
		"name": "always_face_to_camera",
		"type": TYPE_BOOL,
		})
	
	property_list.append(
		{
			"name": "center_offset",
			"type": TYPE_VECTOR2
		})
	
	if always_face_to_camera:
		property_list.append(
			{
			"name": "offset_limit",
			"type": TYPE_FLOAT,
			})
			
		property_list.append(
			{
			"name": "offset_scale",
			"type": TYPE_FLOAT,
			})
	else:
		property_list.append(
		{
			"name": "stack_offset",
			"type": TYPE_VECTOR2
		})
	
	property_list.append(
		{
			"name": "textures",
			"type": TYPE_ARRAY,
			"hint": PROPERTY_HINT_TYPE_STRING,
			"hint_string": str("%d/%d:" + "Texture2D") % \
				[TYPE_OBJECT, PROPERTY_HINT_RESOURCE_TYPE]
		})
	
	return property_list

func set_offset_to( offset : Vector2 ) -> void:
	stack_offset = offset
	
