Class {
	#name : #GtFilterExampleAllState,
	#superclass : #GtFilterExampleState,
	#category : #'GToolkit-SearchFilters-Support'
}

{ #category : #'api - testing' }
GtFilterExampleAllState >> includesCoder: aCoder [
	^ aCoder example isNotNil
]

{ #category : #'api - testing' }
GtFilterExampleAllState >> isStatusFor: aGtExampleWithResult [
	^ false
]

{ #category : #'api - accessing' }
GtFilterExampleAllState >> label [
	^ 'All'
]

{ #category : #'api - accessing' }
GtFilterExampleAllState >> numberOfExamplesFor: anExampler [
	^ anExampler numberOfAllExamples
]

{ #category : #'api - accessing' }
GtFilterExampleAllState >> order [
	^ 1
]
