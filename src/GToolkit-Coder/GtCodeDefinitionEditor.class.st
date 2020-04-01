Class {
	#name : #GtCodeDefinitionEditor,
	#superclass : #BrStencil,
	#instVars : [
		'title',
		'margin',
		'lookStencil'
	],
	#category : #'GToolkit-Coder-Behavior - Editors'
}

{ #category : #'private - instance creation' }
GtCodeDefinitionEditor >> buildSectionLabel: aSectionName [
	
	^ BrLabel new
		look: (BrGlamorousLabelLook new glamorousRegularFontAndSize foreground: Color gray; fontSize: 12);
		text: aSectionName, ':';
		margin: (BlInsets top: 5 right: 5);
		constraintsDo: [ :c | c grid horizontal alignLeft ]
]

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
