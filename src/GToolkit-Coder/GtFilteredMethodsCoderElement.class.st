Class {
	#name : #GtFilteredMethodsCoderElement,
	#superclass : #GtMethodsCoderElement,
	#category : #'GToolkit-Coder-UI'
}

{ #category : #ui }
GtFilteredMethodsCoderElement >> buildElement [ 
	| index |
	super buildElement.
	index := self childIndexOf: listElement.
	self addChild: self filterElement at: index
]

{ #category : #ui }
GtFilteredMethodsCoderElement >> filterElement [
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

{ #category : #'private - callbacks' }
GtFilteredMethodsCoderElement >> updateFilter: aString [
	methodsCoder implementorsFilterString: aString
]
