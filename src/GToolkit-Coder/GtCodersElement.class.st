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
	filterElement := GtFilterTagger new
		padding: (BlInsets all: 2);
		descriptors: filterDescriptors;
		defaultTagType: filterDescriptors first name;
		look: GtFilterTaggerEditableLook;
		when: BrTaggerAddTagRequest
			do: [ :aRequest | 
			(GtSearchMethodsFilter isTag: aRequest tag validFor: coders)
				ifTrue: [ aRequest currentTarget addTag: aRequest tag ].
			self updateFilters: aRequest currentTarget viewModel tags ];
		when: BrTaggerRemoveTagRequest
			do: [ :aRequest | 
			aRequest currentTarget removeTag: aRequest tag.
			self updateFilters: aRequest currentTarget viewModel tags ];
		when: BrTaggerRenameTagRequest
			do: [ :aRequest | 
			(GtSearchMethodsFilter isTag: aRequest tag validFor: coders)
				ifFalse: [ aRequest currentTarget removeTag: aRequest tag ]
				ifTrue:
					[ aRequest currentTarget renameTag: aRequest tag to: aRequest newName ].
			self updateFilters: aRequest currentTarget viewModel tags ];
		when: GtTaggerChangeTagType
			do:
				[ :aRequest | self updateFilters: aRequest currentTarget viewModel tags ];
		yourself.
	coders
		when: GtCodersFiltersChanged
		do: [ :event | self updateTagger: filterElement ].
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

{ #category : #private }
GtCodersElement >> updateTagger: taggerElement [
	| tags |
	tags := OrderedCollection new.
	coders additionalFilters
		do: [ :each | 
			(each class filterDescriptorFor: coders)
				ifNotNil: [ :descriptor | 
					tags
						add:
							(GtFilterTaggerTag new
								name: (each perform: descriptor getter);
								tagType: descriptor name) ] ].
	taggerElement viewModel tags: tags
]
