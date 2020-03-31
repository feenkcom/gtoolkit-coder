Class {
	#name : #GtCodeDefinitionSingleEditor,
	#superclass : #GtCodeDefinitionEntityEditor,
	#instVars : [
		'getSelector',
		'setSelector'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #private }
GtCodeDefinitionSingleEditor >> addErrorOverlayTo: aTagElement [
	| anOverlay anAnimation |

	anOverlay := (BlOverlayElement on: aTagElement)
		geometry: aTagElement geometry copy;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].
	
	anAnimation := BlColorTransition new
		from: (BrGlamorousColors errorBackgroundColor alpha: 0.5);
		to: Color transparent;
		onStepDo: [ :eachColor | anOverlay background: eachColor ];
		onFinishedDo: [ anOverlay removeFromParent ].
	anOverlay addAnimation:  anAnimation.
	aTagElement hasParent
		ifTrue: [ aTagElement parent addChild: anOverlay ]
]

{ #category : #'api - instantiation' }
GtCodeDefinitionSingleEditor >> create [
	<return: #Object>
	| aDefinition theInitialName anEditor |
	
	aDefinition := self definition.
	theInitialName := aDefinition perform: getSelector withArguments: {}.

	anEditor := BrEditableLabel new
		look: lookStencil create;
		margin: self margin;
		text: theInitialName;
		when: BrEditorAcceptWish do: [ :aWish |			
			self
				requestRename: aDefinition
				to: aWish text asString
				from: aWish currentTarget ].
		
		";
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

{ #category : #private }
GtCodeDefinitionSingleEditor >> handleRenameError: anError to: aNewName from: aTagElement [
	anError description traceCr.

	aTagElement switchToEditor.	

	"revert text back to the new name"
	aTagElement text: aNewName.
	aTagElement selecter
		all;
		select.
	
	self addErrorOverlayTo: aTagElement
]

{ #category : #private }
GtCodeDefinitionSingleEditor >> requestRename: aDefinition to: aNewName from: aTagElement [
	setSelector
		ifNil: [ ^ self ].

	[
		| theInitialName |
		theInitialName := aDefinition perform: getSelector withArguments: {}.
		aTagElement text: theInitialName.
		
		aDefinition perform: setSelector withEnoughArguments: { aNewName }.
		
		aTagElement text: aNewName.
	]
		on: Error
		do: [ :anError |
			self
				handleRenameError: anError
				to: aNewName
				from: aTagElement ]
]

{ #category : #accessing }
GtCodeDefinitionSingleEditor >> setSelector [
	^ setSelector
]

{ #category : #accessing }
GtCodeDefinitionSingleEditor >> setSelector: anObject [
	setSelector := anObject
]
