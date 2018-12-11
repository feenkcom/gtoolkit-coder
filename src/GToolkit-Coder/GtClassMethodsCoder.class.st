Class {
	#name : #GtClassMethodsCoder,
	#superclass : #GtMethodsCoder,
	#instVars : [
		'class',
		'object',
		'filteredClasses',
		'categoryFilter',
		'implementorsFilter'
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
GtClassMethodsCoder >> addMethodsForClass: aClass [
	(filteredClasses includes: aClass)
		ifTrue: [ ^ self ].
	filteredClasses add: aClass.
	self updateMethods.
	self updateCoders
]

{ #category : #actions }
GtClassMethodsCoder >> addNewCoder [
	| coder |
	coder := GtMethodCoder newMethod.
	coder classOrMetaClass: self newMethodClass.
	coder object: self object.
	methodCoders addFirst: coder.
	self announce: (GtMethodCoderAdded new coder: self; methodCoder: coder)
]

{ #category : #accessing }
GtClassMethodsCoder >> categoryFilter [
	^ categoryFilter
]

{ #category : #accessing }
GtClassMethodsCoder >> categoryFilter: aSymbol [
	categoryFilter := aSymbol.
	self updateMethods.
	self updateCoders
]

{ #category : #accessing }
GtClassMethodsCoder >> classOrMetaClass [
	^ class
]

{ #category : #private }
GtClassMethodsCoder >> classesFilter [
	| filter |
	filter := nil.
	filteredClasses
		do: [ :each | 
			| classFilter |
			classFilter := GtCoderBehaviorMethodFilter forClass: each.
			filter := filter isNil
				ifTrue: [ classFilter ]
				ifFalse: [ filter | classFilter ] ].
	^ filter
]

{ #category : #testing }
GtClassMethodsCoder >> filteredClass: aBehavior [
	^ filteredClasses includes: aBehavior
]

{ #category : #'initialize-release' }
GtClassMethodsCoder >> forClass: aBehavior [
	class := aBehavior.
	filteredClasses := Set with: aBehavior.
	self forMethods: (GtCoderMethodsCollection forFilter: (GtCoderBehaviorMethodFilter forClass: class))
]

{ #category : #'initialize-release' }
GtClassMethodsCoder >> forObject: anObject [
	object := anObject.
	self forClass: anObject class
]

{ #category : #testing }
GtClassMethodsCoder >> hasFilter [
	^ filteredClasses notEmpty
]

{ #category : #accessing }
GtClassMethodsCoder >> implementorsFilter [
	^ implementorsFilter
]

{ #category : #accessing }
GtClassMethodsCoder >> implementorsFilter: aString [
	implementorsFilter := aString.
	self updateMethods.
	self updateCoders
]

{ #category : #'initialize-release' }
GtClassMethodsCoder >> initialize [
	super initialize.
	filteredClasses := Set new.
	implementorsFilter := ''
]

{ #category : #elements }
GtClassMethodsCoder >> look [
	^ GtMetaMethodsCoderLook new methodsCoder: self
]

{ #category : #elements }
GtClassMethodsCoder >> methodCoderLook [
	^ GtMethodCoderCategoryLook new
		methodsCoder: self;
		yourself
]

{ #category : #private }
GtClassMethodsCoder >> newMethodClass [
	| methodClass |
	methodClass := filteredClasses anyOne.
	filteredClasses
		do: [ :each | 
			(methodClass includesBehavior: each)
				ifFalse: [ methodClass := each ] ].
	^ methodClass
]

{ #category : #private }
GtClassMethodsCoder >> newMethodCoderFor: aMethod [
	^ (super newMethodCoderFor: aMethod) object: object
]

{ #category : #accessing }
GtClassMethodsCoder >> object [
	^ object
]

{ #category : #actions }
GtClassMethodsCoder >> removeMethodsForClass: aClass [
	(filteredClasses includes: aClass)
		ifFalse: [ ^ self ].
	filteredClasses remove: aClass.
	self updateMethods.
	methodCoders removeAllSuchThat: [ :each | each classOrMetaClass = aClass and: [ each isModified not ] ].
	self announce: (GtCoderMethodsListChanged new coder: self)
]

{ #category : #private }
GtClassMethodsCoder >> shouldSort: a before: b [
	a selector isNil
		ifTrue: [ ^ b selector notNil or: [ a classOrMetaClass allSuperclasses size >= b classOrMetaClass allSuperclasses size ] ].
	b selector isNil
		ifTrue: [ ^ false ].
	a selector < b selector
		ifTrue: [ ^ true ].
	a selector > b selector
		ifTrue: [ ^ false ].
	^ a classOrMetaClass allSuperclasses size >= b classOrMetaClass allSuperclasses size
]

{ #category : #private }
GtClassMethodsCoder >> updateCoders [
	| newCoders highlighter |
	newCoders := methodCoders select: [ :each | each isModified ].
	methods
		do: [ :each | 
			(newCoders anySatisfy: [ :coder | coder isForMethod: each ])
				ifFalse: [ newCoders
						add: (methodCoders detect: [ :coder | coder isForMethod: each ] ifNone: [ self newMethodCoderFor: each ]) ] ].
	methodCoders := newCoders.
	methodCoders sort: [ :a :b | self shouldSort: a before: b ].
	highlighter := methods highlighter.
	methodCoders do: [ :each | each highlighter: highlighter ].
	self announce: (GtCoderMethodsListChanged new coder: self)
]

{ #category : #private }
GtClassMethodsCoder >> updateMethods [
	methods
		filter:
			(self classesFilter ifNotNil: [ :filter | categoryFilter ifNil: [ filter ] ifNotNil: [ :category | filter & (GtCoderMethodCategoryFilter forCategory: category) ] ])
				& (GtCoderImplementorPatternFilter pattern: implementorsFilter)
]
