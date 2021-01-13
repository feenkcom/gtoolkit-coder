Class {
	#name : #GtMethodsCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'methodsCoderUIModel',
		'listElement'
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
	self addChild: self listElement as: #codersList
]

{ #category : #ui }
GtMethodsCoderElement >> buildFilter [
	| filterElement filterDescriptors |
	methodsCoderUIModel coder canFilter
		ifFalse: [ ^ self ].
	filterDescriptors := methodsCoderUIModel coder filterDescriptors.
	filterDescriptors isEmpty
		ifTrue: [ ^ self ].
	filterElement := GtFiltersElement new
		padding: (BlInsets all: 2);
		descriptors: filterDescriptors;
		yourself.
	filterElement
		when: GtFiltersChangedEvent
		do: [ :event | self updateCodersFilters: event ].
	methodsCoderUIModel coder announcer weak
		when: GtCodersFiltersChanged
		send: #updateDisplayedFilters
		to: self.
	self addChild: filterElement as: #filter
]

{ #category : #accessing }
GtMethodsCoderElement >> codersUIModel [
	^ methodsCoderUIModel
]

{ #category : #accessing }
GtMethodsCoderElement >> codersUIModel: aGtMethodsCoderUIModel [
	methodsCoderUIModel := aGtMethodsCoderUIModel.
	self buildElement.
	methodsCoderUIModel coder announcer weak
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
		beInSeparateCompositionLayer;
		itemType: [ :itemTypeFactory :eachCoderUIModel | eachCoderUIModel elementClass ];
		itemId: [ :eachCoderUIModel | eachCoderUIModel coder id ];
		itemStencil: [ :anElementClass | anElementClass new ];
		itemDataBinder: [ :eachCoderElement :eachCoderUIModel | eachCoderElement coderUIModel: eachCoderUIModel ];
		itemDataUnbinder: [ :eachCoderElement :eachCoderUIModel | eachCoderElement saveCoderUIModel: eachCoderUIModel ];
		items: methodsCoderUIModel coderUIModels;
		yourself.

	^ listElement
]

{ #category : #'as yet unclassified' }
GtMethodsCoderElement >> scrollToEvent: anEvent [
	| coder index |
	coder := anEvent sourceCoder.
	index := methodsCoderUIModel coder coders identityIndexOf: coder.
	index > 0
		ifTrue: [ (self childNamed: #codersList) look listElement
				scrollToPosition: index ]
]

{ #category : #'private - updating' }
GtMethodsCoderElement >> updateCodersFilters: event [
	| filters |
	filters := OrderedCollection new.
	event filterElement
		filtersDo:
			[ :descriptor :value | filters add: (descriptor newFilterWithValue: value) ].
	^ methodsCoderUIModel coder additionalFilters: filters
]

{ #category : #'private - updating' }
GtMethodsCoderElement >> updateDisplayedFilters [
	self
		childWithId: #filter
		ifFound: [ :aFiltersElement |
			aFiltersElement
				buildFilters: [ methodsCoderUIModel coder additionalFilters
						do: [ :each | 
							(each class filterDescriptorFor: methodsCoderUIModel coder)
								ifNotNil: [ :descriptor | 
									| label |
									label := descriptor valueIsRequired
										ifTrue: [ each filterValueString ].
									aFiltersElement
										addFilterForDescriptor: descriptor
										andValue: label ] ] ] ]
		ifNone: [  ]
]

{ #category : #'private - updating' }
GtMethodsCoderElement >> updateList [
	methodsCoderUIModel
		ifNil: [ ^ self ].
	methodsCoderUIModel updateCoderUIModels.
	self listElement items: methodsCoderUIModel coderUIModels
]
