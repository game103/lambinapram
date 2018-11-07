package  {
	import flash.text.TextField;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.media.Sound;
	import com.milkmangames.nativeextensions.ios.*; 
	import com.milkmangames.nativeextensions.ios.events.*;
	
	public class Scorekeeper {
		private var score:Number;
		private var scoreText:TextField;
		private var hiScore:Number;
		private var hiScoreText:TextField;
		private var stage:Stage;
		private var missionHandler:MissionHandler;
		
		private var pause:Boolean;
		
		private var hiScoreSound:Sound;
		private var gotHiScore:Boolean;

		private var permy:Permy;
		
		private var gameCenter:GameCenter;
		private var reportNovice:Boolean;
		private var reportPro:Boolean;
		private var reportMaster:Boolean;
		
		//Note, permannt high score is in permy, not here - this is just for textField
		public function Scorekeeper(scoreText:TextField,hiScore:Number,hiScoreText:TextField,stage:Stage,missionHandler:MissionHandler,permy:Permy,gameCenter:GameCenter) {
			this.score = 0;
			this.hiScore = hiScore;
			this.scoreText = scoreText;
			this.hiScoreText = hiScoreText;
			this.stage = stage;
			stage.addEventListener(Event.ENTER_FRAME, scoreFunction);
			this.hiScoreText.text = hiScore.toString();
			this.pause = false;
			this.missionHandler = missionHandler;
			this.hiScoreSound = new MissionComplete();
			if(this.hiScore > 0) {
				this.gotHiScore = false;
			}
			else {
				this.gotHiScore = true;
			}
			this.permy = permy;
			
			this.gameCenter = gameCenter;
			this.reportNovice = false;
			this.reportPro = false;
			this.reportMaster = false;
		}
		
		public function scoreFunction(event:Event) {
			if(this.pause == false) {
				score = score + 1;	
				this.missionHandler.setScoreRound(this.missionHandler.getScoreRound() + 1);
				this.missionHandler.setScoreSinceMission(this.missionHandler.getScoreSinceMission() + 1);
				scoreText.text = score.toString();
				if(this.score > this.hiScore) {
					if(this.gotHiScore == false) {
						if(this.permy.getMute() == false) {
							hiScoreSound.play();
						}
						this.gotHiScore = true;
					}
					this.hiScore = score;
					this.hiScoreText.text = hiScore.toString();
				}
				if(score >= 2000) {
					if(this.reportNovice == false) {
						GameCenter.gameCenter.reportAchievement("grp.scoreNovice",100.0);
						this.reportNovice = true;
					}
				}
				if(score >= 4000) {
					if(this.reportPro == false) {
						GameCenter.gameCenter.reportAchievement("grp.scorePro",100.0);
						this.reportPro = true;
					}
				}
				if(score >= 7500) {
					if(this.reportMaster == false) {
						GameCenter.gameCenter.reportAchievement("grp.scoreMaster",100.0);
						this.reportMaster = true;
					}
				}
			}
		}
		
		public function removeEventListeners():void {
			stage.removeEventListener(Event.ENTER_FRAME, scoreFunction);
		}
		
		public function getScore():Number {
			return this.score;
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

	}
	
}
