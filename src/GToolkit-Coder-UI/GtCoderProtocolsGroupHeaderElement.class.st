Class {
	#name : #GtCoderProtocolsGroupHeaderElement,
	#superclass : #BrHorizontalPane,
	#instVars : [
		'targetClass',
		'addProtocolButton',
		'protocolLabel'
	],
	#category : #'GToolkit-Coder-UI-Navigation - Helpers'
}

{ #category : #'as yet unclassified' }
GtCoderProtocolsGroupHeaderElement >> addProtocolFrom: aProtocolEditor [
	self
		addProtocolNamed: aProtocolEditor text asString trimmed
		in: targetClass.

	^ aProtocolEditor fireEvent: BrDropdownHideWish new
]

{ #category : #'as yet unclassified' }
GtCoderProtocolsGroupHeaderElement >> addProtocolNamed: aProtocolName in: aClass [
	| refactoring |
	
	aProtocolName ifEmpty: [ ^ self ].
	aClass ifNil: [ ^ self ].
	
	refactoring := RBAddProtocolChange
		addProtocolNamed: aProtocolName
		in: aClass.
	
	refactoring execute
]

{ #category : #'as yet unclassified' }
GtCoderProtocolsGroupHeaderElement >> createAddProtocolButton [
	| aButtonStencil aPopUp |
	aButtonStencil := [
		BrButton new
			beTinySize;
			aptitude: (BrGlamorousButtonRectangularAptitude paddingScale: 0) + BrGlamorousButtonIconAptitude;
			icon: BrGlamorousVectorIcons add ] asStencil.

	aPopUp := BrGlamorousWithExplicitDropdownAptitude
			handle: aButtonStencil
			content: [ :aButton | self createNewProtocolForm ].

	^ aButtonStencil asElement
		addAptitude: (BrGlamorousButtonFlatExteriorAptitude new
			backgroundPaint: (Color gray alpha: 0.1));
		addAptitude: BrGlamorousButtonWithLabelTooltipAptitude;
		addAptitude: aPopUp;
		label: 'Add new protocol'
]

{ #category : #'as yet unclassified' }
GtCoderProtocolsGroupHeaderElement >> createNewProtocolForm [
	| aContainer aProtocolEditor aDefaultText aProtocolCompleter anAcceptButton |
	aDefaultText := '' asRopedText
			attribute: (BrGhostTextAttribute
					for: ('new protocol name' asRopedText glamorousFormEditorCodeFontAndSize
							foreground: Color lightGray)).

	aContainer := BrHorizontalPane new
			padding: (BlInsets
					top: 6
					right: 2
					bottom: 6
					left: 2);
			cellSpacing: 6;
			alignCenterLeft;
			fitContent.

	aProtocolEditor := BrEditor new
			aptitude: BrGlamorousRegularEditorAptitude new glamorousRegularSmallSize
					+ BrGlamorousInputFieldSpacingAptitude;
			beMode: BrTextEditorEditableSingleLineMode new;
			geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
			vFitContent;
			hFitContent;
			constraintsDo: [ :c | c minWidth: 150 ];
			text: aDefaultText;
			requestFocus.

	aProtocolCompleter := GtCompletionController
			on: aProtocolEditor
			strategy: GtMethodProtocolCompletionStrategy new.

	aProtocolCompleter install.

	aProtocolEditor
		addEditorShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination escape;
				action: [ :anEvent | aProtocolEditor fireEvent: BrDropdownHideWish new ]).

	aProtocolEditor
		addEditorShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination enter;
				action: [ :anEvent | self addProtocolFrom: aProtocolEditor ]).

	aContainer addChild: aProtocolEditor.

	anAcceptButton := BrButton new
			beSmallSize;
			aptitude: (BrGlamorousButtonRectangularAptitude paddingScale: 0.5)
					+ BrGlamorousButtonIconAptitude
					+ (BrGlamorousButtonFlatExteriorAptitude new
							backgroundPaint: (Color gray alpha: 0.1))
					+ BrGlamorousButtonWithLabelTooltipAptitude;
			icon: BrGlamorousVectorIcons accept;
			label: 'Add protocol';
			action: [ self addProtocolFrom: aProtocolEditor ].

	aContainer addChild: anAcceptButton.

	^ aContainer
]

{ #category : #'as yet unclassified' }
GtCoderProtocolsGroupHeaderElement >> initialize [
	super initialize.

	self
		alignCenterLeft;
		hMatchParent;
		vFitContent.

	protocolLabel := BrLabel new
		beSmallSize
		padding: (BlInsets top: 2 bottom: 2);
		aptitude: (BrGlamorousLabelAptitude new foreground: Color gray).

	addProtocolButton := self createAddProtocolButton.
	self addChildren: { protocolLabel . addProtocolButton }
]

{ #category : #'as yet unclassified' }
GtCoderProtocolsGroupHeaderElement >> protocolsGroupName: aGroupName targetClass: aClass [
	protocolLabel text: aGroupName asRopedText.

	targetClass := nil.
	aClass ifNotNil: [
		aGroupName = 'instance side'
			ifTrue:  [ targetClass := aClass instanceSide ].
		aGroupName = 'class side'
			ifTrue:  [ targetClass := aClass classSide ] ].

	targetClass
		ifNil: [ addProtocolButton visibility: BlVisibility gone ]
		ifNotNil: [ addProtocolButton visibility: BlVisibility visible ].
]
