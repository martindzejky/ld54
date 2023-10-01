extends Node


var day: int = 1
var totalSold: float = 0.0
var soldToday: float = 0.0

var isOpen: bool = true


func addSoldAmount(amount: float):
    totalSold += amount
    soldToday += amount
