Class {
	#name : #GtCoderEvaluatedCodeIntervalFinder,
	#superclass : #Object,
	#instVars : [
		'debugSession',
		'context',
		'sourceString',
		'evaluatedCode'
	],
	#category : #'GToolkit-Coder-UI-Coders - Evaluation'
}

{ #category : #accessing }
GtCoderEvaluatedCodeIntervalFinder >> context [
	<return: #Context>
	^ context
]

{ #category : #accessing }
GtCoderEvaluatedCodeIntervalFinder >> context: aContext [
	context := aContext
]

{ #category : #accessing }
GtCoderEvaluatedCodeIntervalFinder >> debugSession [
	<return: #DebugSession>
	^ debugSession
]

{ #category : #accessing }
GtCoderEvaluatedCodeIntervalFinder >> debugSession: anObject [
	debugSession := anObject
]

{ #category : #accessing }
GtCoderEvaluatedCodeIntervalFinder >> evaluatedCode [
	<return: #TGtSourceCoderEvaluatedCode>
	^ evaluatedCode
]

{ #category : #accessing }
GtCoderEvaluatedCodeIntervalFinder >> evaluatedCode: anObject [
	evaluatedCode := anObject
]

{ #category : #finding }
GtCoderEvaluatedCodeIntervalFinder >> find [
	"Return an interval that corresponds to a given evaluated code."

	<return: #Interval or: nil>
	debugSession ifNil: [ ^ nil ].
	debugSession process ifNil: [ ^ nil ].
	context ifNil: [ ^ nil ].
	context isDead ifTrue: [ ^ nil ].

	^ self
		forPharo11OrNewer: [ self debugSession pcRangeForContext: context ]
		forPharo10: [ evaluatedCode ifNil: [ ^ nil ].
			sourceString ifNil: [ ^ nil ].
			self evaluatedCode
				findSourceIntervalForContext: context
				sourceString: sourceString ]
]

{ #category : #accessing }
GtCoderEvaluatedCodeIntervalFinder >> sourceString [
	<return: #String>
	^ sourceString
]

{ #category : #accessing }
GtCoderEvaluatedCodeIntervalFinder >> sourceString: anObject [
	sourceString := anObject
]
