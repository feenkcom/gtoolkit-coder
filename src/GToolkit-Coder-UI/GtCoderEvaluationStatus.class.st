"
I represent an evaluation status of a source code.
I am used by {{gtClass:GtSourceCoderViewModel}}. 
I am an abstract class.
See my subclasses for concrete evaluation statuses: {{gtClass:GtCoderEvaluationStatus | expanded=true | show=#gtSubclassesFor:}}
"
Class {
	#name : #GtCoderEvaluationStatus,
	#superclass : #Object,
	#category : #'GToolkit-Coder-UI-Coders - Evaluation'
}

{ #category : #testing }
GtCoderEvaluationStatus class >> isAbstract [
	^ self name = #GtCoderEvaluationStatus
]

{ #category : #testing }
GtCoderEvaluationStatus >> hasSharedDebugSession [
	^ false
]

{ #category : #'api - hooks' }
GtCoderEvaluationStatus >> onSourceCoderElement: anElement [
	
]
