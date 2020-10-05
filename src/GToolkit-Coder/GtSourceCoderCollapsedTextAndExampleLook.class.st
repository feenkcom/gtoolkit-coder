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
		'exampleLabel'
	],
	#category : #'GToolkit-Coder-UI - Source Coder Look'
}

{ #category : #'private - accessing' }
GtSourceCoderCollapsedTextAndExampleLook >> container [
	<return: #BrHorizontalPane>
	^ container
]

{ #category : #'private - accessing' }
GtSourceCoderCollapsedTextAndExampleLook >> exampleLabel [
	<return: #BrLabel>
	^ exampleLabel
]

{ #category : #'private - updating' }
GtSourceCoderCollapsedTextAndExampleLook >> hide [
	self exampleLabel visibility: BlVisibility hidden
]

{ #category : #initialization }
GtSourceCoderCollapsedTextAndExampleLook >> initialize [
	super initialize.
	self initializeMethodLabel.
	self initializeExampleLabel.
	self initializeContainer.
	
	self container 
		addChild: self methodLabel as: #methodLabel;
		addChild: self exampleLabel as: #exampleLabel.
	
	self addChangeAddChildAs: #(content label) with: [ self container ].
]

{ #category : #initialization }
GtSourceCoderCollapsedTextAndExampleLook >> initializeContainer [
	container := BrHorizontalPane new
		fitContent;
		alignCenterLeft
]

{ #category : #initialization }
GtSourceCoderCollapsedTextAndExampleLook >> initializeExampleLabel [
	exampleLabel := BrLabel new
		look: (BrGlamorousLabelLook new editorMeasurement fontSize: 12);
		padding: (BlInsets top: 1 left: 0 bottom: 0 right: 0);
		margin: (BlInsets left: 5).
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
	self updateExampleLabelFor: anAnnouncement coder
]

{ #category : #'private - accessing' }
GtSourceCoderCollapsedTextAndExampleLook >> resultLabelFor: aSourceCoder [
	| result |
	result := aSourceCoder exampleResult.
	result isNil
		ifTrue: [ ^ 'N/A' asRopedText foreground: BrGlamorousColors lightBorderColor ].
	result isSuccess
		ifTrue: [ ^ 'Success' asRopedText foreground: BrGlamorousColors successBorderColor ].
	result isFailure
		ifTrue: [ ^ 'Failure' asRopedText foreground: BrGlamorousColors errorBorderColor ].
	^ result isError
		ifTrue: [ 'Error' asRopedText 
			foreground: BrGlamorousColors errorBorderColor;
			background: (BrGlamorousColors errorBackgroundColor alpha: 0.5) ]
		ifFalse: [ 'N/A' asRopedText foreground: BrGlamorousColors lightBorderColor ]
]

{ #category : #'private - updating' }
GtSourceCoderCollapsedTextAndExampleLook >> show [
	self exampleLabel visibility: BlVisibility visible
]

{ #category : #'private - updating' }
GtSourceCoderCollapsedTextAndExampleLook >> updateExampleLabelFor: aSourceCoder [
	| aText |
	aSourceCoder canExecuteExample ifFalse: [ self hide. ^ self ].
	self show.
	aText := self resultLabelFor: aSourceCoder.
	self exampleLabel text: aText
]

{ #category : #'private - updating' }
GtSourceCoderCollapsedTextAndExampleLook >> updateLabelsFor: aSourceCoder [
	self updateMethodLabelFor: aSourceCoder.
	self updateExampleLabelFor: aSourceCoder.
]

{ #category : #'private - updating' }
GtSourceCoderCollapsedTextAndExampleLook >> updateMethodLabelFor: aSourceCoder [
	self methodLabel text: aSourceCoder collapsedText
]
