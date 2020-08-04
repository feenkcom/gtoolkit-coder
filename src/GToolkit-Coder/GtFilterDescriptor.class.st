Class {
	#name : #GtFilterDescriptor,
	#superclass : #Object,
	#instVars : [
		'filterClass',
		'name',
		'order',
		'getter',
		'setter',
		'completion'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'instance creation' }
GtFilterDescriptor class >> forClass: aClass [
	^ self new
		filterClass: aClass;
		yourself
]

{ #category : #'instance creation' }
GtFilterDescriptor class >> forClass: aClass named: aString order: anInteger getter: getterSymbol [
	^ (self forClass: aClass)
		name: aString;
		order: anInteger;
		getter: getterSymbol;
		yourself
]

{ #category : #'instance creation' }
GtFilterDescriptor class >> forClass: aClass named: aString order: anInteger getter: getterSymbol setter: setterSymbol completion: completionStrategy [
	^ (self forClass: aClass)
		name: aString;
		order: anInteger;
		getter: getterSymbol;
		setter: setterSymbol;
		completion: completionStrategy;
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

{ #category : #filters }
GtFilterDescriptor >> createForCoders: aMethodsCoder andValue: aString [
	^ (filterClass createFilterFor: aMethodsCoder)
		perform: self setter with: aString;
		yourself
]

{ #category : #accessing }
GtFilterDescriptor >> filterClass [
	^ filterClass
]

{ #category : #accessing }
GtFilterDescriptor >> filterClass: aClass [
	filterClass := aClass
]

{ #category : #accessing }
GtFilterDescriptor >> getter [
	^ getter
]

{ #category : #accessing }
GtFilterDescriptor >> getter: aSymbol [
	getter := aSymbol
]

{ #category : #accessing }
GtFilterDescriptor >> name [
	^ name
]

{ #category : #accessing }
GtFilterDescriptor >> name: aString [
	name := aString
]

{ #category : #accessing }
GtFilterDescriptor >> order [
	^ order
]

{ #category : #accessing }
GtFilterDescriptor >> order: anInteger [
	order := anInteger
]

{ #category : #accessing }
GtFilterDescriptor >> setter [
	^ setter ifNil: [ setter := (getter , ':') asSymbol ]
]

{ #category : #accessing }
GtFilterDescriptor >> setter: aSymbol [
	setter := aSymbol
]
