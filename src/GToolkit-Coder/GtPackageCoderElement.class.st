Class {
	#name : #GtPackageCoderElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'packageCoder'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #'private - ui' }
GtPackageCoderElement >> buildClassesAndTagsTabs [
	| tabGroup |
	tabGroup := BrTabGroup new.
	tabGroup look: BrGlamorousTabGroupLook new.
	tabGroup constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical matchParent ].
	tabGroup addTab: (BrTab new
			 look: BrGlamorousTabLook new;
			 label: 'Classes';
			 stencil: [ packageCoder classesCoder asElement ]).
	tabGroup addTab: (BrTab new
			 look: BrGlamorousTabLook new;
			 label: 'Tags';
			 stencil: [ self buildPackageTagsList ]).
	^ tabGroup
]

{ #category : #'private - ui' }
GtPackageCoderElement >> buildContentPane [
	self addChildren: {
		self buildPackageLabel.
		self buildParentLink.
		self buildClassesAndTagsTabs }
]

{ #category : #'private - ui' }
GtPackageCoderElement >> buildPackageLabel [
	| packageNameEditor container previewButton unloadButton |
		
	container := BrHorizontalPane new
		hMatchParent;
		alignCenterLeft;
		vFitContent.
	
	packageNameEditor := BrEditableLabel new
		look: (BrGlamorousEditableLabelLook new
			defaultBackground: Color transparent;
			glamorousCodeFont;
			bold;
			fontSize: 18);
		text: packageCoder package name;
		margin: (BlInsets all: 0).

	previewButton := GtRefactoringsPreviewButton new
		margin: (BlInsets left: 5);
		visibility: BlVisibility gone;
		refactorings: [ { RBRenamePackageRefactoring from: packageCoder package name to: packageNameEditor text asString } ];
		when: GtRefactoringsAppliedEvent do: [ :anEvent | anEvent currentTarget visibility: BlVisibility hidden ].
		
	packageNameEditor editor
		when: BrTextEditorModifiedEvent 
		do: [ :anEvent |
			anEvent text asString = packageCoder package name
				ifTrue: [ previewButton visibility: BlVisibility gone ]
				ifFalse: [  previewButton visibility: BlVisibility visible ] ].

	unloadButton := BrButton new
		margin: (BlInsets left: 5);
		icon: BrGlamorousVectorIcons remove;
		beSmall;
		look: BrGlamorousButtonWithIconLook new + (BrGlamorousWithDropdownLook
			handle: [ BrButton new
				icon: BrGlamorousIcons empty;
				beSmall;
				look: BrGlamorousButtonRectangularLook new + BrGlamorousButtonIconLook new ]
			content: [ self buildRemovePackageElement ]);
		label: 'Unload'.

	container addChild: packageNameEditor.
	container addChild: previewButton.
	container addChild: unloadButton.

	^ container
]

{ #category : #'private - ui' }
GtPackageCoderElement >> buildPackageTagsList [
	^ BrSimpleList new
		stencil: [ :eachTag | 
			eachTag asCardElement
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical fitContent ];
				yourself ];
		items: (packageCoder packageTagCoders asSortedCollection: [ :a :b | a name < b name ])
]

{ #category : #'private - ui' }
GtPackageCoderElement >> buildParentLink [
	| aLinkContainer |

	aLinkContainer := BrHorizontalPane new
		hMatchParent;
		vFitContent.

	aLinkContainer addChild:
		(BrLabel new
			margin: (BlInsets left: 10);
			look: BrGlamorousLabelLook new glamorousRegularFont;
			text: 'In: ').

	aLinkContainer addChild:
		(BrButton new 
			look: (BrGlamorousButtonExteriorLook new borderPaint: Color transparent) + BrGlamorousLabelLook new glamorousRegularFont;
			label: 'Pharo';
			action: [
				| aCoderToReplace |
				aCoderToReplace := (GtCoderToReplace new coder: GtPackagesCoder new).
				self fireEvent: aCoderToReplace.
				aCoderToReplace isConsumed
					ifFalse: [ self phlow spawnObject: aCoderToReplace coder ] ]).

	^ aLinkContainer
]

{ #category : #'private - ui' }
GtPackageCoderElement >> buildRemovePackageElement [
	| element label labelText classCount extensionCount unloadButton |
	element := BrVerticalPane new
		hFitContent;
		alignCenterLeft;
		vFitContent.
	classCount := packageCoder package definedClasses size.
	extensionCount := packageCoder package extensionMethods size.
	labelText := 'Remove package <1s> with <2p> class<3?:es> and <4p> extension method<5?:s>'
		expandMacrosWithArguments:
			{packageCoder package name.
			classCount.
			(classCount = 1).
			extensionCount.
			(extensionCount = 1)}.
	label := BrLabel new
		margin: (BlInsets all: 10);
		look: BrGlamorousLabelLook new glamorousRegularFont;
		text: labelText asRopedText.
	element addChild: label.
	unloadButton := BrButton new
		icon: BrGlamorousVectorIcons remove;
		beSmall;
		requestFocus;
		look: BrGlamorousButtonWithIconLook new;
		label: 'Unload';
		margin:
			(BlInsets
				top: 0
				left: 10
				bottom: 10
				right: 0);
		action: [ self unloadPackage ];
		yourself.
	element addChild: unloadButton.
	^ element
]

{ #category : #initialization }
GtPackageCoderElement >> initialize [
	super initialize.
	self padding: (BlInsets top: 5 left: 6 bottom: 5 right: 6).
	self matchParent
]

{ #category : #accessing }
GtPackageCoderElement >> packageCoder [
	<return: #GtPackageCoder>

	^ packageCoder
]

{ #category : #accessing }
GtPackageCoderElement >> packageCoder: aGtPackageCoder [
	packageCoder := aGtPackageCoder.

	self buildContentPane
]

{ #category : #actions }
GtPackageCoderElement >> unloadPackage [
	| event |
	packageCoder unload.
	event := GtCoderToReplace new coder: GtPackagesCoder new.
	self fireEvent: event
]
