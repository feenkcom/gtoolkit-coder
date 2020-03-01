Class {
	#name : #GtPharoClassReference,
	#superclass : #GtPharoAssociation,
	#instVars : [
		'referencingMethod',
		'referencedClass'
	],
	#category : #'GToolkit-Coder-Pharo'
}

{ #category : #accessing }
GtPharoClassReference >> from [
	^ self referencingMethod 
]

{ #category : #accessing }
GtPharoClassReference >> referencedClass [
	^ referencedClass
]

{ #category : #accessing }
GtPharoClassReference >> referencedClass: anObject [
	referencedClass := anObject
]

{ #category : #accessing }
GtPharoClassReference >> referencingMethod [
	^ referencingMethod
]

{ #category : #accessing }
GtPharoClassReference >> referencingMethod: anObject [
	referencingMethod := anObject
]

{ #category : #accessing }
GtPharoClassReference >> to [
	^ self referencedClass 
]
