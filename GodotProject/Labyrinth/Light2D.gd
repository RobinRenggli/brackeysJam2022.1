extends Light2D

onready var noise = OpenSimplexNoise.new()
var value = 0.0
const MAX_VALUE = 100000000

func _ready():
	randomize()
	value = randi() % MAX_VALUE
	noise.period = 16

func _physics_process(delta):
	value += 0.5
	if(value > MAX_VALUE): #when value gets too big it loses
		value = 0.0 #precision and stops generating new noise
	var alpha = ((noise.get_noise_1d(value) + 1) / 4.0) + 0.5 #alpha is between 0.5 and 1.0
	self.color = Color(color.r, color.g, color.b, alpha)
