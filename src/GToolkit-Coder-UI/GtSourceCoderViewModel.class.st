Class {
	#name : #GtSourceCoderViewModel,
	#superclass : #GtTextualCoderViewModel,
	#instVars : [
		'evaluationResult'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source Model'
}

{ #category : #'api - actions' }
GtSourceCoderViewModel >> discardChanges [
	self coder discardChanges
]

{ #category : #'api - actions' }
GtSourceCoderViewModel >> doIt: aSourceIntervalOrBlock [
	"Evaluate a piece of source code within an interval and return a result.
	I am also able to evaluate an empty or only consisting of whitespace
	source code in which case the result is nil"
	<return: #Object>
	
	^ self coder doIt: aSourceIntervalOrBlock
]

{ #category : #'api - actions' }
GtSourceCoderViewModel >> doItAll [
	^ self doItAllRequestedBy: self
]

{ #category : #'api - actions' }
GtSourceCoderViewModel >> doItAllRequestedBy: aRequesterObject [
	^ self coder doItAllRequestedBy: aRequesterObject
]

{ #category : #accessing }
GtSourceCoderViewModel >> elementClass [
	^ GtExpandableSourceCoderElement
]

{ #category : #accessing }
GtSourceCoderViewModel >> evaluationResult [
	^ evaluationResult
]

{ #category : #accessing }
GtSourceCoderViewModel >> evaluationResult: anObject [
	evaluationResult := anObject
]
