class_name MoveEffect extends CombatActionEffect

var amount : int
var lateral_direction : LateralDirection
var range_direction : RangeDirection

enum LateralDirection {
    PLAYER_LEFT = -1,
    PLAYER_RIGHT = 1,
    NONE = 0
}

enum RangeDirection {
    PLAYER_FORWARD = -1,
    PLAYER_BACKWARD = 1,
    NONE = 0
}
