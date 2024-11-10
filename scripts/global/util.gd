extends Node

var enemies_killed: int = 0

func within_duration(now: int, then: int, span: int):
	return now <= then + span

func outside_duration(now: int, then: int, span: int):
	return now > then + span
