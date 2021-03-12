Class {
	#name : #GtPharoClassExtension,
	#superclass : #GtPharoAssociation,
	#instVars : [
		'extendedClass',
		'extendingMethod'
	],
	#category : #'GToolkit-Coder-Support-Pharo'
}

{ #category : #accessing }
GtPharoClassExtension >> extendedClass [
	^ self extendingMethod methodClass
]

{ #category : #accessing }
GtPharoClassExtension >> extendingMethod [
	^ extendingMethod
]

{ #category : #accessing }
GtPharoClassExtension >> extendingMethod: anObject [
	extendingMethod := anObject
]

{ #category : #'instance creation' }
GtPharoClassExtension >> from [
	^ self extendingMethod 
]

{ #category : #'instance creation' }
GtPharoClassExtension >> to [
	^ self extendedClass  
]
