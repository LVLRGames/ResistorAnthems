extends Node

const EPISODES:ResourceGroup = preload("res://resources/episodes.tres")
var all_episodes:Array[Episode] = []
var available_episodes:Array[Episode] = []


func _ready() -> void:
	EPISODES.load_all_into(all_episodes)
	for episode in all_episodes:
		#if episode.available:
		available_episodes.append(episode)
	print(available_episodes)
	
