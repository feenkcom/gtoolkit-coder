"
I am a {{gtClass:GtFilterModelItem}}. 
I am used to indicate that there are no items in a list.
"
Class {
	#name : #GtFilterModelEmptyItem,
	#superclass : #GtFilterModelItem,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #accessing }
GtFilterModelEmptyItem >> ifSome: aBlock ifNone: aNoneBlock [
	^ aNoneBlock value
]

{ #category : #testing }
GtFilterModelEmptyItem >> isVirtualFilterModelItem [
	^ true
]

{ #category : #accessing }
GtFilterModelEmptyItem >> label [
	^ 'empty list'
]
