Class {
	#name : #GtFilterDescriptor,
	#superclass : #Object,
	#instVars : [
		'name',
		'order',
		'completion',
		'emptyDefaultValue',
		'creationBlock',
		'valueIsRequired'
	],
	#category : #'GToolkit-Coder-Filters - UI'
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

{ #category : #'initialize-release' }
GtFilterDescriptor >> initialize [
	super initialize.
	valueIsRequired := true
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

{ #category : #testing }
GtFilterDescriptor >> showAsDefaultWhenEmpty [
	^ emptyDefaultValue notNil
]

{ #category : #testing }
GtFilterDescriptor >> valueIsRequired [
	^ valueIsRequired
]

{ #category : #'initialize-release' }
GtFilterDescriptor >> valueNotRequired [
	valueIsRequired := false
]
