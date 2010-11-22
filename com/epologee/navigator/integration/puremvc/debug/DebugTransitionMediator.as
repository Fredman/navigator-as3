package com.epologee.navigator.integration.puremvc.debug {
	import com.epologee.navigator.integration.debug.DebugStatusDisplay;
	import com.epologee.navigator.integration.puremvc.NavigationProxy;
	import com.epologee.navigator.integration.puremvc.TimelineMediator;
	import com.epologee.navigator.namespaces.hidden;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class DebugTransitionMediator extends TimelineMediator {
		public static const NAME : String = getQualifiedClassName(DebugTransitionMediator);
		private var _alignMode : String;
		private var _display : DebugStatusDisplay;

		/**
		 * @param inContainer pass in a Sprite, otherwise the container getter will fail.
		 */
		public function DebugTransitionMediator(inTimeline : Sprite, inAlignMode : String = "BR") {
			super(NAME, inTimeline);
			_alignMode = inAlignMode;
		}

		override public function onRegister() : void {
			var np : NavigationProxy = NavigationProxy(facade.retrieveProxy(NavigationProxy.NAME));
			_display = new DebugStatusDisplay(np.hidden::navigator, _alignMode);

			timeline.addChild(_display);

			if (timeline.stage) {
				setupHotKey();
			} else {
				timeline.addEventListener(Event.ADDED_TO_STAGE, setupHotKey);
			}
		}

		private function setupHotKey(e : Event = null) : void {
			timeline.removeEventListener(Event.ADDED_TO_STAGE, setupHotKey);
			timeline.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		}

		private function handleKeyDown(event : KeyboardEvent) : void {
			switch(String.fromCharCode(event.charCode)) {
				case "~":
				case "$":
				case "`":
					toggleVisibility();
					break;
			}
		}

		private function toggleVisibility() : void {
			timeline.visible = !timeline.visible;
		}
	}
}
