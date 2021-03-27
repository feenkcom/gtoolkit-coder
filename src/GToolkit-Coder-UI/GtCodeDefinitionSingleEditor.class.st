Class {
	#name : #GtCodeDefinitionSingleEditor,
	#superclass : #GtCodeDefinitionSingleViewer,
	#instVars : [
		'setSelector'
	],
	#category : #'GToolkit-Coder-UI-Behaviour - Editor / Reader'
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
	| aDefinition theInitialName anEditableLabel anOwner |
	
	aDefinition := self definition.
	anOwner := self owner.
	theInitialName := aDefinition perform: getSelector withArguments: {}.

	anEditableLabel := BrEditableLabel new
		aptitude: lookStencil create;
		margin: self margin;
		text: theInitialName;
		when: BrEditorAcceptWish do: [ :aWish |			
			self
				requestRename: aDefinition
				to: aWish text asString
				from: aWish currentTarget ].
			
	self containerName
		ifNotNil: [ :aContainerName | anEditableLabel containerName: aContainerName ].

	interactions do: [ :eachAssociation |
		anEditableLabel
			whenKey: eachAssociation key
			labelDo: [ :aShortcutEvent |
				aShortcutEvent consumed: true.
				eachAssociation value cull: aShortcutEvent cull: aDefinition ] ].
		
	eventHandlers do: [ :eachAssociation |
		anEditableLabel
			when: eachAssociation key
			do: [ :aShortcutEvent |
				aShortcutEvent currentTarget isReadOnly
					ifTrue: [
						eachAssociation value cull: aShortcutEvent cull: aDefinition ] ] ].

	completionStencil ifNotNil: [ :aStencil |
		(GtCompletionController
			on: anEditableLabel
			strategy: aStencil create) install ].

	renameAnnouncement
		ifNotNil: [
			aDefinition
				when: renameAnnouncement
				do: [ :anEvent |
					(anOwner isNil or: [ anEvent owner = anOwner ])
						ifTrue: [ anEditableLabel text: anEvent newName ] ] ].

	^ anEditableLabel
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

	[ | theInitialName |
	
		theInitialName := aDefinition perform: getSelector withArguments: {}.
		aTagElement text: theInitialName.
		aDefinition perform: setSelector withEnoughArguments: { aNewName }
	]  on: Error
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
