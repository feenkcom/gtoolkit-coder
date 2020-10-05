Class {
	#name : #GtFilterExampleErrorStatus,
	#superclass : #GtFilterExampleStatus,
	#category : #'GToolkit-Coder-Filters - Support'
}

{ #category : #'api - testing' }
GtFilterExampleErrorStatus >> includesCoder: aCoder [
	^ aCoder canExecuteExample and: [ 
		aCoder exampleResult isNotNil and: [ 
			aCoder exampleResult isError ] ]
]

{ #category : #'api - accessing' }
GtFilterExampleErrorStatus >> label [
	^ 'Error'
]

{ #category : #'api - accessing' }
GtFilterExampleErrorStatus >> order [
	^ 4
]
