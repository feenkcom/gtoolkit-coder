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
		'instVarC'
	],
	#classVars : [
		'ClassVarA',
		'ClassVarB',
		'ClassVarC'
	],
	#pools : [
		'GtBehaviorCoderDummySharedPool'
	],
	#classInstVars : [
		'hello'
	],
	#category : #'GToolkit-Coder-Examples-Dummies'
}

{ #category : #accessing }
GtBehaviorCoderDummyClass >> computeSurfaceArea [
	"Compute and return a surface area of the rectangle"
	<return: #Number>
	| aRectangle |

	aRectangle := Rectangle origin: 20@30 extent: 40@50.
	^ aRectangle width * aRectangle height
]

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
