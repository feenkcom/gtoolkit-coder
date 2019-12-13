Class {
	#name : #GtReorderParametersAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'actionBlock',
		'icon'
	],
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #'instance creation' }
GtReorderParametersAttribute class >> action: aBlock icon: anIcon [
	^ self new
		actionBlock: aBlock;
		icon: anIcon;
		yourself
]

{ #category : #accessing }
GtReorderParametersAttribute >> actionBlock [
	^ actionBlock
]

{ #category : #accessing }
GtReorderParametersAttribute >> actionBlock: aBlock [
	actionBlock := aBlock
]

{ #category : #accessing }
GtReorderParametersAttribute >> affect: aTBrTextEditorTextualPiece in: anEditorElement [
	^ BlElement new
		size: icon extent;
		background: icon;
		addEventHandlerOn: BlClickEvent do: [ :anEvent | actionBlock cull: anEvent ];
		yourself
]

{ #category : #accessing }
GtReorderParametersAttribute >> icon [
	^ icon
]

{ #category : #accessing }
GtReorderParametersAttribute >> icon: anObject [
	icon := anObject
]

{ #category : #'initialize-release' }
GtReorderParametersAttribute >> initialize [
	super initialize.
	self beAppend.
	self beNotOverwritableByStyler
]
