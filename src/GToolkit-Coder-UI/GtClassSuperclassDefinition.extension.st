Extension { #name : #GtClassSuperclassDefinition }

{ #category : #'*GToolkit-Coder-UI' }
GtClassSuperclassDefinition >> browseFrom: anEvent [
	self class environment
		at: self name
		ifPresent: [ :aClass |
			| aCoderEvent aClassCoder |

			aClassCoder := GtBehaviorCoder forClass: aClass.
			aCoderEvent := GtCoderToSpawn new coder: aClassCoder.
			anEvent currentTarget fireEvent: aCoderEvent.
			aCoderEvent isConsumed
				ifFalse: [ anEvent currentTarget phlow spawnTool: (GtReadyCoderTool coder: aCoderEvent coder) ] ]
]

{ #category : #'*GToolkit-Coder-UI' }
GtClassSuperclassDefinition >> browseReferencesFrom: anEvent [
	self class environment
		at: self name
		ifPresent:
			[ :class | anEvent currentTarget phlow spawnObject: class gtReferences ]
]

{ #category : #'*GToolkit-Coder-UI' }
GtClassSuperclassDefinition >> editors [
	^ { self superclassEditor }
]

{ #category : #'*GToolkit-Coder-UI' }
GtClassSuperclassDefinition >> readers [
	^ { self superclassReader }
]

{ #category : #'*GToolkit-Coder-UI' }
GtClassSuperclassDefinition >> replaceFrom: anEvent [
	self class environment
		at: self name
		ifPresent: [ :aClass |
			| aCoderEvent aClassCoder |
			aClassCoder := GtBehaviorCoder forClass: aClass.
			aCoderEvent := GtCoderToReplace new coder: aClassCoder.
			anEvent currentTarget fireEvent: aCoderEvent.
			aCoderEvent isConsumed ifFalse: [ 
				anEvent currentTarget phlow spawnTool: (GtReadyCoderTool coder: aCoderEvent coder) ] ]
]

{ #category : #'*GToolkit-Coder-UI' }
GtClassSuperclassDefinition >> superclassEditor [
	<return: #GtCodeDefinitionViewer>
	
	^ GtCodeDefinitionSingleEditor new
			definition: self;
			title: 'Superclass';
			getSelector: #name;
			setSelector: #name:;
			renameEvent: GtBehaviorSuperclassRenamed;
			completion: [ GtClassesCompletionStrategy new ];
			whenKey: BlKeyCombination primaryB do: [ :anEvent :aDefinition  | 
				aDefinition browseFrom: anEvent ];
			whenKey: BlKeyCombination primaryN do: [ :anEvent :aDefinition  | 
				aDefinition browseReferencesFrom: anEvent ];
			whenPrimaryClickDo: [ :anEvent :aDefinition | 
				aDefinition browseFrom: anEvent ];
			whenKey: BlKeyCombination primaryC do: [ :anEvent :aDefinition  |
				Clipboard clipboardText: aDefinition name asString ];
		containerName: self class behaviorSuperclassEditorName
]

{ #category : #'*GToolkit-Coder-UI' }
GtClassSuperclassDefinition >> superclassReader [
	<return: #GtCodeDefinitionViewer>
	
	^ GtCodeDefinitionSingleReader new
			definition: self;
			title: 'Superclass';
			getSelector: #name;
			renameEvent: GtBehaviorSuperclassRenamed;
			whenPrimaryClickDo: [ :anEvent :aDefinition  | aDefinition browseFrom: anEvent ];
			whenClickDo: [ :anEvent :aDefinition | aDefinition replaceFrom: anEvent ]
]
