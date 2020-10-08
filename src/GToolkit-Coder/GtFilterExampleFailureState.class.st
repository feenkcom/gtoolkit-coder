Class {
	#name : #GtFilterExampleFailureState,
	#superclass : #GtFilterExampleState,
	#category : #'GToolkit-Coder-Filters - Support'
}

{ #category : #'api - accessing' }
GtFilterExampleFailureState >> color [
	^ BrGlamorousColors failureBackgroundColor
]

{ #category : #'api - testing' }
GtFilterExampleFailureState >> includesCoder: aCoder [
	^ aCoder canExecuteExample and: [ 
		aCoder exampleResult isNotNil and: [ 
			aCoder exampleResult isFailure ] ]
]

{ #category : #'api - testing' }
GtFilterExampleFailureState >> isStatusFor: aGtExampleWithResult [
	^ aGtExampleWithResult isNotNil and: [ 
			aGtExampleWithResult hasResult and: [ 
				aGtExampleWithResult isFailure ] ]
]

{ #category : #'api - accessing' }
GtFilterExampleFailureState >> label [
	^ 'Failure'
]

{ #category : #'api - accessing' }
GtFilterExampleFailureState >> numberOfExamplesFor: anExampler [
	^ anExampler numberOfFailureExamples
]

{ #category : #'api - accessing' }
GtFilterExampleFailureState >> order [
	^ 3
]
