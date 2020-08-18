Class {
	#name : #GtCodersElement,
	#superclass : #BlElement,
	#instVars : [
		'coders',
		'listElement'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #converting }
GtCodersElement >> asVerticallyResizableDo: aBlock [
	^ self
]

{ #category : #ui }
GtCodersElement >> buildElement [
	self layout: BlLinearLayout vertical.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self buildFilter.
	self addChild: self listElement as: #codersList.
]

{ #category : #ui }
GtCodersElement >> buildElementForCoder: aCoder [
	^ aCoder asElement
]

{ #category : #ui }
GtCodersElement >> buildFilter [
	| filterElement filterDescriptors |
	coders canFilter
		ifFalse: [ ^ self ].
	filterDescriptors := coders filterDescriptors.
	filterDescriptors isEmpty
		ifTrue: [ ^ self ].
	filterElement := GtMethodsFilterElement new
		padding: (BlInsets all: 2);
		coders: coders;
		yourself.
	coders
		when: GtCodersFiltersChanged
		do: [ :event | filterElement buildFiltersFrom: coders ].
	self addChild: filterElement as: #filter
]

{ #category : #accessing }
GtCodersElement >> coders [
	^ coders
]

{ #category : #accessing }
GtCodersElement >> coders: aCoders [
	coders := aCoders.
	self buildElement.
	coders announcer weak
		when: GtCodersCoderAdded , GtCodersCoderRemoved , GtCodersCodersChanged
			send: #updateList
			to: self;
		when: GtCodersScrollToCoder send: #scrollToEvent: to: self
]

{ #category : #ui }
GtCodersElement >> listElement [
	listElement
		ifNotNil: [ ^ listElement ].

	listElement := BrSimpleList new
		matchParent;
		itemType: [ :itemTypeFactory :eachCoder | eachCoder elementClass ];
		itemStencil: [ :anElementClass | anElementClass new ];
		itemDataBinder: [ :eachCoderElement :eachCoder | eachCoderElement coder: eachCoder ];
		items: coders coders;
		yourself.

	^ listElement
]

{ #category : #private }
GtCodersElement >> scrollToEvent: anEvent [
	| coder index |
	coder := anEvent sourceCoder.
	index := coders coders identityIndexOf: coder.
	index > 0
		ifTrue: [ (self childNamed: #codersList) look listElement scrollToPosition: index ]
]

{ #category : #private }
GtCodersElement >> updateFilters: tags [
	| descriptorsMap items |
	tags isEmpty
		ifTrue: [ ^ coders additionalFilters: #() ].
	descriptorsMap := coders filterDescriptors
		inject: Dictionary new
		into: [ :sum :each | 
			sum
				at: each name put: each;
				yourself ].
	items := tags
		collect: [ :each | (descriptorsMap at: each tagType) -> each name ].
	coders
		additionalFilters:
			((items asSortedCollection: [ :a :b | a key order < b key order ])
				collect: [ :each | each key createForCoders: coders andValue: each value ])
]

{ #category : #private }
GtCodersElement >> updateList [
	listElement items: coders coders
]
