Class {
	#name : #GtFilterModelTestCaseResultStateItem,
	#superclass : #GtFilterModelItem,
	#instVars : [
		'resultState'
	],
	#category : 'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #accessing }
GtFilterModelTestCaseResultStateItem >> icon [
	^ BlElement new
		background: self resultState color;
		border: self resultState border;
		size: 8 @ 8
]

{ #category : #accessing }
GtFilterModelTestCaseResultStateItem >> itemValue [
	^ self resultState
]

{ #category : #accessing }
GtFilterModelTestCaseResultStateItem >> label [
	^ self resultState label
]

{ #category : #printing }
GtFilterModelTestCaseResultStateItem >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		print: (self resultState ifNotNil: #label);
		nextPut: $)
]

{ #category : #accessing }
GtFilterModelTestCaseResultStateItem >> resultState [
	^ resultState
]

{ #category : #accessing }
GtFilterModelTestCaseResultStateItem >> resultState: anObject [
	resultState := anObject
]
