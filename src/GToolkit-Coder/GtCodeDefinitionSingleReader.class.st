Class {
	#name : #GtCodeDefinitionSingleReader,
	#superclass : #GtCodeDefinitionSingleViewer,
	#category : #'GToolkit-Coder-Behavior - Editors'
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
		text: theInitialName.

	interactions do: [ :eachAssociation |
		aLabel addInteraction: (BrTextEditorInteraction new
			combination: eachAssociation key;
			action: [ :aTextEditor :anEvent |
				anEvent consumed: true.
				eachAssociation value cull: anEvent cull: aDefinition ]) ].
		
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
