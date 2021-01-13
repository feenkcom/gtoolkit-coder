"
I am an ${class:BlElement}$.
I am an icon that represents an ${class:GtExampleWithResult}$ result state.
!! Not Executed State
${example:GtCoderExampleStateElementExamples>>#exampleStateElement_NotExecuted|codeExpanded=false|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=50}$
!! Success State
${example:GtCoderExampleStateElementExamples>>#exampleStateElement_Success|codeExpanded=false|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=50}$
!! Failure State
${example:GtCoderExampleStateElementExamples>>#exampleStateElement_Failure|codeExpanded=false|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=50}$
!! Error State
${example:GtCoderExampleStateElementExamples>>#exampleStateElement_Error|codeExpanded=false|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=50}$
"
Class {
	#name : #GtCoderExampleStateElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable + TBrEnableable',
	#classTraits : 'TBrLayoutResizable classTrait + TBrEnableable classTrait',
	#instVars : [
		'example',
		'styleLook'
	],
	#category : #'GToolkit-Coder-UI-Basic'
}

{ #category : #'private - asserting' }
GtCoderExampleStateElement >> assertExample: aGtExampleWithResult [
	self 
		assert: [ aGtExampleWithResult isNotNil ] 
		description: [ 'Example must be non-nil' ].
]

{ #category : #'private - actions' }
GtCoderExampleStateElement >> debugExampleFrom: aButton [
	self exampleDo: [ :anExample |
		anExample openingDebugger result ]
]

{ #category : #'api - accessing' }
GtCoderExampleStateElement >> example [
	<return: #GtExampleWithResult or: nil>
	^ example
]

{ #category : #'api - accessing' }
GtCoderExampleStateElement >> example: aGtExampleWithResult [
	self assertExample: aGtExampleWithResult.
	self unsubscribeFromExample.
	example := aGtExampleWithResult asExampleWithResult.
	self subscribeToExample.
	self onExampleChanged.
]

{ #category : #'private - accessing' }
GtCoderExampleStateElement >> exampleDo: aBlock [
	self example ifNotNil: aBlock
]

{ #category : #'private - accessing' }
GtCoderExampleStateElement >> exampleResult [
	<return: #GtExampleResult or: nil>
	^ self example ifNotNil: #result
]

{ #category : #'private - accessing' }
GtCoderExampleStateElement >> exampleState [
	^ GtFilterExampleState default stateFromExample: self example
]

{ #category : #'private - testing' }
GtCoderExampleStateElement >> hasExampleResult [
	<return: #Boolean>
	^ self example
		ifNotNil: #hasResult
		ifNil: [ false ]
]

{ #category : #initialization }
GtCoderExampleStateElement >> initialize [
	super initialize.
	self initializeViewModels.

	self 
		layout: BlLinearLayout horizontal;
		geometry: BlCircle new;
		margin: (BlInsets all: 1);
		exact: 8@8.
		
	self initializeInteractiveLook.
	self initializeTooltipLook.
	self addLook: BrLayoutResizerLook inherit.
]

{ #category : #initialization }
GtCoderExampleStateElement >> initializeInteractiveLook [
	self addLook: (styleLook := BrStyleCommonLook new).
	self updateStyleLook.
]

{ #category : #initialization }
GtCoderExampleStateElement >> initializeTooltipLook [
	self addLook:
		(BrGlamorousWithTooltipLook2 content: [
			self newTooltipContent ])
]

{ #category : #initialization }
GtCoderExampleStateElement >> initializeViewModels [
	| aButtonModel |
	
	aButtonModel := BrButtonModel new
		action: [ :aButton | self onClick: aButton ].
	self viewModel: aButtonModel.
]

{ #category : #'private - instance creation' }
GtCoderExampleStateElement >> newInspectorWithExampleResult [
	^ ((GtInspector forObject: self tooltipObject)
			exact: 400@400)
				asScalableElement size: 200@200.
]

{ #category : #'private - instance creation' }
GtCoderExampleStateElement >> newNotExecutedLabel [
	^ BrLabel new
		look: BrGlamorousLabelLook;
		text: 'Not Executed Example';
		padding: (BlInsets all: 5)
]

{ #category : #'private - instance creation' }
GtCoderExampleStateElement >> newNotExecutedToolbar [
	^ BrToolbar new
		look: BrGlamorousToolbarLook new;
		addItem: (BrButton new
			look: BrGlamorousButtonWithIconLook;
			icon: BrGlamorousVectorIcons play;
			label: 'Play';
			action: [ :aButton | self playExampleFrom: aButton ];
			beSmallSize);
		addItem: (BrButton new
			look: BrGlamorousButtonWithIconLook;
			icon: BrGlamorousVectorIcons playinspect;
			label: 'Play and Inspect';
			action: [ :aButton | self playAndInspectExampleFrom: aButton ];
			beSmallSize);
		addChild: (BrButton new
			look: BrGlamorousButtonWithIconLook;
			icon: BrGlamorousVectorIcons debug;
			label: 'Debug';
			action: [ :aButton | self debugExampleFrom: aButton ];
			beSmallSize)
]

{ #category : #'private - instance creation' }
GtCoderExampleStateElement >> newNotExecutedTooltipContent [
	^ BrVerticalPane new
		fitContent;
		alignCenterLeft;
		padding: (BlInsets all: 5);
		addChild: (BrLabel new
			look: BrGlamorousLabelLook;
			margin: (BlInsets left: 2);
			text: 'Example not executed');
		addChild: (self newNotExecutedToolbar
			margin: (BlInsets top: 3)).
]

{ #category : #'private - instance creation' }
GtCoderExampleStateElement >> newTooltipContent [
	| aContainer |
	aContainer := BrFrame new
		fitContent;
		when: GtPhlowObjectToSpawn do: [ :anEvent | self fireEvent: (GtPhlowObjectToSpawn new
				object: anEvent object;
				sourceElement: anEvent target) ].
	aContainer addChild: (self example hasResult
			ifTrue: [ self newInspectorWithExampleResult ]
			ifFalse: [ self newNotExecutedTooltipContent ]).
	^ aContainer
]

{ #category : #'private - event handling' }
GtCoderExampleStateElement >> onClick: aButton [
	self exampleDo: [ :anExample | 
		anExample hasResult ifFalse: [ ^ self ].
		anExample isSuccess ifTrue: [ ^ self spawnExampleFrom: aButton ].
		self debugExampleFrom: aButton ]
]

{ #category : #'private - hooks' }
GtCoderExampleStateElement >> onExampleChanged [
	self updateIcon.
]

{ #category : #'private - announcement handling' }
GtCoderExampleStateElement >> onExampleExecuted: aGtExampleExecuted [
	BlUseAsyncFeatures 
		ifEnabledDo: [  
			self enqueueTask: (BlTaskAction new action: [
				self updateIcon ]) ]
		otherwise: [ self updateIcon ]
]

{ #category : #'private - actions' }
GtCoderExampleStateElement >> playAndInspectExampleFrom: aButton [
	self playExampleFrom: aButton.
	self spawnExampleFrom: aButton.
]

{ #category : #'private - actions' }
GtCoderExampleStateElement >> playExampleFrom: aButton [
	self exampleDo: [ :anExample |
		anExample run ]
]

{ #category : #'private - actions' }
GtCoderExampleStateElement >> spawnExampleFrom: anElement [
	self exampleDo: [ :anExample |
		anExample hasResult ifTrue: [ 
			anElement phlow spawnObject: anExample result returnValueOrExampleException ] ]
]

{ #category : #'private - accessing' }
GtCoderExampleStateElement >> styleLook [
	<return: #BrStyleCommonLook>
	^ styleLook
]

{ #category : #'private - subscriptions' }
GtCoderExampleStateElement >> subscribeToExample [
	self example announcer
		when: GtExampleExecuted
		send: #onExampleExecuted:
		to: self.
]

{ #category : #'private - accessing' }
GtCoderExampleStateElement >> tooltipObject [
	self exampleResult ifNotNil: [ :aResult | ^ aResult returnValueOrExampleException ].
	^ self example
]

{ #category : #'private - subscriptions' }
GtCoderExampleStateElement >> unsubscribeFromExample [
	self example ifNil: [ ^ self ].
	self example announcer unsubscribe: self.
]

{ #category : #'private - updating' }
GtCoderExampleStateElement >> updateIcon [
	self background: self exampleState color.
	self updateStyleLook.
]

{ #category : #'private - updating' }
GtCoderExampleStateElement >> updateStyleLook [
	
	"the following nil check can be removed anytime later.
	It is useful for a couple of days until the next image build (instead of update)."
	self styleLook ifNil: [ ^ self ].
	
	self styleLook
		default: [ :aStyle | aStyle background: self exampleState color ];
		hovered: [ :aStyle | aStyle background: self exampleState color darker ].
]
