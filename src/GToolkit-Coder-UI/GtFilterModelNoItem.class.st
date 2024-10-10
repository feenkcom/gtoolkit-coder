Class {
	#name : #GtFilterModelNoItem,
	#superclass : #GtFilterModelItem,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #accessing }
GtFilterModelNoItem >> ifSome: aBlock ifNone: aNoneBlock [
	^ aNoneBlock value
]

{ #category : #accessing }
GtFilterModelNoItem >> label [
	^ 'none'
]
