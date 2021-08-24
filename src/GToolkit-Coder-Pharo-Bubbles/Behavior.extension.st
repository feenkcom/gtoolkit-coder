Extension { #name : 'Behavior' }

{ #category : '*GToolkit-Coder-Pharo-Bubbles' }
Behavior >> gtCoderProtocolsBubblesFor: aView context: aPhlowContext [
	<gtClassView>
	| aBehaviorCoderViewModel |
	
	aBehaviorCoderViewModel := aPhlowContext
		optionAt: #behaviorCoder
		ifPresent: [ :aBehaviorCoderUIModel | aBehaviorCoderUIModel ]
		ifAbsentPut: [ (GtPharoBehaviorCoder forClass: self) asCoderUIModel ].
	
	^ aView explicit
		priority: 11;
		title: 'Bubbles';
		disableAsync;
		stencil: [ GtPharoBehaviorBubblesElement new
				pharoBehaviorCoderViewModel: aBehaviorCoderViewModel ];
		actionButtonIcon: BrGlamorousIcons zoomin
			tooltip: 'Zoom in'
			action: [ :aButton :aTab | aTab viewContentElement zoomIn ];
		actionButtonIcon: BrGlamorousIcons zoomout
			tooltip: 'Zoom out'
			action: [ :aButton :aTab | aTab viewContentElement zoomOut ];
		actionButtonIcon: BrGlamorousIcons zoomtofit
			tooltip: 'Zoom to fit'
			action: [ :aButton :aTab | aTab viewContentElement zoomToFit ];
		actionUpdateButton
]
