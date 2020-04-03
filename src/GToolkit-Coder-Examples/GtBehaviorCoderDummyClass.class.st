"
I am a class that is used to show case class coder in examples.

I have a few instance and class variables
"
Class {
	#name : #GtBehaviorCoderDummyClass,
	#superclass : #Object,
	#traits : 'TGtBehaviorCoderDummyTrait',
	#classTraits : 'TGtBehaviorCoderDummyTrait classTrait',
	#instVars : [
		'instVarA',
		'instVarB',
		'instVarC',
		'newSlot'
	],
	#classVars : [
		'classVarA',
		'classVarB',
		'classVarC'
	],
	#category : #'GToolkit-Coder-Examples-Dummies'
}

{ #category : #accessing }
GtBehaviorCoderDummyClass >> instVarA [
	^ instVarA
]

{ #category : #accessing }
GtBehaviorCoderDummyClass >> instVarA: anObject [
	instVarA := anObject
]

{ #category : #accessing }
GtBehaviorCoderDummyClass >> instVarB [
	^ instVarB
]

{ #category : #accessing }
GtBehaviorCoderDummyClass >> instVarB: anObject [
	instVarB := anObject
]

{ #category : #accessing }
GtBehaviorCoderDummyClass >> instVarC [
	^ instVarC
]

{ #category : #accessing }
GtBehaviorCoderDummyClass >> instVarC: anObject [
	instVarC := anObject
]
