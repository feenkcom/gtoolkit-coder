Class {
	#name : #GtVariableInputFilter,
	#superclass : #BrTextEditorInputFilter,
	#category : #'GToolkit-Coder-AddOns-Inline rename'
}

{ #category : #'as yet unclassified' }
GtVariableInputFilter >> filter: aString [
	^ aString select: [ :each | each isAlphaNumeric or: [ each = $_ ] ]
]
