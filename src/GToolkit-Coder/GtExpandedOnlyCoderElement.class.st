Class {
	#name : #GtExpandedOnlyCoderElement,
	#superclass : #BrVerticalPane,
	#category : #'GToolkit-Coder-UI'
}

{ #category : #adding }
GtExpandedOnlyCoderElement >> addCodersLookTo: anElement coder: aCoderModel [ 
	| aLook |
	aLook := anElement look.
	(aCoderModel coderLook ifNil: [ aCoderModel coders ifNotNil: #coderLook ])
		ifNotNil: [ :f | aLook := aLook ifNil: [ f ] ifNotNil: [ aLook + f ] ].
	aLook notNil
		ifTrue: [ anElement look: aLook ]
]

{ #category : #converting }
GtExpandedOnlyCoderElement >> asVerticallyResizableDo: aBlock [
	^ self
]

{ #category : #'instance creation' }
GtExpandedOnlyCoderElement >> newActionsElement: aCoderModel [
	^ GtCoderActionsElement new
		coder: aCoderModel;
		margin: (BlInsets top: 5);
		yourself
]

{ #category : #'instance creation' }
GtExpandedOnlyCoderElement >> newExpandedElement: aCoderModel [
	^ GtCoderContentElement new
		coder: aCoderModel editorElement: aCoderModel expandedEditorElement;
		in: [ :anElement | self addCodersLookTo: anElement coder: aCoderModel ];
		yourself
]

{ #category : #'focus requesting' }
GtExpandedOnlyCoderElement >> requestFocus [
	^ self
		childNamed: #editor
		ifFound: [ :anEditorElement | anEditorElement requestFocus ]
		ifNone: [ super requestFocus ]
]
