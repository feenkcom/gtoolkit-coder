"
I am a ${class:BrLook}$.
I am a ${class:GtSourceCoderLook}$.
I attach two labels:
# a ${method:GtSourceCoderCollapsedTextAndExampleLook>>#methodLabel|label=method name}$, and
# example ${method:GtSourceCoderCollapsedTextAndExampleLook>>#exampleLabel|label=execution status}$.
!! Examples
If a method is an example, I display the method name and example result: ${example:GtCoderCollapsedContentElementExamples>>#textAndExampleLook_withExampleMethod|codeExpanded=false|previewExpanded=true|previewHeight=150}$ 
If a method is """"not"""" an example, I omit displaying the example result: ${example:GtCoderCollapsedContentElementExamples>>#textAndExampleLook_withRegularMethod|codeExpanded=false|previewExpanded=true|previewHeight=150}$ 
"
Class {
	#name : #GtSourceCoderCollapsedTextAndExampleLook,
	#superclass : #GtSourceCoderLook,
	#instVars : [
		'container',
		'methodLabel',
		'exampleElement'
	],
	#category : #'GToolkit-Coder-UI - Source Coder Look'
}

{ #category : #'private - accessing' }
GtSourceCoderCollapsedTextAndExampleLook >> container [
	<return: #BrHorizontalPane>
	^ container
]

{ #category : #'private - accessing' }
GtSourceCoderCollapsedTextAndExampleLook >> exampleElement [
	<return: #BlElement>
	^ exampleElement
]

{ #category : #'private - updating' }
GtSourceCoderCollapsedTextAndExampleLook >> hide [
	self exampleElement visibility: BlVisibility hidden
]

{ #category : #initialization }
GtSourceCoderCollapsedTextAndExampleLook >> initialize [
	super initialize.
	self initializeMethodLabel.
	self initializeExampleElement.
	self initializeContainer.
	
	self container 
		addChild: self methodLabel as: #methodLabel;
		addChild: self exampleElement as: #exampleElement.
	
	self addChangeAddChildAs: #(content label) with: [ self container ].
]

{ #category : #initialization }
GtSourceCoderCollapsedTextAndExampleLook >> initializeContainer [
	container := BrHorizontalPane new
		fitContent;
		alignCenterLeft
]

{ #category : #initialization }
GtSourceCoderCollapsedTextAndExampleLook >> initializeExampleElement [
	exampleElement := BlElement new
		background: GtFilterExampleNotExecutedStatus default color;
		geometry: BlCircle new;
		margin: (BlInsets top: 4 left: 1 bottom: 1 right: 1);
		size: 8 @ 8.
]

{ #category : #initialization }
GtSourceCoderCollapsedTextAndExampleLook >> initializeMethodLabel [
	methodLabel := BrLabel new
		look: BrGlamorousLabelLook new editorMeasurement bold glamorousCodeFont
]

{ #category : #'private - accessing' }
GtSourceCoderCollapsedTextAndExampleLook >> methodLabel [
	<return: #BrLabel>
	^ methodLabel
]

{ #category : #hooks }
GtSourceCoderCollapsedTextAndExampleLook >> onCoderChanged: aSourceCoder [
	self widget coder ifNotNil: [ :aPreviousCoder | aPreviousCoder announcer unsubscribe: self ].
	
	self updateLabelsFor: aSourceCoder.

	aSourceCoder announcer weak
		when: GtCoderCollapsedLabelChanged
		send: #onCollapsedLabelChanged:
		to: self.
	aSourceCoder announcer weak
		when: GtCoderExampleExecuted
		send: #onExampleExecuted:
		to: self
]

{ #category : #'private - announcement handling' }
GtSourceCoderCollapsedTextAndExampleLook >> onCollapsedLabelChanged: anAnnouncement [
	self updateLabelsFor: anAnnouncement coder
]

{ #category : #'private - announcement handling' }
GtSourceCoderCollapsedTextAndExampleLook >> onExampleExecuted: anAnnouncement [
	self updateExampleElementFor: anAnnouncement coder
]

{ #category : #'private - accessing' }
GtSourceCoderCollapsedTextAndExampleLook >> resultLabelFor: aSourceCoder [
	| result |
	result := aSourceCoder exampleResult.
	result isNil
		ifTrue: [ ^ 'N/A' asRopedText background: GtFilterExampleNotExecutedStatus default color ].
	result isSuccess
		ifTrue: [ ^ 'Success' asRopedText background: GtFilterExampleSuccessStatus default color ].
	result isFailure
		ifTrue: [ ^ 'Failure' asRopedText background: GtFilterExampleFailureStatus default color ].
	result isError
		ifTrue: [ 'Error' asRopedText background: GtFilterExampleErrorStatus default color ].
	^ 'N/A' asRopedText background: GtFilterExampleNotExecutedStatus default color
]

{ #category : #'private - updating' }
GtSourceCoderCollapsedTextAndExampleLook >> show [
	self exampleElement visibility: BlVisibility visible
]

{ #category : #'private - updating' }
GtSourceCoderCollapsedTextAndExampleLook >> updateExampleElementFor: aSourceCoder [
	| anExampleResult |

	aSourceCoder canExecuteExample
		ifFalse: [ self hide.
			^ self ].
	self show.

	anExampleResult := aSourceCoder exampleResult.
	anExampleResult ifNil: [ 
		self exampleElement
			background: GtFilterExampleNotExecutedStatus default color.
		^ self ].
	anExampleResult isSuccess ifTrue: [ 
		self exampleElement
			background: GtFilterExampleSuccessStatus default color.
		^ self ].
	anExampleResult isFailure ifTrue: [ 
		self exampleElement
			background: GtFilterExampleFailureStatus default color.
		^ self ].
	self exampleElement
		background: GtFilterExampleErrorStatus default color.
]

{ #category : #'private - updating' }
GtSourceCoderCollapsedTextAndExampleLook >> updateLabelsFor: aSourceCoder [
	self updateMethodLabelFor: aSourceCoder.
	self updateExampleElementFor: aSourceCoder.
]

{ #category : #'private - updating' }
GtSourceCoderCollapsedTextAndExampleLook >> updateMethodLabelFor: aSourceCoder [
	self methodLabel text: aSourceCoder collapsedText
]
