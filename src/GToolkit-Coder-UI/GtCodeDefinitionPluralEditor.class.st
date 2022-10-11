Class {
	#name : #GtCodeDefinitionPluralEditor,
	#superclass : #GtCodeDefinitionPluralViewer,
	#instVars : [
		'addSelector',
		'renameSelector',
		'removeSelector',
		'contextMenuBlock',
		'renameRefactoringBlock'
	],
	#category : #'GToolkit-Coder-UI-Behaviour - Editor / Reader'
}

{ #category : #accessing }
GtCodeDefinitionPluralEditor >> addSelector: aSelector [
	addSelector := aSelector
]

{ #category : #'api - instantiation' }
GtCodeDefinitionPluralEditor >> addTag: aNewTag [
	^ aNewTag name
		ifNotEmpty: [ :name | self definition perform: addSelector withEnoughArguments: {name} ]
]

{ #category : #'api - instantiation' }
GtCodeDefinitionPluralEditor >> buildRenamePreviewFrom: aTag to: aNewName [
	| oldName |
	oldName := aTag name.
	^ GtRefactoringsPreviewButton new
		margin: (BlInsets
				top: 5
				left: -3
				bottom: 0
				right: 5);
		refactorings: [ {renameRefactoringBlock value: oldName value: aNewName} ]
]

{ #category : #accessing }
GtCodeDefinitionPluralEditor >> contextMenuBlock: aBinaryBlock [
	"Block accepts a label definition and editor and returns a GtCoderContextMenuContent"

	contextMenuBlock := aBinaryBlock
]

{ #category : #'api - instantiation' }
GtCodeDefinitionPluralEditor >> create [
	<return: #Object>
	| anOwner theInitialNames aTagger |
	anOwner := self owner.

	theInitialNames := self definition
			perform: getSelector
			withEnoughArguments: {anOwner}.

	aTagger := BrTagger new
			aptitude: (BrGlamorousTaggerEditableAptitude new
					margin: self margin;
					tagLabel: [ :aTaggerTag | self createElementForTag: aTaggerTag ];
					in: [ :aLook | separatorStencil ifNotNil: [ aLook separator: separatorStencil ] ];
					yourself);
			namedTags: theInitialNames;
			when: BrTaggerAddTagRequest do: [ :aRequest | self addTag: aRequest tag ];
			when: BrTaggerRemoveTagRequest
				do: [ :aRequest | self removeTag: aRequest tag ];
			when: BrTaggerRenameTagRequest
				do: [ :aRequest | 
					self
						renameTag: aRequest tag
						to: aRequest newName
						from: aRequest source.
					aRequest currentTarget renameTag: aRequest tag to: aRequest newName ].

	self containerName
		ifNotNil: [ :aContainerName | aTagger containerName: aContainerName ].

	self definition
		when: addAnnouncement
		do: [ :anEvent | 
			(anOwner isNil or: [ anEvent owner = anOwner ])
				ifTrue: [ aTagger addTagNamed: anEvent name ] ].
	self definition
		when: removeAnnouncement
		do: [ :anEvent | 
			(anOwner isNil or: [ anEvent owner = anOwner ])
				ifTrue: [ aTagger removeTagNamed: anEvent name ] ].
	self definition
		when: renameAnnouncement
		do: [ :anEvent | 
			(anOwner isNil or: [ anEvent owner = anOwner ])
				ifTrue: [ aTagger renameTagNamed: anEvent oldName to: anEvent newName ] ].

	^ aTagger
]

{ #category : #'api - instantiation' }
GtCodeDefinitionPluralEditor >> createElementForTag: aTaggerTag [
	| eachLabelDefinition anEditableLabel |
	eachLabelDefinition := aTaggerTag
			ifNotNil: [ modelSelector
					ifNotNil: [ :aSelector | 
						aTaggerTag name
							ifEmpty: [ nil ]
							ifNotEmpty: [ :aTagName | self definition perform: aSelector withEnoughArguments: {aTaggerTag name} ] ] ].
	anEditableLabel := BrEditableLabel new
			text: aTaggerTag name;
			styler: styler;
			inputFilter: inputFilter;
			aptitude: lookStencil create
					+ (BrGlamorousWithContextMenuAptitude
							content: (contextMenuBlock value: eachLabelDefinition value: self));
			yourself.

	interactions
		do: [ :eachAssociation | 
			anEditableLabel
				whenKey: eachAssociation key
				labelDo: [ :aShortcutEvent :aShortcut | 
					aShortcutEvent consumed: true.
					eachLabelDefinition
						ifNotNil: [ eachAssociation value cull: aShortcutEvent cull: eachLabelDefinition ] ] ].
	eventHandlers
		do: [ :eachAssociation | 
			anEditableLabel
				when: eachAssociation key
				do: [ :anEvent | 
					anEvent currentTarget isReadOnly
						ifTrue: [ eachLabelDefinition
								ifNotNil: [ eachAssociation value cull: anEvent cull: eachLabelDefinition ] ] ] ].
	completionStencil
		ifNotNil: [ :aStencil | (GtCompletionController on: anEditableLabel strategy: aStencil create) install ].

	^ anEditableLabel
]

{ #category : #'api - instantiation' }
GtCodeDefinitionPluralEditor >> initialize [
	super initialize.
	contextMenuBlock := [ :def :edit | [ GtCoderContextMenuContent new editorElement: edit ] ].
	self
		whenKey: BlKeyCombination primaryR
		do: [ :anEvent :aDefinition | anEvent target switchToEditor ]
]

{ #category : #accessing }
GtCodeDefinitionPluralEditor >> removeSelector: aSelector [
	removeSelector := aSelector
]

{ #category : #'api - instantiation' }
GtCodeDefinitionPluralEditor >> removeTag: aTag [
	^ self definition perform: removeSelector withEnoughArguments: {aTag name}
]

{ #category : #accessing }
GtCodeDefinitionPluralEditor >> renameRefactoringBlock: aBlock [
	"This block should return a refactoring that will rename all references from the old name to the old name.
	It is evaluated when renaming existing variables in the class"
	
	renameRefactoringBlock := aBlock
]

{ #category : #accessing }
GtCodeDefinitionPluralEditor >> renameSelector: aSelector [
	renameSelector := aSelector
]

{ #category : #'api - instantiation' }
GtCodeDefinitionPluralEditor >> renameTag: aTag to: aNewName from: aTaggerAptitude [
	| newName aPreviewButton |
	newName := aNewName trimmed.
	newName = aTag name ifTrue: [ ^ self ].
	newName
		ifEmpty: [ self removeTag: aTag name.
			^ self ].
	renameRefactoringBlock notNil
		ifTrue: [ aPreviewButton := self buildRenamePreviewFrom: aTag to: newName.
			aTaggerAptitude
				tagElementFor: aTag
				ifFound: [ :elem | elem parent addChild: aPreviewButton after: elem ] ]
		ifFalse: [ self definition
				perform: renameSelector
				withEnoughArguments: {aTag name.
						newName} ]
]

{ #category : #accessing }
GtCodeDefinitionPluralEditor >> textualCoderViewModel [
	"Hack to use context menus"
	^self
]
