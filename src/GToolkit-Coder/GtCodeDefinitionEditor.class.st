Class {
	#name : #GtCodeDefinitionEditor,
	#superclass : #BrStencil,
	#instVars : [
		'title',
		'margin',
		'lookStencil'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #initialization }
GtCodeDefinitionEditor >> initialize [
	super initialize.
	
	margin := BlInsets top: 3 left: 0 bottom: 3 right: 5.
	lookStencil := [ BrGlamorousEditableLabelLook new
		glamorousCodeFont;
		defaultForeground: Color black;
		fontSize: 10 ] asStencil.
]

{ #category : #accessing }
GtCodeDefinitionEditor >> look: aStencil [
	lookStencil := aStencil asStencil
]

{ #category : #accessing }
GtCodeDefinitionEditor >> margin [
	^ margin
]

{ #category : #accessing }
GtCodeDefinitionEditor >> margin: anObject [
	margin := anObject
]

{ #category : #printing }
GtCodeDefinitionEditor >> printOn: aStream [
	aStream print: self title
]

{ #category : #accessing }
GtCodeDefinitionEditor >> title [
	^ title
]

{ #category : #accessing }
GtCodeDefinitionEditor >> title: anObject [
	title := anObject
]
