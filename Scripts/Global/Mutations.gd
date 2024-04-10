class_name Mutation


static func Integer(value : int, variation: float):
    return max(0, roundi(value + randfn(0, variation)))


static func Float(value : float, variation: float):
    return max(0, value + randfn(0, variation))


static func FloatArray(array : Array[float], variation: float):
    var mutated_array = []

    for value in array:
        mutated_array.append(Float(value, variation))
    
    return mutated_array


static func IntegerArray(array : Array[int], variation: float):
    var mutated_array = []

    for value in array:
        mutated_array.append(Integer(value, variation))
    
    return mutated_array



static func Color(color : Color, variation: float):
    return Color(
        Float(color.r, variation),
        Float(color.g, variation),
        Float(color.b, variation)
    )