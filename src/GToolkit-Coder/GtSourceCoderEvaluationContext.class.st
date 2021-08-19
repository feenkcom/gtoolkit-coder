Class {
	#name : 'GtSourceCoderEvaluationContext',
	#superclass : 'Object',
	#instVars : [
		'coder',
		'requesterObject',
		'sourceInterval',
		'sourceString',
		'evaluatedInterval',
		'evaluatedSourceString'
	],
	#category : 'GToolkit-Coder-Coders - Evaluation'
}

{ #category : 'api - context' }
GtSourceCoderEvaluationContext >> all [
	sourceInterval := GtSourceCoderEvaluationAllSource new
]

{ #category : 'accessing' }
GtSourceCoderEvaluationContext >> coder [
	<return: #GtSourceCoder>

	^ coder
]

{ #category : 'accessing' }
GtSourceCoderEvaluationContext >> coder: aGtSourceCoder [
	coder := aGtSourceCoder
]

{ #category : 'accessing' }
GtSourceCoderEvaluationContext >> evaluatedInterval [
	^ evaluatedInterval
]

{ #category : 'accessing' }
GtSourceCoderEvaluationContext >> evaluatedInterval: anObject [
	evaluatedInterval := anObject
]

{ #category : 'accessing' }
GtSourceCoderEvaluationContext >> evaluatedSourceString [
	^ evaluatedSourceString
]

{ #category : 'accessing' }
GtSourceCoderEvaluationContext >> evaluatedSourceString: anObject [
	evaluatedSourceString := anObject
]

{ #category : 'api - context' }
GtSourceCoderEvaluationContext >> from: aStartPosition to: aStopPosition [
	sourceInterval := GtSourceCoderEvaluationPartialSource new
		startPosition: aStartPosition;
		stopPosition: aStopPosition;
		yourself
]

{ #category : 'initialization' }
GtSourceCoderEvaluationContext >> initialize [
	super initialize.
	
	sourceInterval := GtSourceCoderEvaluationAllSource new
]

{ #category : 'accessing' }
GtSourceCoderEvaluationContext >> requesterObject [
	^ requesterObject
]

{ #category : 'accessing' }
GtSourceCoderEvaluationContext >> requesterObject: anObject [
	requesterObject := anObject
]

{ #category : 'accessing' }
GtSourceCoderEvaluationContext >> sourceInterval [
	<return: #GtSourceCoderEvaluationSourceInterval>

	^ sourceInterval
]

{ #category : 'accessing' }
GtSourceCoderEvaluationContext >> sourceInterval: aGtSourceCoderEvaluationSourceInterval [
	sourceInterval := aGtSourceCoderEvaluationSourceInterval
]

{ #category : 'accessing' }
GtSourceCoderEvaluationContext >> sourceString [
	^ sourceString
]

{ #category : 'accessing' }
GtSourceCoderEvaluationContext >> sourceString: anObject [
	"Set the complete source string of the coder at the moment of the evaluation"

	sourceString := anObject
]
