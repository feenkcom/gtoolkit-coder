Class {
	#name : #GtBehaviorCoderUIModel,
	#superclass : #GtCoderUIModel,
	#instVars : [
		'definitionCoderUIModel',
		'methodsCoderUIModel'
	],
	#category : #'GToolkit-Coder-UI-Coder - Behavior Model'
}

{ #category : #accessing }
GtBehaviorCoderUIModel >> definitionCoderUIModel [
	^ definitionCoderUIModel ifNil: [ self coder definitionCoder asCoderUIModel ]
]

{ #category : #accessing }
GtBehaviorCoderUIModel >> elementClass [
	^ GtBehaviorCoderElement
]

{ #category : #accessing }
GtBehaviorCoderUIModel >> methodsCoderUIModel [
	^ methodsCoderUIModel ifNil: [ self coder methodsCoder asCoderUIModel ]
]
