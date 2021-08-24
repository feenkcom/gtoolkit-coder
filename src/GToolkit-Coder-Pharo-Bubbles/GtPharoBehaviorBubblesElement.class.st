Class {
	#name : 'GtPharoBehaviorBubblesElement',
	#superclass : 'BlElement',
	#traits : 'TGtWithPharoBehaviorCoderViewModel',
	#classTraits : 'TGtWithPharoBehaviorCoderViewModel classTrait',
	#instVars : [
		'canvas',
		'zoomToProtocolHandler'
	],
	#category : 'GToolkit-Coder-Pharo-Bubbles'
}

{ #category : 'private' }
GtPharoBehaviorBubblesElement >> canvasBoundingBox [
	<return: #Rectangle>
	| aBoundingBox |

	canvas hasChildren
		ifFalse: [ ^ BlBounds new asRectangle ].

	aBoundingBox := nil.

	canvas childrenDo: [ :aChild |
		aBoundingBox
			ifNil: [ aBoundingBox := aChild bounds inParent bounds ]
			ifNotNil: [ aBoundingBox merge: aChild bounds inParent bounds ] ].

	^ aBoundingBox expanded asRectangle
]

{ #category : 'hooks - layout' }
GtPharoBehaviorBubblesElement >> dispatchLayoutDone [
	super dispatchLayoutDone.
	
	(canvas layout isKindOf: BlBasicLayout)
		ifTrue: [ ^ self ].
	
	canvas layout: BlBasicLayout new.
	
	self zoomToFit
]

{ #category : 'initialization' }
GtPharoBehaviorBubblesElement >> initialize [

	super initialize.

	self constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical matchParent ].

	self beInSeparateCompositionLayer.
	self background: BrGlamorousColors backdropColor.
	self addAptitude: BrGlamorousMaximizerFullscreenHostAptitude new.

	canvas := BlCanvassableElement new constraintsDo: [ :c | 
		          c horizontal matchParent.
		          c vertical matchParent ].
	canvas addEventHandler: BlSlideHandler new.
	canvas addEventHandler: BlScrollSlideHandler new.
	canvas layout: (BlOnceLayout on: (GtGraphGridLayout new gapSize: 30)).

	canvas
		when: BlCanvassableZoomLevelChanged
		do: [ :anEvent | 
		self updateForZoomLevel: anEvent currentTarget zoomLevel ].

	zoomToProtocolHandler := BlEventHandler
		                         on: BlClickEvent
		                         do: [ :anEvent | 
			                         anEvent consumed: true.
			                         self zoomInTo:
				                         anEvent currentTarget parent ].

	self addChild: canvas
]

{ #category : 'api - pharo behavior coder view model' }
GtPharoBehaviorBubblesElement >> onPharoBehaviorCoderViewModelChanged [
	"Is sent when a new pharoBehaviorCoder view model is assigned to the element.
	Note: #onPharoBehaviorCoderViewModelChanged is sent before #subscribeToPharoBehaviorCoderViewModel
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostPharoBehaviorCoderViewModelChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"
	| theProtocols |

	theProtocols := self pharoBehaviorCoderViewModel protocols sorted.	
	
	canvas removeChildren.
	canvas addChildren: (theProtocols collect: [ :eachProtocol |
		| eachBehaviorProtocolCoder eachBehaviorProtocolCoderViewModel |
		eachBehaviorProtocolCoder := GtPharoBehaviorProtocolCoder
			forBehavior: self pharoBehaviorCoderViewModel behavior
			protocol: eachProtocol.

		eachBehaviorProtocolCoderViewModel := GtPharoBehaviorProtocolCoderViewModel new
			coderModel: eachBehaviorProtocolCoder.
			
		GtPharoBehaviorProtocolBubbleElement new
			pharoBehaviorProtocolCoderViewModel: eachBehaviorProtocolCoderViewModel;
			addEventHandler: BlPullHandler new ])
]

{ #category : 'private' }
GtPharoBehaviorBubblesElement >> startZoomAnimation: anAnimation [
	anAnimation onFinishedDo: [
		(self query // BlElement) all
			do: [ :eachCard | eachCard invalidate ] ].
		
	self addAnimation: anAnimation
]

{ #category : 'private' }
GtPharoBehaviorBubblesElement >> updateForZoomLevel: aZoomLevel [

	(self query // GtPharoBehaviorProtocolBubbleElement) all do: [ 
		:eachCard | 
		eachCard childrenDo: [ :eachChild | 
			aZoomLevel > 0.5
				ifTrue: [ eachChild visibility: BlVisibility visible ]
				ifFalse: [ eachChild visibility: BlVisibility hidden ].
			aZoomLevel > 0.5
				ifTrue: [ 
					eachCard
						childWithId: #protocolLabelPreview
						ifFound: [ :anElement | 
							anElement removeFromParent.
							anElement removeEventHandler: zoomToProtocolHandler ]
						ifNone: [  ] ]
				ifFalse: [ 
					eachCard
						childWithId: #protocolLabelPreview
						ifFound: [ :anElement | 
						anElement visibility: BlVisibility visible ]
						ifNone: [ 
							eachCard addChild: ((BrLabel new
									  padding: (BlInsets all: 2);
									  aptitude: BrGlamorousLabelAptitude;
									  text: eachCard pharoBehaviorProtocolCoderViewModel protocol)
									 asScalableElement
									 id: #protocolLabelPreview;
									 fitAll;
									 addEventHandler: zoomToProtocolHandler;
									 constraintsDo: [ :c | c ignoreByLayout ]) ] ] ] ]
]

{ #category : 'api - zooming' }
GtPharoBehaviorBubblesElement >> zoomIn [
	self startZoomAnimation: (BlNumberTransition new
		onStepDo: [ :eachLevel | canvas zoomLevel: eachLevel ];
		from: canvas zoomLevel;
		to: canvas zoomLevel + canvas zoomStep;
		duration: 200 milliSeconds)
]

{ #category : 'api - zooming' }
GtPharoBehaviorBubblesElement >> zoomInTo: anElement [
	| anElementBounds anElementExtent aNewZoomLevel aMoveDelta zoomAnimation relocateAnimations |
	
	anElementBounds := anElement bounds inParent: self.
	anElementExtent := anElementBounds extent.
	(anElementExtent x isZero or: [ anElementExtent y isZero ])
		ifTrue: [ ^ self ].

	aNewZoomLevel := 1.
	
	aMoveDelta := (canvas localPointToChildren: canvas bounds inLocal center) - (canvas localPointToChildren: anElementBounds center).

	zoomAnimation := BlNumberTransition new
		target: canvas;
		onStepDo: [ :eachLevel :aCanvas | aCanvas zoomLevel: eachLevel ];
		from: canvas zoomLevel;
		to: aNewZoomLevel;
		duration: 500 milliSeconds.
		
	relocateAnimations := canvas children accountedByLayout collect: [ :eachElement |
		BlNumberTransition new
			target: eachElement;
			onStepDo: [ :eachPoint :aTarget | aTarget relocate: eachPoint ];
			from: eachElement constraints position;
			to: eachElement constraints position + aMoveDelta;
			duration: 200 milliSeconds ].
	
	self startZoomAnimation: (BlSequentialAnimation with: { BlParallelAnimation with: relocateAnimations . zoomAnimation }).
]

{ #category : 'api - zooming' }
GtPharoBehaviorBubblesElement >> zoomOut [
	self startZoomAnimation: (BlNumberTransition new
		onStepDo: [ :eachLevel | canvas zoomLevel: eachLevel ];
		from: canvas zoomLevel;
		to: canvas zoomLevel - canvas zoomStep;
		duration: 200 milliSeconds)
]

{ #category : 'api - zooming' }
GtPharoBehaviorBubblesElement >> zoomToFit [
	| theChildrenBoundingBox theChildrenExtent aNewZoomLevel aMoveDelta zoomAnimation relocateAnimations |
	
	theChildrenBoundingBox := self canvasBoundingBox.
	theChildrenExtent := theChildrenBoundingBox extent.
	(theChildrenExtent x isZero or: [ theChildrenExtent y isZero ])
		ifTrue: [ ^ self ].

	aNewZoomLevel := ((canvas extent / theChildrenExtent) min - 0.05) min: 1.

	aMoveDelta := (canvas localPointToChildren: canvas bounds inLocal center) - (theChildrenBoundingBox center).

	zoomAnimation := BlNumberTransition new
		target: canvas;
		onStepDo: [ :eachLevel :aCanvas | aCanvas zoomLevel: eachLevel ];
		from: canvas zoomLevel;
		to: aNewZoomLevel;
		duration: 500 milliSeconds.

	relocateAnimations := canvas children accountedByLayout collect: [ :eachElement |
		BlNumberTransition new
			target: eachElement;
			onStepDo: [ :eachPoint :aTarget | aTarget relocate: eachPoint ];
			from: eachElement constraints position;
			to: eachElement constraints position + aMoveDelta;
			duration: 200 milliSeconds ].
	
	self startZoomAnimation: (BlSequentialAnimation with: { zoomAnimation . BlParallelAnimation with: relocateAnimations }).
]
