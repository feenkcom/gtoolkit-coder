Class {
	#name : #GtFilterExampleErrorState,
	#superclass : #GtFilterExampleState,
	#category : 'GToolkit-Coder-Filters - Support'
}

{ #category : #'api - accessing' }
GtFilterExampleErrorState >> color [
	^ BrGlamorousColors errorBackgroundColor
]

{ #category : #'api - testing' }
GtFilterExampleErrorState >> includesCoder: aCoder [
	^ aCoder canExecuteExample and: [ 
		aCoder exampleResult isNotNil and: [ 
			aCoder exampleResult isError ] ]
]

{ #category : #'api - testing' }
GtFilterExampleErrorState >> isStatusFor: aGtExampleWithResult [
	^ aGtExampleWithResult isNotNil and: [ 
			aGtExampleWithResult hasResult and: [ 
				aGtExampleWithResult isError ] ]
]

{ #category : #'api - accessing' }
GtFilterExampleErrorState >> label [
	^ 'Error'
]

{ #category : #'api - accessing' }
GtFilterExampleErrorState >> numberOfExamplesFor: anExampler [
	^ anExampler numberOfErrorExamples
]

{ #category : #'api - accessing' }
GtFilterExampleErrorState >> order [
	^ 4
]
