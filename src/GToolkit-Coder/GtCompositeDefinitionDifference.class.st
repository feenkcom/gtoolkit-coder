Class {
	#name : #GtCompositeDefinitionDifference,
	#superclass : #GtCodeDefinitionDifference,
	#instVars : [
		'differences'
	],
	#category : #'GToolkit-Coder-Behavior - Differences'
}

{ #category : #'instance creation' }
GtCompositeDefinitionDifference class >> withAll: aCollectionOfDifferences [
	^ self new
		addAll: aCollectionOfDifferences;
		yourself
]

{ #category : #accessing }
GtCompositeDefinitionDifference >> add: aDifference [

	aDifference hasDifference
		ifFalse: [ ^ self ].

	differences add: aDifference
]

{ #category : #accessing }
GtCompositeDefinitionDifference >> addAll: aCollectionOfDifferences [
	differences addAll: (aCollectionOfDifferences select: [ :eachDifference | eachDifference hasDifference ])
]

{ #category : #converting }
GtCompositeDefinitionDifference >> asClassRefactorings: aClass [
	^ self differences flatCollect: [ :eachDifference | (eachDifference asClassRefactorings: aClass) asOrderedCollection ]
]

{ #category : #converting }
GtCompositeDefinitionDifference >> asClassRefactorings: aClass in: anRBModel [
	^ self differences flatCollect: [ :eachDifference | (eachDifference asClassRefactorings: aClass in: anRBModel) asOrderedCollection ]
]

{ #category : #accessing }
GtCompositeDefinitionDifference >> differences [
	^ differences
]

{ #category : #'gt-extension' }
GtCompositeDefinitionDifference >> gtDifferencesFor: aView [
	<gtView>
	
	^ aView list
		title: 'Differences';
		priority: 1;
		items: [ self differences ]
]

{ #category : #testing }
GtCompositeDefinitionDifference >> hasDifference [
	<return: #Boolean>
	
	^ self differences isNotEmpty
]

{ #category : #initialization }
GtCompositeDefinitionDifference >> initialize [
	super initialize.
	
	differences := OrderedCollection new
]
