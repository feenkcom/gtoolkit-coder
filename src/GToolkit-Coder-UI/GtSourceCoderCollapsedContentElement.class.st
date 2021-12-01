Class {
	#name : #GtSourceCoderCollapsedContentElement,
	#superclass : #GtSourceCoderContentElement,
	#instVars : [
		'label',
		'addOns',
		'content'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #initialization }
GtSourceCoderCollapsedContentElement >> initialize [
	super initialize.
	
	content := BlElement new
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ].

	label := self newLabel.
	addOns := self newAddOnsContainer.

	content addChildren: { label. addOns }.
	self addChild: content
]

{ #category : #'instance creation' }
GtSourceCoderCollapsedContentElement >> newAddOnsContainer [
	^ BrHorizontalPane new
		fitContent;
		margin: (BlInsets top: 4 left: 1 bottom: 1 right: 1);
		withAsyncPromiseDo: [ :anElementPromise |
			anElementPromise
				whenSuccess: [ :aContainer :theAddOns |
					aContainer removeChildren.
					theAddOns previews do: [ :eachAddOn |
						(eachAddOn stencilBuilder 
							coderUIModel: textualCoderViewModel;
							build) ifNotNil: [ :eachAddOnStencil |
								aContainer addChild: eachAddOnStencil asElement ] ] ];
				whenError: [ :aContainer :anError |
					aContainer removeChildren.
					aContainer addChild: (BrLabel new aptitude: BrGlamorousLabelAptitude; text: anError printString) ];
				whenPending: [ :aContainer | ] ]
]

{ #category : #'instance creation' }
GtSourceCoderCollapsedContentElement >> newLabel [
	^ BlAttributedTextElement new
		id: GtSourceCoderCollapsedTextId;
		editorMeasurement;
		bold;
		glamorousCodeFont;
		withAsyncPromiseDo: [ :anElementPromise |
			anElementPromise
				whenSuccess: [ :aLabel :aText | aLabel text: aText asRopedText ];
				whenError: [ :aLabel :anError | aLabel text: anError printString asRopedText ];
				whenPending: [ :aLabel | aLabel text: '' asRopedText ] ]
]

{ #category : #'api - textual coder view model' }
GtSourceCoderCollapsedContentElement >> onTextualCoderViewModelChanged [
	super onTextualCoderViewModelChanged.
	
	label asyncPromise promise: textualCoderViewModel collapsedTextPromise.
	addOns asyncPromise promise: textualCoderViewModel addOns
]
