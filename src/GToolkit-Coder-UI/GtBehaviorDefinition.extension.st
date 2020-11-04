Extension { #name : #GtBehaviorDefinition }

{ #category : #'*GToolkit-Coder-UI' }
GtBehaviorDefinition >> nameEditor [
	<return: #GtCodeDefinitionViewer>
	
	^ GtCodeDefinitionSingleEditor new
		definition: self;
		title: 'Name';
		getSelector: #name;
		setSelector: #name:;
		renameEvent: GtBehaviorRenamed;
		completion: [ GtClassesCompletionStrategy new ];
		containerName: self class behaviorNameEditorName
]
