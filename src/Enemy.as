package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	public class Enemy {
		private var target1:MovieClip;
		private var target2:MovieClip;
		private var target3:MovieClip;
		private var sendOne:Number;
		private var speed:Number;
		private var lamb:MovieClip;
		private var pram:MovieClip;
		private var scorekeeper:Scorekeeper;
		private var player:Player;
		private var scenery:Scenery;
		private var coin:Coin;
		private var permy:Permy;
		private var fade:MovieClip;
		private var newHighScore:Boolean;
		private var timer:Timer;
		private var allDone:Boolean;
		private var leaveRate:Number;
		private var pause:Boolean;
		private var pausable:Boolean;
		private var missionHandler:MissionHandler;
		private var mainSound:SoundChannel;
		private var mainSoundSound:Sound;
		private var fadeTimer:Timer;
		private var pauseSoundPos:Number;
		private var isTut:Boolean;
		
		private var first1:Number;
		private var second:Number;
		private var third:Number;
		private var fourth:Number;
		
		private var everyTime:Number;
	

		public function Enemy(target1:MovieClip,target2:MovieClip,target3:MovieClip,lamb:MovieClip,pram:MovieClip,scorekeeper:Scorekeeper,player:Player,fade:MovieClip,permy:Permy,missionHandler:MissionHandler,mainSound:SoundChannel,mainSoundSound:Sound,isTut:Boolean) {
			this.target1 = target1;
			this.target2 = target2;
			this.target3 = target3;
			this.target1.mouseEnabled = false;
			this.target1.mouseChildren = false;
			this.target2.mouseEnabled = false;
			this.target2.mouseChildren = false;
			this.target3.mouseEnabled = false;
			this.target3.mouseChildren = false;
			
			this.first1 = 3;
			this.second = 3;
			this.third = 3;
			this.fourth = 3;
			
			this.lamb = lamb;
			this.lamb.mouseEnabled = false;
			this.lamb.mouseChildren = false;
			this.pram = pram;
			this.pram.mouseEnabled = false;
			this.pram.mouseChildren = false;
			
			this.scorekeeper = scorekeeper;
			this.player = player;
			
			this.isTut = isTut;
			
			if(this.isTut) {
				this.everyTime = 1;
			}
			else {
				this.everyTime = -1;
			}
			
			this.fade = fade;
			
			this.permy = permy;
			
			this.allDone = false;
			
			this.timer = new Timer(1000);
			
			this.speed = 15;
			
			this.leaveRate = 31;
			
			this.pause = false;
			this.pausable = true;
			
			this.missionHandler = missionHandler;
			
			this.mainSound = mainSound;
			
			this.fadeTimer = new Timer(60);
			this.fadeTimer.addEventListener(TimerEvent.TIMER,fadeSound);
			
			this.pauseSoundPos = 0;
			this.mainSoundSound = mainSoundSound;
			
			this.move();
		}
		
		public function fadeSound(event:Event) {
			var vol:Number = this.mainSound.soundTransform.volume;
			var soundT:SoundTransform = this.mainSound.soundTransform;
			vol = vol - 0.05;
			soundT.volume = vol;
			if(vol > 0) {
				this.mainSound.soundTransform = soundT; 
			}
			else {
				this.mainSound.stop();
				this.fadeTimer.stop();
				this.fadeTimer.removeEventListener(TimerEvent.TIMER,fadeSound);
			}
		}
		
		
		public function move():void {
			if(this.pause == false) {
				if(this.speed < 24 || this.fourth == 1 || this.third == 1 || this.second == 1 || this.first1 == 1) {
					this.sendOne = Math.floor(Math.random() * 3) + 1;
				}
				else {
					this.sendOne = 1;
				}
				if(this.everyTime != -1) {
					this.sendOne = everyTime;
				}
				this["target"+sendOne].gotoAndStop(Math.floor(Math.random() * 3) + 1);
				this["target"+sendOne].addEventListener(Event.ENTER_FRAME,go);
				this.fourth = this.third;
				this.third = this.second;
				this.second = this.first1;
				this.first1 = this.sendOne;
			}
		}
		
		public function go(event:Event):void {
			if(this.pause == false) {
				this["target"+sendOne].x = this["target"+sendOne].x - this.speed;
				if(this["target"+sendOne].x < 280) {
					if(this["target"+sendOne].hitTestObject(this.lamb) || this["target"+sendOne].hitTestObject(this.pram)) {
						if(this["target"+sendOne].perfectHitTest(this.lamb,1) || this["target"+sendOne].perfectHitTest(this.pram,1)) {
							if(this.isTut == false) {
								this.die();
							}
							else {
								if(this.isTut) {
									this.lamb.alpha = .5;
									this.pram.alpha = .5;
								}
							}
							//eventually this will be die - remmber to remove Event listener
						}
						else {
							if(this.isTut) {
								this.lamb.alpha = 1;
								this.pram.alpha = 1;
							}
						}
					}
					else {
						if(this.isTut) {
							this.lamb.alpha = 1;
							this.pram.alpha = 1;
						}
					}
				}
				else {
					if(this.isTut) {
						this.lamb.alpha = 1;
						this.pram.alpha = 1;
					}
				}
				if(this["target"+sendOne].x < - 100) {
					this["target"+sendOne].x = 1010;
					if(this.speed < 26) {
						if(this.isTut == false) {
							this.speed = this.speed + 0.25;
						}
					}
					this["target"+sendOne].removeEventListener(Event.ENTER_FRAME,go);
					this.move();
				}
			}
		}
		
		public function getSpeed():Number { 
			return this.speed;
		}
		
		public function setScenery(scenery:Scenery):void {
			this.scenery = scenery;
		}
		
		public function setCoin(coin:Coin):void {
			this.coin = coin;
		}
		
		public function getMovingX():Number {
			return this["target"+sendOne].x;
		}
		
		//lose game - remove all event listeners and stuff from objects, that is why the enemy knows about them
		public function die() {
			mainSound.removeEventListener(Event.SOUND_COMPLETE,restartSoundFromBeginning);
			fadeTimer.start();
			if(this.permy.getMute() == false) {
				var dieSound:Sound = new Lose();
				dieSound.play();
			}
			this.pausable = false;
			this["target"+sendOne].removeEventListener(Event.ENTER_FRAME,go);
			this["target"+sendOne].inner.stop();
			this.pram.w1.stop();
			this.pram.w2.stop();
			this.player.removeEventListeners();
			this.coin.removeEventListeners();
			this.scenery.removeEventListeners();
			this.scorekeeper.removeEventListeners();
			this.missionHandler.removeEventListeners();
			this.fade.x = 0;
			this.fade.alpha = 0;
			
			this.permy.addScoreQueue(this.scorekeeper.getScore());
			//new hiScore variable
			//SET PERMANANT HI SCORE
			if(this.permy.getHiScore() < this.scorekeeper.getScore()) {
				this.newHighScore = true;
				this.permy.setHiScore(this.scorekeeper.getScore());
				this.fade.newHighScoreText.visible = true;
			}
			else {
				this.newHighScore = false;
				this.fade.newHighScoreText.visible = false;
			}
			
			this.fade.scoreText.text = this.scorekeeper.getScore();
			this.fade.coinsText.text = this.coin.getCoins();
			this.fade.hiScoreText.text = this.permy.getHiScore();
			this.fade.totalCoinsText.text = this.permy.getTotalCoins() - this.coin.getCoins();
			
			this.fade.scoreLabel.x = -452;
			this.fade.scoreText.x = -224;
			this.fade.coinsLabel.x = -452;
			this.fade.coinsText.x = -224;
			this.fade.hiScoreLabel.x = -452;
			this.fade.hiScoreText.x = -224;
			this.fade.totalCoinsLabel.x = -494;
			this.fade.totalCoinsText.x = -224;
			
			this.fade.newHighScoreText.scaleX = 0;
			this.fade.newHighScoreText.scaleY = 0;
			
			this.fade.addEventListener(Event.ENTER_FRAME,waitAMoment);
		}
		
		public function waitAMoment(event:Event):void {
			var timer:Timer = new Timer(1000,1);
			timer.addEventListener(TimerEvent.TIMER,dieAnimationBegin);
			timer.start();
			this.fade.removeEventListener(Event.ENTER_FRAME,waitAMoment);
		}
		
		public function dieAnimationBegin(event:TimerEvent) {
			this.fade.addEventListener(Event.ENTER_FRAME,dieAnimation);
		}
		
		public function dieAnimation(event:Event):void {
			this.allDone = false;
			if(this.fade.alpha < 1) {
				this.fade.alpha = this.fade.alpha + 0.05;
			}
			else if(this.fade.alpha > 1) {
				this.fade.alpha = 1;
			}
			else if(this.fade.scoreLabel.x < 44) {
				this.fade.scoreLabel.x = this.fade.scoreLabel.x + this.leaveRate;
				this.fade.scoreText.x = this.fade.scoreText.x + this.leaveRate;
				this.leaveRate = this.leaveRate - 1;
				if(this.leaveRate == 0) {
					this.leaveRate = 31;
				}
			}
			else if(this.fade.coinsLabel.x < 44) {
				this.fade.coinsLabel.x = this.fade.coinsLabel.x + this.leaveRate;
				this.fade.coinsText.x = this.fade.coinsText.x + this.leaveRate;
				this.leaveRate = this.leaveRate - 1;
				if(this.leaveRate == 0) {
					this.leaveRate = 31;
				}
			}
			else if(this.fade.hiScoreLabel.x < 44) {
				this.fade.hiScoreLabel.x = this.fade.hiScoreLabel.x + this.leaveRate;
				this.fade.hiScoreText.x = this.fade.hiScoreText.x + this.leaveRate;
				this.leaveRate = this.leaveRate - 1;
				if(this.leaveRate == 0) {
					this.leaveRate = 31;
				}
			}
			else if(this.fade.totalCoinsLabel.x < 2) {
				this.fade.totalCoinsLabel.x = this.fade.totalCoinsLabel.x + this.leaveRate;
				this.fade.totalCoinsText.x = this.fade.totalCoinsText.x + this.leaveRate;
				this.leaveRate = this.leaveRate - 1;
			}
			else if(this.newHighScore && this.fade.newHighScoreText.scaleX < 1) {
				this.fade.newHighScoreText.scaleX = this.fade.newHighScoreText.scaleX + 0.05;
				this.fade.newHighScoreText.scaleY = this.fade.newHighScoreText.scaleY + 0.05;
			}
			else if(Number(this.fade.coinsText.text > 0)) {
				if(Number(this.fade.coinsText.text) > 1000) {
					this.fade.coinsText.text = (Number(this.fade.coinsText.text) - 1000).toString();
					this.fade.totalCoinsText.text = (Number(this.fade.totalCoinsText.text) + 1000).toString();
				}
				else if(Number(this.fade.coinsText.text) > 100) {
					this.fade.coinsText.text = (Number(this.fade.coinsText.text) - 100).toString();
					this.fade.totalCoinsText.text = (Number(this.fade.totalCoinsText.text) + 100).toString();
				}
				else if(Number(this.fade.coinsText.text) > 10) {
					this.fade.coinsText.text = (Number(this.fade.coinsText.text) - 10).toString();
					this.fade.totalCoinsText.text = (Number(this.fade.totalCoinsText.text) + 10).toString();
				}
				else {
					this.fade.coinsText.text = (Number(this.fade.coinsText.text) - 1).toString();
					this.fade.totalCoinsText.text = (Number(this.fade.totalCoinsText.text) + 1).toString();
				}
			}
			else {
				this.allDone = true;
			}
		}
		
		public function removeDieListeners():void {
			this.fade.removeEventListener(Event.ENTER_FRAME,dieAnimation);
		}
		
		public function getAllDone():Boolean {
			return this.allDone;
		}
		
		public function setPause() {
			if(this.pause == false) {
				this.pause = true;
				this.pauseSoundPos = mainSound.position;
				mainSound.stop();
				this.target1.inner.stop();
				this.target2.inner.stop();
				this.target3.inner.stop();
			}
			else if(this.pause) {
				this.pause = false;
				if(this.permy.getMute() == false) {
					mainSound = mainSoundSound.play(this.pauseSoundPos,1,new SoundTransform(0.4));
					mainSound.addEventListener(Event.SOUND_COMPLETE,restartSoundFromBeginning);
				}
				this.target1.inner.play();
				this.target2.inner.play();
				this.target3.inner.play();
			}
		}
		
		function restartSoundFromBeginning(event:Event) {
			mainSound.removeEventListener(Event.SOUND_COMPLETE,restartSoundFromBeginning);
			mainSound = mainSoundSound.play(0,999,new SoundTransform(0.4));
		}
		
		public function getPause():Boolean {
			return this.pause;
		}
		
		public function getPausable():Boolean {
			return this.pausable;
		}
			
		public function setEveryTime(everyTime:Number) {
			this.everyTime = everyTime;
		}
	}
	
}
