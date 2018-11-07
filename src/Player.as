package  {
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.media.Sound;
	import flash.events.KeyboardEvent;

	public class Player {
		private var lamb:MovieClip;
		private var pram:MovieClip;
		private var touch:MovieClip;
		private var touch2:MovieClip;
		private var jumpOk:Boolean;
		private var pause:Boolean;
		private var missionHandler:MissionHandler;
		
		private var lambJumpSound:Sound;
		private var pramJumpSound:Sound;
		
		private var permy:Permy;
		
		private var hat:MovieClip;
		private var accessory:MovieClip;
		
		private var isTut:Boolean;
		
		private var stage:Stage;
		
		public function Player(lamb:MovieClip,pram:MovieClip,touch:MovieClip,touch2:MovieClip,missionHandler:MissionHandler,permy:Permy,hat:MovieClip,accessory:MovieClip,isTut:Boolean, stage:Stage) {
			this.missionHandler = missionHandler;
			this.lamb = lamb;
			this.lamb.mouseEnabled = false;
			this.lamb.mouseChildren = false;
			this.pram = pram;
			this.pram.mouseEnabled = false;
			this.pram.mouseChildren = false;
			this.pram.w1.play();
			this.pram.w2.play();
			this.lamb.jumpVelocity = -21;
			this.lamb.groundVelocity = -20;
			this.touch = touch;
			this.touch2 = touch2;
			this.jumpOk = true;
			this.isTut = isTut;
			this.touch.addEventListener(MouseEvent.CLICK,jump);
			this.touch2.addEventListener(MouseEvent.CLICK,pramJump);
			this.pause = false;
			
			this.permy = permy;
			
			this.hat = hat;
			this.accessory = accessory;
			
			this.lambJumpSound = new Jump();
			this.pramJumpSound = new PramJump();
			
			this.stage = stage;
			this.stage.addEventListener(KeyboardEvent.KEY_UP, respondToKeyboard);
		}
		
		public function respondToKeyboard(keyboardEvent:KeyboardEvent) {
			// left arrow key
			if(keyboardEvent.keyCode == 37) {
				jump(null);
			}
			// right arrow key
			else if(keyboardEvent.keyCode == 39) {
				pramJump(null);
			}
		}
		
		public function jump(event:Event):void {
			if(this.pause == false) {
				if(this.jumpOk) {
					if(this.isTut == false) {
						this.missionHandler.setJumpsRound(missionHandler.getJumpsRound() + 1);
						this.missionHandler.setJumpsSinceMission(missionHandler.getJumpsSinceMission() + 1);
					}
					if(this.permy.getMute() == false) {
						this.lambJumpSound.play();
					}
					this.lamb.jumpVelocity = 20;
					this.lamb.addEventListener(Event.ENTER_FRAME,jumpAnimation);
				}
			}
		}
		
		public function pramJump(event:Event):void {
			if(this.pause == false) {
				if(this.jumpOk) {
					if(this.isTut == false) {
						this.missionHandler.setJumpsRound(missionHandler.getJumpsRound() + 1);
						this.missionHandler.setJumpsSinceMission(missionHandler.getJumpsSinceMission() + 1);
					}
					if(this.permy.getMute() == false) {
						this.pramJumpSound.play();
					}
					this.lamb.jumpVelocity = 20;
					this.lamb.addEventListener(Event.ENTER_FRAME,pramJumpAnimation);
				}
			}
		}
		
		public function jumpAnimation(event:Event):void {
			if(this.pause == false) {
				if(this.lamb.jumpVelocity >= this.lamb.groundVelocity) {
					this.lamb.y = this.lamb.y - this.lamb.jumpVelocity;
					if(this.isTut == false) {
						this.hat.y = this.lamb.y - 22.5;
						this.accessory.y = this.lamb.y + 52.5;
					}
					this.lamb.jumpVelocity --;
					this.jumpOk = false;
				}
				else {
					this.jumpOk = true;
					this.lamb.removeEventListener(Event.ENTER_FRAME,jumpAnimation);
				}
			}
		}
		
		public function pramJumpAnimation(event:Event):void {
			if(this.pause == false) {
				if(this.lamb.jumpVelocity >= this.lamb.groundVelocity) {
					this.lamb.y = this.lamb.y - this.lamb.jumpVelocity;
					this.pram.y = this.pram.y - this.lamb.jumpVelocity;
					if(this.isTut == false) {
						this.hat.y = this.lamb.y - 22.5;
						this.accessory.y = this.lamb.y + 52.5;
					}
					this.lamb.jumpVelocity --;
					this.jumpOk = false;
				}
				else {
					this.jumpOk = true;
					this.lamb.removeEventListener(Event.ENTER_FRAME,pramJumpAnimation);
				}
			}
		}
		
		public function removeEventListeners():void {
			this.touch.removeEventListener(MouseEvent.CLICK,jump);
			this.touch2.removeEventListener(MouseEvent.CLICK,pramJump);
			this.lamb.removeEventListener(Event.ENTER_FRAME,pramJumpAnimation);
			this.lamb.removeEventListener(Event.ENTER_FRAME,jumpAnimation);
			this.stage.removeEventListener(KeyboardEvent.KEY_UP,respondToKeyboard);
		}
		
		public function setPause() {
			if(this.pause == false) {
				this.pause = true;
				this.pram.w1.stop();
				this.pram.w2.stop();
			}
			else if(this.pause) {
				this.pause = false;
				this.pram.w1.play();
				this.pram.w2.play();
			}
		}
		public function getPause():Boolean {
			return this.pause;
		}
		
		public function getJumpOk():Boolean {
			return this.jumpOk;
		}
		
	}
}
