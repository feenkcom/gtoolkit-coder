Class {
	#name : #GtFilterModelComputingItem,
	#superclass : #GtFilterModelItem,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #accessing }
GtFilterModelComputingItem >> ifSome: aBlock ifNone: aNoneBlock [
	^ aNoneBlock value
]

{ #category : #testing }
GtFilterModelComputingItem >> isVirtualFilterModelItem [
	^ true
]

{ #category : #accessing }
GtFilterModelComputingItem >> label [
	^ 'computing...'
]
