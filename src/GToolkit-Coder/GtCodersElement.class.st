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
	filterElement := GtFiltersElement new
		padding: (BlInsets all: 2);
		descriptors: filterDescriptors;
		yourself.
	filterElement
		when: GtFiltersChangedEvent
		do: [ :event | self updateCodersFilters: event ].
	coders weak
		when: GtCodersFiltersChanged
		do: [ :event | self updateDisplayedFilters: filterElement ].
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

{ #category : #ui }
GtCodersElement >> updateCodersFilters: event [
	| filters |
	filters := OrderedCollection new.
	event filterElement
		filtersDo:
			[ :descriptor :value | filters add: (descriptor newFilterWithValue: value) ].
	^ coders additionalFilters: filters
]

{ #category : #ui }
GtCodersElement >> updateDisplayedFilters: filterElement [
	filterElement
		buildFilters: [ coders additionalFilters
				do: [ :each | 
					(each class filterDescriptorFor: coders)
						ifNotNil: [ :descriptor | 
							| label |
							label := descriptor valueIsRequired
								ifTrue: [ each filterValueString ].
							filterElement
								addFilterForDescriptor: descriptor
								andValue: label ] ] ]
]

{ #category : #private }
GtCodersElement >> updateList [
	listElement items: coders coders
]
