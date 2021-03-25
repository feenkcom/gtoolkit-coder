Class {
	#name : #GtPharoDummyEnvironment,
	#superclass : #GtPharoDummy,
	#instVars : [
		'dummyPackages'
	],
	#category : #'GToolkit-Coder-Pharo-Examples-Dummies'
}

{ #category : #'api - generation' }
GtPharoDummyEnvironment class >> withPackages: anAmountOfPackages classes: anAmountOfClasses [
	^ GtPharoDummiesGenerator withPackages: anAmountOfPackages classes: anAmountOfClasses
]

{ #category : #'api - methods' }
GtPharoDummyEnvironment >> anyDummyKeywordMethod [
	<return: #GtPharoDummyMethod>

	^ self dummyPackages anyOne anyDummyKeywordMethod
]

{ #category : #'api - methods' }
GtPharoDummyEnvironment >> anyDummyUnaryClassMethod [
	<return: #GtPharoDummyMethod>

	^ self dummyPackages anyOne anyDummyUnaryClassMethod
]

{ #category : #'api - methods' }
GtPharoDummyEnvironment >> anyDummyUnaryMethod [
	<return: #GtPharoDummyMethod>

	^ self dummyPackages anyOne anyDummyUnaryMethod
]

{ #category : #'api - methods' }
GtPharoDummyEnvironment >> anyUnaryMethod [
	<return: #CompiledMethod>

	^ self anyDummyUnaryMethod realMethod
]

{ #category : #accessing }
GtPharoDummyEnvironment >> dummyPackages [
	^ dummyPackages
]

{ #category : #accessing }
GtPharoDummyEnvironment >> dummyPackages: anObject [
	dummyPackages addAll: anObject
]

{ #category : #initialization }
GtPharoDummyEnvironment >> finalize [
	self removeFromSystem
]

{ #category : #accessing }
GtPharoDummyEnvironment >> gtPackagesFor: aView [
	<gtView>

	^ aView list
		title: 'Packages';
		items: [ self dummyPackages ];
		itemText: #packageName
]

{ #category : #initialization }
GtPharoDummyEnvironment >> initialize [
	super initialize.
	
	dummyPackages := OrderedCollection new.
	
	"the copy of myself will be used as a finalization executor"
	self class finalizationRegistry add: self
]

{ #category : #initialization }
GtPharoDummyEnvironment >> removeFromSystem [
	EpMonitor disableDuring: [ self dummyPackages do: [ :each | each removeFromSystem ] ]
]
