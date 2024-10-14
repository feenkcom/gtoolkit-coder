Class {
	#name : #GtFilterVirtualEmptyModel,
	#superclass : #GtFilterModel,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #testing }
GtFilterVirtualEmptyModel >> isVirtualFilterModel [
	^ true
]

{ #category : #accessing }
GtFilterVirtualEmptyModel >> label [
	^ 'empty'
]
