/**
 * A file to keep track of room numbers.
 * Format: NMM -> Nth level, MMth room
 * 
 * If you want to insert a level between two existing ones, you can simply name
 * the variable something like L2R4A, L2R4B, but make sure to update the number assignments
 * so that numbering is consistent to what the player experiences.
 * This also means that the variable name might not necessarily truly reflect the exact room
 * number.
 * 
 * This class also holds an array for which room are checkpoints in each level.
 */
class RoomNo
{
	public static var L1R1 = 101;
	public static var L1R2 = 102;
	public static var L1R3 = 103;
	public static var L1R4 = 104;
	public static var L1R5 = 105;
	public static var L1R6 = 106;
	public static var L1R7 = 107;
	public static var L1R8 = 108;
	public static var L2R1 = 201;
	public static var L2R2 = 202;
	public static var L2R3 = 203;
	public static var L2R4 = 204;
	public static var L2R5 = 205;
	public static var L2R6 = 206;
	public static var L2R7 = 207;
	public static var L2R8 = 208;
	public static var L3R1 = 301;

	public static var CHKPTS = [1 => [L1R1, L1R7], 2 => [L2R1, L2R7], 3 => [L2R1]];
}
