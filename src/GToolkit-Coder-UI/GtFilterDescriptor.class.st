"
I describe how a {{gtClass:GtSearchMethodsFilter}} should look and behave in a UI.
I am used to build {{gtClass:GtFilterTagElement}} instances inside of {{gtClass:GtFiltersElement}}.
For more details:
- {{gtMethod:GtPharoMethodsCoderElement>>#buildFilter}} is a code that inittialize {{gtClass:GtFiltersElement}} using instances of myself,
- {{gtMethod:GtSearchFilter class>>#filterDescriptorFor:|show=#gtImplementorsFor:}} displays a list of various definitions of myself.
See {{gtClass:GtFiltersElement}} for an example.


"
Class {
	#name : #GtFilterDescriptor,
	#superclass : #Object,
	#instVars : [
		'name',
		'order',
		'creationBlock',
		'isDefault',
		'completionBlock',
		'completion',
		'emptyDefaultValue',
		'valueIsRequired'
	],
	#category : #'GToolkit-Coder-UI-Filters'
}

{ #category : #'instance creation' }
GtFilterDescriptor class >> creator: aBlock named: aString order: anInteger [
	^ self new
		creator: aBlock;
		named: aString;
		order: anInteger;
		yourself
]

{ #category : #'instance creation' }
GtFilterDescriptor class >> creator: aBlock named: aString order: anInteger completion: completionStrategy [
	^ self new
		creator: aBlock;
		named: aString;
		order: anInteger;
		completion: completionStrategy;
		yourself
]

{ #category : #'instance creation' }
GtFilterDescriptor class >> creator: aBlock named: aString order: anInteger completion: completionStrategy emptyDefaultValue: defaultValueString [
	^ self new
		creator: aBlock;
		named: aString;
		order: anInteger;
		completion: completionStrategy;
		emptyDefaultValue: defaultValueString;
		yourself
]

{ #category : #comparing }
GtFilterDescriptor >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	^ self class = anObject class
		and: [ self name = anObject name
				and: [ self order = anObject order
						and: [ self emptyDefaultValue = anObject emptyDefaultValue
								and: [ self valueIsRequired = anObject valueIsRequired ] ] ] ]
]

{ #category : #'api - configuration' }
GtFilterDescriptor >> beNotDefault [
	"Do not display this particular descriptor filter as a default filter"

	isDefault := false
]

{ #category : #accessing }
GtFilterDescriptor >> completion [
	^ completion ifNil: [ completion := (completionBlock ifNil: [ self defaultCompletion ]) value ]
]

{ #category : #'api - configuration' }
GtFilterDescriptor >> completion: completionStrategyBlock [
	completionBlock := completionStrategyBlock
]

{ #category : #accessing }
GtFilterDescriptor >> creationBlock [
	^ creationBlock ifNil: [ self defaultCreator ]
]

{ #category : #'api - configuration' }
GtFilterDescriptor >> creationBlock: aBlock [
	
	"We deprecated #creationBlock: in favor of #creator: to keep the instance side api be as close as possible to fluent class side api"
	self
		deprecated: 'Please use creator: instead.'
		transformWith:
			'`@receiver creationBlock: `@statements1'
				-> '`@receiver creator: `@statements1'.

	self creator: aBlock
]

{ #category : #'api - configuration' }
GtFilterDescriptor >> creator: aBlock [
	creationBlock := aBlock
]

{ #category : #initialization }
GtFilterDescriptor >> defaultCompletion [
	^ [ nil  ]
]

{ #category : #initialization }
GtFilterDescriptor >> defaultCreator [
	^ [ :aString | GtSearchNullFilter new ]
]

{ #category : #initialization }
GtFilterDescriptor >> defaultName [
	^ 'No name'
]

{ #category : #initialization }
GtFilterDescriptor >> defaultOrder [
	^ 1
]

{ #category : #accessing }
GtFilterDescriptor >> emptyDefaultValue [
	^ emptyDefaultValue
]

{ #category : #'api - configuration' }
GtFilterDescriptor >> emptyDefaultValue: aString [
	emptyDefaultValue := aString
]

{ #category : #'gt - extensions' }
GtFilterDescriptor >> gtCompletionsFor: aView [
	<gtView>
	self completion ifNil: [ ^ aView empty ].
	(self completion isKindOf: GtStringsCompletionStrategy)
		ifFalse: [ ^ aView empty ].
	^ aView forward
		title: 'Completions';
		object: [ self completion ];
		view: #gtCompletionsFor:
]

{ #category : #'gt - extensions' }
GtFilterDescriptor >> gtInfoFor: aView [
	<gtView>
	
	^ aView columnedList
		title: 'Info';
		priority: 1;
		items: [ { 
			'Name' -> (name ifNil: [ 'Unspecified (default: {1})' format: { self defaultName printString } ]).
			'Order' -> (order ifNil: [ 'Unspecified (default: {1})' format: { self defaultOrder printString } ]).
			'Filter creator' -> (creationBlock ifNil: [ 'Unspecified (default: {1})' format: { self defaultCreator } ]).
			'Completion' -> (completionBlock ifNil: [ 'Unspecified (default: {1})' format: { self defaultCompletion } ]).
			'Value required' -> valueIsRequired.
			'Is default' -> isDefault.
			'Default value when empty' -> (emptyDefaultValue
				ifNotNil: [ :aValue | aValue printString ]
				ifNil: [ 'Unspecified (default: {1})' format: { nil } ]). 
			'Show default value when empty' -> self showAsDefaultWhenEmpty
		} ];
	column: 'Property' text: #key;
	column: 'Value' text: #value;
	send: #value;
	actionUpdateButton
]

{ #category : #'gt - extensions' }
GtFilterDescriptor >> gtViewFilterBlockFor: aView [
	<gtView>
	
	creationBlock ifNil: [ ^ aView empty ].
	
	^ aView forward 
		title: 'Filter Creation Block';
		object: [ creationBlock ];
		view: #gtSourceCodeFor:
]

{ #category : #comparing }
GtFilterDescriptor >> hash [
	^ self class hash hashMultiply bitXor: self name hash
]

{ #category : #initialization }
GtFilterDescriptor >> initialize [
	super initialize.

	valueIsRequired := true.
	isDefault := true
]

{ #category : #testing }
GtFilterDescriptor >> isDefault [
	"Return true if the filter should be applied as a default"

	^ isDefault
]

{ #category : #testing }
GtFilterDescriptor >> isValueValid: aValueString [
	"Return true if a given value is valid for this filter descriptor, false otherwise.
	Empty values are valid only when the empty default value is empty too or is unspecified"
	<return: #Boolean>
	
	^ self valueIsRequired not or: [
		aValueString isNotEmpty or: [
			aValueString = (self emptyDefaultValue ifNil: [ '' ]) ] ]
]

{ #category : #accessing }
GtFilterDescriptor >> name [
	"Return the name of the filter (or a default one if not specified) to be displayed in the list of the filters."
	<return: #String>
	
	^ name ifNil: [ self defaultName ]
]

{ #category : #'api - configuration' }
GtFilterDescriptor >> name: aString [
	"We deprecated #name: in favor of #named: to keep the instance side api be as close as possible to fluent class side api"
	self
		deprecated: 'Please use named: instead.'
		transformWith:
			'`@receiver name: `@statements1'
				-> '`@receiver named: `@statements1'.

	self named: aString
]

{ #category : #'api - configuration' }
GtFilterDescriptor >> named: aString [
	name := aString
]

{ #category : #filters }
GtFilterDescriptor >> newFilterWithValue: aString [
	^ self creationBlock cull: aString
]

{ #category : #accessing }
GtFilterDescriptor >> order [
	"The order of the filter in the list of all filters."
	<return: #Number>

	^ order ifNil: [ self defaultOrder ]
]

{ #category : #'api - configuration' }
GtFilterDescriptor >> order: anInteger [
	order := anInteger
]

{ #category : #printing }
GtFilterDescriptor >> printOn: aStream [
	self name ifNil: [ ^ super printOn: aStream ].
	aStream 
		nextPutAll: 'Filter Descriptor: ';
		nextPutAll: self name asString;
		nextPutAll: ' (order: ';
		print: self order;
		nextPutAll: ')'
]

{ #category : #testing }
GtFilterDescriptor >> showAsDefaultWhenEmpty [
	^ isDefault and: [ valueIsRequired not or: [ emptyDefaultValue notNil ] ]
]

{ #category : #testing }
GtFilterDescriptor >> valueIsRequired [
	"Return true if the filter requires an input value, false otherwise.
	Filters that require a value should be rendered with a text input field
	allowing users to enter the value."
	<return: #Boolean>

	^ valueIsRequired
]

{ #category : #'api - configuration' }
GtFilterDescriptor >> valueNotRequired [
	valueIsRequired := false
]
