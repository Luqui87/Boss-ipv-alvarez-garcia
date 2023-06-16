extends StaticBody2D

export (bool) var right : bool ;



func _on_Area2D_body_entered(body):
	body._handle_transporter(1)


func _on_Area2D_body_exited(body):
	body._handle_exit_transporter()
