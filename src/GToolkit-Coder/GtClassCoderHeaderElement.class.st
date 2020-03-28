Class {
	#name : #GtClassCoderHeaderElement,
	#superclass : #BrExpander,
	#instVars : [
		'classCoder',
		'expanderElement',
		'headerModel',
		'instVars',
		'classVars',
		'theSuperclass',
		'thePackage',
		'theTag',
		'theClassName',
		'traits'
	],
	#category : #'GToolkit-Coder-Class - UI'
}

{ #category : #'event handling' }
GtClassCoderHeaderElement >> actOnClassChanged: theClass [
	self classCoder navigationModel
		updateSelectionWith: theClass.

	self initializeElements
]

{ #category : #'event handling' }
GtClassCoderHeaderElement >> actOnClassUpdated [
	self initializeElements
]

{ #category : #'event handling' }
GtClassCoderHeaderElement >> actOnPackageChanged: anAnnouncement [
	self classCoder navigationModel updateSelectionWith: anAnnouncement package.
	
	self header: [ BlElement new ].
	self content: [ BlElement new ]
]

{ #category : #'private - class vars' }
GtClassCoderHeaderElement >> buildClassVarsEditor [
	^ BrTagger new
		look: (BrGlamorousTaggerEditableLook new
			margin: self buttonMargin;
			editableLabel: [ BrEditableLabel new look: self editableLabelLook ]);
		namedTags: headerModel classVarNames;
		when: BrTaggerAddTagRequest do: [ :aRequest |
			aRequest tag name
				ifNotEmpty: [ headerModel addClassVarNamed: aRequest tag name ] ];
		when: BrTaggerRemoveTagRequest do: [ :aRequest |
			headerModel removeClassVarNamed: aRequest tag name ];
		when: BrTaggerRenameTagRequest do: [ :aRequest |
			aRequest newName trimmed
				ifEmpty: [ headerModel removeClassVarNamed: aRequest tag name ]
				ifNotEmpty: [ :aNewName | headerModel renameClassVarNamed: aRequest tag name to: aNewName ] ]
]

{ #category : #'private - instance creation' }
GtClassCoderHeaderElement >> buildDefinitionEditor [
	| theClassProperties |
		
	theClassProperties := BlElement new
		layout: (BlGridLayout new columnCount: 2; cellSpacing: 0);
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ].

	theClassProperties addChildren: { 
		self buildSectionLabel: 'Super:'.
		theSuperclass := self buildSuperclassEditor.
		self buildSectionLabel: 'Package:'.
		self buildPackageAndTagEditor.
		self buildSectionLabel: 'Traits:'.
		traits := self buildTraitsEditor.
		self buildSectionLabel: 'Inst. vars:'.
		instVars := self buildInstVarsEditor.
		self buildSectionLabel: 'Class vars:'.
		classVars := self buildClassVarsEditor.
		"self buildSectionLabel: 'Class instance vars:'.
		self buildSuperClassButton."
	}.

	^ theClassProperties
]

{ #category : #'private - instance creation' }
GtClassCoderHeaderElement >> buildDefinitionViewer [
	| theClassProperties |

	theClassProperties := BlElement new
		layout: (BlGridLayout new columnCount: 2; cellSpacing: 5);
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ].

	theClassProperties addChildren: { 
		self buildSectionLabel: 'Super:'.
		self buildSuperclassEditor.
		self buildSectionLabel: 'Package:'.
		self buildPackageAndTagEditor.
	}.
	
	^ theClassProperties
]

{ #category : #'private - inst vars' }
GtClassCoderHeaderElement >> buildInstVarsEditor [
	^ BrTagger new
		look: (BrGlamorousTaggerEditableLook new
			margin: self buttonMargin;
			editableLabel: [ BrEditableLabel new look: self editableLabelLook ]);
		namedTags: headerModel instVarNames;
		when: BrTaggerAddTagRequest do: [ :aRequest |
			aRequest tag name
				ifNotEmpty: [ headerModel addInstVarNamed: aRequest tag name ] ];
		when: BrTaggerRemoveTagRequest do: [ :aRequest |
			headerModel removeInstVarNamed: aRequest tag name ];
		when: BrTaggerRenameTagRequest do: [ :aRequest |
			aRequest newName trimmed
				ifEmpty: [ headerModel removeInstVarNamed: aRequest tag name ]
				ifNotEmpty: [ :aNewName | headerModel renameInstVarNamed: aRequest tag name to: aNewName ] ]
]

{ #category : #'private - package / tag' }
GtClassCoderHeaderElement >> buildPackageAndTagEditor [
	^ BlElement new
		layout: BlFlowLayout horizontal;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		margin: self buttonMargin;
		addChildren: { 
			self buildPackageEditor.
			BrLabel new
				look: (BrGlamorousLabelLook new glamorousCodeFontAndSize foreground: BrGlamorousColors darkBorderColor);
				text: '/';
				margin: (BlInsets left: 4 right: 4);
				constraintsDo: [ :c | c flow vertical alignCenter ].
				
			self buildTagEditor
		}
]

{ #category : #'private - package / tag' }
GtClassCoderHeaderElement >> buildPackageEditor [
	thePackage := BrEditableLabel new
		look: self editableLabelLook;
		text: headerModel packageName;
		whenKey: BlKeyCombination primaryB
			labelDo: [ :anEditor :anEvent | anEvent currentTarget phlow
				spawnObject: headerModel packageName asPackage ].

	(GtCompletionController
		on: thePackage
		strategy: (GtPackagesCompletionStrategy new)) install.

	^ thePackage
]

{ #category : #'private - ui' }
GtClassCoderHeaderElement >> buildSectionLabel: aSectionName [
	
	^ BrLabel new
		look: (BrGlamorousLabelLook new glamorousRegularFontAndSize foreground: Color gray; fontSize: 12);
		text: aSectionName;
		margin: (BlInsets top: 5 right: 2);
		constraintsDo: [ :c | c grid horizontal alignLeft ]
]

{ #category : #'private - superclass' }
GtClassCoderHeaderElement >> buildSuperclassEditor [
	| aSuperclassEditor |
	
	aSuperclassEditor := BrEditableLabel new
		look: self editableLabelLook;
		inputFilter: BrTextEditorAlphaNumericInputFilter new;
		text: (headerModel theSuperclassName);
		margin: self buttonMargin;
		whenKey: BlKeyCombination primaryB
			labelDo: [ :anEditor :anEvent | anEvent currentTarget phlow
				spawnObject: (GtClassCoder forClass: headerModel theSuperclass realClass) ].

	(GtCompletionController
		on: aSuperclassEditor
		strategy: (GtClassesCompletionStrategy forSuperclasses: headerModel theClass)) install.

	^ aSuperclassEditor
]

{ #category : #'private - package / tag' }
GtClassCoderHeaderElement >> buildTagEditor [
	theTag := BrEditableLabel new
		look: self editableLabelLook;
		text: (headerModel tagName);
		whenKey: BlKeyCombination primaryB
			labelDo: [ :anEditor :anEvent | anEvent currentTarget phlow
				spawnObject: (headerModel packageName asPackage classTagNamed: headerModel tagName) ].

	^ theTag
]

{ #category : #'private - traits' }
GtClassCoderHeaderElement >> buildTraitsEditor [
	^ BrTagger new
		look: (BrGlamorousTaggerEditableLook new
			margin: self buttonMargin;
			separator: [
				BrLabel new
					look: (BrGlamorousLabelLook new glamorousCodeFont foreground: BrGlamorousColors darkBorderColor );
					text: '+' ];
			editableLabel: [
				BrEditableLabel new
					look: self editableLabelLook ]);
		namedTags: headerModel traitNames;
		when: BrTaggerAddTagRequest do: [ :aRequest |
			aRequest tag name
				ifNotEmpty: [ headerModel addInstVarNamed: aRequest tag name ] ];
		when: BrTaggerRemoveTagRequest do: [ :aRequest |
			headerModel removeInstVarNamed: aRequest tag name ];
		when: BrTaggerRenameTagRequest do: [ :aRequest |
			aRequest newName trimmed
				ifEmpty: [ headerModel removeInstVarNamed: aRequest tag name ]
				ifNotEmpty: [ :aNewName | headerModel renameInstVarNamed: aRequest tag name to: aNewName ] ]
]

{ #category : #'private - ui' }
GtClassCoderHeaderElement >> buttonMargin [
	^ BlInsets top: 3 left: 0 bottom: 3 right: 5
]

{ #category : #accessing }
GtClassCoderHeaderElement >> classCoder [
	<return: #GtClassCoder>

	^ classCoder
]

{ #category : #accessing }
GtClassCoderHeaderElement >> classCoder: aGtClassCoder [
	classCoder := aGtClassCoder.	
	classCoder
		when: GtCoderClassUpdatedAnnouncement
			do: [ :anAnnouncement | headerModel theClass: anAnnouncement classOrMetaClass ];
		when: GtCoderPackageUpdatedAnnouncement
			do: [ :anAnnouncement | self actOnPackageChanged: anAnnouncement ].
			
	headerModel theClass: classCoder theClass
]

{ #category : #'private - instance creation' }
GtClassCoderHeaderElement >> editableLabelLook [
	^ BrGlamorousEditableLabelLook new
		glamorousCodeFont;
		defaultForeground: Color black;
		fontSize: 10
]

{ #category : #initialization }
GtClassCoderHeaderElement >> initialize [
	super initialize.	
	
	self viewModel add: (headerModel := GtClassCoderHeaderModel new).

	self
		look: GtCoderExpanderWithoutShadowLook;
		hMatchParent;
		vFitContent.

	self
		when: GtClassCoderHeaderClassChanged
		do: [ :anEvent | self actOnClassChanged: anEvent theClass ].
	
	"Instance variables"
	self
		when: GtClassCoderHeaderInstVarAdded
		do: [ :anEvent | self onInstVarAdded: anEvent instanceVariable ].
	self
		when: GtClassCoderHeaderInstVarRemoved
		do: [ :anEvent | self onInstVarRemoved: anEvent instanceVariable ].
	self
		when: GtClassCoderHeaderInstVarRenamed
		do: [ :anEvent | self onInstVarRenamed: anEvent oldName to: anEvent newName ].
	
	"Class variables"	
	self
		when: GtClassCoderHeaderClassVarAdded
		do: [ :anEvent | self onClassVarAdded: anEvent classVariable ].
	self
		when: GtClassCoderHeaderClassVarRemoved
		do: [ :anEvent | self onClassVarRemoved: anEvent classVariable ].
	self
		when: GtClassCoderHeaderClassVarRenamed
		do: [ :anEvent | self onClassVarRenamed: anEvent oldName to: anEvent newName ]
]

{ #category : #'private - ui' }
GtClassCoderHeaderElement >> initializeElements [
	self header: [ self buildDefinitionViewer ].
	self content: [ self buildDefinitionEditor ]
]

{ #category : #'private - class vars' }
GtClassCoderHeaderElement >> onClassVarAdded: aClassVariable [
	classVars ifNotNil: [ :aTagger | aTagger addTagNamed: aClassVariable name ]
]

{ #category : #'private - class vars' }
GtClassCoderHeaderElement >> onClassVarRemoved: aClassVariable [
	classVars ifNotNil: [ :aTagger | aTagger removeTagNamed: aClassVariable name ]
]

{ #category : #'private - class vars' }
GtClassCoderHeaderElement >> onClassVarRenamed: anOldName to: aNewName [
	classVars ifNotNil: [ :aTagger | aTagger renameTagNamed: anOldName to: aNewName ]
]

{ #category : #'private - inst vars' }
GtClassCoderHeaderElement >> onInstVarAdded: anInstanceVariable [
	instVars ifNotNil: [ :aTagger | aTagger addTagNamed: anInstanceVariable name ]
]

{ #category : #'private - inst vars' }
GtClassCoderHeaderElement >> onInstVarRemoved: anInstanceVariable [
	instVars ifNotNil: [ :aTagger | aTagger removeTagNamed: anInstanceVariable name ]
]

{ #category : #'private - inst vars' }
GtClassCoderHeaderElement >> onInstVarRenamed: anOldName to: aNewName [
	instVars ifNotNil: [ :aTagger | aTagger renameTagNamed: anOldName to: aNewName ]
]
