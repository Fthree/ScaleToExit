class_name Check_Scale_Attribute
extends Attribute

signal check_scale(source: Box)

func do_check(source: Box):
	check_scale.emit(source)