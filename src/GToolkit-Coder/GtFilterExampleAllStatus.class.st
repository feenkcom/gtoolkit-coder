Class {
	#name : #GtFilterExampleAllStatus,
	#superclass : #GtFilterExampleStatus,
	#category : #'GToolkit-Coder-Filters - Support'
}

{ #category : #'api - testing' }
GtFilterExampleAllStatus >> includesCoder: aCoder [
	^ aCoder example isNotNil
]

{ #category : #'api - accessing' }
GtFilterExampleAllStatus >> label [
	^ 'All'
]

{ #category : #'api - accessing' }
GtFilterExampleAllStatus >> order [
	^ 1
]
