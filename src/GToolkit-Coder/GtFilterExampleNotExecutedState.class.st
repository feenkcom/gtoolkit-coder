Class {
	#name : #GtFilterExampleNotExecutedState,
	#superclass : #GtFilterExampleState,
	#category : #'GToolkit-Coder-Filters - Support'
}

{ #category : #'api - accessing' }
GtFilterExampleNotExecutedState >> color [
	^ BrGlamorousColors neutralBackgroundColor
]

{ #category : #'api - testing' }
GtFilterExampleNotExecutedState >> includesCoder: aCoder [
	^ aCoder exampleResult isNil
]

{ #category : #'api - testing' }
GtFilterExampleNotExecutedState >> isStatusFor: aGtExampleWithResult [
	^ aGtExampleWithResult hasResult not
]

{ #category : #'api - accessing' }
GtFilterExampleNotExecutedState >> label [
	^ 'Not Executed'
]

{ #category : #'api - accessing' }
GtFilterExampleNotExecutedState >> numberOfExamplesFor: anExampler [
	^ anExampler numberOfNotExecutedExamples
]

{ #category : #'api - accessing' }
GtFilterExampleNotExecutedState >> order [
	^ 5
]
