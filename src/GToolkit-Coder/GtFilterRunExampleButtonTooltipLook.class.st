Class {
	#name : #GtFilterRunExampleButtonTooltipLook,
	#superclass : #GtFilterRunExampleButtonLook,
	#instVars : [
		'tooltipContent'
	],
	#category : #'GToolkit-Coder-Filters - UI'
}

{ #category : #initialization }
GtFilterRunExampleButtonTooltipLook >> initialize [
	super initialize.
	self initializeTooltipContent.

	self add: (BrGlamorousWithTooltipLook2 content: self tooltipContent).
]

{ #category : #initialization }
GtFilterRunExampleButtonTooltipLook >> initializeTooltipContent [
	tooltipContent := BrColumnedList new.
	tooltipContent 
		items: GtFilterExampleStatus default statuses;
		padding: (BlInsets all: 10);
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
GtFilterRunExampleButtonTooltipLook >> tooltipContent [
	<return: #BlElement>
	^ tooltipContent
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonTooltipLook >> updateList [
	self tooltipContent
		items: GtFilterExampleStatus default statuses
]
