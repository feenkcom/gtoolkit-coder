Class {
	#name : #GtFilterTaggerEditableLook,
	#superclass : #BrGlamorousTaggerEditableLook,
	#category : #'GToolkit-Coder-Filters - UI'
}

{ #category : #initialization }
GtFilterTaggerEditableLook >> defaultTagLabelStencil [
	^ [ :aTag | 
	| element |
	element := BrHorizontalPane new.
	element fitContent.
	element addChild: (self dropDownFor: aTag) as: #typeTag.
	element addChild: (self editableLabelFor: aTag) as: #editableLabel ]
		asStencilBuilder: BrTaggerTagStencilBuilder
]

{ #category : #initialization }
GtFilterTaggerEditableLook >> dropDownFor: aTag [
	| button dropDownLook |
	button := BrButton new.
	dropDownLook := BrGlamorousWithDropdownLook
		handle: [ BrButton new
				label: aTag tagType;
				icon: BrGlamorousVectorIcons downwards;
				beSmall;
				look: BrGlamorousButtonWithLabelAndIconLook - BrGlamorousButtonExteriorLook;
				yourself ]
		content: [ BrSimpleList new
				items: self widget viewModel descriptors;
				stencil: [ :each | 
					| element |
					element := BlElement new.
					element
						viewModel:
							(BrInteractiveModel new
								withHover;
								yourself);
						look:
							(BrInteractiveCommonLook new
								default: [ :f | f background: Color transparent ];
								hovered: [ :f | f background: BrGlamorousColors defaultButtonBorderColor ];
								yourself);
						layout: BlLinearLayout horizontal;
						constraintsDo: [ :c | 
							c horizontal matchParent.
							c vertical fitContent ];
						padding: (BlInsets all: 5);
						addEventHandlerOn: BlClickEvent
							do: [ button label: each name.
							dropDownLook hide.
							self update: aTag to: each inPane: button parent.
							(self widget viewModel tags includes: aTag)
								ifTrue: [ self dispatchEvent: (GtTaggerChangeTagType new tag: aTag) ] ];
						addChild:
							(BrLabel new
								look: BrGlamorousLabelLook;
								text: each name;
								yourself).
					element ];
				hFitContent;
				vFitContent ].
	button look: BrGlamorousButtonWithLabelAndIconLook + dropDownLook.
	button label: aTag tagType.
	button icon: BrGlamorousVectorIcons downwards.
	button beSmall.
	^ button
]

{ #category : #initialization }
GtFilterTaggerEditableLook >> editableLabelFor: aTag [
	^ BrEditableLabel new
		look:
			BrGlamorousEditableLabelLook new glamorousRegularFont
				glamorousRegularSmallSize;
		text: aTag name;
		padding: (BlInsets all: 2)
]

{ #category : #hooks }
GtFilterTaggerEditableLook >> focus: anElement [
	^ (anElement
		childNamed: #editableLabel
		ifFound: [ :element | element ]
		ifNone: [ anElement ]) requestFocus
]

{ #category : #hooks }
GtFilterTaggerEditableLook >> focusItemAfter: aTagElement [
	aTagElement
		nextSiblingSuchThat: [ :eachElement | eachElement isFocusable ]
		do: [ :anElement | self focus: anElement ]
]

{ #category : #hooks }
GtFilterTaggerEditableLook >> focusItemBefore: aTagElement [
	aTagElement
		previousSiblingSuchThat: [ :eachElement | eachElement isFocusable ]
		do: [ :anElement | self focus: anElement ]
]

{ #category : #'private - instance creation' }
GtFilterTaggerEditableLook >> newAddTagButton [
	^ BrButton new
		look:
			BrGlamorousButtonRectangularLook new + BrGlamorousButtonIconLook new
				+ BrGlamorousButtonWithLabelTooltipLook new
				+
					(BrInteractiveCommonLook new
						default: [ :aWidget | 
							aWidget
								border: BlBorder empty;
								background: BrGlamorousColors neutralBackgroundColor ];
						hovered:
								[ :aWidget | aWidget background: BrGlamorousColors neutralBackgroundColor darker ];
						pressed: [ :aWidget | 
							aWidget
								background: BrGlamorousColors neutralBackgroundColor darker darker ];
						focused: [ :aWidget | 
							aWidget
								border: (BlBorder paint: BrGlamorousColors focusedEditorBorderColor width: 1) ]);
		icon: BrGlamorousVectorIcons add;
		label: 'Add Filter';
		beSmall;
		hExact: 20;
		margin: margin;
		constraintsDo: [ :c | c flow vertical alignCenter ];
		action: [ :aButton | self addTagCreatorElement ];
		addShortcut:
			(BlShortcut new
				combination: BlKeyCombination arrowLeft;
				action: [ :anEvent | self focusItemBefore: anEvent currentTarget ]);
		addShortcut:
			(BlShortcut new
				combination: BlKeyCombination return;
				action: [ :anEvent | self addTagCreatorElement ])
]

{ #category : #initialization }
GtFilterTaggerEditableLook >> newTagCreatorElement [
	| aNewTagCreator editableLabel tag |
	tag := self widget viewModel createTagNamed: ''.
	aNewTagCreator := (tagLabelStencil tag: tag) asElement.
	aNewTagCreator
		padding: (BlInsets all: 3);
		margin: margin.
	editableLabel := aNewTagCreator childNamed: #editableLabel.
	editableLabel
		constraintsDo: [ :c | c flow vertical alignCenter ];
		requestFocus;
		switchToEditor;
		when: BrEditorAcceptWish
			do: [ :aWish | 
			| newTag |
			newTag := self widget viewModel createTagNamed: aWish text asString.
			newTag tagType: tag tagType.
			self requestAddTag: newTag from: aWish currentTarget parent ];
		when: BrEditorCancelWish
			do: [ :anEvent | 
			self focusItemAfter: anEvent currentTarget.
			self
				removeTagElement: anEvent currentTarget parent
				withSeparatorAt: tagElements size + 1 ].
	editableLabel navigator
		moveTo: 0;
		apply.
	^ aNewTagCreator
]

{ #category : #'private - instance creation' }
GtFilterTaggerEditableLook >> newTagElementFor: aTaggerTag [
	<return: #BlElement>
	| element |
	element := (tagLabelStencil tag: aTaggerTag) asElement margin: margin.
	(element childNamed: #editableLabel)
		when: BrEditorAcceptWish
			do: [ :aWish | 
			self
				requestRenameTag: aTaggerTag
				to: aWish text asString
				from: aWish currentTarget parent ];
		whenKey: BlKeyCombination backspace
			labelDo: [ :aShortcutEvent :aShortcut :aTextEditor | 
			self
				requestRemoveTag: aTaggerTag
				from: aShortcutEvent currentTarget parent ].
	^ element
]

{ #category : #hooks }
GtFilterTaggerEditableLook >> onTagAdded: aTaggerTag at: aTagIndex [
	| aTagElement |

	aTagElement := self newTagElementFor: aTaggerTag.
	self assignTag: aTaggerTag toElement: aTagElement.

	self addTagElement: aTagElement withSeparatorAt: aTagIndex.
	tagElements add: aTagElement beforeIndex: aTagIndex.
	
	shouldGiveFocusToNewTag
		ifTrue: [ self focus: aTagElement ]
]

{ #category : #hooks }
GtFilterTaggerEditableLook >> onTagRemoved: aTaggerTag at: anIndex [
	self
		tagElementFor: aTaggerTag
		ifFound: [ :aTagElement | 
			aTagElement hasFocus
				ifTrue: [ anIndex = 1
						ifTrue: [ self focusItemAfter: aTagElement ]
						ifFalse:
							[ self focusItemBefore: aTagElement ] ].
			tagElements remove: aTagElement.
			self removeTagElement: aTagElement withSeparatorAt: anIndex ]
]

{ #category : #'api - requests' }
GtFilterTaggerEditableLook >> onTagRenamed: aTaggerTag to: aNewName [
	self
		tagElementFor: aTaggerTag
		ifFound: [ :aTagElement | (aTagElement childNamed: #editableLabel) text: aNewName ]
]

{ #category : #hooks }
GtFilterTaggerEditableLook >> onTagsChanged: theTags [
	tags removeChildren: self tagElements.
	tagElements := OrderedCollection new.
	theTags withIndexDo: [ :eachTag :eachIndex | self onTagAdded: eachTag at: eachIndex ]
]

{ #category : #'api - requests' }
GtFilterTaggerEditableLook >> requestRenameTag: aTaggerTag to: aNewName from: aTagElement [	
	[
		(aTagElement childNamed: #editableLabel) text: aTaggerTag name.
		self dispatchEvent: (BrTaggerRenameTagRequest new tag: aTaggerTag; newName: aNewName).
	]
		on: Error
		do: [ :anError |
			self
				handleRenameError: anError
				to: aNewName
				from: (aTagElement childNamed: #editableLabel) ]
]

{ #category : #private }
GtFilterTaggerEditableLook >> update: aTag to: descriptor inPane: aPane [
	aTag tagType: descriptor name.
	aTag name: ''.
	aPane
		childNamed: #editableLabel
		ifFound: [ :label | self updateLabel: label using: descriptor ]
]

{ #category : #private }
GtFilterTaggerEditableLook >> updateLabel: label using: descriptor [
	| completionController |
	label deleter
		from: 0 to: label text size;
		delete.
	(label userData at: #completionController ifAbsent: [ nil ])
		ifNotNil: [ :controller | controller uninstall ].
	completionController := descriptor completion
		ifNil: [ nil ]
		ifNotNil:
			[ :strategy | (GtCompletionController on: label strategy: strategy) install ].
	label userData at: #completionController put: completionController
]
