Class {
	#name : #GtPackageCoderElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'packageCoder'
	],
	#category : #'GToolkit-Coder-UI-Coder - Package'
}

{ #category : #'private - ui' }
GtPackageCoderElement >> buildContentPane [
	self addChildren: {
		self buildPackageLabel.
		self buildParentLink.
		self buildContentTabs }
]

{ #category : #'private - ui' }
GtPackageCoderElement >> buildContentTabs [
	<return: #BrTabGroup>
	| contentTabs |
	contentTabs := GtPhlowCompositeView new
		views: self packageViewItems;
		asElementDo: [ :aBrTabGroup | aBrTabGroup ].
	^ contentTabs
]

{ #category : #'private - ui' }
GtPackageCoderElement >> buildPackageLabel [
	| packageNameEditor container previewButton unloadButton |
		
	container := BrHorizontalPane new
		hMatchParent;
		alignCenterLeft;
		vFitContent.
	
	packageNameEditor := BrEditableLabel new
		id: GtPackageCoderPackageNameId;
		look: (BrGlamorousEditableLabelLook new
			defaultBackground: Color transparent;
			glamorousCodeFont;
			bold;
			fontSize: 18);
		text: packageCoder package name;
		margin: (BlInsets all: 0);
		whenKey: BlKeyCombination primaryB
			labelDo: [ :aShortcutEvent| self phlow spawnTool: (GtPackageCoderTool package: self package) ];
		whenKey: BlKeyCombination primaryG
			labelDo: [ :aShortcutEvent | self phlow spawnObject: self package ];
		whenKey: BlKeyCombination primaryR
			labelDo: [ :aShortcutEvent | aShortcutEvent currentTarget switchToEditor ];
		whenKey: BlKeyCombination primaryC
			labelDo: [ :aShortcutEvent | Clipboard clipboardText: self package name asString ].

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

	unloadButton := GtPreviewChangeButton new
		icon: BrGlamorousVectorIcons remove;
		label: 'Unload';
		changeAction: [ self unloadPackage ];
		changeStencil: [ self buildRemovePackageLabel ].

	container addChild: packageNameEditor.
	container addChild: previewButton.
	container addChild: unloadButton.

	^ container
]

{ #category : #'private - ui' }
GtPackageCoderElement >> buildPackageTagsList [
	^ BrSimpleList new
		itemStencil: [ GtPackageTagCardElement new ];
		itemDataBinder: [ :eachTagCard :eachTagCoder | eachTagCard coder: eachTagCoder ];
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
			margin: (BlInsets left: 4);
			beSmallSize;
			look: (BrGlamorousLabelLook new glamorousRegularFont foreground: BrGlamorousColors defaultButtonTextColor);
			text: 'In: ').

	aLinkContainer addChild:
		(BrButton new 
			look: (BrGlamorousButtonExteriorLook new borderPaint: Color transparent)
				+ BrGlamorousLabelLook new glamorousRegularFont;
			label: 'Pharo';
			beSmallSize;
			fitContent;
			action: [
				| aCoderToReplace |
				aCoderToReplace := (GtCoderToReplace new coder: GtPackagesCoder new).
				self fireEvent: aCoderToReplace.
				aCoderToReplace isConsumed
					ifFalse: [ self phlow spawnObject: aCoderToReplace coder ] ]).

	^ aLinkContainer
]

{ #category : #'private - ui' }
GtPackageCoderElement >> buildRemovePackageLabel [
	| labelText classCount extensionCount |

	classCount := packageCoder package definedClasses size.
	extensionCount := packageCoder package extensionMethods size.

	labelText := 'Remove package <1s> with <2p> class<3?:es> and <4p> extension method<5?:s>'
		expandMacrosWithArguments:
			{packageCoder package name.
			classCount.
			(classCount = 1).
			extensionCount.
			(extensionCount = 1)}.

	^ BrLabel new
		margin: (BlInsets all: 10);
		look: BrGlamorousLabelLook new glamorousRegularFont;
		text: labelText asRopedText
]

{ #category : #accessing }
GtPackageCoderElement >> coderUIModel: aGtPackageCoder [
	packageCoder := aGtPackageCoder coder.

	self buildContentPane
]

{ #category : #initialization }
GtPackageCoderElement >> initialize [
	super initialize.

	self padding: (BlInsets top: 5 left: 6 bottom: 5 right: 6).
	self when: BlClickEvent do: [ self requestFocus ].
	self matchParent
]

{ #category : #accessing }
GtPackageCoderElement >> package [
	<return: #RPackage>

	^ self packageCoder package
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

{ #category : #'private - ui' }
GtPackageCoderElement >> packageViewItems [
	| collector context |
	collector := GtPhlowViewsCollector new.
	collector fromObject: self packageCoder package.
	collector pragmaName: #gtPackageView.
	context := GtPhlowContext new.
	context packageCoder: self packageCoder.
	collector context: context.
	^ collector collect
]

{ #category : #actions }
GtPackageCoderElement >> unloadPackage [
	packageCoder unload.

	self fireEvent: (GtCoderToReplace new coder: GtPackagesCoder new)
]
