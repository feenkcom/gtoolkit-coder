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

{ #category : #'api - accessing' }
GtFilterExampleNotExecutedStatus >> order [
	^ 5
]
