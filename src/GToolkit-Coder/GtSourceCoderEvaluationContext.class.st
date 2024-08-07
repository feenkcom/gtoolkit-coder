Class {
	#name : #GtSourceCoderEvaluationContext,
	#superclass : #Object,
	#instVars : [
		'coder',
		'requesterObject',
		'sourceInterval',
		'sourceString',
		'evaluatedInterval',
		'evaluatedSourceString',
		'evaluatedCode',
		'executionStrategy'
	],
	#category : #'GToolkit-Coder-Coders - Evaluation'
}

{ #category : #'api - context' }
GtSourceCoderEvaluationContext >> all [
	sourceInterval := GtSourceCoderEvaluationAllSource new
]

{ #category : #accessing }
GtSourceCoderEvaluationContext >> coder [
	<return: #GtSourceCoder>

	^ coder
]

{ #category : #accessing }
GtSourceCoderEvaluationContext >> coder: aGtSourceCoder [
	coder := aGtSourceCoder
]

{ #category : #'api - context' }
GtSourceCoderEvaluationContext >> evaluatedCode [
	"Return an object, representing the evaluated source string.
	For example in case of Pharo, it is a reference to a compiled method."

	<return: #TGtSourceCoderEvaluatedCode>
	^ evaluatedCode ifNil: [ evaluatedCode := GtSourceCoderNoEvaluatedCode default ]
]

{ #category : #'api - context' }
GtSourceCoderEvaluationContext >> evaluatedCode: aContextReference [
	"Set a {{gtClass:TGtSourceCoderEvaluatedCode}}"

	evaluatedCode := aContextReference
]

{ #category : #accessing }
GtSourceCoderEvaluationContext >> evaluatedInterval [
	^ evaluatedInterval
]

{ #category : #accessing }
GtSourceCoderEvaluationContext >> evaluatedInterval: anObject [
	evaluatedInterval := anObject
]

{ #category : #accessing }
GtSourceCoderEvaluationContext >> evaluatedSourceString [
	^ evaluatedSourceString
]

{ #category : #accessing }
GtSourceCoderEvaluationContext >> evaluatedSourceString: anObject [
	evaluatedSourceString := anObject
]

{ #category : #accessing }
GtSourceCoderEvaluationContext >> executionStrategy [
	^ executionStrategy
]

{ #category : #accessing }
GtSourceCoderEvaluationContext >> executionStrategy: anObject [
	executionStrategy := anObject
]

{ #category : #'api - context' }
GtSourceCoderEvaluationContext >> from: aStartPosition to: aStopPosition [
	sourceInterval := GtSourceCoderEvaluationPartialSource new
		startPosition: aStartPosition;
		stopPosition: aStopPosition;
		yourself
]

{ #category : #initialization }
GtSourceCoderEvaluationContext >> initialize [
	super initialize.
	
	sourceInterval := GtSourceCoderEvaluationAllSource new
]

{ #category : #accessing }
GtSourceCoderEvaluationContext >> requesterObject [
	<return: #TGtCoderRequesterObject>
	^ requesterObject ifNil: [ GtNoCoderRequester uniqueInstance ]
]

{ #category : #accessing }
GtSourceCoderEvaluationContext >> requesterObject: anObject [
	requesterObject := anObject asCoderRequesterObject
]

{ #category : #accessing }
GtSourceCoderEvaluationContext >> sourceInterval [
	<return: #GtSourceCoderEvaluationSourceInterval>

	^ sourceInterval
]

{ #category : #accessing }
GtSourceCoderEvaluationContext >> sourceInterval: aGtSourceCoderEvaluationSourceInterval [
	sourceInterval := aGtSourceCoderEvaluationSourceInterval
]

{ #category : #accessing }
GtSourceCoderEvaluationContext >> sourceString [
	^ sourceString
]

{ #category : #accessing }
GtSourceCoderEvaluationContext >> sourceString: anObject [
	"Set the complete source string of the coder at the moment of the evaluation"

	sourceString := anObject
]

{ #category : #accessing }
GtSourceCoderEvaluationContext >> targetBehavior [
	"Return a target behavior in which the method should be compiled. The target behavior can differ from
	the method's behavior if for example the method originates from the trait"

	<return: #Behavior>
	^ nil
]
