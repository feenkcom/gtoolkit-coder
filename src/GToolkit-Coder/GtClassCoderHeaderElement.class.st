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

{ #category : #'private - class vars' }
GtClassCoderHeaderElement >> actOnClassVarAdded: aClassVariable [
	classVars ifNotNil: [ :aTagger | aTagger addTagNamed: aClassVariable name ]
]

{ #category : #'private - class vars' }
GtClassCoderHeaderElement >> actOnClassVarRemoved: aClassVariable [
	classVars ifNotNil: [ :aTagger | aTagger removeTagNamed: aClassVariable name ]
]

{ #category : #'private - class vars' }
GtClassCoderHeaderElement >> actOnClassVarRenamed: anOldName to: aNewName [
	classVars ifNotNil: [ :aTagger | aTagger renameTagNamed: anOldName to: aNewName ]
]

{ #category : #'private - inst vars' }
GtClassCoderHeaderElement >> actOnInstVarAdded: anInstanceVariable [
	instVars ifNotNil: [ :aTagger | aTagger addTagNamed: anInstanceVariable name ]
]

{ #category : #'private - inst vars' }
GtClassCoderHeaderElement >> actOnInstVarRemoved: anInstanceVariable [
	instVars ifNotNil: [ :aTagger | aTagger removeTagNamed: anInstanceVariable name ]
]

{ #category : #'private - inst vars' }
GtClassCoderHeaderElement >> actOnInstVarRenamed: anOldName to: aNewName [
	instVars ifNotNil: [ :aTagger | aTagger renameTagNamed: anOldName to: aNewName ]
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
		theSuperclass := self buildSuperClassButton.
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
		self buildSuperClassButton.
		self buildSectionLabel: 'Package:'.
		self buildSuperClassButton.
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
GtClassCoderHeaderElement >> buildSuperClassButton [
	^ BrEditableLabel new
		look: BrGlamorousEditableLabelLook new;
		text: (headerModel theSuperclassName)
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
		do: [ :anEvent | self actOnInstVarAdded: anEvent instanceVariable ].
	self
		when: GtClassCoderHeaderInstVarRemoved
		do: [ :anEvent | self actOnInstVarRemoved: anEvent instanceVariable ].
	self
		when: GtClassCoderHeaderInstVarRenamed
		do: [ :anEvent | self actOnInstVarRenamed: anEvent oldName to: anEvent newName ].
	
	"Class variables"	
	self
		when: GtClassCoderHeaderClassVarAdded
		do: [ :anEvent | self actOnClassVarAdded: anEvent classVariable ].
	self
		when: GtClassCoderHeaderClassVarRemoved
		do: [ :anEvent | self actOnClassVarRemoved: anEvent classVariable ].
	self
		when: GtClassCoderHeaderClassVarRenamed
		do: [ :anEvent | self actOnClassVarRenamed: anEvent oldName to: anEvent newName ]
]

{ #category : #'private - ui' }
GtClassCoderHeaderElement >> initializeElements [
	self header: [ self buildDefinitionViewer ].
	self content: [ self buildDefinitionEditor ]
]
