Extension { #name : #GtPackageDefinition }

{ #category : #'*GToolkit-Coder-UI' }
GtPackageDefinition >> browseFrom: anEvent [
	| aRealPackage aCoderEvent aPackageCoder |

	aRealPackage := RPackageOrganizer default
		packageNamed: self name
		ifAbsent: [ ^ self ].

	aPackageCoder := GtPackageCoder forPackage: aRealPackage.
	aCoderEvent := GtCoderToSpawn new coder: aPackageCoder.
	anEvent currentTarget fireEvent: aCoderEvent.
	aCoderEvent isConsumed
		ifFalse: [ anEvent currentTarget phlow spawnTool: (GtReadyCoderTool coder: aCoderEvent coder) ]
]

{ #category : #'*GToolkit-Coder-UI' }
GtPackageDefinition >> editors [
	^ { self packageEditor }
]

{ #category : #'*GToolkit-Coder-UI' }
GtPackageDefinition >> packageEditor [
	^ GtCodeDefinitionSingleEditor new
		title: 'Package';
		definition: self;
		getSelector: #name;
		setSelector: #name:;
		renameEvent: GtBehaviorPackageRenamed;
		completion: [ GtPackagesCompletionStrategy new ];
		whenKey: BlKeyCombination primaryB do: [ :anEvent :aDefinition  | aDefinition browseFrom: anEvent ];
		whenPrimaryClickDo: [ :anEvent :aDefinition | aDefinition browseFrom: anEvent ];
		whenKey: BlKeyCombination primaryC do: [ :anEvent :aDefinition  |
			Clipboard clipboardText: aDefinition name asString ];
		containerName: self class packageEditorName
]

{ #category : #'*GToolkit-Coder-UI' }
GtPackageDefinition >> packageReader [
	^ GtCodeDefinitionSingleReader new
		title: 'Package';
		definition: self;
		getSelector: #name;
		renameEvent: GtBehaviorPackageRenamed;
		whenClickDo: [ :anEvent :aDefinition | aDefinition replaceFrom: anEvent ];
		whenPrimaryClickDo: [ :anEvent :aDefinition  | aDefinition browseFrom: anEvent ]
]

{ #category : #'*GToolkit-Coder-UI' }
GtPackageDefinition >> readers [
	^ { self packageReader }
]

{ #category : #'*GToolkit-Coder-UI' }
GtPackageDefinition >> replaceFrom: anEvent [
	| aRealPackage aCoderEvent aPackageCoder |

	aRealPackage := RPackageOrganizer default
		packageNamed: self name
		ifAbsent: [ ^ self ].

	aPackageCoder := GtPackageCoder forPackage: aRealPackage.
	aCoderEvent := GtCoderToReplace new coder: aPackageCoder.
	anEvent currentTarget fireEvent: aCoderEvent.
	aCoderEvent isConsumed
		ifFalse: [ anEvent currentTarget phlow spawnTool: (GtReadyCoderTool coder: aCoderEvent coder) ]
]
