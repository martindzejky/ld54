extends Node


var totalSold: float = 0.0
var soldToday: float = 0.0


func addSoldAmount(amount: float):
    totalSold += amount
    soldToday += amount
