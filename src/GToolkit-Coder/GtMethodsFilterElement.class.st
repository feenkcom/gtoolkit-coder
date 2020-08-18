Class {
	#name : #GtMethodsFilterElement,
	#superclass : #BrHorizontalFlow,
	#instVars : [
		'coders'
	],
	#category : #'GToolkit-Coder-Filters - UI'
}

{ #category : #accessing }
GtMethodsFilterElement >> addDefaultAllCategory [
	| filterElement |
	self childrenCount = 1
		ifFalse: [ ^ self ].
	filterElement := GtMethodsFilterTagElement new.
	filterElement filter: self.
	filterElement
		descriptor: (self descriptors detect: [ :each | each name = 'Category' ]).
	filterElement makeDefaultAllFilter.
	self addChild: filterElement at: self childrenCount
]

{ #category : #actions }
GtMethodsFilterElement >> applyFilters [
	| filters |
	filters := OrderedCollection new.
	1 to: self childrenCount - 1 do: [ :i | 
		((self childAt: i) filterForCoders: coders)
			ifNotNil: [ :filter | filters add: filter ] ].
	coders additionalFilters: filters.
	self addDefaultAllCategory
]

{ #category : #accessing }
GtMethodsFilterElement >> buildFiltersFrom: methodsCoder [
	[ self childrenCount > 1 ] whileTrue: [ self removeChildAt: 1 ].
	methodsCoder additionalFilters
		do: [ :each | 
			(each class filterDescriptorFor: methodsCoder)
				ifNotNil: [ :descriptor | 
					| filterElement |
					filterElement := GtMethodsFilterTagElement new.
					filterElement filter: self.
					filterElement descriptor: descriptor.
					descriptor requiresValue
						ifTrue: [ filterElement valueString: (each perform: descriptor getter) ].
					self addChild: filterElement at: self childrenCount ] ].
	self addDefaultAllCategory
]

{ #category : #accessing }
GtMethodsFilterElement >> coders: aMethodsCoder [
	coders := aMethodsCoder.
	self addDefaultAllCategory
]

{ #category : #accessing }
GtMethodsFilterElement >> createNewTag [
	| tag |
	(self childrenCount > 1
		and: [ (self childAt: self childrenCount - 1) isDefaultAllFilter ])
		ifTrue: [ self removeChildAt: self childrenCount - 1 ].
	tag := GtMethodsFilterTagElement new.
	tag filter: self.
	tag descriptor: self descriptors first.
	self addChild: tag at: self childrenCount.
	tag activateEditor
]

{ #category : #accessing }
GtMethodsFilterElement >> descriptors [
	^ coders filterDescriptors
]

{ #category : #accessing }
GtMethodsFilterElement >> initialize [
	super initialize.
	self hMatchParent.
	self vFitContent.
	self addChild: self newAddTagButton as: #newButton
]

{ #category : #accessing }
GtMethodsFilterElement >> newAddTagButton [
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
		margin: (BlInsets all: 2);
		beSmall;
		hExact: 20;
		constraintsDo: [ :c | c flow vertical alignCenter ];
		action: [ :aButton | self createNewTag ];
		addShortcut:
			(BlShortcut new
				combination: BlKeyCombination return;
				action: [ :anEvent | self createNewTag ])
]
