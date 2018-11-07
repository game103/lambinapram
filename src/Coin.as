package  {
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.display.DisplayObject;
	
	public class Coin {
		private var lamb:MovieClip;
		private var pram:MovieClip;
		private var coins:Number;
		private var coinField:TextField;
		private var coin1:MovieClip;
		private var enemy:Enemy;
		private var sendThem:Boolean;
		private var pause:Boolean;
		private var permy:Permy;
		
		private var missionHandler:MissionHandler;

		public function Coin(lamb:MovieClip,pram:MovieClip,coinField:TextField,coin1:MovieClip,enemy:Enemy,missionHandler:MissionHandler,permy:Permy) {
			this.lamb = lamb;
			this.pram = pram;
			this.permy = permy;
			this.coins = 0;
			this.coinField = coinField;
			this.coin1 = coin1;
			this.enemy = enemy;
			this.missionHandler = missionHandler;
			
			this.coin1.mouseEnabled = false;
			this.coin1.mouseChildren = false;
			
			this.coin1.value.text = (Math.floor(Math.random()*10) + 1).toString();
			
			this.coin1.addEventListener(Event.ENTER_FRAME,move);
			
			this.coin1.x = 1010;
			this.sendThem = false;
			
			this.pause = false;
		}
		
		public function move(event:Event) {
			if(this.pause == false) {
				//keep coin box updated
				this.coinField.text = this.coins.toString();
				if(this.sendThem) {
					
					//get money
					if(this.coin1.visible) {
						if(this.coin1.x < 280) {
							if(this.coin1.hitTestObject(this.lamb) || this.coin1.hitTestObject(this.pram)) {
								if(this.coin1.perfectHitTest(this.lamb,1) || this.coin1.perfectHitTest(this.pram,1)) {
									this.coins = this.coins + Number(this.coin1.value.text);
									this.permy.setTotalCoins(this.permy.getTotalCoins() + Number(this.coin1.value.text));
									this.missionHandler.setCoinsRound(this.missionHandler.getCoinsRound() + Number(this.coin1.value.text));
									this.missionHandler.setCoinsSinceMission(this.missionHandler.getCoinsSinceMission() + Number(this.coin1.value.text));
									this.coin1.visible = false;
								}
							}
						}
					}
					
					this.coin1.x = this.coin1.x - this.enemy.getSpeed();
					if(this.coin1.x <= -50) {
						this.coin1.visible = true;
						this.coin1.x = 1010;
						this.coin1.value.text = (Math.floor(Math.random()*10) + 1).toString();
						this.sendThem = false;
					}
				}
				else if(this.enemy.getMovingX() <= 480) {
					if(this.sendThem == false) {
						var level:Number = (Math.floor(Math.random()*3) + 1);
						var yCor:Number = 0;
						if(level == 1) {
							yCor = 175;
						}
						else if(level == 2) {
							yCor = 315;
						}
						else if(level == 3) {
							yCor = 505;
						}
						this.coin1.y = yCor;
						this.sendThem = true;
					}
				}
			}
		}
		
		public function removeEventListeners():void {
			this.coin1.removeEventListener(Event.ENTER_FRAME,move);
		}
		
		public function getCoins():Number {
			return this.coins;
		}
		
		public function setPause() {
			if(this.pause == false) {
				this.pause = true;
			}
			else if(this.pause) {
				this.pause = false;
			}
		}
		public function getPause():Boolean {
			return this.pause;
		}

		public function addCoins(coins:Number) {
			this.coins = this.coins + coins;
			this.permy.setTotalCoins(this.permy.getTotalCoins() + coins);
		}
	}
	
}
