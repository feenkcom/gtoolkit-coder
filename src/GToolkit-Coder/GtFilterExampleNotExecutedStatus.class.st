Class {
	#name : #GtFilterExampleNotExecutedStatus,
	#superclass : #GtFilterExampleStatus,
	#category : #'GToolkit-Coder-Filters - Support'
}

{ #category : #'api - testing' }
GtFilterExampleNotExecutedStatus >> includesCoder: aCoder [
	^ aCoder exampleResult isNil
]

{ #category : #'api - accessing' }
GtFilterExampleNotExecutedStatus >> label [
	^ 'Not Executed'
]

{ #category : #'private - accessing' }
GtFilterExampleNotExecutedStatus >> numberOfExamplesFor: anExampler [
	^ anExampler numberOfNotExecutedExamples
]

{ #category : #'api - accessing' }
GtFilterExampleNotExecutedStatus >> order [
	^ 5
]
