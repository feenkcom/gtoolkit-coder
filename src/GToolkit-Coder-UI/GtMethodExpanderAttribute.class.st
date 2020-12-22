Class {
	#name : #GtMethodExpanderAttribute,
	#superclass : #BrGlamorousTrangleExpanderTextAttribute,
	#instVars : [
		'classOrMetaClass',
		'selector'
	],
	#category : #'GToolkit-Coder-UI-Attributes'
}

{ #category : #'instance creation' }
GtMethodExpanderAttribute class >> forClass: aClass andSelector: aSymbol [
	^ self new
		forClass: aClass andSelector: aSymbol;
		yourself
]

{ #category : #private }
GtMethodExpanderAttribute >> buildMethodCoder [
	| editorElement coder method |
	(method := classOrMetaClass lookupSelector: selector)
		ifNil: [ ^ BlElement new ].
	coder := GtMethodCoder
		forExample: (classOrMetaClass gtExamplesFactory createExample: method).
	coder subscribeToSystem.
	editorElement := coder asElement.
	editorElement border: (BlBorder paint: Color veryLightGray width: 1).
	editorElement
		margin:
			(BlInsets
				top: 3
				right: 10
				bottom: 10
				left: 10).
	^ editorElement
]

{ #category : #accessing }
GtMethodExpanderAttribute >> classOrNonMetaClass [
	^ classOrMetaClass
]

{ #category : #'initialize-release' }
GtMethodExpanderAttribute >> forClass: aClass andSelector: aSymbol [
	classOrMetaClass := aClass.
	selector := aSymbol
]

{ #category : #'initialize-release' }
GtMethodExpanderAttribute >> initialize [
	super initialize.
	self
		attributesCreatingBlock: [ BrTextAdornmentDynamicAttribute new
				beAppend;
				stencil: [ self buildMethodCoder ] ]
]

{ #category : #accessing }
GtMethodExpanderAttribute >> selector [
	^ selector
]
