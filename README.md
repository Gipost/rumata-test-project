⚔ **Top-Down Mini-Game (Godot Test Task)** ⚔
![скриншот](https://i.postimg.cc/Vvh0tGqB/rumata.png)
В данном тестовом задании реализован top-down проект, соответствующий ТЗ.
Персонаж - рыцарь, передвигается по карте в поисках монеток, имеющий дэщ атаку. Противники - слизни, которые патрулируют свои участки. При встрече с игроком они начинают преследовать его и могут делать дэш в его сторону.

Реализована модульная система ИИ, которая позволяет при необходимости добавлять новых мобов с разными типами поведения (например, без чарджа, или без патруля или только с чарджем, или вообще спокойно добавить стрелка с проджектайлами).

Генерация карты выполняется на основе Simplex Noise.
Также реализованы сохранения, игра сохраняется при выходе через меню (ESC). 
Вместо обычного Victory Screen реализована катсцена: появляется секретный проход, камера плавно к нему переходит, а по достижении игроком - вызывается Victory Screen.

**Ответы на вопросы:**

**Вопрос 1.**
Как работает система сцены в Godot и в чем ее преимущества? 

В Godot каждая сцена - это дерево узлов (Nodes), которая состоит из Parent(родитель) и Children(потомки) образуя иерархию. Такая структура позволяет компоновать игру модульно.
При запуске сцены Godot вызывает методы жизненного цикла узлов:
**_enter_tree()** - вызывается, когда узел добавлен в дерево сцены. Здесь удобно подключать сигналы и готовить зависимости.
**_ready()** - вызывается один раз, когда все дочерние узлы готовы. Тут обычно инициализируются данные и начинается работа узла.
**_process(delta)** - вызывается каждый кадр, используется для логики, которая не зависит от физики.
**_physics_process(delta)** - вызывается с фиксированным шагом для физики и движения.

Пример блок схемы платформера
```
[StartScreen.tscn]
 └── Label "Loading..."
        |
        v
[MainMenu.tscn]
 ├── Button "Play" --> переход к Game.tscn
 └── Button "Exit"
        |
        v
[Game.tscn]
 ├── Level
 │    ├── Player
 │    ├── TileMapLayers
 │    └── EnemyNodes
  │   └── PickUps
 ├── CanvasLayer
 │    ├── ScreenFrameUI(статичный интерфейс, аля полоска здоровья, монеты и подобное)
 │    ├── PopupMenu(Вызываемое меню во время игры)
 │    └── DialogueControl(UI диалогов)
```

**Вопрос 2.**
Объясните, как работают сигналы (Signals) в Godot?
Приведите общий пример использования сигналов и\или двух несвязанных между собой node (Не имеющие общего родителя)

Сигналы — это механизм обратной связи , который позволяет узлам общаться между собой, не зная напрямую о существовании друг друга. 
Узел может излучать (emit) сигнал при определённом событии, а другие узлы могут подписываться (connect) на него и выполнять код-обработчик.
Простой пример реализации в Area2D в body_entered, для реализации получения урона на основе коллизии
```
func _on_contact_area_body_entered(body: Node2D) -> void:
	if body is Player: //проверка на нужный нам объект
		match body.current_state:
			Player.State.DASH:
				self.take_damage()
			_:
				body.take_damage() //вызываем функцию у нашего объекта который мы получили с помощью эмита сигнала
```
также можно использовать и свои собственные сигналы.

**Вопрос 3.**
Как в GDScript организовать наследование, и зачем это нужно?

В GDScript наследование задаётся через ключевое слово extends. Один скрипт может расширять другой, получая его свойства и методы. 
Также можно использовать встроенные классы Godot (например, Node2D, CharacterBody2D, Control) как базовые.
Зачем это нужно? Модульность, удобство, возможность расширения классов, добавляя им специфичные особенности.
Пример:
```
class_name Entity
extends CharacterBody2D
var health: int = 10
func take_damage(amount: int):pass
func die():pass
```
```
class_name Player //в классе игрока добавляем параметр броня и реализуем получение урона уже с учетом брони
extends Entity
var armor: int = 5
func take_damage(amount: int):
  health -= amount/(1-armor*0.1)
```
**Вопрос 4.**
Как работает система импорта ресурсов в Godot? Что произойдет, если изменить исходный файл изображения?

При импортировании ресурса Godot автоматически помещает его в систему импорта, создавая файл с расширением .import
При изменении исходного файла он просто переимпортируется в проект.

**Вопрос 5.**
Что такое _process() и _physics_process() в GDScript и чем они отличаются?

_process(delta)

    Вызывается каждый кадр.
    Частота вызова зависит от FPS игры (например, при 60 FPS — 60 раз в секунду).
    Используется для всего, что не зависит строго от физики:
    
      анимации (tween)
      визуальные эффекты
      UI-логика
      отслеживание состояния, которое не требует фиксированной точности
    
    Пример:
    
    func _process(delta):
        rotation += 90 * delta  # плавный поворот спрайта
        
_physics_process(delta)
    
    Вызывается с фиксированной частотой (обычно 60 раз в секунду, можно настроить в настройках проекта).
    Используется для:
  
      обработки физики
      движения с учётом коллизий (move_and_slide, move_and_collide)
  Пример:
  func _physics_process(delta):
      velocity.y += 800 * delta  # гравитация
      velocity = move_and_slide(velocity, Vector2.UP)

**Вопрос 6.**
Как создать и использовать таймер (Timer) в Godot?
```
  await get_tree().create_timer(1.00).timeout
```
  или создать через инспектор 
  или задать вручную через код
  ```
    func _ready():
    	var timer = Timer.new()
    	timer.wait_time = 2.0  
    	timer.one_shot = true
    	add_child(timer)
    	timer.start()
  ```
    	# коннектим сигнал
    	timer.timeout.connect(_on_timer_timeout)
  ```
  func _on_timer_timeout():
  	print("timeout")
  ```
**Вопрос 7.**
Объясните, как работает система слоев и масок (Layers and Masks) для коллизий в Godot.

Простыми словами Слой это на каком слое находится объект
а маска это с какими слоями он будет взаимодействовать
Пример игрок находится на 1 слое(предположим он назван player)
А Enemy находится на 2 слое (предположим он назван enemy)
и вот чтобы коллизия работала 
у Player должен быть указан в mask слой Enemy
А у Enemy слой player соответственно для его коллизии т.к проверка на коллизию двухсторонняя


**Вопрос 8.**
Как в GDScript организовать взаимодействие между разными сценами или узлами?

Через прямую ссылку на узел
```
var player = get_node("/root/Game/Player")
player.health -= 10
```
С помощью **@export** или **@onready** разница в том что @export хранится на диске
```
@export var target: Node
target.do_something()
```
через сигнал
```
PlayerNode
signal died
func _on_health_zero():
    emit_signal("died")
 ```
```   
GameController
player.died.connect(_on_player_died)
func _on_player_died():
    game_over()
```
**Вопрос 9.**
Как загрузить и инстанцировать сцену динамически во время выполнения игры?
C помощью load и preload, при этом желательно использовать load(), т.к с preload() если наша сцена в более чем одном экземпляре могут появляться баги и проблемы
пример
```
func spawn_enemy():
	var EnemyScene = load("res://scenes/Enemy.tscn")
	var enemy = EnemyScene.instantiate()
	get_tree().current_scene.add_child(enemy)
```
**Вопрос 10.**
Какие средства профилирования и отладки предоставляет Godot? Как ими пользоваться?

*Output / Debug Console*:
  Показывает ошибки, предупреждения и print() вывод.
  Можно использовать push_warning() и push_error() для более структурированных сообщений.
  Также можно посмотреть stack trace, мониторинг fps, статистику (количество объектов нод,память видеопамять и т.д.)
*Remote scene tree и inspector*:
  Позволяют смотреть структуру сцен во время выполнения а также значения параметров у нод.

**Вопрос 11.**
Как реализовать систему сохранения и загрузки данных игры в Godot? Какие существуют подходы и какие классы для этого используются?
Через файлы и дикшинари. 
Условно в дикшинари закидываем нужные нам данные такие как позиции объектов/их параметры/или просто нужные нам параметры
потом открываем файл на write и сохраняем после чего открываем его для чтения чтобы получить эти параметры нашей функцией в любой момент
пример:
```
func save_game():
	var save_data = {}
	save_data["seed"] = Globals.room_seed
	save_data["room_height"] = Globals.game_config.room_height
	save_data["room_width"] = Globals.game_config.room_width
	save_data["show_tutor"] = Globals.show_tutor
	var player = Globals.player
	if player:
		save_data["player"] = {
			"pos": [player.global_position.x, player.global_position.y],
			#собранные монеты
			"coins": Globals.GameController.collected_coins 
		}
  var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()
```
  #читаем наш сейвфайл
  ```
func get_savefile():
	if not FileAccess.file_exists("user://savegame.json"):
		return 
	
	var file = FileAccess.open("user://savegame.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(data) != TYPE_DICTIONARY:
		return
	return data
  ```
```
  #берем нужную инфу
  func load_tutor_state():
	var data = get_savefile()
	if data:
		Globals.show_tutor = data["show_tutor"]
```
**Вопрос 12.**
Как подключить и использовать Android плагины в Godot? Какие шаги необходимы для интеграции?

   Честно говоря я не использовал Android плагины для интеграции в Godot. Но интегрировал SDK в геймейкере до этого по этому могу предположить что это не очень сложно.
   Предположу что мы добавляем наш плагин в папку проекта res://android/plugins/ и в android экспорте ставим галочку над нашим плагином
   и после вызываем его наподобии 
   ```
   if Engine.has_singleton("MyPlugin"):
    var plugin = Engine.get_singleton("MyPlugin")
    plugin.call("doSomething")  
  ```

На этом все, Спасибо за внимание!
