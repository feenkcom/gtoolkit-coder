Class {
	#name : #GtClassMethodsCoder,
	#superclass : #GtMethodsCoder,
	#instVars : [
		'class',
		'object',
		'filteredClasses'
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
	aClass selectors do: [ :each | methodCoders add: (self newMethodCoderFor: aClass >> each) ].
	methodCoders sort: [ :a :b | self shouldSort: a before: b ].
	self announce: (GtCoderMethodsListChanged new coder: self)
]

{ #category : #actions }
GtClassMethodsCoder >> addNewCoder [
	| coder |
	coder := GtMethodCoder newMethod.
	coder classOrMetaClass: self classOrMetaClass.
	coder object: self object.
	methodCoders addFirst: coder.
	self announce: (GtMethodCoderAdded new coder: self; methodCoder: coder)
]

{ #category : #accessing }
GtClassMethodsCoder >> classOrMetaClass [
	^ class
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

{ #category : #'initialize-release' }
GtClassMethodsCoder >> initialize [
	super initialize.
	filteredClasses := Set new
]

{ #category : #elements }
GtClassMethodsCoder >> look [
	^ GtMetaMethodsCoderLook new methodsCoder: self
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
	self announce: (GtCoderMethodsListChanged new coder: self).
	filteredClasses isEmpty
		ifTrue: [ self addMethodsForClass: self classOrMetaClass ]
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
GtClassMethodsCoder >> updateMethods [
	| filter |
	filter := nil.
	filteredClasses
		do: [ :each | 
			| classFilter |
			classFilter := GtCoderBehaviorMethodFilter forClass: each.
			filter := filter isNil
				ifTrue: [ classFilter ]
				ifFalse: [ filter | classFilter ] ].
	methods filter: filter
]
