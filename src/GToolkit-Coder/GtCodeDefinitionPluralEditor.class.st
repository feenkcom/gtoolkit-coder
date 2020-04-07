Class {
	#name : #GtCodeDefinitionPluralEditor,
	#superclass : #GtCodeDefinitionEntityEditor,
	#instVars : [
		'separatorStencil',
		'getSelector',
		'addSelector',
		'renameSelector',
		'removeSelector',
		'addAnnouncement',
		'removeAnnouncement',
		'renameAnnouncement'
	],
	#category : #'GToolkit-Coder-Behavior - Editors'
}

{ #category : #accessing }
GtCodeDefinitionPluralEditor >> addEvent: anObject [
	addAnnouncement := anObject
]

{ #category : #accessing }
GtCodeDefinitionPluralEditor >> addSelector [
	^ addSelector
]

{ #category : #accessing }
GtCodeDefinitionPluralEditor >> addSelector: anObject [
	addSelector := anObject
]

{ #category : #'api - instantiation' }
GtCodeDefinitionPluralEditor >> create [
	<return: #Object>
	| aDefinition anOwner theInitialNames addAction removeAction renameAction aTagger |

	aDefinition := self definition.
	anOwner := self owner.
	
	theInitialNames := aDefinition perform: getSelector withEnoughArguments: { anOwner }.

	addAction := [ :aNewTag |
		aNewTag name
			ifNotEmpty: [ aDefinition perform: addSelector withEnoughArguments: { aNewTag name . anOwner } ] ].

	removeAction := [ :aTag | aDefinition perform: removeSelector withEnoughArguments: { aTag name . anOwner } ].
	
	renameAction := [ :aTag :aNewName |
		aNewName trimmed
			ifEmpty: [ removeAction value: aTag name ]
			ifNotEmpty: [ :aTrimmedName |
				aDefinition perform: renameSelector withEnoughArguments: { aTag name . aTrimmedName . anOwner } ] ].

	aTagger := BrTagger new
		look: (BrGlamorousTaggerEditableLook new
			margin: self margin;
			editableLabel: [ :aTaggerTag |
				| anEditableLabel |
				anEditableLabel := BrEditableLabel new
					text: aTaggerTag name;
					styler: styler;
					inputFilter: inputFilter;
					look: lookStencil create;
					yourself.
				
				completionStencil ifNotNil: [ :aStencil |
					(GtCompletionController
						on: anEditableLabel
						strategy: aStencil create) install ].
				
				anEditableLabel ];
			in: [ :aLook | separatorStencil ifNotNil: [ aLook separator: separatorStencil ] ];
			yourself);
		namedTags: theInitialNames;
		when: BrTaggerAddTagRequest do: [ :aRequest | addAction value: aRequest tag ];
		when: BrTaggerRemoveTagRequest do: [ :aRequest | removeAction value: aRequest tag ];
		when: BrTaggerRenameTagRequest do: [ :aRequest | renameAction value: aRequest tag value: aRequest newName ].

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

{ #category : #accessing }
GtCodeDefinitionPluralEditor >> getSelector [
	^ getSelector
]

{ #category : #accessing }
GtCodeDefinitionPluralEditor >> getSelector: anObject [
	getSelector := anObject
]

{ #category : #initialization }
GtCodeDefinitionPluralEditor >> initialize [
	super initialize.
	
	"no separator by default"
	separatorStencil := nil
]

{ #category : #accessing }
GtCodeDefinitionPluralEditor >> removeEvent: anObject [
	removeAnnouncement := anObject
]

{ #category : #accessing }
GtCodeDefinitionPluralEditor >> removeSelector [
	^ removeSelector
]

{ #category : #accessing }
GtCodeDefinitionPluralEditor >> removeSelector: anObject [
	removeSelector := anObject
]

{ #category : #accessing }
GtCodeDefinitionPluralEditor >> renameEvent: anObject [
	renameAnnouncement := anObject
]

{ #category : #accessing }
GtCodeDefinitionPluralEditor >> renameSelector [
	^ renameSelector
]

{ #category : #accessing }
GtCodeDefinitionPluralEditor >> renameSelector: anObject [
	renameSelector := anObject
]

{ #category : #accessing }
GtCodeDefinitionPluralEditor >> separator: aStencil [
	separatorStencil := aStencil asStencil
]
