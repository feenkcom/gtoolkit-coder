Class {
	#name : #GtCodeDefinitionEntityEditor,
	#superclass : #GtCodeDefinitionEditor,
	#instVars : [
		'definition',
		'owner',
		'styler',
		'inputFilter',
		'completionStencil',
		'modelSelector',
		'interactions',
		'eventHandlers'
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
	interactions := OrderedCollection new.
	eventHandlers := OrderedCollection new.
	
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

{ #category : #interactions }
GtCodeDefinitionEntityEditor >> when: aBlEvent do: aBlock [
	"aBlock is in form [ :anEvent :aCodeDefinition ]"
	
	eventHandlers add: (aBlEvent -> aBlock)
]

{ #category : #interactions }
GtCodeDefinitionEntityEditor >> whenKey: aBlKeyCombination do: aBlock [
	"aBlock is in form [ :anEvent :aCodeDefinition ]"
	
	interactions add: (aBlKeyCombination -> aBlock)
]

{ #category : #interactions }
GtCodeDefinitionEntityEditor >> whenPrimaryClickDo: aBlock [
	"aBlock is in form [ :anEvent :aCodeDefinition ]"
	
	self
		when: BlClickEvent
		do: [ :anEvent :aDefinition |
				anEvent modifiers isPrimaryModifier 
					ifTrue: [
						anEvent consumed: true.
						aBlock cull: anEvent cull: aDefinition ] ]
]
