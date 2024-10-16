Class {
	#name : #GtFilterModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'order',
		'creator',
		'name',
		'labelBuilder',
		'isDefault'
	],
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #comparing }
GtFilterModel >> = anObject [
	"I compare similarity of two filter models.
	I must not compare selected items. For such cases, use #equals:."
	
	self == anObject ifTrue: [ ^ true ].

	^ self class = anObject class
		and: [ self name = anObject name 
		and: [ self order = anObject order ] ]
]

{ #category : #announcer }
GtFilterModel >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #converting }
GtFilterModel >> asFilterLabeledElement [
	<return: #GtFilterSettingsElement>
	^ self filterLabelElementClass new filterViewModel: self asFilterViewModel
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

{ #category : #initialization }
GtFilterModel >> beDefault [
	isDefault := true
]

{ #category : #initialization }
GtFilterModel >> beNotDefault [
	isDefault := false
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
GtFilterModel >> defaultFilterName [
	| aToIndex aFromIndex |
	aToIndex := (self class name size - 5 max: 1).
	aFromIndex := 9 min: aToIndex.
	^ self class name copyFrom: aFromIndex to: aToIndex
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
GtFilterModel >> filterLabelElementClass [
	<return: #'GtFilterLabelElement class'>
	^ labelBuilder labelElementClass
]

{ #category : #accessing }
GtFilterModel >> filterViewModelClass [
	<return: #'GtFilterViewModel class'>
	^ labelBuilder labelElementClass
]

{ #category : #'gt - extensions' }
GtFilterModel >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		stencil: [ self asFilterLabeledElement margin: (BlInsets all: 10) ]
]

{ #category : #comparing }
GtFilterModel >> hash [
	^ self class hash 
		bitXor: (self name hash 
		bitXor: self order hash)
]

{ #category : #initialization }
GtFilterModel >> initialize [
	super initialize.
	labelBuilder := GtFilterModelImplicitPrefixLabel new model: self.
	isDefault := false.
]

{ #category : #testing }
GtFilterModel >> isDefaultFilterModel [
	^ isDefault
]

{ #category : #testing }
GtFilterModel >> isVirtualFilterModel [
	^ false
]

{ #category : #accessing }
GtFilterModel >> label [
	"Return filter label"

	<return: #String>
	^ labelBuilder label
]

{ #category : #accessing }
GtFilterModel >> label: aString [
	self
		deprecated: 'Use name: instead'
		transformWith: '`@receiver label: `@argument' -> '`@receiver name: `@argument'.
	self name: aString
]

{ #category : #accessing }
GtFilterModel >> name [
	"Return filter name"

	<return: #String>
	^ name ifNil: [ name := self defaultFilterName ]
]

{ #category : #accessing }
GtFilterModel >> name: aString [
	"Set filter name. 
	The name is used in a filter selection (dropdown) list."

	name = aString ifTrue: [ ^ self ].

	name := aString.
	self notifyLabelChanged
]

{ #category : #accessing }
GtFilterModel >> named: aString [
	self name: aString
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

{ #category : #accessing }
GtFilterModel >> prefixLabel: aString [
	"Display a filter label before a setting widget."

	| aLabel |
	aLabel := GtFilterModelExplicitPrefixLabel new label: aString.
	labelBuilder = aLabel ifTrue: [ ^ self ].

	labelBuilder := aLabel.
	self notifyLabelChanged
]

{ #category : #printing }
GtFilterModel >> printDetailsOn: aStream [
	aStream
		nextPutAll: self name asString;
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

{ #category : #accessing }
GtFilterModel >> suffixLabel: aString [
	"Display a filter label after a setting widget."

	| aLabel |
	aLabel := GtFilterModelExplicitSuffixLabel new label: aString.
	labelBuilder = aLabel ifTrue: [ ^ self ].

	labelBuilder := aLabel.
	self notifyLabelChanged
]
