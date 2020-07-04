Class {
	#name : #GtFixItAction,
	#superclass : #Object,
	#instVars : [
		'methodCoder',
		'node'
	],
	#category : #'GToolkit-Coder-FixIt'
}

{ #category : #'instance creation' }
GtFixItAction class >> forCoder: aMethodCoder node: aRBProgramNode [
	^ self new
		methodCoder: aMethodCoder;
		node: aRBProgramNode;
		yourself
]

{ #category : #element }
GtFixItAction >> asElement [
	| element |
	element := BrHorizontalPane new.
	element hMatchParent.
	element vFitContent.
	element padding: (BlInsets all: 5).
	element
		addChild:
			(BrLabel new
				text: self description;
				look: BrGlamorousLabelLook).
	element
		addChild:
			(BrButton new
				icon: BrGlamorousVectorIcons accept;
				beSmall;
				look: BrGlamorousButtonWithIconLook new;
				label: 'Save';
				action: [ self execute ]).
	^ element
]

{ #category : #accessing }
GtFixItAction >> description [
	self subclassResponsibility
]

{ #category : #executing }
GtFixItAction >> execute [
	self subclassResponsibility
]

{ #category : #initialization }
GtFixItAction >> methodCoder: aCoder [
	methodCoder := aCoder
]

{ #category : #initialization }
GtFixItAction >> node: aRBProgramNode [
	node := aRBProgramNode
]
