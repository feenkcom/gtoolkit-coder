"
I am a ${class:BrLook}$.
I am a ${class:GtSourceCoderLook}$.
I attach two labels:
# a ${method:GtSourceCoderCollapsedTextAndExampleLook>>#methodLabel|label=method name}$, and
# example ${method:GtSourceCoderCollapsedTextAndExampleLook>>#exampleElement|label=execution state}$.
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
	#category : #'GToolkit-Coder-UI-Coder - Source Look'
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
		addChild: self methodLabel as: GtSourceCoderCollapsedTextId;
		addChild: self exampleElement as: #exampleElement.
	
	self addChangeAddChildAs: #(content label) with: [ self container ]
]

{ #category : #initialization }
GtSourceCoderCollapsedTextAndExampleLook >> initializeContainer [
	container := BrHorizontalPane new
		fitContent;
		alignCenterLeft
]

{ #category : #initialization }
GtSourceCoderCollapsedTextAndExampleLook >> initializeExampleElement [
	exampleElement := GtCoderExampleStateElement new
		margin: (BlInsets top: 4 left: 1 bottom: 1 right: 1).
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
GtSourceCoderCollapsedTextAndExampleLook >> onCoderChanged: aGtSourceCoderUIModel [
	self widget coderUIModel
		ifNotNil: [ :aPreviousCoder | aPreviousCoder coder announcer unsubscribe: self ].
	self updateLabelsFor: aGtSourceCoderUIModel coder.
	aGtSourceCoderUIModel coder announcer weak
		when: GtCoderCollapsedLabelChanged
		send: #onCollapsedLabelChanged:
		to: self.
	aGtSourceCoderUIModel coder announcer weak
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

{ #category : #'private - updating' }
GtSourceCoderCollapsedTextAndExampleLook >> show [
	self exampleElement visibility: BlVisibility visible
]

{ #category : #'private - updating' }
GtSourceCoderCollapsedTextAndExampleLook >> updateExampleElementFor: aSourceCoder [
	aSourceCoder canExecuteExample
		ifFalse: [ self hide.
			^ self ].
	self show.

	self exampleElement example: aSourceCoder example
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
