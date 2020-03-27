Class {
	#name : #GtClassCoderHeaderElement,
	#superclass : #BrExpander,
	#instVars : [
		'classCoder',
		'expanderElement',
		'headerModel',
		'instVars',
		'classVars',
		'theSuperclass'
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

{ #category : #'private - ui' }
GtClassCoderHeaderElement >> buildClassName [
	^ BrLabel new
		margin: (BlInsets left: 10);
		look: (BrGlamorousLabelLook new bold glamorousRegularFont fontSize: 20);
		text: classCoder name
]

{ #category : #'private - ui' }
GtClassCoderHeaderElement >> buildClassVarNames [
	| aContainer |
	
	aContainer := BlElement new.
	aContainer layout: BlFlowLayout new.
	aContainer constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].
	
	^ aContainer
]

{ #category : #'private - class vars' }
GtClassCoderHeaderElement >> buildClassVarsEditor [
	^ BrTagger new
		look: BrGlamorousTaggerEditableLook new;
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
	| aContainer theClassProperties |
	
	aContainer := BrVerticalPane new
		hMatchParent;
		vFitContent.
	
	aContainer addChild: (self buildClassName).
	
	theClassProperties := BlElement new
		layout: (BlGridLayout new columnCount: 2; cellSpacing: 5);
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ].

	theClassProperties addChildren: { 
		self buildSectionLabel: 'Super:'.
		theSuperclass := self buildSuperclassEditor.
		"self buildSectionLabel: 'Traits:'.
		self buildSuperClassButton.
		self buildSectionLabel: 'Package:'.
		self buildSuperClassButton."
		self buildSectionLabel: 'Instance vars:'.
		instVars := self buildInstVarsEditor.
		self buildSectionLabel: 'Class vars:'.
		classVars := self buildClassVarsEditor.
		"self buildSectionLabel: 'Class instance vars:'.
		self buildSuperClassButton."
	}.

	aContainer addChild: theClassProperties.

	^ aContainer
]

{ #category : #'private - instance creation' }
GtClassCoderHeaderElement >> buildDefinitionViewer [
	| aContainer theClassProperties |
	
	aContainer := BrVerticalPane new
		hMatchParent;
		vFitContent.
	
	aContainer addChild: (self buildClassName).
	
	theClassProperties := BlElement new
		layout: (BlGridLayout new columnCount: 2; cellSpacing: 5);
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ].

	theClassProperties addChildren: { 
		self buildSectionLabel: 'Super:'.
		self buildSuperclassEditor.
		self buildSectionLabel: 'Package:'.
		self buildSuperclassEditor.
	}.
	
	aContainer addChild: theClassProperties.
	
	^ aContainer
]

{ #category : #'private - ui blocks' }
GtClassCoderHeaderElement >> buildEditableButton [
	^ BrButton new
		look: BrGlamorousButtonWithLabelLook new
]

{ #category : #'private - inst vars' }
GtClassCoderHeaderElement >> buildInstVarsEditor [
	^ BrTagger new
		look: BrGlamorousTaggerEditableLook new;
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

{ #category : #'private - ui blocks' }
GtClassCoderHeaderElement >> buildSectionLabel: aSectionName [
	
	^ BrLabel new
		look: (BrGlamorousLabelLook new glamorousRegularFontAndSize foreground: Color gray);
		text: aSectionName;
		constraintsDo: [ :c | c grid horizontal alignLeft ]
]

{ #category : #'private - superclass' }
GtClassCoderHeaderElement >> buildSuperclassEditor [
	| aSuperclassEditor |
	
	aSuperclassEditor := BrEditableLabel new
		look: BrGlamorousEditableLabelLook new glamorousCodeFontAndSize;
		text: (headerModel theSuperclassName).
	
	(GtCompletionController
		on: aSuperclassEditor
		strategy: (GtCoderClassCompletionStrategy forSuperclasses: headerModel theClass)) install.

	^ aSuperclassEditor
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

{ #category : #initialization }
GtClassCoderHeaderElement >> initialize [
	super initialize.
	
	self viewModel add: (headerModel := GtClassCoderHeaderModel new).

	self
		look: GtCoderExpanderLook new;
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
