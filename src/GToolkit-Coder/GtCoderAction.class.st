Class {
	#name : #GtCoderAction,
	#superclass : #Object,
	#instVars : [
		'title',
		'icon',
		'action'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'method coder actions' }
GtCoderAction class >> runExampleOn: aMethodCoder [
	<gtMethodCoderContextAction: 1>
	aMethodCoder example isNil
		ifTrue: [ ^ nil ].
	^ self new
		title: 'Run' translated;
		icon: BrGlamorousIcons play;
		action: [ :button | aMethodCoder runFrom: button ]
]

{ #category : #'method coder actions' }
GtCoderAction class >> saveActionOn: aMethodCoder [
	<gtMethodCoderMainAction: 1>
	^ self new
		title: 'Save' translated;
		icon: BrGlamorousIcons accept;
		action: [ aMethodCoder save ]
]

{ #category : #accessing }
GtCoderAction >> action [
	^ action
]

{ #category : #accessing }
GtCoderAction >> action: anObject [
	action := anObject
]

{ #category : #evaluating }
GtCoderAction >> glamourValueWithArgs: aSequenceOfArguments [
	^ self action glamourValueWithArgs: aSequenceOfArguments
]

{ #category : #accessing }
GtCoderAction >> icon [
	^ icon
]

{ #category : #accessing }
GtCoderAction >> icon: anObject [
	icon := anObject
]

{ #category : #accessing }
GtCoderAction >> title [
	^ title
]

{ #category : #accessing }
GtCoderAction >> title: anObject [
	title := anObject
]

{ #category : #evaluating }
GtCoderAction >> valueWithArguments: aSequenceOfArguments [
	^ self action valueWithArguments: aSequenceOfArguments
]
