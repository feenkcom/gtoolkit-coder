Class {
	#name : #GtSourceCoderEvaluationSourceInterval,
	#superclass : #Object,
	#category : 'GToolkit-Coder-Coders - Evaluation'
}

{ #category : #evaluation }
GtSourceCoderEvaluationSourceInterval >> computeSourceInterval: aCompleteCoderSourceTextOrString [
	<return: #Interval>

	^ self subclassResponsibility
]

{ #category : #evaluation }
GtSourceCoderEvaluationSourceInterval >> computeSourceString: aCompleteCoderSourceTextOrString [
	<return: #String>

	^ self subclassResponsibility
]
