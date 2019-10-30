Class {
	#name : #GtClassMethodsCoder,
	#superclass : #GtFilteredMethodsCoder,
	#instVars : [
		'class',
		'object',
		'filteredClasses'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'instance creation' }
GtClassMethodsCoder class >> forClass: aBehavior [
	^ self new
		forClass: aBehavior;
		yourself
]

{ #category : #'instance creation' }
GtClassMethodsCoder class >> forObject: anObject [
	^ self new
		forObject: anObject;
		yourself
]

{ #category : #actions }
GtClassMethodsCoder >> addMethodsForClass: aClass [
	(filteredClasses includes: aClass)
		ifTrue: [ ^ self ].
	filteredClasses add: aClass.
	self updateMethods.
	self updateCoders
]

{ #category : #actions }
GtClassMethodsCoder >> addNewCoder [
	| coder |
	coder := GtMethodCoder newMethod.
	coder classOrMetaClass: self newMethodClass.
	coder object: self object.
	coders addFirst: coder.
	self
		announce:
			(GtCodersCoderAdded new
				coders: self;
				coder: coder;
				yourself)
]

{ #category : #accessing }
GtClassMethodsCoder >> classOrMetaClass [
	^ class
]

{ #category : #private }
GtClassMethodsCoder >> classesFilter [
	| filter |
	filter := nil.
	filteredClasses
		do: [ :each | 
			| classFilter |
			classFilter := GtSearchMethodsInInstanceAndClassSideFilter forClass: each.
			filter := filter isNil
				ifTrue: [ classFilter ]
				ifFalse: [ filter | classFilter ] ].
	^ filter
]

{ #category : #private }
GtClassMethodsCoder >> combinedFilter [
	| combined |
	combined := super combinedFilter.
	^ combined isNil
		ifTrue: [ self classesFilter ]
		ifFalse: [ self classesFilter 
			ifNil: [ nil ] 
			ifNotNil: [ :filter | filter & combined ] ]
]

{ #category : #testing }
GtClassMethodsCoder >> filteredClass: aBehavior [
	^ filteredClasses includes: aBehavior
]

{ #category : #private }
GtClassMethodsCoder >> filters [
	^ {
		self classesFilter.
		self categoryFilter.
		self implementorsFilter}
]

{ #category : #'initialize-release' }
GtClassMethodsCoder >> forClass: aBehavior [
	class := aBehavior.
	filteredClasses := Set with: aBehavior.
	self forItems: (GtSearchMethodGroupResult 
		forFilter: (GtSearchMethodsInInstanceAndClassSideFilter forClass: class))
]

{ #category : #'initialize-release' }
GtClassMethodsCoder >> forObject: anObject [
	object := anObject.
	self forClass: anObject class
]

{ #category : #printing }
GtClassMethodsCoder >> gtDisplayString [
	^ class name , ' methods'
]

{ #category : #spotter }
GtClassMethodsCoder >> gtSpotterMethodsFor: aStep [
	<gtSearch>
	aStep listProcessor
		priority: 10;
		title: 'Methods';
		allCandidates: [ self coders ];
		itemName: [ :method | method selector ];
		previewElement: [ :coder | coder previewElement ];
		filter: GTFilterSubstring
]

{ #category : #testing }
GtClassMethodsCoder >> hasFilter [
	^ filteredClasses notEmpty
]

{ #category : #'initialize-release' }
GtClassMethodsCoder >> initialize [
	super initialize.
	filteredClasses := Set new
]

{ #category : #private }
GtClassMethodsCoder >> newCoderFor: aMethod [
	^ (super newCoderFor: aMethod) object: object
]

{ #category : #private }
GtClassMethodsCoder >> newMethodClass [
	| methodClass |
	methodClass := filteredClasses anyOne.
	filteredClasses
		do: [ :each | 
			(methodClass includesBehavior: each)
				ifFalse: [ methodClass := each ] ].
	^ methodClass
]

{ #category : #accessing }
GtClassMethodsCoder >> object [
	^ object
]

{ #category : #actions }
GtClassMethodsCoder >> removeMethodsForClass: aClass [
	(filteredClasses includes: aClass)
		ifFalse: [ ^ self ].
	filteredClasses remove: aClass.
	self updateMethods.
	coders
		removeAllSuchThat: [ :each | 
			(each classOrMetaClass = aClass
				or: [ each classOrMetaClass = aClass classSide ])
				and: [ each isModified not ] ].
	self
		announce:
			(GtCodersCodersChanged new
				coders: self;
				yourself)
]

{ #category : #private }
GtClassMethodsCoder >> shouldSort: a before: b [
	a selector isNil
		ifTrue: [ ^ b selector notNil or: [ a classOrMetaClass allSuperclasses size >= b classOrMetaClass allSuperclasses size ] ].
	b selector isNil
		ifTrue: [ ^ false ].
	a selector < b selector
		ifTrue: [ ^ true ].
	a selector > b selector
		ifTrue: [ ^ false ].
	^ a classOrMetaClass allSuperclasses size >= b classOrMetaClass allSuperclasses size
]
