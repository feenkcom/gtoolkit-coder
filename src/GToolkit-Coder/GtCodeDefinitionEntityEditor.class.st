Class {
	#name : #GtCodeDefinitionEntityEditor,
	#superclass : #GtCodeDefinitionEditor,
	#instVars : [
		'definition',
		'owner',
		'styler',
		'inputFilter',
		'completionStencil',
		'modelSelector'
	],
	#category : #'GToolkit-Coder-Behavior - Editors'
}

{ #category : #accessing }
GtCodeDefinitionEntityEditor >> completion: aStencil [
	completionStencil := aStencil asStencil
]

{ #category : #accessing }
GtCodeDefinitionEntityEditor >> definition [
	^ definition
]

{ #category : #accessing }
GtCodeDefinitionEntityEditor >> definition: anObject [
	definition := anObject
]

{ #category : #initialization }
GtCodeDefinitionEntityEditor >> initialize [
	super initialize.

	inputFilter := BrTextEditorNoInputFilter new.
	styler := BlTextNullStyler new.
	
	"no completion by default"
	completionStencil := nil.

	"no owner by default"
	owner := nil.
	
	"no model by default"
	modelSelector := nil
]

{ #category : #accessing }
GtCodeDefinitionEntityEditor >> modelSelector [
	^ modelSelector
]

{ #category : #accessing }
GtCodeDefinitionEntityEditor >> modelSelector: anObject [
	modelSelector := anObject
]

{ #category : #accessing }
GtCodeDefinitionEntityEditor >> owner [
	^ owner
]

{ #category : #accessing }
GtCodeDefinitionEntityEditor >> owner: anObject [
	owner := anObject
]
