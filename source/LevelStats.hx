import flixel.FlxG;
import openfl.utils.IAssetCache;

class LevelStats extends BaseLevel
{
	public static var curr_level:Int;
	public static var curr_room:Int;
	public static var timer:Float;
	public static var beat:Float;
	public static var prev_beat:Int;
	public static var shortest_notes_elpsd:Int;
	public static var prev_sne:Int;
	public static var shortest_note_len:Float;
	public static var ticks_len:Int;
	public static var _ticks:Array<Tick>;
	public static var scroll_mul:Int;

	// PURELY FOR TESTING
	public static var enchant_chance:Float;

	public static var bpm:Float;
	public static var qtr_note:Float;
	public static var shortest_note:LevelState.NoteType;
	public static var snpq:Int;
	public static var tick_format:Array<LevelState.AttackType>;

	// supposed boundaries of timeline display
	public static var TIMELINE_LEFT = 100;
	public static var TIMELINE_RIGHT = 1060;
	public static var TIMELINE_TOP = 0;
	public static var TIMELINE_BOTTOM = 50;
	public static var TICK_X_OFFSET:Int;

	public static function initialize(level_no:Int)
	{
		curr_level = level_no;
		curr_room = 0;
		timer = 0;
		beat = 0;
		prev_beat = 0;
		shortest_notes_elpsd = 0;
		prev_sne = 0;
		TICK_X_OFFSET = Std.int(FlxG.width / 2);
		switch (level_no)
		{
			case 1:
				bpm = 130;
				tick_format = [RED, RED, RED, RED];
				shortest_note = QUARTER;
				snpq = 1;
				scroll_mul = 350;
				enchant_chance = 0.25;
				ticks_len = 16;
			default:
		}
		qtr_note = 60 / bpm;

		switch (shortest_note)
		{
			case QUARTER:
				shortest_note_len = qtr_note;
			case EIGHTH:
				shortest_note_len = qtr_note / 2;
			case SIXTEENTH:
				shortest_note_len = qtr_note / 4;
		}
		createTicks();
	}

	public static function update(elapsed:Float)
	{
		timer += elapsed;
		beat = timer / qtr_note;
		shortest_notes_elpsd = Math.floor(timer / shortest_note_len);
		updateTicks();
	}

	private static function createTicks()
	{
		_ticks = new Array();
		for (i in 0...(tick_format.length * 4))
		{
			var tick = new Tick(tick_format[i % tick_format.length], i, Math.random() <= enchant_chance,
				Std.int((i * shortest_note_len - timer) * scroll_mul) + TICK_X_OFFSET, TIMELINE_BOTTOM - TIMELINE_TOP);
			_ticks[i] = tick;
			// tick.makeGraphic(20, TIMELINE_BOTTOM - TIMELINE_TOP, temp_color, true);
			// tick.x = (i * shortest_note_len - timer) * scroll_mul;
			// tick.y = -150;
			tick.scrollFactor.set(0, 0);
		}
	}

	private static function updateTicks()
	{
		for (i in _ticks)
		{
			i.x = (i.getTick() * shortest_note_len - timer) * scroll_mul + TICK_X_OFFSET;
		}
		if (shortest_notes_elpsd >= Std.int(_ticks.length / 2))
		{
			if (shortest_notes_elpsd > prev_sne)
			{
				var recycled_tick = _ticks[(shortest_notes_elpsd - Std.int(_ticks.length / 2)) % _ticks.length];
				// TESTING ONLY; TO BE CHANGED LATER WHEN ENCHANTED MARKUP IS CREATED
				// (also, enchanted has to be set before judge in order for enchant glow to show up properly)
				recycled_tick.setEnchanted(Math.random() <= enchant_chance);
				recycled_tick.setJudge(NONE);
				recycled_tick.setTick(shortest_notes_elpsd + Std.int(_ticks.length / 2));
				debugTickDisplay();
			}
		}
	}

	private static function debugTickDisplay()
	{
		var output = "";
		for (i in _ticks)
		{
			output += " " + i.getTick();
			switch (i.getJudge())
			{
				case NONE:
					output += "N";
				case PERFECT:
					output += "P";
				case GREAT:
					output += "G";
				case OK:
					output += "O";
				default:
			}
			if (i.getEnchanted())
			{
				output += "#";
			}
		}
		trace(output);
	}
}