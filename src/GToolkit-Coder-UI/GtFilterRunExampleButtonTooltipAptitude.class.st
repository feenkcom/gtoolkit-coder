Class {
	#name : #GtFilterRunExampleButtonTooltipAptitude,
	#superclass : #GtFilterRunExampleButtonAptitude,
	#instVars : [
		'tooltipContent'
	],
	#category : #'GToolkit-Coder-UI-Filters'
}

{ #category : #initialization }
GtFilterRunExampleButtonTooltipAptitude >> initialize [
	super initialize.
	self initializeTooltipContent.

	self add: (BrGlamorousWithTooltipAptitude content: [self initializeTooltipContent]).
]

{ #category : #initialization }
GtFilterRunExampleButtonTooltipAptitude >> initializeTooltipContent [
	tooltipContent := BrColumnedList new.
	tooltipContent 
		items: GtFilterExampleState default allStates;
		padding: (BlInsets all: 10);
		fitContent.
		
	tooltipContent 
		addEventHandlerOn: BrSelectionChanged do: [ :anEvent |
			anEvent selectedDo: [ :theIndices |
				| aWidgetElement aSelectedObject |

				aWidgetElement := anEvent currentTarget.
				aSelectedObject := aWidgetElement viewModel itemAt: theIndices first.
				
				self coder 
					setFilters: {
						((GtSearchExamplesFilter new
							resultState: aSelectedObject)
							coder: self coder)}
					source: self
		] ].

	tooltipContent column
		title: 'Icon';
		cellStencil: [ 
			| anElement |
			anElement := BlElement new
				background: BlBackground transparent.
			self initializeIconElement: anElement.
			anElement ];
		dataBinder: [ :anElement :anItem |
			anElement background: anItem color ];
		width: 10.
	
	tooltipContent column
		title: 'Name';
		cellStencil: [ 
			BrLabel new
				aptitude: BrGlamorousLabelAptitude ];
		dataBinder: [ :anElement :anItem | 
			anElement text: anItem label ];
		width: 100.
	
	tooltipContent column
		title: 'Amount';
		cellStencil: [ 
			BrLabel new
				aptitude: BrGlamorousLabelAptitude;
				fitContent ];
		dataBinder: [ :anElement :anItem | 
			| aTotal aTotalString aTotalText |
			self examplerDo: [ :anExampler | 
				aTotal := anItem numberOfExamplesFor: anExampler.
				aTotalString := aTotal asString, (' example' asPluralBasedOn: aTotal) ].
			aTotalString ifNil: [ aTotalString := '? examples' ].
			aTotalText := aTotalString asRopedText foreground: Color gray.
			anElement text: aTotalText ].
	^ tooltipContent
]

{ #category : #'private - accessing' }
GtFilterRunExampleButtonTooltipAptitude >> listItems [
	| states |
	states := GtFilterExampleState default allStates.
	^ states collect: [ :eachState |
		eachState labelWithAmountFor: self coder exampler ].
]

{ #category : #'private - accessing' }
GtFilterRunExampleButtonTooltipAptitude >> tooltipContent [
	<return: #BlElement>
	^ tooltipContent
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonTooltipAptitude >> updateList [
	| statusesToDisplay |
	statusesToDisplay := GtFilterExampleState default allStates reject: [ :eachStatus | 
		(eachStatus numberOfExamplesFor: self exampler) isZero ].

	self tooltipContent
		items: statusesToDisplay
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonTooltipAptitude >> updateWidget [
	super updateWidget.
	self updateList.
]
