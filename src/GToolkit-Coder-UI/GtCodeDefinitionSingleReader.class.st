Class {
	#name : #GtCodeDefinitionSingleReader,
	#superclass : #GtCodeDefinitionSingleViewer,
	#category : #'GToolkit-Coder-UI-Behaviour - Editor / Reader'
}

{ #category : #'api - instantiation' }
GtCodeDefinitionSingleReader >> create [
	<return: #Object>
	| aDefinition theInitialName aLabel anOwner |
	
	aDefinition := self definition.
	anOwner := self owner.
	theInitialName := aDefinition perform: getSelector withArguments: {}.

	aLabel := BrEditor new
		beReadOnlyWithoutSelection;
		fitContent;
		look: lookStencil create;
		margin: self margin;
		focusability: BlFocusability none;
		text: theInitialName.

	self containerName
		ifNotNil: [ :aContainerName | aLabel containerName: aContainerName ].

	interactions do: [ :eachAssociation |
		aLabel addEditorShortcut: (BlShortcutWithAction new
			combination: eachAssociation key;
			action: [ :aShortcutEvent |
				aShortcutEvent consumed: true.
				eachAssociation value cull: aShortcutEvent cull: aDefinition ]) ].
		
	eventHandlers do: [ :eachAssociation |
		aLabel
			when: eachAssociation key
			do: [ :anEvent | eachAssociation value cull: anEvent cull: aDefinition ] ].

	renameAnnouncement
		ifNotNil: [
			aDefinition
				when: renameAnnouncement
				do: [ :anEvent |
					(anOwner isNil or: [ anEvent owner = anOwner ])
						ifTrue: [ aLabel text: anEvent newName ] ] ].

	^ aLabel
]
