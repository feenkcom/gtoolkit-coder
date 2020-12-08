Class {
	#name : #GtPackageTagCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'packageTagCoder'
	],
	#category : #'GToolkit-Coder-UI-Basic'
}

{ #category : #'build ui' }
GtPackageTagCoderElement >> buildContentPane [
	self removeChildren.
	self addChild: self buildPackageTagLabel.
	self addChild: self buildParentLink.
	self addChild: self buildContentTabs
]

{ #category : #'build ui' }
GtPackageTagCoderElement >> buildContentTabs [
	<return: #BrTabGroup>
	| contentTabs |
	contentTabs := GtPhlowCompositeView new
		views: self packageTagViewItems;
		asElementDo: [ :aBrTabGroup | aBrTabGroup ].
	^ contentTabs
]

{ #category : #'build ui' }
GtPackageTagCoderElement >> buildPackageTagLabel [
	| tagNameEditor container previewButton unloadButton |
		
	container := BrHorizontalPane new
		hMatchParent;
		alignCenterLeft;
		vFitContent.
	
	tagNameEditor := BrEditableLabel new
		look: (BrGlamorousEditableLabelLook new
			defaultBackground: Color transparent;
			glamorousCodeFont;
			bold;
			fontSize: 18);
		inputFilter: BrTextEditorAlphaNumericInputFilter new;
		text: packageTagCoder packageTag name;
		margin: (BlInsets all: 0).

	previewButton := GtRefactoringsPreviewButton new
		margin: (BlInsets left: 5);
		visibility: BlVisibility gone;
		refactorings: [ { RBRenamePackageTagRefactoring packageName: packageTagCoder package name from: packageTagCoder packageTag name to: tagNameEditor text asString } ];
		when: GtRefactoringsAppliedEvent do: [ :anEvent | anEvent currentTarget visibility: BlVisibility hidden ].
		
	tagNameEditor editor
		when: BrTextEditorModifiedEvent 
		do: [ :anEvent |
			anEvent text asString = packageTagCoder packageTag name
				ifTrue: [ previewButton visibility: BlVisibility gone ]
				ifFalse: [  previewButton visibility: BlVisibility visible ] ].

	unloadButton := GtPreviewChangeButton new
		icon: BrGlamorousVectorIcons remove;
		label: 'Unload';
		changeAction: [ self unloadPackageTag ];
		changeStencil: [ self buildRemovePackageTagLabel ].

	container addChild: tagNameEditor.
	container addChild: previewButton.
	container addChild: unloadButton.

	^ container
]

{ #category : #'build ui' }
GtPackageTagCoderElement >> buildParentLink [
	| element |
	element := BlElement new.
	element layout: BlLinearLayout new beHorizontal.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element
		addChild:
			(BrLabel new
				margin: (BlInsets left: 4);
				beSmallSize;
				look:
					(BrGlamorousLabelLook new glamorousRegularFont
						foreground: BrGlamorousColors defaultButtonTextColor);
				text: 'In: ').
	element
		addChild:
			(BrButton new
				look:
					(BrGlamorousButtonExteriorLook new borderPaint: Color transparent)
						+ BrGlamorousLabelLook new glamorousRegularFont;
				label: packageTagCoder package name;
				fitContent;
				beSmallSize;
				action: [ | anEvent |
					anEvent := GtCoderToReplace new
						coder: packageTagCoder packageCoder.
					self fireEvent: anEvent.
					anEvent isConsumed
						ifFalse: [ self phlow spawnObject: anEvent coder ] ]).
	^ element
]

{ #category : #'build ui' }
GtPackageTagCoderElement >> buildRemovePackageTagLabel [
	| labelText count |
	count := packageTagCoder packageTag classes size.
	labelText := 'Remove package tag <1s> and <2p> class<3?:es>'
		expandMacrosWithArguments:
			{packageTagCoder packageTag name.
			count.
			(count = 1)}.
	^ BrLabel new
		margin: (BlInsets all: 10);
		look: BrGlamorousLabelLook new glamorousRegularFont;
		text: labelText asRopedText
]

{ #category : #initialization }
GtPackageTagCoderElement >> initialize [
	super initialize.
	self padding: (BlInsets top: 5 left: 6 bottom: 5 right: 6).
	self layout: BlLinearLayout vertical.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ]
]

{ #category : #accessing }
GtPackageTagCoderElement >> packageTagCoder [
	^ packageTagCoder
]

{ #category : #accessing }
GtPackageTagCoderElement >> packageTagCoder: anObject [
	packageTagCoder := anObject.
	self buildContentPane
]

{ #category : #'build ui' }
GtPackageTagCoderElement >> packageTagViewItems [
	| collector context |
	collector := GtPhlowViewsCollector new.
	collector fromObject: self packageTagCoder packageTag.
	collector pragmaName: #gtPackageTagView.
	context := GtPhlowContext new.
	context packageTagCoder: self packageTagCoder.
	collector context: context.
	^ collector collect
]

{ #category : #actions }
GtPackageTagCoderElement >> unloadPackageTag [
	| event |
	packageTagCoder unload.
	event := GtCoderToReplace new coder: (GtPackageCoder forPackage: packageTagCoder package).
	self fireEvent: event
]
