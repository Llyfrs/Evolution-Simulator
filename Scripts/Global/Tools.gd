extends Node


func print_patten(pattern):
	for i in range(len(pattern)):
		print(str(i) + ". " + str(pattern[i]))


func check_pattern(pattern):
	for i in range(pattern.size()):
		for j in range(pattern[i].size()):
			for k in range(4):
				if pattern[i][j][k] >= pattern.size():
					print("error")
