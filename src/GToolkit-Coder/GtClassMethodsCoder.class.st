Class {
	#name : #GtClassMethodsCoder,
	#superclass : #GtMethodsCoder,
	#instVars : [
		'class',
		'object'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'instance creation' }
GtClassMethodsCoder class >> forClass: aBehavior [
	^ self new
		forClass: aBehavior;
		yourself
]

{ #category : #'instance creation' }
GtClassMethodsCoder class >> forObject: anObject [
	^ self new
		forObject: anObject;
		yourself
]

{ #category : #actions }
GtClassMethodsCoder >> addMethodCoderIn: anElement [
	| coder |
	coder := GtMethodCoder new.
	coder classOrMetaClass: class.
	coder object: object.
	anElement items: (Array with: coder) , anElement items
]

{ #category : #elements }
GtClassMethodsCoder >> asElement [
	| listElement element button |
	listElement := super asElement.
	element := BlElement new.
	element layout: BlLinearLayout vertical.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	button := BrButton new.
	button
		margin:
			(BlInsets
				top: 10
				left: 10
				bottom: 0
				right: 0).
	button
		look: BrGlamorousButtonWithIconLook;
		icon: BrGlamorousIcons add asElement;
		action: [ self addMethodCoderIn: listElement ].
	element addChild: button.
	element addChild: listElement.
	^ element
]

{ #category : #'initialize-release' }
GtClassMethodsCoder >> forClass: aBehavior [
	class := aBehavior.
	self forMethods: (GtCoderMethodsCollection forFilter: (GtCoderBehaviorMethodFilter forClass: class))
]

{ #category : #'initialize-release' }
GtClassMethodsCoder >> forMethods: compiledMethods [
	super forMethods: compiledMethods.
	methodCoders do: [ :each | each object: object ]
]

{ #category : #'initialize-release' }
GtClassMethodsCoder >> forObject: anObject [
	object := anObject.
	self forClass: anObject class
]
