Class {
	#name : 'GtHighlightingBindingStrategy',
	#superclass : 'GtBindingStrategy',
	#category : 'GToolkit-VariableBindings-Core'
}

{ #category : 'private' }
GtHighlightingBindingStrategy >> treatBinding: anAssocOrNil of: aSymbol [
	"Subclasses can treat existing or missing bindings of a variable named aSymbol"
	<return: #LiteralVariable or: nil>
	^ anAssocOrNil
]
