Class {
	#name : #GtFilterModelExampleResultStateItem,
	#superclass : #GtFilterModelItem,
	#instVars : [
		'resultState'
	],
	#category : 'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #accessing }
GtFilterModelExampleResultStateItem >> icon [
	^ BlElement new
		size: 8 @ 8;
		background: self resultState color;
		geometry: BlRectangleGeometry new
]

{ #category : #accessing }
GtFilterModelExampleResultStateItem >> itemValue [
	^ self resultState
]

{ #category : #accessing }
GtFilterModelExampleResultStateItem >> label [
	^ self resultState label
]

{ #category : #printing }
GtFilterModelExampleResultStateItem >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		print: (self resultState ifNotNil: #label);
		nextPut: $)
]

{ #category : #accessing }
GtFilterModelExampleResultStateItem >> resultState [
	^ resultState
]

{ #category : #accessing }
GtFilterModelExampleResultStateItem >> resultState: anObject [
	resultState := anObject
]
