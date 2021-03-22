Class {
	#name : #GtSourceCoderEvaluationAllSource,
	#superclass : #GtSourceCoderEvaluationSourceInterval,
	#category : #'GToolkit-Coder-Coders - Evaluation'
}

{ #category : #evaluation }
GtSourceCoderEvaluationAllSource >> computeSourceInterval: aCompleteCoderSourceTextOrString [
	<return: #Interval>

	^ 1 to: aCompleteCoderSourceTextOrString size
]

{ #category : #evaluation }
GtSourceCoderEvaluationAllSource >> computeSourceString: aCompleteCoderSourceTextOrString [
	<return: #String>

	^ aCompleteCoderSourceTextOrString asString
]
