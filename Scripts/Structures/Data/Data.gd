## "Abstract" class for different data types that can be returned by a Sensor when it detects a object
class_name Data


enum DataType {
	WALL,
	FOOD,
	PLANT,
	CREATURE
}

var type : DataType


## Yes the sensor only scans to a certain distance and in that sense it works like a if statement
## but it does not allow creature to ignore something if it's close for example 
var distance : float 


