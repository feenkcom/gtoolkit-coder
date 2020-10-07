Class {
	#name : #GtFilterExampleNotExecutedStatus,
	#superclass : #GtFilterExampleStatus,
	#category : #'GToolkit-Coder-Filters - Support'
}

{ #category : #'api - accessing' }
GtFilterExampleNotExecutedStatus >> color [
	^ BrGlamorousColors neutralBackgroundColor
]

{ #category : #'api - testing' }
GtFilterExampleNotExecutedStatus >> includesCoder: aCoder [
	^ aCoder exampleResult isNil
]

{ #category : #'api - accessing' }
GtFilterExampleNotExecutedStatus >> label [
	^ 'Not Executed'
]

{ #category : #'api - accessing' }
GtFilterExampleNotExecutedStatus >> numberOfExamplesFor: anExampler [
	^ anExampler numberOfNotExecutedExamples
]

{ #category : #'api - accessing' }
GtFilterExampleNotExecutedStatus >> order [
	^ 5
]
