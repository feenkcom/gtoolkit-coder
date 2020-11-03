Extension { #name : #GtPoolsDefinition }

{ #category : #'*GToolkit-Coder-UI' }
GtPoolsDefinition >> editors [
	^ { self poolsEditor }
]

{ #category : #'*GToolkit-Coder-UI' }
GtPoolsDefinition >> poolsEditor [
	<return: #GtCodeDefinitionViewer>
	
	^ GtCodeDefinitionPluralEditor new
		definition: self;
		title: 'Pools';
		addSelector: #addPoolNamed:;
		removeSelector: #removePoolNamed:;
		renameSelector: #renamePoolNamed:to:;
		getSelector: #names;
		modelSelector: #poolNamed:;
		addEvent: GtBehaviorPoolAdded;
		removeEvent: GtBehaviorPoolRemoved;
		renameEvent: GtBehaviorPoolRenamed;
		separator: [
			BrLabel new
				look: (BrGlamorousLabelLook new glamorousCodeFont foreground: BrGlamorousColors darkBorderColor );
				text: '+' ];
		completion: [ GtPoolsCompletionStrategy new ];
		whenKey: BlKeyCombination primaryB do: [ :anEvent :aDefinition  | aDefinition browseFrom: anEvent ];
		whenKey: BlKeyCombination primaryC do: [ :anEvent :aDefinition  |
			Clipboard clipboardText: aDefinition name asString ];
		whenPrimaryClickDo: [ :anEvent :aDefinition | aDefinition browseFrom: anEvent ];
		containerName: self class poolsEditorName
]
