Class {
	#name : #GtSearchMethodGroupResult,
	#superclass : #GtSearchTypedGroupResult,
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #converting }
GtSearchMethodGroupResult >> asCoder [
	^ GtFilteredMethodsCoder forMethods: self
]

{ #category : #converting }
GtSearchMethodGroupResult >> asElement [
	^ self asCoder asElement 
]

{ #category : #ui }
GtSearchMethodGroupResult >> gtItemsFor: aView [
	^ aView explicit 
		title: 'Live' translated;
		priority: 10;
		stencil: [ self asCoder ]
]

{ #category : #changes }
GtSearchMethodGroupResult >> methodAdded: aMethodAnnouncement [
	(filtered and: [ filter notNil ])
		ifFalse: [ ^ self ].
	(filter includeMethod: aMethodAnnouncement methodAdded)
		ifFalse: [ ^ self ].
	items add: aMethodAnnouncement methodAdded.
	announcer announce: (ValueAdded newValue: aMethodAnnouncement methodAdded)
]

{ #category : #changes }
GtSearchMethodGroupResult >> methodChanged: aMethodAnnouncement [
	| index |
	(filtered and: [ filter notNil ])
		ifFalse: [ ^ self ].
	index := items identityIndexOf: aMethodAnnouncement oldMethod ifAbsent: [ 0 ].
	(filter includeMethod: aMethodAnnouncement newMethod)
		ifTrue: [ index = 0
				ifTrue: [ items add: aMethodAnnouncement newMethod.
					announcer announce: (ValueAdded newValue: aMethodAnnouncement newMethod) ] ].
	index > 0
		ifTrue: [ items at: index put: aMethodAnnouncement newMethod.
			announcer announce: (ValueChanged oldValue: aMethodAnnouncement oldMethod newValue: aMethodAnnouncement newMethod) ]
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
	methods
		sort: [ :a :b | 
			a methodClass = b methodClass
				ifTrue: [ a selector < b selector ]
				ifFalse: [ a methodClass name < b methodClass name ] ].
	items := methods.
	filtered := true.
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
