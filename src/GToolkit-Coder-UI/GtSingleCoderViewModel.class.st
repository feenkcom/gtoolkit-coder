"
1. Coder UI Model
Wraps {{gtClass:GtCoderModel}} and optionally adds UI related api and state. Coder UI Model should be passed to any Coder UI element instead of the {{gtClass:GtCoderModel}}


"
Class {
	#name : #GtSingleCoderViewModel,
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
GtSingleCoderViewModel >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
GtSingleCoderViewModel >> announcerUIModel [
	^ self announcer
]

{ #category : #converting }
GtSingleCoderViewModel >> asCoderUIModel [
	^ self
]

{ #category : #converting }
GtSingleCoderViewModel >> asElement [
	^ self elementClass new
		coderUIModel: self;
		yourself
]

{ #category : #accessing }
GtSingleCoderViewModel >> coder [
	^ self coderModel
]

{ #category : #accessing }
GtSingleCoderViewModel >> coder: anObject [
	self coderModel: anObject
]

{ #category : #accessing }
GtSingleCoderViewModel >> coderLook [
	^ self coder coderLook
]

{ #category : #accessing }
GtSingleCoderViewModel >> coders [
	^ self coder coders
]

{ #category : #accessing }
GtSingleCoderViewModel >> codersUIModel [
	^ codersUIModel
]

{ #category : #accessing }
GtSingleCoderViewModel >> codersUIModel: anObject [
	codersUIModel := anObject
]

{ #category : #accessing }
GtSingleCoderViewModel >> elementClass [
	^ self subclassResponsibility
]

{ #category : #'gt-extension' }
GtSingleCoderViewModel >> gtLiveFor: aView [
	<gtView>

	^ aView forward
		title: 'Live';
		priority: 1;
		object: [ self asElement ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtSingleCoderViewModel >> hasFocus [

	self
		deprecated: 'Please use #focused instead'
		transformWith: '`@receiver hasFocus' -> '`@receiver focused'.

	^ self focused
]

{ #category : #accessing }
GtSingleCoderViewModel >> hasFocus: aBoolean [
	self
		deprecated: 'Please use #focused: instead.'
		transformWith:
			'`@receiver hasFocus: `@statements1'
				-> '`@receiver focused: `@statements1'.

	self focused: aBoolean
]

{ #category : #testing }
GtSingleCoderViewModel >> isModified [
	^ self coder isModified
]

{ #category : #'api - coder model' }
GtSingleCoderViewModel >> onCoderModelChanged [
	"Is sent when a new coder model is assigned to the view model"
]

{ #category : #accessing }
GtSingleCoderViewModel >> programCounterRange [
	"This is workwound util the method coder context had a dedicated element.
	Now the element for displaying a coder is shared between all types of coders."

	^ nil
]
