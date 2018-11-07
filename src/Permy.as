package  {
	
	public class Permy {
		private var totalCoins:Number;
		private var hiScore:Number;
		private var mute:Boolean;
		private var hat:String;
		private var accessory:String;
		private var boughtItems:Array;
		private var tutSeen:Boolean;
		private var pramColor:Number;
		
		private var userId:String;
		private var userName:String;
		private var scoreQueue:Array;
		
		private static var permy:Permy;
		
		public static function getPermy() {
			if( permy == null ) {
				permy = new Permy();
			}
			return permy;
		}
		
		public function Permy() {
			this.hiScore = 0;
			this.totalCoins = 0;
			this.mute = false;
			this.hat = "None";
			this.accessory = "None";
			this.tutSeen = false;
			this.boughtItems = new Array();
			this.pramColor = 1;
			this.scoreQueue = new Array();
			this.userId = null;
			this.userName = null;
		}
		
		public function getPramColor():Number {
			return this.pramColor
		}
		
		public function setPramColor(color:Number) {
			this.pramColor = color;
		}
		
		public function getTutSeen():Boolean {
			return this.tutSeen;
		}
		
		public function setTutSeen():void {
			this.tutSeen = true;
		}
		
		public function setTutSeenSave(tutSeen:Boolean):void {
			this.tutSeen = tutSeen;
		}
		
		public function getHiScore():Number {
			return this.hiScore;
		}
		
		public function getTotalCoins():Number {
			return this.totalCoins;
		}

		public function setHiScore(hiScore:Number):void {
			this.hiScore = hiScore;
		}
		
		public function setTotalCoins(totalCoins:Number):void {
			this.totalCoins = totalCoins;
		}
		
		public function getMute():Boolean {
			return this.mute;
		}
		
		public function setMute(mute:Boolean) {
			this.mute = mute;
		}
		public function getHat():String {
			return this.hat;
		}
		public function setHat(hat:String) {
			this.hat = hat;
		}
		
		public function getAccessory():String {
			return this.accessory;
		}
		public function setAccessory(accessory:String) {
			this.accessory = accessory;
		}
		
		public function getBoughtItems():Array {
			return this.boughtItems;
		}
		
		public function setBoughtItems(boughtItems:Array) {
			this.boughtItems = boughtItems;
		}
		
		public function addBoughtItem(item:String) {
			this.boughtItems.push(item);
		}

		public function getUserId():String {
			return this.userId;
		}
		
		public function setUserId(userId:String):void {
			this.userId = userId;
		}
		
		public function getUserName():String {
			return this.userName;
		}
		
		public function setUserName(userName:String):void {
			this.userName = userName;
		}
		
		public function getScoreQueue():Array {
			return this.scoreQueue;
		}
		
		public function setScoreQueue(scoreQueue:Array):void {
			this.scoreQueue = scoreQueue;
		}
		
		public function addScoreQueue(score:Number):void {
			if( this.scoreQueue == null ) {
				this.scoreQueue = new Array();
			}
			this.scoreQueue.push(score);
		}
	}
	
}
