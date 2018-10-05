Class {
	#name : #GtMethodsCoder,
	#superclass : #Announcer,
	#instVars : [
		'class',
		'object',
		'methodCoders'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtMethodsCoder class >> forClass: aBehavior [
	^ self new
		forClass: aBehavior;
		yourself
]

{ #category : #'instance creation' }
GtMethodsCoder class >> forImplementors: aSymbol [
	| methods |
	methods := OrderedCollection new.
	Smalltalk
		allClassesDo: [ :each | 
			(each includesSelector: aSymbol)
				ifTrue: [ methods add: each >> aSymbol ] ].
	^ self forMethods: (self sortMethods: methods)
]

{ #category : #'instance creation' }
GtMethodsCoder class >> forMethods: compiledMethods [
	^ self new
		forMethods: compiledMethods;
		yourself
]

{ #category : #'instance creation' }
GtMethodsCoder class >> forObject: anObject [
	^ self new
		forObject: anObject;
		yourself
]

{ #category : #'instance creation' }
GtMethodsCoder class >> forReferences: aSymbol [
	| methods |
	methods := OrderedCollection new.
	Smalltalk allClassesDo: [ :each | (each thoroughWhichSelectorsReferTo: aSymbol) do: [ :sel | methods add: each >> sel ] ].
	^ self forMethods: (self sortMethods: methods)
]

{ #category : #private }
GtMethodsCoder class >> sortMethods: aCollection [
	^ aCollection
		asSortedCollection: [ :a :b | 
			a methodClass = b methodClass
				ifTrue: [ a selector < b selector ]
				ifFalse: [ a methodClass name < b methodClass name ] ]
]

{ #category : #actions }
GtMethodsCoder >> addMethodCoderIn: anElement [
	| coder element |
	coder := GtMethodCoder new.
	coder classOrMetaClass: class.
	coder object: object.
	element := coder asElement.
	coder
		when: GtCoderEvaluationAnnouncement
		do: [ :announcement | 
			anElement
				fireEvent:
					(GtPhlowObjectToSelect new
						object: announcement result;
						sourceElement: anElement) ].
	anElement addChild: element at: 2
]

{ #category : #elements }
GtMethodsCoder >> asElement [
	| element button |
	element := BlElement new.
	element layout: BlLinearLayout vertical.
	element padding: (BlInsets all: 10).
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	methodCoders
		do: [ :each | 
			each
				when: GtCoderEvaluationAnnouncement
				do: [ :announcement | 
					element
						fireEvent:
							(GtPhlowObjectToSelect new
								object: announcement result;
								sourceElement: element) ] ].
	class notNil
		ifTrue: [ button := BrButton new.
			button
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousIcons add asElement;
				action: [ self addMethodCoderIn: element ].
			element addChild: button ].
	element addChildren: (methodCoders collect: [ :each | each asElement ]).
	^ element
]

{ #category : #'initialize-release' }
GtMethodsCoder >> forClass: aBehavior [
	class := aBehavior.
	self forMethods: (class selectors asSortedCollection collect: [ :each | class >> each ])
]

{ #category : #'initialize-release' }
GtMethodsCoder >> forMethods: compiledMethods [
	methodCoders := compiledMethods collect: [ :each | GtMethodCoder forMethod: each ].
	methodCoders
		do: [ :each | 
			each when: GtCoderDrillDownAnnouncement do: [ :event | self announce: event ].
			each object: object ]
]

{ #category : #'initialize-release' }
GtMethodsCoder >> forObject: anObject [
	object := anObject.
	self forClass: anObject class
]
