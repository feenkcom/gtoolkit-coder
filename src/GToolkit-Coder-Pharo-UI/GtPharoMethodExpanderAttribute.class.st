Class {
	#name : #GtPharoMethodExpanderAttribute,
	#superclass : #BrGlamorousTrangleExpanderTextAttribute,
	#instVars : [
		'classOrMetaClass',
		'selector'
	],
	#category : #'GToolkit-Coder-Pharo-UI-Attributes'
}

{ #category : #'instance creation' }
GtPharoMethodExpanderAttribute class >> forClass: aClass andSelector: aSymbol [
	^ self new
		forClass: aClass andSelector: aSymbol;
		yourself
]

{ #category : #private }
GtPharoMethodExpanderAttribute >> buildMethodCoder [
	| editorElement coder method |
	(method := classOrMetaClass lookupSelector: selector)
		ifNil: [ ^ BlElement new ].
	coder := GtPharoMethodCoder
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
GtPharoMethodExpanderAttribute >> classOrNonMetaClass [
	^ classOrMetaClass
]

{ #category : #'initialize-release' }
GtPharoMethodExpanderAttribute >> forClass: aClass andSelector: aSymbol [
	classOrMetaClass := aClass.
	selector := aSymbol
]

{ #category : #'initialize-release' }
GtPharoMethodExpanderAttribute >> initialize [
	super initialize.
	self
		attributesCreatingBlock: [ BrTextAdornmentDynamicAttribute new
				beAppend;
				stencil: [ self buildMethodCoder ] ]
]

{ #category : #accessing }
GtPharoMethodExpanderAttribute >> selector [
	^ selector
]
