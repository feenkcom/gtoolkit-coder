Class {
	#name : #GtImplementorsFilterMethodsCoderLook,
	#superclass : #BrLook,
	#instVars : [
		'methodsCoder'
	],
	#category : #'GToolkit-Coder-Looks'
}

{ #category : #initialization }
GtImplementorsFilterMethodsCoderLook >> filterElement [
	| element editor |
	editor := BrTextEditor new.
	editor
		when: BrTextEditorInsertedEvent do: [ :event | self updateFilter: editor text asString ];
		when: BrTextEditorDeletedEvent do: [ :event | self updateFilter: editor text asString ].
	element := BrEditorElement new.
	element editor: editor.
	element border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1).
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element
		margin:
			(BlInsets
				top: 10
				left: 10
				bottom: 0
				right: 10).
	element padding: (BlInsets all: 3).
	^ element
]

{ #category : #initialization }
GtImplementorsFilterMethodsCoderLook >> initializeLook [
	| methodsList index |
	super initializeLook.
	methodsList := self widget childNamed: #methodsList.
	index := self widget childIndexOf: methodsList.
	self widget addChild: self filterElement at: index
]

{ #category : #accessing }
GtImplementorsFilterMethodsCoderLook >> methodsCoder [
	^ methodsCoder
]

{ #category : #accessing }
GtImplementorsFilterMethodsCoderLook >> methodsCoder: aMethodsCoder [
	methodsCoder := aMethodsCoder
]

{ #category : #private }
GtImplementorsFilterMethodsCoderLook >> updateFilter: aString [
	methodsCoder implementorsFilterString: aString
]
