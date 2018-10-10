Class {
	#name : #GtMethodsCoder,
	#superclass : #Announcer,
	#instVars : [
		'class',
		'object',
		'methodCoders',
		'highlighter'
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
	| coder |
	coder := GtMethodCoder new.
	coder classOrMetaClass: class.
	coder object: object.
	coder
		when: GtCoderEvaluationAnnouncement
		do: [ :announcement | 
			anElement
				fireEvent:
					(GtPhlowObjectToSelect new
						object: announcement result;
						sourceElement: anElement) ].
	anElement items: (Array with: coder) , anElement items
]

{ #category : #elements }
GtMethodsCoder >> asElement [
	| element listElement button |
	listElement := BrSimpleList new.
	listElement stencil: [ :each | each asElement ].
	listElement padding: (BlInsets all: 10).
	listElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	listElement display: methodCoders.
	class notNil
		ifTrue: [ element := BlElement new.
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
			element addChild: listElement ]
		ifFalse: [ element := listElement ].
	methodCoders
		do: [ :each | 
			each
				when: GtCoderDrillDownAnnouncement
					do: [ :annoucement | 
					element
						fireEvent:
							(GtPhlowObjectToSpawn new
								object: annoucement coder;
								sourceElement: element) ];
				when: GtCoderEvaluationAnnouncement
					do: [ :announcement | 
					element
						fireEvent:
							(GtPhlowObjectToSpawn new
								object: announcement result;
								sourceElement: element) ] ].
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

{ #category : #ui }
GtMethodsCoder >> gtLiveFor: aView [
	<gtView>
	^ aView explicit 
		title: 'Live';
		priority: 10;
		stencil: [ self ]
]

{ #category : #accessing }
GtMethodsCoder >> highlighter [
	^ highlighter
]

{ #category : #accessing }
GtMethodsCoder >> highlighter: aReferenceHighlighter [
	highlighter := aReferenceHighlighter.
	methodCoders do: [ :each | each highlighter: aReferenceHighlighter ]
]

{ #category : #'initialize-release' }
GtMethodsCoder >> initialize [
	super initialize.
	methodCoders := #()
]
