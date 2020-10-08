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
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'example'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #'private - asserting' }
GtCoderExampleStateElement >> assertExample: aGtExampleWithResult [
	self 
		assert: [ aGtExampleWithResult isNotNil ] 
		description: [ 'Example must be non-nil' ].
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
	self initializeInteractiveModel.

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
	self addLook:
		(BrInteractiveCommonLook new
			default: [ :aWidget | aWidget background: self exampleState color ];
			hovered: [ :aWidget | aWidget background: self exampleState color darker ])
		
]

{ #category : #initialization }
GtCoderExampleStateElement >> initializeInteractiveModel [
	self viewModel: (BrInteractiveModel new addStates: {
		BrLayoutHorizontalResizerModel exact: 8.
		BrLayoutVerticalResizerModel exact: 8.
		BrHoverModel new.
	})
]

{ #category : #initialization }
GtCoderExampleStateElement >> initializeTooltipLook [
	self addLook:
		(BrGlamorousWithTooltipLook2 content: [
			self newTooltipContent ])
]

{ #category : #'private - instance creation' }
GtCoderExampleStateElement >> newInspectorWithExampleResult [
	| aContainer anInspector |
	aContainer := BrFrame new
		fitContent;
		when: GtPhlowObjectToSpawn do: [ :anEvent | self fireEvent: (GtPhlowObjectToSpawn new
				object: anEvent object;
				sourceElement: anEvent target) ].
	anInspector := ((GtInspector forObject: self tooltipObject)
			exact: 400@400)
				asScalableElement size: 200@200.
	aContainer
		addChild: anInspector.
	^ aContainer
]

{ #category : #'private - instance creation' }
GtCoderExampleStateElement >> newNotExecutedLabel [
	^ BrLabel new
		look: BrGlamorousLabelLook;
		text: 'Not Executed Example';
		padding: (BlInsets all: 5)
]

{ #category : #'private - instance creation' }
GtCoderExampleStateElement >> newTooltipContent [
	^ self example hasResult
			ifTrue: [ self newInspectorWithExampleResult ]
			ifFalse: [ self newNotExecutedLabel ]
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

{ #category : #'private - subscriptions' }
GtCoderExampleStateElement >> subscribeToExample [
	self example announcer weak
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
	self background: self exampleState color
]
