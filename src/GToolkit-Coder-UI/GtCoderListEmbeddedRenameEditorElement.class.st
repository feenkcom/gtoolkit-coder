Class {
	#name : #GtCoderListEmbeddedRenameEditorElement,
	#superclass : #BrHorizontalPane,
	#instVars : [
		'itemToRename',
		'ghostText',
		'editorElement',
		'renameAction',
		'endRenameAction'
	],
	#category : 'GToolkit-Coder-UI-Navigation - Helpers'
}

{ #category : #initialization }
GtCoderListEmbeddedRenameEditorElement >> createAcceptButton [
	^ BrButton new
		beTinySize;
		margin: (BlInsets left: 5 right: 2);
		aptitude: (BrGlamorousButtonRectangularAptitude paddingScale: 0.5)
				+ BrGlamorousButtonIconAptitude
				+ (BrGlamorousButtonFlatExteriorAptitude new
						backgroundPaint: BrGlamorousColors neutralBackgroundColor;
						hoveredBackgroundPaint: BrGlamorousColors secondaryHeaderBackgroundColor)
				+ BrGlamorousButtonWithLabelTooltipAptitude2;
		icon: BrGlamorousVectorIcons accept;
		label: 'Rename protocol';
		action: [ self privatePerformRename ]
]

{ #category : #initialization }
GtCoderListEmbeddedRenameEditorElement >> createCancelButton [
	^ BrButton new
		beTinySize;
		margin: (BlInsets left: 2 right: 2);
		aptitude: (BrGlamorousButtonRectangularAptitude paddingScale: 0.5)
				+ BrGlamorousButtonIconAptitude
				+ (BrGlamorousButtonFlatExteriorAptitude new
						backgroundPaint: BrGlamorousColors neutralBackgroundColor;
						hoveredBackgroundPaint: BrGlamorousColors secondaryHeaderBackgroundColor)
				+ BrGlamorousButtonWithLabelTooltipAptitude2;
		icon: BrGlamorousVectorIcons cancel;
		label: 'Cancel';
		action: [ self privateEndRename ]
]

{ #category : #'private - actions' }
GtCoderListEmbeddedRenameEditorElement >> createCompleterStrategy [
	^ self subclassResponsibility
]

{ #category : #initialization }
GtCoderListEmbeddedRenameEditorElement >> createEditorElement [
	| aEditorElement aCompleter |

	aEditorElement := BrEditor new
			aptitude: BrGlamorousRegularEditorAptitude new glamorousRegularSmallSize
					+ BrGlamorousInputFieldSpacingAptitude;
			beMode: BrTextEditorEditableSingleLineMode new;
			geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
			padding: (BlInsets
					top: 2
					left: 5
					bottom: 2
					right: 5);
			hMatchParent;
			vFitContent;
			text: '';
			requestFocus.

	aCompleter := GtCompletionController
			on: aEditorElement
			strategy: self createCompleterStrategy.

	aCompleter install.

	aEditorElement
		addEditorShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination escape;
				action: [ :anEvent | self privateEndRename ]).

	aEditorElement
		addEditorShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination enter;
				action: [ :anEvent | self privatePerformRename ]).

	^ aEditorElement
]

{ #category : #initialization }
GtCoderListEmbeddedRenameEditorElement >> createGhostTestAttribute [
	^ BrGhostTextAttribute
		for: (ghostText asRopedText glamorousFormEditorCodeFontAndSize
				foreground: Color lightGray)
]

{ #category : #accessing }
GtCoderListEmbeddedRenameEditorElement >> endRenameAction: aBlock [
	endRenameAction := aBlock
]

{ #category : #initialization }
GtCoderListEmbeddedRenameEditorElement >> initialize [
	| anAcceptButton aCancelButton |
	super initialize.
	
	self alignCenterLeft;
		hMatchParent;
		vFitContent.

	ghostText := 'new name'.
	renameAction := [ :anItemToRename :aNewName | ].
	endRenameAction := [ :anItemToRename | ].

	editorElement := self createEditorElement.
	anAcceptButton := self createAcceptButton.
	aCancelButton := self createCancelButton.

	self addChildren: { editorElement . anAcceptButton . aCancelButton }.
]

{ #category : #'private - actions' }
GtCoderListEmbeddedRenameEditorElement >> itemLabelOf: anItemToRename [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtCoderListEmbeddedRenameEditorElement >> itemToRename: anItemToRename [
	| anItemText |

	itemToRename := anItemToRename.
	anItemText := (self itemLabelOf: itemToRename) asRopedText attribute: self createGhostTestAttribute.
	
	editorElement text: anItemText.
	editorElement navigator moveToEnd apply.
	editorElement selecter all select.
]

{ #category : #'private - actions' }
GtCoderListEmbeddedRenameEditorElement >> privateEndRename [
	endRenameAction cull: itemToRename
]

{ #category : #'private - actions' }
GtCoderListEmbeddedRenameEditorElement >> privatePerformRename [
	"Performs a rename protocol action and updates UI removing a protocol editor"
	| aNewName |

	aNewName := editorElement text asString trimmed.

	renameAction cull: itemToRename cull: aNewName.

	self privateEndRename
]

{ #category : #accessing }
GtCoderListEmbeddedRenameEditorElement >> renameAction: aBlock [
	renameAction := aBlock
]
