Class {
	#name : #GtFilterExampleSuccessStatus,
	#superclass : #GtFilterExampleStatus,
	#category : #'GToolkit-Coder-Filters - Support'
}

{ #category : #'api - testing' }
GtFilterExampleSuccessStatus >> includesCoder: aCoder [
	^ aCoder canExecuteExample and: [ 
		aCoder exampleResult isNotNil and: [ 
			aCoder exampleResult isSuccess ] ]
]

{ #category : #'api - accessing' }
GtFilterExampleSuccessStatus >> label [
	^ 'Success'
]

{ #category : #'api - accessing' }
GtFilterExampleSuccessStatus >> numberOfExamplesFor: anExampler [
	^ anExampler numberOfSuccessExamples
]

{ #category : #'api - accessing' }
GtFilterExampleSuccessStatus >> order [
	^ 2
]
