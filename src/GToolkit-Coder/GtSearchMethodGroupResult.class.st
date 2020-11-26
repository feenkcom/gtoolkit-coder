Class {
	#name : #GtSearchMethodGroupResult,
	#superclass : #GtSearchTypedGroupResult,
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'instance creation' }
GtSearchMethodGroupResult class >> forClass: aClass andVariable: aString [
	^ self forFilter: (GtSearchInstanceVariableReferenceFilter forClass: aClass andVariable: aString)
]

{ #category : #'instance creation' }
GtSearchMethodGroupResult class >> forFilter: aCoderMethodsFilter [
	^ self new
		updateForFilter: aCoderMethodsFilter;
		yourself
]

{ #category : #'instance creation' }
GtSearchMethodGroupResult class >> forImplementors: aSymbol [
	^ self forFilter: (GtSearchImplementorsFilter selector: aSymbol)
]

{ #category : #'instance creation' }
GtSearchMethodGroupResult class >> forReferences: aSymbol [
	^ self forFilter: (GtSearchReferencesFilter literal: aSymbol)
]

{ #category : #converting }
GtSearchMethodGroupResult >> asCoder [
	^ GtFilteredMethodsCoder forItems: self
]

{ #category : #converting }
GtSearchMethodGroupResult >> asElement [
	^ self asCoder asElement 
]

{ #category : #ui }
GtSearchMethodGroupResult >> gtItemsFor: aView [
	<gtView>
	^ aView explicit 
		title: 'Live' translated;
		priority: 10;
		stencil: [ self asCoder ]
]

{ #category : #changes }
GtSearchMethodGroupResult >> methodAdded: aMethodAnnouncement [
	(filtered and: [ filter notNil ])
		ifFalse: [ ^ self ].
	(filter matches: aMethodAnnouncement methodAdded)
		ifFalse: [ ^ self ].
	items add: aMethodAnnouncement methodAdded.
	
	"we should just re-sort when a method is added"
	self sortMethods: items.

	announcer announce: (ValueAdded newValue: aMethodAnnouncement methodAdded)
]

{ #category : #changes }
GtSearchMethodGroupResult >> methodChanged: aMethodAnnouncement [
	| index selector class |
	(filtered and: [ filter notNil ])
		ifFalse: [ ^ self ].
	selector := aMethodAnnouncement oldMethod selector.
	class := aMethodAnnouncement oldMethod methodClass.
	index := (1 to: items size)
		detect: [ :i | 
			| method |
			method := items at: i.
			method selector = selector and: [ method methodClass = class ] ]
		ifNone: [ 0 ].
	(filter matches: aMethodAnnouncement newMethod)
		ifTrue: [ index = 0
				ifTrue: [ items add: aMethodAnnouncement newMethod.
					announcer
						announce: (ValueAdded newValue: aMethodAnnouncement newMethod) ] ].
	index > 0
		ifTrue: [ items at: index put: aMethodAnnouncement newMethod.
			announcer
				announce:
					(ValueChanged
						oldValue: aMethodAnnouncement oldMethod
						newValue: aMethodAnnouncement newMethod) ]
]

{ #category : #changes }
GtSearchMethodGroupResult >> methodRemoved: aMethodAnnouncement [
	items remove: aMethodAnnouncement methodRemoved ifAbsent: [ ^ self ].
	announcer announce: (ValueRemoved oldValue: aMethodAnnouncement methodRemoved)
]

{ #category : #enumerating }
GtSearchMethodGroupResult >> refreshItems [
	self refreshMethods
]

{ #category : #enumerating }
GtSearchMethodGroupResult >> refreshMethods [
	| methods |
	filtered
		ifTrue: [ ^ self ].
	methods := OrderedCollection new.
	filter ifNotNil: [ 
		"The actual filtering should be dipatched through the filter"
		scope itemsDo: [ :aCompiledMethod | 
			(filter matches: aCompiledMethod) ifTrue: [
				methods add: aCompiledMethod ] ] ].
	self sortMethods: methods.
	items := methods.
	filtered := true.
]

{ #category : #private }
GtSearchMethodGroupResult >> sortMethods: aCollectionOfMethods [
	aCollectionOfMethods sort: GtMethodsSortFunction new
]

{ #category : #subscription }
GtSearchMethodGroupResult >> subscribe [
	SystemAnnouncer uniqueInstance weak
		when: MethodAdded send: #methodAdded: to: self;
		when: MethodModified send: #methodChanged: to: self;
		when: MethodRemoved send: #methodRemoved: to: self
]

{ #category : #subscription }
GtSearchMethodGroupResult >> unsubscribe [
	SystemAnnouncer uniqueInstance unsubscribe: self
]
