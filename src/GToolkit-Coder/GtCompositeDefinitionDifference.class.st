Class {
	#name : #GtCompositeDefinitionDifference,
	#superclass : #GtCodeDefinitionDifference,
	#instVars : [
		'differences'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
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
