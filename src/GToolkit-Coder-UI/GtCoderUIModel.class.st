"
!Coder UI Model
Wraps ${class:GtCoderModel}$ and optionally adds UI related api and state. Coder UI Model should be passed to any Coder UI element instead of the ${class:GtCoderModel}$
"
Class {
	#name : #GtCoderUIModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer + TGtWithCoderModel',
	#classTraits : 'TGtAnnouncer classTrait + TGtWithCoderModel classTrait',
	#instVars : [
		'announcer',
		'codersUIModel'
	],
	#category : #'GToolkit-Coder-UI-Coder - Basic'
}

{ #category : #accessing }
GtCoderUIModel >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
GtCoderUIModel >> announcerUIModel [
	^ self announcer
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
	^ self coderModel
]

{ #category : #accessing }
GtCoderUIModel >> coder: anObject [
	self coderModel: anObject
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
	^ self subclassResponsibility
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

{ #category : #testing }
GtCoderUIModel >> isModified [
	^ self coder isModified
]

{ #category : #'api - coder model' }
GtCoderUIModel >> onCoderModelChanged [
	"Is sent when a new coder model is assigned to the view model"
]

{ #category : #accessing }
GtCoderUIModel >> programCounterRange [
	"This is workwound util the method coder context had a dedicated element.
	Now the element for displaying a coder is shared between all types of coders."

	^ nil
]
