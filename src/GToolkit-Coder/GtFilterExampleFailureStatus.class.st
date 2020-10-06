Class {
	#name : #GtFilterExampleFailureStatus,
	#superclass : #GtFilterExampleStatus,
	#category : #'GToolkit-Coder-Filters - Support'
}

{ #category : #'api - testing' }
GtFilterExampleFailureStatus >> includesCoder: aCoder [
	^ aCoder canExecuteExample and: [ 
		aCoder exampleResult isNotNil and: [ 
			aCoder exampleResult isFailure ] ]
]

{ #category : #'api - accessing' }
GtFilterExampleFailureStatus >> label [
	^ 'Failure'
]

{ #category : #'api - accessing' }
GtFilterExampleFailureStatus >> numberOfExamplesFor: anExampler [
	^ anExampler numberOfFailureExamples
]

{ #category : #'api - accessing' }
GtFilterExampleFailureStatus >> order [
	^ 3
]
