Class {
	#name : #GtCodeDefinitionViewer,
	#superclass : #BrStencil,
	#instVars : [
		'title',
		'margin',
		'lookStencil'
	],
	#category : #'GToolkit-Coder-UI-Behaviour - Editor / Reader'
}

{ #category : #accessing }
GtCodeDefinitionViewer >> aptitude: aStencil [
	lookStencil := aStencil asStencil
]

{ #category : #'private - instance creation' }
GtCodeDefinitionViewer >> buildSectionLabel: aSectionName [
	
	^ BrLabel new
		aptitude: (BrGlamorousLabelAptitude new glamorousRegularFontAndSize foreground: Color gray; fontSize: 12);
		text: aSectionName, ':';
		margin: (BlInsets top: 5 right: 5);
		focusability: BlFocusability none;
		constraintsDo: [ :c | c grid horizontal alignLeft ]
]

{ #category : #initialization }
GtCodeDefinitionViewer >> initialize [
	super initialize.
	
	margin := BlInsets top: 3 left: 0 bottom: 3 right: 5.
	lookStencil := [ BrGlamorousEditableLabelAptitude new
		glamorousCodeFont;
		defaultForeground: Color black;
		fontSize: 10 ] asStencil.
]

{ #category : #accessing }
GtCodeDefinitionViewer >> margin [
	^ margin
]

{ #category : #accessing }
GtCodeDefinitionViewer >> margin: anObject [
	margin := anObject
]

{ #category : #printing }
GtCodeDefinitionViewer >> printOn: aStream [
	aStream print: self title
]

{ #category : #accessing }
GtCodeDefinitionViewer >> title [
	^ title
]

{ #category : #accessing }
GtCodeDefinitionViewer >> title: anObject [
	title := anObject
]
