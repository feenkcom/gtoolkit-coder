Class {
	#name : #GtPharoTraitUsage,
	#superclass : #GtPharoAssociation,
	#instVars : [
		'trait',
		'baseBehavior'
	],
	#category : #'GToolkit-Coder-Support-Pharo'
}

{ #category : #accessing }
GtPharoTraitUsage >> baseBehavior [
	^ baseBehavior
]

{ #category : #accessing }
GtPharoTraitUsage >> baseBehavior: aBehavior [
	baseBehavior := aBehavior
]

{ #category : #'instance creation' }
GtPharoTraitUsage >> from [
	^ self baseBehavior
]

{ #category : #'instance creation' }
GtPharoTraitUsage >> to [
	^ self usedTrait
]

{ #category : #accessing }
GtPharoTraitUsage >> usedTrait [
	^ trait
]

{ #category : #accessing }
GtPharoTraitUsage >> usedTrait: aTrait [
	trait := aTrait
]
