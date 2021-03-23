Class {
	#name : #GtPharoDummyClass,
	#superclass : #GtPharoDummy,
	#instVars : [
		'dummyPackage',
		'realClass',
		'className',
		'dummyMethods',
		'instVarNames'
	],
	#category : #'GToolkit-Coder-Pharo-Examples-Dummies'
}

{ #category : #accessing }
GtPharoDummyClass >> addDummyMethods: aCollectionOfDummyMethods [
	dummyMethods addAll: aCollectionOfDummyMethods.
	aCollectionOfDummyMethods do: [ :eachDummyMethod | eachDummyMethod dummyClass: self ]
]

{ #category : #'api - methods' }
GtPharoDummyClass >> anyDummyKeywordMethod [
	<return: #GtPharoDummyMethod>

	^ self dummyKeywordMethods anyOne
]

{ #category : #'api - methods' }
GtPharoDummyClass >> anyDummyUnaryMethod [
	<return: #GtPharoDummyMethod>

	^ self dummyUnaryMethods anyOne
]

{ #category : #'api - inst vars' }
GtPharoDummyClass >> anyInstVarName [
	<return: #Symbol>

	^ self instVarNames anyOne
]

{ #category : #accessing }
GtPharoDummyClass >> className [
	^ className
]

{ #category : #accessing }
GtPharoDummyClass >> className: anObject [
	className := anObject
]

{ #category : #'api - methods' }
GtPharoDummyClass >> dummyKeywordMethods [
	^ self dummyMethods select: [ :each | each isKeyword ]
]

{ #category : #accessing }
GtPharoDummyClass >> dummyMethods [
	^ dummyMethods
]

{ #category : #accessing }
GtPharoDummyClass >> dummyPackage [
	^ dummyPackage
]

{ #category : #accessing }
GtPharoDummyClass >> dummyPackage: anObject [
	dummyPackage := anObject
]

{ #category : #'api - methods' }
GtPharoDummyClass >> dummyUnaryMethods [
	^ self dummyMethods select: [ :each | each isUnary ]
]

{ #category : #'gt-extensions' }
GtPharoDummyClass >> gtCoderFor: aView [
	<gtView>
	| aRealClass |

	(aRealClass := realClass) ifNil: [ ^ aView empty ].

	^ aView explicit
		title: 'Coder';
		priority: 5;
		stencil: [ GtCoder forClass: aRealClass ]
]

{ #category : #initialization }
GtPharoDummyClass >> initialize [
	super initialize.
	
	dummyMethods := OrderedCollection new
]

{ #category : #accessing }
GtPharoDummyClass >> instVarNames [
	^ instVarNames
]

{ #category : #accessing }
GtPharoDummyClass >> instVarNames: anObject [
	instVarNames := anObject
]

{ #category : #accessing }
GtPharoDummyClass >> realClass [
	^ realClass
]

{ #category : #accessing }
GtPharoDummyClass >> realClass: anObject [
	realClass := anObject
]

{ #category : #removing }
GtPharoDummyClass >> removeFromSystem [
	realClass
		ifNil: [ ^ self ].

	realClass removeFromSystem.
	realClass := nil
]
