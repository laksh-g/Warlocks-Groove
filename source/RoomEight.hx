import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.shapes.*;
import flixel.addons.editors.ogmo.FlxOgmo3Loader.EntityData;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import howler.Howl;
import howler.Howler;
import js.html.idb.Factory;

using flixel.util.FlxSpriteUtil;

class RoomEight extends LevelState
{
	public var charge_aura:FlxSprite;

	override public function create()
	{
		super.create();
		room_no = RoomNo.L1R8;
		FlxG.fixedTimestep = false;

		bgColor = 0xffcccccc;
		createLevel();
		nextLevel = LvlTwoRoomOne;
		currLevel = RoomEight;
		end_of_level = true;

		// beat_sound = FlxG.sound.load("assets/sounds/beat.wav");
		// beat_sound.volume = 0.3;

		// setShortestNote();

		// var line_style_2 = {color: FlxColor.BLACK, thickness: 3.0};
		// timeline_arw = new FlxShapeArrow(-5, -50, new FlxPoint(10, 50), new FlxPoint(10, 0), 15, line_style_2);
		// add(timeline_arw);
		// var draw_style = {smoothing: true};

		// level_bounds = FlxCollision.createCameraWall(FlxG.camera, true, 1);
		createHUDandTicks();
		levelUpdate();
		var boss = null;
		for (m in _monsters)
		{
			if (m.alive)
			{
				boss = m;
			}
		}
		_hud.spawnBossBar(boss);
		_actionSignal.add(handleCall);
		// timer = 0;
		// beat = 0;
		// shortest_notes_elpsd = 0;
		// prev_sne = 0;
		// FlxG.sound.playMusic("assets/music/test.mp3", 0.6, true);
		charge_aura = new FlxSprite();
		charge_aura.loadGraphic("assets/images/charge.png", false, 0, 0, true);
		charge_aura.alpha = 0;
		add(charge_aura);
	}

	function createLevel()
	{
		map = new FlxOgmo3Loader(AssetPaths.map1__ogmo, AssetPaths.room8__json);
		walls = map.loadTilemap(AssetPaths.tiles__png, "walls");
		interactables = map.loadTilemap(AssetPaths.tiles__png, "Interactables");
		add(walls);
		add(interactables);
		// loadTutorial();
	}

	function loadTutorial()
	{
		var mouse = new FlxSprite(70, 200);
		mouse.loadGraphic("assets/images/mouse.png", false, 80, 64, true);
		add(mouse);
		var instr = new FlxText(50, 360, 0, "FIRE ON BEAT", 10);
		instr.setFormat("assets/font.ttf", 20, FlxColor.RED, LEFT);
		instr.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		add(instr);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	/**
	 * takes calls from enemies present in this room.
	 * @param input 0th index = action, 1st index = X-coordinate for action, 2nd index = Y-coordinate, 3rd and further = anything else needed
	 */
	public function handleCall(input:Array<Float>)
	{
		switch (input[0])
		{
			case 0:
				// TODO: replace this with proper own projectile
				_projectiles.add(new EnemyBullet(input[1], input[2], _player, _player.getMidpoint(), "FB from Cat", 140.0));
			case 1:
				for (i in 0...(LevelStats.hard_mode ? 6 : 4))
				{
					var ran_point = _player.getMidpoint();
					ran_point.rotate(FlxPoint.weak(input[1], input[2]), FlxG.random.float(-50, 50));
					_projectiles.add(new LargeBullet(input[1], input[2], null, ran_point, "Large from Cat",
						FlxG.random.float(90, LevelStats.hard_mode ? 160 : 140)));
					ran_point.put();
				}
			case 2:
				_projectiles.add(new WaveBullet(input[1], input[2], _player, _player.getMidpoint(), "Wave from Cat", (LevelStats.hard_mode ? 160.0 : 150.0)));
			// signal to send just to start charging sprite
			// input[3] = charge time
			case 3:
				charge_aura.setPosition(input[1] - 110, input[2] - 100);
				FlxTween.tween(charge_aura, {alpha: 1}, input[3], {
					ease: FlxEase.cubeOut,
					onComplete: function(input:FlxTween):Void
					{
						FlxTween.tween(charge_aura, {alpha: 0}, 0.4, {ease: FlxEase.quadOut});
					}
				});
			default:
		}
	}

	// disabling for now...
	// private override function handleMonsterProjectileCollisions(monsters:FlxObject, projectiles:Projectile)
	// {
	// 	if (projectiles.getType() != ENEMY)
	// 	{
	// 		if (projectiles.getType() == RED && !cast(projectiles, MagMissile).blow)
	// 		{
	// 			LevelStats.hitOnce(projectiles._timing);
	// 		}
	// 		if (Std.isOfType(monsters, Cat))
	// 		{
	// 			var cat = cast(monsters, Cat);
	// 			if (cat.shielded)
	// 			{
	// 				if (projectiles._enchanted)
	// 				{
	// 					cat.curr_shield_hp--;
	// 					if (cat.curr_shield_hp == 0)
	// 					{
	// 						cat.shieldBreaking();
	// 						// other shield-breaking code goes here
	// 					}
	// 				}
	// 				else
	// 				{
	// 					// shield deflecting projectile logic goes here
	// 				}
	// 			}
	// 			else
	// 			{
	// 				monsters.health -= projectiles.getDamage();
	// 				if (monsters.health <= 0)
	// 				{
	// 					_monsters.remove(cast(monsters, Enemy));
	// 					monsters.kill();
	// 				}
	// 				projectiles.kill();
	// 				// trace("projectile kill initiated");
	// 			}
	// 		}
	// 		monsters.health -= projectiles.getDamage();
	// 		if (monsters.health <= 0)
	// 		{
	// 			_monsters.remove(cast(monsters, Enemy));
	// 			spawnHealthPellets(cast(monsters, Cat).pellet_drop, monsters.getMidpoint().x, monsters.getMidpoint().y);
	// 			monsters.kill();
	// 		}
	// 		else
	// 		{
	// 			var spawn = 0;
	// 			if (LevelStats.combo >= 100)
	// 			{
	// 				spawn = 2;
	// 			}
	// 			else if (LevelStats.combo >= 25)
	// 			{
	// 				spawn = 1 + FlxG.random.int(0, 1);
	// 			}
	// 			else
	// 			{
	// 				spawn = FlxG.random.int(0, 1);
	// 			}
	// 			spawnHealthPellets(spawn, monsters.getMidpoint().x, monsters.getMidpoint().y);
	// 		}
	// 		projectiles.kill();
	// 		// trace("projectile kill initiated");
	// 	}
	// }
}
