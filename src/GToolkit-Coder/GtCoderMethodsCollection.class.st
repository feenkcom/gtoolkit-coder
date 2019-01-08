Class {
	#name : #GtCoderMethodsCollection,
	#superclass : #Collection,
	#instVars : [
		'methods',
		'filter',
		'filtered',
		'announcer'
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

{ #category : #accessing }
GtCoderMethodsCollection >> announcer [
	^ announcer
]

{ #category : #converting }
GtCoderMethodsCollection >> asCoder [
	^ GtFilteredMethodsCoder forMethods: self
]

{ #category : #converting }
GtCoderMethodsCollection >> asElement [
	^ self asCoder asElement 
]

{ #category : #enumerating }
GtCoderMethodsCollection >> do: aBlock [
	self refreshMethods.
	^ methods do: aBlock
]

{ #category : #accessing }
GtCoderMethodsCollection >> filter [
	^ filter
]

{ #category : #accessing }
GtCoderMethodsCollection >> filter: coderMethodsFilter [
	filtered := false.
	methods := OrderedCollection new.
	filter := coderMethodsFilter
]

{ #category : #ui }
GtCoderMethodsCollection >> gtLiveFor: aView [
	<gtView>
	^ aView explicit 
		title: 'Live';
		priority: 10;
		stencil: [ self asCoder ]
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
	announcer := Announcer new.
	filtered := false.
	methods := OrderedCollection new.
	self subscribe
]

{ #category : #changes }
GtCoderMethodsCollection >> methodAdded: aMethodAnnouncement [
	(filtered and: [ filter notNil ])
		ifFalse: [ ^ self ].
	(filter includeMethod: aMethodAnnouncement methodAdded)
		ifFalse: [ ^ self ].
	methods add: aMethodAnnouncement methodAdded.
	announcer announce: (ValueAdded newValue: aMethodAnnouncement methodAdded)
]

{ #category : #changes }
GtCoderMethodsCollection >> methodChanged: aMethodAnnouncement [
	| index |
	(filtered and: [ filter notNil ])
		ifFalse: [ ^ self ].
	index := methods identityIndexOf: aMethodAnnouncement oldMethod ifAbsent: [ 0 ].
	(filter includeMethod: aMethodAnnouncement newMethod)
		ifTrue: [ index = 0
				ifTrue: [ methods add: aMethodAnnouncement newMethod.
					announcer announce: (ValueAdded newValue: aMethodAnnouncement newMethod) ] ].
	index > 0
		ifTrue: [ methods at: index put: aMethodAnnouncement newMethod.
			announcer announce: (ValueChanged oldValue: aMethodAnnouncement oldMethod newValue: aMethodAnnouncement newMethod) ]
]

{ #category : #changes }
GtCoderMethodsCollection >> methodRemoved: aMethodAnnouncement [
	methods remove: aMethodAnnouncement methodRemoved ifAbsent: [ ^ self ].
	announcer announce: (ValueRemoved oldValue: aMethodAnnouncement methodRemoved)
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

{ #category : #subscription }
GtCoderMethodsCollection >> subscribe [
	SystemAnnouncer uniqueInstance weak
		when: MethodAdded send: #methodAdded: to: self;
		when: MethodModified send: #methodChanged: to: self;
		when: MethodRemoved send: #methodRemoved: to: self
]

{ #category : #subscription }
GtCoderMethodsCollection >> unsubscribe [
	SystemAnnouncer uniqueInstance unsubscribe: self
]
