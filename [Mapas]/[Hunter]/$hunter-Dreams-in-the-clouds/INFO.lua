setRadioChannel(0)
song = playSound("http://vita.gamers-board.com/serverfiles/race/lindsey88.mp3", true)
outputChatBox("#800000RickAvory: #ffffffHola, ",255,255,255,true)
outputChatBox("#800000RickAvory: #ffffffbienvenido",255,255,255,true)
outputChatBox("#800000RickAvory: #ffffffEste es un mapa hunter para Minijuegos hecho por mi",255,255,255,true)
outputChatBox("#800000RickAvory: #ffffffBuena suerte, ojala ganes usa Control para disparar.",255,255,255,true)
bindKey("z", "down",
function ()
        setSoundPaused(song, not isSoundPaused(song))
end
)