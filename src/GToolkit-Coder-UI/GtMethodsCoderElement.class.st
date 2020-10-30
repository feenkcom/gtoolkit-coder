Class {
	#name : #GtMethodsCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'coders',
		'listElement',
		'codersUIModel'
	],
	#category : #'GToolkit-Coder-UI-Coder - Methods'
}

{ #category : #converting }
GtMethodsCoderElement >> asVerticallyResizableDo: aBlock [
	^ self
]

{ #category : #ui }
GtMethodsCoderElement >> buildElement [
	self layout: BlLinearLayout vertical.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self buildFilter.
	self addChild: self listElement as: #codersList.
]

{ #category : #ui }
GtMethodsCoderElement >> buildFilter [
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
	coders
		when: GtCodersFiltersChanged
		do: [ :event | self updateDisplayedFilters: filterElement ].
	self addChild: filterElement as: #filter
]

{ #category : #accessing }
GtMethodsCoderElement >> coders [
	^ coders
]

{ #category : #accessing }
GtMethodsCoderElement >> coders: aCoders [
	coders := aCoders.
	
	codersUIModel := GtCodersUIModel new coders: aCoders.

	self buildElement.
	coders announcer weak
		when: GtCodersCoderAdded , GtCodersCoderRemoved , GtCodersCodersChanged
			send: #updateList
			to: self;
		when: GtCodersScrollToCoder send: #scrollToEvent: to: self
]

{ #category : #ui }
GtMethodsCoderElement >> listElement [
	listElement
		ifNotNil: [ ^ listElement ].

	listElement := BrSimpleList new
		matchParent;
		itemType: [ :itemTypeFactory :eachCoderUIModel | eachCoderUIModel coder elementClass ];
		itemStencil: [ :anElementClass | anElementClass new ];
		itemDataBinder: [ :eachCoderElement :eachCoderUIModel | eachCoderElement coderUIModel: eachCoderUIModel ];
		itemDataUnbinder: [ :eachCoderElement :eachCoderUIModel | eachCoderElement saveCoderUIModel: eachCoderUIModel ];
		items: codersUIModel coderUIModels;
		yourself.

	^ listElement
]

{ #category : #'as yet unclassified' }
GtMethodsCoderElement >> scrollToEvent: anEvent [
	| coder index |
	coder := anEvent sourceCoder.
	index := coders coders identityIndexOf: coder.
	index > 0
		ifTrue: [ (self childNamed: #codersList) look listElement scrollToPosition: index ]
]

{ #category : #'private - updating' }
GtMethodsCoderElement >> updateCodersFilters: event [
	| filters |
	filters := OrderedCollection new.
	event filterElement
		filtersDo:
			[ :descriptor :value | filters add: (descriptor newFilterWithValue: value) ].
	^ coders additionalFilters: filters
]

{ #category : #'private - updating' }
GtMethodsCoderElement >> updateDisplayedFilters: filterElement [
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

{ #category : #'private - updating' }
GtMethodsCoderElement >> updateList [
	codersUIModel
		ifNil: [ ^ self ].
	codersUIModel updateCoderUIModels.
	self listElement items: codersUIModel coderUIModels
]
