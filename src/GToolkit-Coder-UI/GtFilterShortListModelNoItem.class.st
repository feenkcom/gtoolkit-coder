Class {
	#name : #GtFilterShortListModelNoItem,
	#superclass : #GtFilterShortListModelItem,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #accessing }
GtFilterShortListModelNoItem >> ifSome: aBlock ifNone: aNoneBlock [
	^ aNoneBlock value
]

{ #category : #accessing }
GtFilterShortListModelNoItem >> label [
	^ ''
]
