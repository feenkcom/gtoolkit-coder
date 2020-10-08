Class {
	#name : #GtFilterExampleSuccessState,
	#superclass : #GtFilterExampleState,
	#category : #'GToolkit-Coder-Filters - Support'
}

{ #category : #'api - accessing' }
GtFilterExampleSuccessState >> color [
	^ BrGlamorousColors successBackgroundColor
]

{ #category : #'api - testing' }
GtFilterExampleSuccessState >> includesCoder: aCoder [
	^ aCoder canExecuteExample and: [ 
		aCoder exampleResult isNotNil and: [ 
			aCoder exampleResult isSuccess ] ]
]

{ #category : #'api - testing' }
GtFilterExampleSuccessState >> isStatusFor: aGtExampleWithResult [
	^ aGtExampleWithResult hasResult and: [ 
		aGtExampleWithResult isSuccess ]
]

{ #category : #'api - accessing' }
GtFilterExampleSuccessState >> label [
	^ 'Success'
]

{ #category : #'api - accessing' }
GtFilterExampleSuccessState >> numberOfExamplesFor: anExampler [
	^ anExampler numberOfSuccessExamples
]

{ #category : #'api - accessing' }
GtFilterExampleSuccessState >> order [
	^ 2
]
