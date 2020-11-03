Extension { #name : #GtTraitsDefinition }

{ #category : #'*GToolkit-Coder-UI' }
GtTraitsDefinition >> editors [
	^ { self traitsEditor }
]

{ #category : #'*GToolkit-Coder-UI' }
GtTraitsDefinition >> traitsEditor [
	<return: #GtCodeDefinitionViewer>
	
	^ GtCodeDefinitionPluralEditor new
		definition: self;
		title: 'Traits';
		addSelector: #addTraitNamed:;
		removeSelector: #removeTraitNamed:;
		renameSelector: #renameTraitNamed:to:;
		getSelector: #names;
		modelSelector: #traitNamed:;
		addEvent: GtBehaviorTraitAdded;
		removeEvent: GtBehaviorTraitRemoved;
		renameEvent: GtBehaviorTraitRenamed;
		separator: [
			BrLabel new
				look: (BrGlamorousLabelLook new glamorousCodeFont foreground: BrGlamorousColors darkBorderColor );
				text: '+' ];
		completion: [ GtTraitsCompletionStrategy new ];
		whenKey: BlKeyCombination primaryB do: [ :anEvent :aDefinition  | aDefinition browseFrom: anEvent ];
		whenKey: BlKeyCombination primaryC do: [ :anEvent :aDefinition  |
			Clipboard clipboardText: aDefinition name asString ];
		whenPrimaryClickDo: [ :anEvent :aDefinition | aDefinition browseFrom: anEvent ];
		containerName: self class traitsEditorName
]
