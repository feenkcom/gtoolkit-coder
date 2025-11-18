Class {
	#name : #GtCodeDefinitionPluralReader,
	#superclass : #GtCodeDefinitionPluralViewer,
	#category : #'GToolkit-Coder-UI-Behaviour - Editor / Reader'
}

{ #category : #'api - instantiation' }
GtCodeDefinitionPluralReader >> create [
	<return: #Object>
	| aDefinition anOwner theInitialNames aTagger |

	aDefinition := self definition.
	anOwner := self owner.

	theInitialNames := aDefinition perform: getSelector withEnoughArguments: { anOwner }.

	aTagger := BrTagger new
		aptitude: (BrGlamorousTaggerAptitude new
			margin: self margin;
			tagLabel: [ :aTaggerTag |
				| aLabel eachLabelDefinition |

				eachLabelDefinition := aTaggerTag ifNotNil: [
					modelSelector ifNotNil: [ :aSelector | 
						aTaggerTag name
							ifEmpty: [ nil ]
							ifNotEmpty: [ :aTagName | aDefinition perform: aSelector withEnoughArguments: { aTaggerTag name } ] ] ].

				aLabel := BrEditor new
					beReadOnlyWithoutSelection;
					text: aTaggerTag name;
					fitContent;
					styler: styler;
					aptitude: lookStencil create;
					focusability: BlFocusability none;
					yourself.
				
				interactions do: [ :eachAssociation |
					aLabel addEditorShortcut: (BlShortcutWithAction new
						combination: eachAssociation key;
						action: [ :aShortcutEvent |							
							aShortcutEvent consumed: true.
							eachLabelDefinition
								ifNotNil: [ eachAssociation value cull: aShortcutEvent cull: eachLabelDefinition ] ]) ].
					
				eventHandlers do: [ :eachAssociation |
					aLabel
						when: eachAssociation key
						do: [ :anEvent |
							eachLabelDefinition
								ifNotNil: [ eachAssociation value cull: anEvent cull: eachLabelDefinition ] ] ].
				
				aLabel ];
			in: [ :aLook | separatorStencil ifNotNil: [ aLook separator: separatorStencil ] ];
			yourself);
		namedTags: theInitialNames.

	self containerName
		ifNotNil: [ :aContainerName | aTagger containerName: aContainerName ].

	aDefinition
		when: addAnnouncement
		do: [ :anEvent | 
			(anOwner isNil or: [ anEvent owner = anOwner ])
				ifTrue: [ aTagger addTagNamed: anEvent name ] ].
		
	aDefinition
		when: removeAnnouncement
		do: [ :anEvent |
			(anOwner isNil or: [ anEvent owner = anOwner ])
				ifTrue: [ aTagger removeTagNamed: anEvent name ] ].
		
	aDefinition
		when: renameAnnouncement
		do: [ :anEvent |
			(anOwner isNil or: [ anEvent owner = anOwner ])
				ifTrue: [ aTagger renameTagNamed: anEvent oldName to: anEvent newName ] ].
		
	^ aTagger
]
