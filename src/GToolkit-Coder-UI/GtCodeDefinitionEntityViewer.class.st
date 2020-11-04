Class {
	#name : #GtCodeDefinitionEntityViewer,
	#superclass : #GtCodeDefinitionViewer,
	#instVars : [
		'definition',
		'owner',
		'styler',
		'inputFilter',
		'completionStencil',
		'modelSelector',
		'interactions',
		'eventHandlers',
		'containerName'
	],
	#category : #'GToolkit-Coder-UI-Behaviour - Editor / Reader'
}

{ #category : #accessing }
GtCodeDefinitionEntityViewer >> completion: aStencil [
	completionStencil := aStencil asStencil
]

{ #category : #accessing }
GtCodeDefinitionEntityViewer >> containerName [
	^ containerName
]

{ #category : #accessing }
GtCodeDefinitionEntityViewer >> containerName: anObject [
	containerName := anObject
]

{ #category : #accessing }
GtCodeDefinitionEntityViewer >> definition [
	^ definition
]

{ #category : #accessing }
GtCodeDefinitionEntityViewer >> definition: anObject [
	definition := anObject
]

{ #category : #initialization }
GtCodeDefinitionEntityViewer >> initialize [
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
GtCodeDefinitionEntityViewer >> modelSelector [
	^ modelSelector
]

{ #category : #accessing }
GtCodeDefinitionEntityViewer >> modelSelector: anObject [
	modelSelector := anObject
]

{ #category : #accessing }
GtCodeDefinitionEntityViewer >> owner [
	^ owner
]

{ #category : #accessing }
GtCodeDefinitionEntityViewer >> owner: anObject [
	owner := anObject
]

{ #category : #interactions }
GtCodeDefinitionEntityViewer >> when: aBlEvent do: aBlock [
	"aBlock is in form [ :anEvent :aCodeDefinition ]"
	
	eventHandlers add: (aBlEvent -> aBlock)
]

{ #category : #interactions }
GtCodeDefinitionEntityViewer >> whenClickDo: aBlock [
	"I do not react to primary+click"
	"aBlock is in form [ :anEvent :aCodeDefinition ]"
	
	self
		when: BlClickEvent
		do: [ :anEvent :aDefinition |
			anEvent modifiers isPrimaryModifier 
				ifFalse: [
					anEvent consumed: true.
					aBlock cull: anEvent cull: aDefinition ] ]
]

{ #category : #interactions }
GtCodeDefinitionEntityViewer >> whenKey: aBlKeyCombination do: aBlock [
	"aBlock is in form [ :anEvent :aCodeDefinition ]"
	
	interactions add: (aBlKeyCombination -> aBlock)
]

{ #category : #interactions }
GtCodeDefinitionEntityViewer >> whenPrimaryClickDo: aBlock [
	"aBlock is in form [ :anEvent :aCodeDefinition ]"
	
	self
		when: BlClickEvent
		do: [ :anEvent :aDefinition |
				anEvent modifiers isPrimaryModifier 
					ifTrue: [
						anEvent consumed: true.
						aBlock cull: anEvent cull: aDefinition ] ]
]
