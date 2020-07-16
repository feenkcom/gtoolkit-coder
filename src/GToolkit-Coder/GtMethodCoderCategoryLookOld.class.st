Class {
	#name : #GtMethodCoderCategoryLookOld,
	#superclass : #GtSourceCoderLook,
	#category : #'GToolkit-Coder-UI - Source Coder Look'
}

{ #category : #initialization }
GtMethodCoderCategoryLookOld >> addMethodTags [
	self hierarchyDropDown
		ifNil: [
			| editor |
			editor := self buildCategoryEditor.
			self attachToBottomRight: editor.
			self widget addChild: editor as: self categoryEditorName ]
		ifNotNil: [ :dropDown | 
			| tags |
			tags := BrHorizontalPane new.
			tags fitContent.
			tags cellSpacing: 2.
			tags addChild: dropDown as: self hierarchyDropDownName.
			tags addChild: self buildCategoryEditor as: self categoryEditorName.
			self attachToBottomRight: tags.
			self widget addChild: tags as: self tagsName ]
]

{ #category : #initialization }
GtMethodCoderCategoryLookOld >> attachToBottomRight: anElement [
	anElement
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored horizontal alignRight.
			c ignored vertical alignBottom ]
]

{ #category : #initialization }
GtMethodCoderCategoryLookOld >> buildCategoryEditor [
	| editor |
	editor := BrEditableLabel new
		look:
			(BrGlamorousEditableLabelLook new
				glamorousCodeFont;
				defaultForeground: Color black;
				fontSize: 10);
		padding: (BlInsets all: 2);
		margin: (BlInsets all: 0);
		text: (self category ifNil: [ '' ]) asRopedText;
		when: BrEditorAcceptWish
			do:
				[ :aWish | self methodCoder renameProtocol: aWish text asString ].
	(GtCompletionController
		on: editor
		strategy: GtMethodProtocolCompletionStrategy new) install.
	^ editor
]

{ #category : #accessing }
GtMethodCoderCategoryLookOld >> category [
	^ self methodCoder category
]

{ #category : #initialization }
GtMethodCoderCategoryLookOld >> categoryEditorName [
	^ #categoryEditor
]

{ #category : #private }
GtMethodCoderCategoryLookOld >> classOrMetaClass [
	^ self methodCoder classOrMetaClass
]

{ #category : #'private - hierarchy button' }
GtMethodCoderCategoryLookOld >> hierarchyDropDown [
	| look overriding overridden icon |

	overriding := self methodCoder isOverriding.
	overridden := self methodCoder isOverridden.
	(overriding or: [ overridden ])
		ifFalse: [ ^ nil ].

	icon := overriding
		ifTrue: [ overridden
				ifTrue: [ BrGlamorousVectorIcons upwardsDownwards ]
				ifFalse: [ BrGlamorousVectorIcons upwards ] ]
		ifFalse: [ BrGlamorousVectorIcons downwards ].

	^ BrButton new
		label: 'Hierarchy Implementors';
		beTiny;
		look:
			BrGlamorousButtonWithIconLook
				+
					(look := BrGlamorousWithDropdownLook
						stencil: [ | tree dropDownElement |
							tree := self hierarchyTree.
							tree
								when: BrSelectionChanged
								do: [ :event | 
									look hide.
									tree
										selectedNodeDo: [ :node | 
											node value == self methodCoder
												ifFalse: [ | coderEvent classCoder |
													classCoder := GtClassCoder
														forClass: node value classOrMetaClass.
													coderEvent := GtCoderToSpawn new coder: classCoder.
													self widget fireEvent: coderEvent.
													coderEvent isConsumed
														ifFalse: [ self widget phlow
																spawnTool: (GtReadyCoderTool coder: coderEvent coder) ].
													classCoder
														withSelectedMethod: (node value classOrMetaClass methodNamed: node value currentSelector) ] ] ].
							dropDownElement := BlElement new.
							dropDownElement size: 250 @ 140.
							dropDownElement margin: (BlInsets all: 1).
							dropDownElement geometry: (BlRectangle cornerRadius: 4).
							dropDownElement addChild: tree.
							dropDownElement
								addChild:
									(BrResizer new
										target: dropDownElement;
										beTop;
										look: BrGlamorousResizerLook new;
										constraintsDo: [ :c | 
											c ignoreByLayout.
											c ignored horizontal weight: 0.2 ]).
							dropDownElement
								addChild:
									(BrResizer new
										target: dropDownElement;
										beBottom;
										look: BrGlamorousResizerLook new;
										constraintsDo: [ :c | 
											c ignoreByLayout.
											c ignored horizontal weight: 0.2 ]).
							dropDownElement
								addChild:
									(BrResizer new
										target: dropDownElement;
										beLeft;
										look: BrGlamorousResizerLook;
										constraintsDo: [ :c | 
											c ignoreByLayout.
											c ignored vertical weight: 0.2 ]).
							dropDownElement
								addChild:
									(BrResizer new
										target: dropDownElement;
										beRight;
										look: BrGlamorousResizerLook;
										constraintsDo: [ :c | 
											c ignoreByLayout.
											c ignored vertical weight: 0.2 ]).
							BlElement new
								look:
									(BrGlamorousDropdownLook new
										handle:
											(BrButton new
												beTiny;
												look:
													BrGlamorousButtonWithIconLook - BrGlamorousButtonWithLabelTooltipLook
														- BrGlamorousButtonExteriorLook;
												icon: icon;
												yourself);
										content: dropDownElement;
										yourself);
								yourself ]);
		icon: icon;
		yourself
]

{ #category : #initialization }
GtMethodCoderCategoryLookOld >> hierarchyDropDownName [
	^ #hierarchy
]

{ #category : #'private - hierarchy button' }
GtMethodCoderCategoryLookOld >> hierarchyTree [
	| tree |
	tree := BrColumnedTree new.
	tree
		items: {self rootMethodCoder}
		children: [ :each | self methodCoderChildrenOf: each ].
	tree matchParent.
	tree expandAll.
	tree column
		title: 'Method';
		stencil: [ :each | 
			| text |
			text := each value classOrMetaClass name asRopedText.
			text glamorousCodeFont.
			each value == self methodCoder
				ifTrue: [ text bold ].
			BrLabel new
				text: text;
				look: BrGlamorousLabelLook ].
	^ tree
]

{ #category : #initialization }
GtMethodCoderCategoryLookOld >> initialize [
	super initialize.
	self
		addChange:
			(BrLookChange new
				up: [ :e | self addMethodTags ];
				down: [ :e | self removeMethodTags ];
				yourself)
]

{ #category : #accessing }
GtMethodCoderCategoryLookOld >> methodCoder [
	^ self widget coder
]

{ #category : #private }
GtMethodCoderCategoryLookOld >> methodCoderChildrenOf: aMethodCoder [
	^ (aMethodCoder classOrMetaClass
		includesBehavior: self classOrMetaClass)
		ifTrue: [ self
				subclassCodersOf: aMethodCoder classOrMetaClass
				into: OrderedCollection new ]
		ifFalse: [ {(self superclassSubclassCoderOf: aMethodCoder classOrMetaClass)} ]
]

{ #category : #initialization }
GtMethodCoderCategoryLookOld >> removeMethodTags [
	self widget
		childNamed: self tagsName
		ifFound: [ :tags | tags removeFromParent ]
		ifNone: [  ].

	self widget
		childNamed: self categoryEditorName
		ifFound: [ :toggle | toggle removeFromParent ]
		ifNone: [  ]
]

{ #category : #private }
GtMethodCoderCategoryLookOld >> rootMethodCoder [
	| current superClass selector |
	current := self methodCoder.
	selector := current currentSelector.
	selector isNil
		ifTrue: [ ^ current ].
	[ superClass := current classOrMetaClass superclass notNil
		ifTrue: [ current classOrMetaClass superclass
				whichClassIncludesSelector: selector ].
	superClass notNil ]
		whileTrue: [ current := GtMethodCoder
				forMethod: (superClass methodNamed: selector) ].
	^ current
]

{ #category : #private }
GtMethodCoderCategoryLookOld >> selector [
	^ self methodCoder currentSelector
]

{ #category : #private }
GtMethodCoderCategoryLookOld >> subclassCodersOf: aClass into: aCollection [
	| selector |
	selector := self selector.
	aClass subclasses
		do: [ :each | 
			(each includesSelector: selector)
				ifTrue: [ aCollection
						add: (GtMethodCoder forMethod: (each methodNamed: selector)) ]
				ifFalse: [ self subclassCodersOf: each into: aCollection ] ].
	^ aCollection
]

{ #category : #private }
GtMethodCoderCategoryLookOld >> superclassSubclassCoderOf: aClass [
	aClass subclasses
		do: [ :each | 
			each == self classOrMetaClass
				ifTrue: [ ^ self methodCoder ].
			(self classOrMetaClass includesBehavior: each)
				ifTrue: [ ^ (each includesSelector: self selector)
						ifTrue: [ GtMethodCoder forMethod: (each methodNamed: self selector) ]
						ifFalse: [ self superclassSubclassCoderOf: each ] ] ].
	^ self methodCoder
]

{ #category : #initialization }
GtMethodCoderCategoryLookOld >> tagsName [
	^ #tags
]
