Class {
	#name : #GtCoderMethodsCollection,
	#superclass : #Collection,
	#instVars : [
		'methods',
		'filter',
		'filtered'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtCoderMethodsCollection class >> forClass: aClass andVariable: aString [
	^ self forFilter: (GtCoderInstanceVariableReferenceFilter forClass: aClass andVariable: aString)
]

{ #category : #'instance creation' }
GtCoderMethodsCollection class >> forFilter: aCoderMethodsFilter [
	^ self new
		filter: aCoderMethodsFilter;
		yourself
]

{ #category : #'instance creation' }
GtCoderMethodsCollection class >> forImplementors: aSymbol [
	^ self forFilter: (GtCoderImplementorsFilter selector: aSymbol)
]

{ #category : #'instance creation' }
GtCoderMethodsCollection class >> forReferences: aSymbol [
	^ self forFilter: (GtCoderReferencesFilter literal: aSymbol)
]

{ #category : #adding }
GtCoderMethodsCollection >> add: aMethod [
	self refreshMethods.
	^ methods add: aMethod
]

{ #category : #private }
GtCoderMethodsCollection >> allBehaviorsDo: aBlock [
	Smalltalk
		allClassesAndTraitsDo: [ :each | 
			aBlock
				value: each;
				value: each classSide ]
]

{ #category : #private }
GtCoderMethodsCollection >> allMethodsSelect: aBlock [
	| methods |
	methods := OrderedCollection new.
	self
		allBehaviorsDo: [ :each | 
			each
				methodsDo: [ :method | 
					(aBlock value: method)
						ifTrue: [ methods add: method ] ] ].
	^ methods
]

{ #category : #converting }
GtCoderMethodsCollection >> asCoder [
	^ GtMethodsCoder forMethods: self
]

{ #category : #enumerating }
GtCoderMethodsCollection >> do: aBlock [
	self refreshMethods.
	^ methods do: aBlock
]

{ #category : #'initialize-release' }
GtCoderMethodsCollection >> filter: coderMethodsFilter [
	filter := coderMethodsFilter
]

{ #category : #accessing }
GtCoderMethodsCollection >> highlighter [
	^ filter notNil
		ifTrue: [ filter highlighter ]
		ifFalse: [ nil ]
]

{ #category : #'initialize-release' }
GtCoderMethodsCollection >> initialize [
	super initialize.
	filtered := false.
	methods := OrderedCollection new
]

{ #category : #enumerating }
GtCoderMethodsCollection >> refreshMethods [
	filtered
		ifTrue: [ ^ self ].
	methods := filter isNil
		ifTrue: [ OrderedCollection new ]
		ifFalse: [ self allMethodsSelect: [ :each | filter includeMethod: each ] ].
	methods
		sort: [ :a :b | 
			a methodClass = b methodClass
				ifTrue: [ a selector < b selector ]
				ifFalse: [ a methodClass name < b methodClass name ] ].
	filtered := true
]

{ #category : #removing }
GtCoderMethodsCollection >> remove: aMethod ifAbsent: aBlock [
	self refreshMethods.
	^ methods remove: aMethod ifAbsent: aBlock
]

{ #category : #accessing }
GtCoderMethodsCollection >> size [
	self refreshMethods.
	^ methods size
]

{ #category : #private }
GtCoderMethodsCollection >> species [
	self refreshMethods.
	^ methods class
]
