Class {
	#name : #GtFilterModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'label',
		'order',
		'creator'
	],
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #comparing }
GtFilterModel >> = anObject [
	"I compare similarity of two filter models.
	I must not compare selected items. For such cases, use #equals:."
	
	self == anObject ifTrue: [ ^ true ].

	^ self class = anObject class
		and: [ self label = anObject label 
		and: [ self order = anObject order ] ]
]

{ #category : #announcer }
GtFilterModel >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #converting }
GtFilterModel >> asFilterViewModel [
	<return: #GtFilterViewModel>
	^ self filterViewModelClass new filterModel: self
]

{ #category : #converting }
GtFilterModel >> asSearchFilter [
	<return: #GtSearchFilter or: nil>
	^ creator cull: self selectedValue cull: self
]

{ #category : #converting }
GtFilterModel >> asUserSettingsElement [
	<return: #GtFilterSettingsElement>
	^ self asFilterViewModel asUserSettingsElement
]

{ #category : #testing }
GtFilterModel >> changesFilteredResult [
	"Indicates whether it changes a result of filtered items, e.g., list of method coders."

	<return: #Boolean>
	^ true
]

{ #category : #accessing }
GtFilterModel >> creator [
	^ creator
]

{ #category : #accessing }
GtFilterModel >> creator: anObject [
	creator := anObject
]

{ #category : #initialization }
GtFilterModel >> defaultFilterLabel [
	^ self class name copyFrom: 9 to: self class name size - 5
]

{ #category : #initialization }
GtFilterModel >> defaultFilterOrder [
	^ 50
]

{ #category : #comparing }
GtFilterModel >> equals: anObject [
	self = anObject ifFalse: [ ^ false ].

	^ self selectedValue = anObject selectedValue
]

{ #category : #accessing }
GtFilterModel >> filterViewModelClass [
	<return: #'GtFilterViewModel class'>
	^ self subclassResponsibility
]

{ #category : #'gt - extensions' }
GtFilterModel >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		stencil: [ (GtFilterNameElement new filterViewModel: self asFilterViewModel)
				margin: (BlInsets all: 10) ]
]

{ #category : #comparing }
GtFilterModel >> hash [
	^ self class hash 
		bitXor: (self label hash 
		bitXor: self order hash)
]

{ #category : #testing }
GtFilterModel >> isVirtualFilterModel [
	^ false
]

{ #category : #accessing }
GtFilterModel >> label [
	"Return filter label"

	<return: #String>
	^ label ifNil: [ label := self defaultFilterLabel ]
]

{ #category : #accessing }
GtFilterModel >> label: aString [
	label = aString ifTrue: [ ^ self ].
	
	label := aString.
	self notifyLabelChanged.
]

{ #category : #accessing }
GtFilterModel >> named: aString [
	self label: aString
]

{ #category : #'private - notifying' }
GtFilterModel >> notifyLabelChanged [
	self
		announce: (GtFilterModelLabelChanged new
				model: self;
				label: self label)
]

{ #category : #accessing }
GtFilterModel >> order [
	^ order ifNil: [ order := self defaultFilterOrder ]
]

{ #category : #accessing }
GtFilterModel >> order: anObject [
	order := anObject
]

{ #category : #printing }
GtFilterModel >> printDetailsOn: aStream [
	aStream
		nextPutAll: self label asString;
		nextPutAll: ': ';
		print: (self selectedValue ifNotNil: [ :aValue | aValue asFilterModelItem itemValue ]);
		nextPutAll: ', order: ';
		print: self order
]

{ #category : #printing }
GtFilterModel >> printOn: aStream [
	super printOn: aStream.

	aStream nextPut: $(.
	self printDetailsOn: aStream.
	aStream nextPut: $)
]

{ #category : #accessing }
GtFilterModel >> selectedValue [
	"Return a filter value, e.g., selected item, input text."

	^ nil
]
