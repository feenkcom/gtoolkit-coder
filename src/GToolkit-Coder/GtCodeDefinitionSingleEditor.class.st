Class {
	#name : #GtCodeDefinitionSingleEditor,
	#superclass : #GtCodeDefinitionEntityEditor,
	#instVars : [
		'getSelector'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #'api - instantiation' }
GtCodeDefinitionSingleEditor >> create [
	<return: #Object>
	| aDefinition theInitialName anEditor |
	
	aDefinition := self definition.
	theInitialName := aDefinition perform: getSelector withArguments: {}.

	anEditor := BrEditableLabel new
		look: lookStencil create;
		margin: self margin;
		text: theInitialName";
		whenKey: BlKeyCombination primaryB
			labelDo: [ :anEditor :anEvent | anEvent currentTarget phlow
				spawnObject: headerModel packageName asPackage ]".

	completionStencil ifNotNil: [ :aStencil |
		(GtCompletionController
			on: anEditor
			strategy: aStencil create) install ].
		
	^ anEditor
]

{ #category : #accessing }
GtCodeDefinitionSingleEditor >> getSelector [
	^ getSelector
]

{ #category : #accessing }
GtCodeDefinitionSingleEditor >> getSelector: anObject [
	getSelector := anObject
]
