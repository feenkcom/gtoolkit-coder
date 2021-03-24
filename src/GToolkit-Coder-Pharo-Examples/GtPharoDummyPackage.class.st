Class {
	#name : #GtPharoDummyPackage,
	#superclass : #GtPharoDummy,
	#instVars : [
		'packageName',
		'realPackage',
		'dummyClasses'
	],
	#category : #'GToolkit-Coder-Pharo-Examples-Dummies'
}

{ #category : #'api - methods' }
GtPharoDummyPackage >> anyDummyKeywordMethod [
	<return: #GtPharoDummyMethod>

	^ self dummyClasses anyOne anyDummyKeywordMethod
]

{ #category : #'api - methods' }
GtPharoDummyPackage >> anyDummyUnaryClassMethod [
	<return: #GtPharoDummyMethod>

	^ self dummyClasses anyOne anyDummyUnaryClassMethod
]

{ #category : #'api - methods' }
GtPharoDummyPackage >> anyDummyUnaryMethod [
	<return: #GtPharoDummyMethod>

	^ self dummyClasses anyOne anyDummyUnaryMethod
]

{ #category : #accessing }
GtPharoDummyPackage >> dummyClasses [
	^ dummyClasses
]

{ #category : #accessing }
GtPharoDummyPackage >> dummyClasses: aCollectionOfDummyClasses [
	dummyClasses addAll: aCollectionOfDummyClasses.
	aCollectionOfDummyClasses do: [ :eachDummyClass | eachDummyClass dummyPackage: self ]
]

{ #category : #'gt-extensions' }
GtPharoDummyPackage >> gtClassesFor: aView [
	<gtView>

	^ aView list
		title: 'Classes';
		priority: 7;
		items: [ self dummyClasses ];
		itemText: #className
]

{ #category : #'gt-extensions' }
GtPharoDummyPackage >> gtCoderFor: aView [
	<gtView>
	| aRealPackage |

	(aRealPackage := realPackage) ifNil: [ ^ aView empty ].

	^ aView explicit
		title: 'Coder';
		priority: 5;
		stencil: [ GtCoder forPackage: aRealPackage ]
]

{ #category : #initialization }
GtPharoDummyPackage >> initialize [
	super initialize.
	
	dummyClasses := OrderedCollection new
]

{ #category : #accessing }
GtPharoDummyPackage >> packageName [
	^ packageName
]

{ #category : #accessing }
GtPharoDummyPackage >> packageName: anObject [
	packageName := anObject
]

{ #category : #accessing }
GtPharoDummyPackage >> realPackage [
	^ realPackage
]

{ #category : #accessing }
GtPharoDummyPackage >> realPackage: anObject [
	realPackage := anObject
]

{ #category : #removing }
GtPharoDummyPackage >> removeFromSystem [
	realPackage
		ifNil: [ ^ self ].
		
	dummyClasses do: [ :eachClass | eachClass removeFromSystem ].
	realPackage removeFromSystem.
	realPackage := nil
]
