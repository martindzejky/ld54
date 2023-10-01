extends Node

var loaded = {}

func play(name: String):
    
    # load the sound
    
    if not loaded.has(name):
        
        var path := 'res://sounds/' + name + '.wav'
        
        if not ResourceLoader.exists(path):
            return
        
        var res := ResourceLoader.load(path)
        loaded[name] = res
    
    var player := AudioStreamPlayer2D.new()
    add_child(player)
    player.stream = loaded[name]
    player.play()
    
    await player.finished
    player.queue_free()
