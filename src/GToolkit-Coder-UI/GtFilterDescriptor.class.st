"
I describe how a ${class:GtSearchMethodsFilter}$ should look and behave in a UI.
I am used to build ${class:GtFilterTagElement}$ instances inside of ${class:GtFiltersElement}$.
For more details:
- ${method:GtMethodsCoderElement>>#buildFilter}$ is a code that inittialize ${class:GtFiltersElement}$ using instances of myself,
- ${method:GtSearchMethodsFilter class>>#filterDescriptorFor:|show=#gtImplementorsFor:}$ displays a list of various definitions of myself.
See ${class:GtFiltersElement}$ for an example.
"
Class {
	#name : #GtFilterDescriptor,
	#superclass : #Object,
	#instVars : [
		'name',
		'order',
		'completion',
		'emptyDefaultValue',
		'creationBlock',
		'valueIsRequired',
		'isDefault'
	],
	#category : #'GToolkit-Coder-UI-Filters'
}

{ #category : #'instace creation' }
GtFilterDescriptor class >> creator: aBlock named: aString order: anInteger [
	^ self new
		creationBlock: aBlock;
		name: aString;
		order: anInteger;
		yourself
]

{ #category : #'instance creation' }
GtFilterDescriptor class >> creator: aBlock named: aString order: anInteger completion: completionStrategy [
	^ self new
		creationBlock: aBlock;
		name: aString;
		order: anInteger;
		completion: completionStrategy;
		yourself
]

{ #category : #'instance creation' }
GtFilterDescriptor class >> creator: aBlock named: aString order: anInteger completion: completionStrategy emptyDefaultValue: defaultValueString [
	^ self new
		creationBlock: aBlock;
		name: aString;
		order: anInteger;
		completion: completionStrategy;
		emptyDefaultValue: defaultValueString;
		yourself
]

{ #category : #'initialize-release' }
GtFilterDescriptor >> beNotDefault [
	"Do not display this particular descriptor filter as a default filter"
	isDefault := false
]

{ #category : #accessing }
GtFilterDescriptor >> completion [
	^ completion
]

{ #category : #accessing }
GtFilterDescriptor >> completion: completionStrategy [
	completion := completionStrategy
]

{ #category : #accessing }
GtFilterDescriptor >> creationBlock: aBlock [
	creationBlock := aBlock
]

{ #category : #accessing }
GtFilterDescriptor >> emptyDefaultValue [
	^ emptyDefaultValue
]

{ #category : #accessing }
GtFilterDescriptor >> emptyDefaultValue: aString [
	emptyDefaultValue := aString
]

{ #category : #'gt-extensions' }
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

{ #category : #'initialize-release' }
GtFilterDescriptor >> initialize [
	super initialize.
	valueIsRequired := true.
	isDefault := true.
]

{ #category : #accessing }
GtFilterDescriptor >> name [
	^ name
]

{ #category : #accessing }
GtFilterDescriptor >> name: aString [
	name := aString
]

{ #category : #filters }
GtFilterDescriptor >> newFilterWithValue: aString [
	^ creationBlock value: aString
]

{ #category : #accessing }
GtFilterDescriptor >> order [
	^ order
]

{ #category : #accessing }
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
	^ isDefault and: [ emptyDefaultValue notNil ]
]

{ #category : #testing }
GtFilterDescriptor >> valueIsRequired [
	^ valueIsRequired
]

{ #category : #'initialize-release' }
GtFilterDescriptor >> valueNotRequired [
	valueIsRequired := false
]
