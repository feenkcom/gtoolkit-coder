Class {
	#name : #GtFilterRunExampleButtonTooltipLook,
	#superclass : #GtFilterRunExampleButtonLook,
	#instVars : [
		'tooltipContainer',
		'tooltipContent'
	],
	#category : #'GToolkit-Coder-Filters - UI'
}

{ #category : #initialization }
GtFilterRunExampleButtonTooltipLook >> initialize [
	super initialize.
	self initializeTooltipContainer.
	self initializeTooltipContent.
	self tooltipContainer addChild: self tooltipContent.
	self add: (BrGlamorousWithTooltipLook2 content: self tooltipContainer).
]

{ #category : #initialization }
GtFilterRunExampleButtonTooltipLook >> initializeTooltipContainer [
	tooltipContainer := BrVerticalPane new
		fitContent
]

{ #category : #initialization }
GtFilterRunExampleButtonTooltipLook >> initializeTooltipContent [
	tooltipContent := BrColumnedList new.
	tooltipContent 
		items: GtFilterExampleStatus default statuses;
		margin: (BlInsets all: 10);
		fitContent.
	
	tooltipContent column
		title: 'Name';
		cellStencil: [ 
			BrLabel new
				look: BrGlamorousLabelLook ];
		dataBinder: [ :anElement :anItem | 
			anElement text: anItem label ];
		width: 100.
	
	tooltipContent column
		title: 'Amount';
		cellStencil: [ 
			BrLabel new
				look: BrGlamorousLabelLook ];
		dataBinder: [ :anElement :anItem | 
			| aTotal aTotalString aTotalText |
			aTotal := anItem numberOfExamplesFor: self coder exampler.
			aTotalString := aTotal asString, (' example' asPluralBasedOn: aTotal).
			aTotalText := aTotalString asRopedText foreground: Color gray.
			anElement text: aTotalText ];
		width: 80.
	
]

{ #category : #'private - accessing' }
GtFilterRunExampleButtonTooltipLook >> listItems [
	| states |
	states := GtFilterExampleStatus default statuses.
	^ states collect: [ :eachState |
		eachState labelWithAmountFor: self coder exampler ].
]

{ #category : #'private - hooks' }
GtFilterRunExampleButtonTooltipLook >> onCoderChanged [
	super onCoderChanged.
	self updateList.
]

{ #category : #'private - announcement handling' }
GtFilterRunExampleButtonTooltipLook >> onExampleExecuted: aGtCoderExampleExecuted [
	self widgetDo: [ :aWidget | 
		aWidget enqueueTask: (BlTaskAction new action: [
			self updateList ]) ]
]

{ #category : #'private - accessing' }
GtFilterRunExampleButtonTooltipLook >> tooltipContainer [
	<return: #BlElement>
	^ tooltipContainer
]

{ #category : #'private - accessing' }
GtFilterRunExampleButtonTooltipLook >> tooltipContent [
	<return: #BlElement>
	^ tooltipContent
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonTooltipLook >> updateList [
	self tooltipContent
		items: GtFilterExampleStatus default statuses
]
