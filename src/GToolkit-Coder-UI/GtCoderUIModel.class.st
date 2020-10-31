"
!Coder UI Model
Wraps ${class:GtCoderModel}$ and optionally adds UI related api and state. Coder UI Model should be passed to any Coder UI element instead of the ${class:GtCoderModel}$
"
Class {
	#name : #GtCoderUIModel,
	#superclass : #Object,
	#instVars : [
		'coder',
		'codersUIModel',
		'hasFocus',
		'expanded'
	],
	#category : #'GToolkit-Coder-UI-Coder - Basic'
}

{ #category : #accessing }
GtCoderUIModel >> announcer [
	^ coder announcer
]

{ #category : #converting }
GtCoderUIModel >> asCoderUIModel [
	^ self
]

{ #category : #converting }
GtCoderUIModel >> asElement [
	^ self elementClass new
		coderUIModel: self;
		yourself
]

{ #category : #accessing }
GtCoderUIModel >> coder [
	^ coder
]

{ #category : #accessing }
GtCoderUIModel >> coder: anObject [
	coder := anObject
]

{ #category : #accessing }
GtCoderUIModel >> coderLook [
	^ self coder coderLook
]

{ #category : #accessing }
GtCoderUIModel >> coders [
	^ self coder coders
]

{ #category : #accessing }
GtCoderUIModel >> codersUIModel [
	^ codersUIModel
]

{ #category : #accessing }
GtCoderUIModel >> codersUIModel: anObject [
	codersUIModel := anObject
]

{ #category : #accessing }
GtCoderUIModel >> elementClass [
	^ GtExpandableCoderElement
]

{ #category : #'api - ui' }
GtCoderUIModel >> expanded [
	^ expanded
]

{ #category : #'api - ui' }
GtCoderUIModel >> expanded: aBoolean [
	expanded := aBoolean
]

{ #category : #'api - ui' }
GtCoderUIModel >> focused [
	<return: #Boolean>

	^ hasFocus
]

{ #category : #'api - ui' }
GtCoderUIModel >> focused: aBoolean [
	hasFocus = aBoolean
		ifTrue: [ ^ self ].

	hasFocus := aBoolean.

	codersUIModel ifNotNil: [ :theCoders |
		aBoolean
			ifTrue: [ theCoders focusCoderUIModel: self  ]
			ifFalse: [ theCoders unfocusCoderUIModel: self ] ]
]

{ #category : #'gt-extension' }
GtCoderUIModel >> gtLiveFor: aView [
	<gtView>

	^ aView forward
		title: 'Live';
		priority: 1;
		object: [ self asElement ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtCoderUIModel >> hasFocus [

	self
		deprecated: 'Please use #focused instead'
		transformWith: '`@receiver hasFocus' -> '`@receiver focused'.

	^ self focused
]

{ #category : #accessing }
GtCoderUIModel >> hasFocus: aBoolean [
	self
		deprecated: 'Please use #focused: instead.'
		transformWith:
			'`@receiver hasFocus: `@statements1'
				-> '`@receiver focused: `@statements1'.

	self focused: aBoolean
]

{ #category : #initialization }
GtCoderUIModel >> initialize [
	super initialize.
	
	hasFocus := false.
	expanded := true
]
